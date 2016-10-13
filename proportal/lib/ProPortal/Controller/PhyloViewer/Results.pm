package ProPortal::Controller::PhyloViewer::Results;

use IMG::Util::Base 'MooRole';

with 'ProPortal::Controller::PhyloViewer::Pipeline';

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Base',
			tmpl_includes => {
				tt_scripts => [ 'phylo_viewer' ]
			}
		};
	}
);


use JSON qw( encode_json decode_json );
use Text::CSV_XS qw[ csv ];


=head3 render

Will require JSON plugin for rendering data set

=cut

sub render {
	my $self = shift;
	my $args = shift || $self->args;

	my $treeio = $self->read_tree_file({
		file => $args->{newick},
		format => 'newick'
	});
#	say 'gene tax file res: ' . Dumper $self->read_gene_taxon_file( $args );
	my $uniq;

	my $gp_data = $self->read_gene_taxon_file({
		file => $args->{gene_taxon_file}
	});

	# extract the unique taxa from the taxon list
	for ( @$gp_data ) {

		$uniq->{taxa}{ $_->{taxon_oid} }++;
		$uniq->{gene}{ $_->{gene_oid} } = $_;
	}

	my $db_results = $self->get_metadata_for_taxa({
		taxon_oid => [ keys %{$uniq->{taxa}} ]
	});

	my $taxon_data;
	for ( @$db_results ) {
		$taxon_data->{ $_->{ taxon_oid } } = $_;
	}

	my $ds;
	my $max = 0;
	my $leaves;
	while( my $tree = $treeio->next_tree ) {
		$leaves = scalar $tree->get_leaf_nodes;
		push @$ds, {
			length => 0,
			cumul_len => 0,
 			children => make_pruned_tree_ds(
				root => $tree->get_root_node,
				node => $tree->get_root_node,
				tree => $tree,
				data => $taxon_data,
				max => \$max
			),
		};
	}

#	say Dumper $ds;

	if ( scalar @$ds > 1 ) {
		die 'Too many roots!';
	}

#	$ds->[0]{children} = prune_tree_ds( $ds->[0]{children} );

#	say 'Finished tree pruning: tree now:';
#	say Dumper $ds;

	return $self->add_defaults_and_render( {
		js => {
			gene_data => $uniq->{gene},
			taxon_data => $taxon_data,
			array => $db_results,
			tree => $ds->[0],
			max_length => $max,
			n_leaves => $leaves,
		}
	} );

}

sub make_tree_ds {
	my %args = ( @_ );

	my @children;
	for my $child ( $args{node}->each_Descendent ) {
		my $c_data = {
			length => $args{tree}->distance( -nodes => [ $args{node}, $child ] ),
			cumul_len => $args{tree}->distance( -nodes => [ $args{root}, $child ] ),
		};
		if ( $child->id ) {
			$c_data->{name} = $child->id;
			# merge the gene and taxon data
			$c_data->{metadata} = $args{data}->{ $child->id } if $args{data}->{ $child->id };
		}

		if ( 0 < scalar $child->each_Descendent ) {
			$c_data->{children} = make_tree_ds( %args, node => $child );
		}
		else {
			if ( $c_data->{cumul_len} > ${$args{max}} ) {
				${$args{max}} = $c_data->{cumul_len};
			}
		}
		push @children, $c_data;
	}
	return \@children;
}

sub make_pruned_tree_ds {
	my %args = ( @_ );
	my $level = $args{level} || 0;
	my $indent = ( "\t" ) x  $level;
#	say $indent . 'Entering make_pruned_tree_ds';

	my @unfiltered = $args{node}->each_Descendent;
	my $children_by_dist;
	my @children;
	FILTER_CHILDREN:
	while ( @unfiltered ) {
		my $child = shift @unfiltered;
#		say $indent . 'Examining an unfiltered child...';
		my $c_data;

		$c_data = {
			length => $args{tree}->distance( -nodes => [ $args{node}, $child ] ),
			cumul_len => $args{tree}->distance( -nodes => [ $args{root}, $child ] ),
		};

		if ( $child->id ) {
			$c_data->{name} = $child->id;
			$c_data->{metadata} = $args{data}->{ $child->id } if $args{data}->{ $child->id };
		}

#		say $indent . 'child: ' . Dumper $c_data;

		if ( 0 < scalar $child->each_Descendent ) {
#			say $indent . 'found a node with children';
			my @ok;
			for my $gc ( $child->each_Descendent ) {
				if ( 0 == $args{tree}->distance( -nodes => [ $child, $gc ] ) ) {
					push @unfiltered, $gc;
#					say $indent . 'found a child with distance zero!';
				}
				else {
#					say $indent . 'found an OK child';
					push @ok, $gc;
				}
			}
			if ( @ok ) {
				$c_data->{children} = make_pruned_tree_ds( %args, node => $child, level => $level + 1 );
#				say $indent . 'pruned children: ' . Dumper $c_data;
			}
			else {
#				say $indent . 'No valid children found';
				next FILTER_CHILDREN;
			}
		}

		# ignore intermediate nodes with length 0
		# CHECK: do we need to do this?
		if ( 0 == $c_data->{length} ) {
#			say $indent . 'this node has length 0; going to next node';
			next FILTER_CHILDREN;
		}
#		next if 0 == $c_data->{length};

		if ( ! $c_data->{children} && $c_data->{cumul_len} > ${$args{max}} ) {
			${$args{max}} = $c_data->{cumul_len};
		}

		push @{$children_by_dist->{ $c_data->{cumul_len} }}, $c_data;
#		push @children, $c_data;

	}

	for my $d ( keys %$children_by_dist ) {
		if ( scalar @{$children_by_dist->{$d}} == 1 ) {
			push @children, $children_by_dist->{$d}[0];
		}
		else {
			# create a grouping node
			my $length;
			for ( @{$children_by_dist->{$d}} ) {
				if ( defined $length && $_->{length} != $length ) {
#					say 'length mismatch!';
				}
				$length = $_->{length};
				$_->{length} = 0;
			}
			push @children, { length => $length, cumul_len => $d, children => $children_by_dist->{$d} };
		}
	}
#	say $indent . 'returning children: ' . Dumper \@children;
	return \@children;
}


sub prune_tree_ds {
	my $unfiltered = shift;

	my @children;
	FILTER_CHILDREN:
	while ( @$unfiltered ) {
		my $c = shift @$unfiltered;
		if ( $c->{children} ) {
			my @got_length;
			for my $gc ( @{$c->{children}} ) {
				if ( $c->{cumul_len} ne $gc->{cumul_len} ) {
					push @got_length, $gc;
				}
				else {
					$gc->{length} = $c->{length};
					push @$unfiltered, $gc;
				}
			}
			if ( scalar @got_length > 0 ) {
				$c->{children} = prune_tree_ds([ @got_length ]);
			}
			else {
				delete $c->{children};
				next FILTER_CHILDREN;
			}
		}
		push @children, $c;
	}
	return [ @children ];
}

1;
