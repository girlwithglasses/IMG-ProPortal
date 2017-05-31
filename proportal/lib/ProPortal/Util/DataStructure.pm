package ProPortal::Util::DataStructure;

use IMG::Util::Import 'MooRole';

requires 'choke';

=pod

=encoding UTF-8

=head1 NAME

ProPortal::Util::DataStructure - wrangle data structures!

=head3 make_tree

	my $obj = $self->make_tree( $ds, $path );

@param  $ds     data structure

@return $tree   tree structure in the form

	{	name => $node_name,
		children => [ $node, $node, $node, ... ]
	}

=head3 make_tree_with_path

	my $obj = $self->make_tree_with_path( $ds, $path );

@param  $ds     data structure
@param  $path   string representing the current path to the root of the tree

@return $tree   tree structure in the form

	{	name => $node_name,
		path => $path_to_node . "__" . $node_name,
		children => [ $node, $node, $node, ... ]
	}

=cut

sub make_tree {
	my $self = shift;
	my $ds = shift;
	if ( 'ARRAY' eq ref $ds ) {
		return [ sort { $a->{name} cmp $b->{name} } @$ds ];
	}
	elsif ( 'HASH' eq ref $ds ) {
		my $struct;
		for ( sort keys %$ds ) {
			push @$struct, { name => $_, children => $self->make_tree( $ds->{$_} ) };
		}
		return $struct;
	}
	$self->choke({
		err => 'format_err',
		subject => 'Recursive tree-maker input'
	});
}

sub make_tree_with_path {
	my $self = shift;
	my $ds = shift;
	my $path = shift // '';
	if ( 'ARRAY' eq ref $ds ) {
		return [ sort { $a->{name} cmp $b->{name} } @$ds ];
	}
	elsif ( 'HASH' eq ref $ds ) {
		my $struct;
		my $p;
		for ( sort keys %$ds ) {
			( $p = $_ ) =~ s/\W/_/g;
			push @$struct, {
				name => $_,
				path => $path . "__$p",
				children => $self->make_tree_with_path( $ds->{$_}, $path . "__$p"  )
			};
		}
		return $struct;
	}
	$self->choke({
		err => 'format_err',
		subject => 'Recursive tree-maker input'
	});
}


=head3 make_bioperl_tree, make_pruned_bioperl_tree, prune_bioperl_tree

Recursive tree structure builder, using a BioPerl tree as a base

	my $obj = $self->make_bioperl_tree( %args );

make_pruned_bioperl_tree removes extra nodes

@param  %args     data structure
	$self->make_pruned_bioperl_tree(
		root => $tree->get_root_node, # tree root
		node => $tree->get_root_node, # current tree node
		tree => $tree,                # tree data structure
		data => $taxon_data,          # taxon data to integrate into the tree
		max => \$max                  # current maximum path length
	),

@return $tree   tree structure in the form

	{	name => $node_name,
		children => [ $node, $node, $node, ... ],
		metadata => $data_h, # taxon data
		length => $dist, # between this node and its parent
		cumul_len => $dist # between root and this node
	}

=cut

sub make_pruned_bioperl_tree {
	my $self = shift;
	my %args = ( @_ );
	my $level = $args{level} || 0;
#	my $indent = ( "\t" ) x  $level;
#	log_debug { $indent . 'Entering make_pruned_tree_ds' };

	my @unfiltered = $args{node}->each_Descendent;
	my $children_by_dist;
	my @children;
	FILTER_CHILDREN:
	while ( @unfiltered ) {
		my $child = shift @unfiltered;
#		log_debug { $indent . 'Examining an unfiltered child...' };
		my $c_data;

		$c_data = {
			length => $args{tree}->distance( -nodes => [ $args{node}, $child ] ),
			cumul_len => $args{tree}->distance( -nodes => [ $args{root}, $child ] ),
		};

		if ( $child->id ) {
			$c_data->{name} = $child->id;
			$c_data->{metadata} = $args{data}->{ $child->id } if $args{data}->{ $child->id };
		}

#		log_debug { $indent . 'child: ' . Dumper $c_data };

		if ( 0 < scalar $child->each_Descendent ) {
#			log_debug { $indent . 'found a node with children' };
			my @ok;
			for my $gc ( $child->each_Descendent ) {
				if ( 0 == $args{tree}->distance( -nodes => [ $child, $gc ] ) ) {
					push @unfiltered, $gc;
#					log_debug { $indent . 'found a child with distance zero!' };
				}
				else {
#					log_debug { $indent . 'found an OK child' };
					push @ok, $gc;
				}
			}
			if ( @ok ) {
				$c_data->{children} = $self->make_pruned_bioperl_tree( %args, node => $child, level => $level + 1 );
#				log_debug { $indent . 'pruned children: ' . Dumper $c_data };
			}
			else {
#				log_debug { $indent . 'No valid children found' };
				next FILTER_CHILDREN;
			}
		}

		# ignore intermediate nodes with length 0
		# CHECK: do we need to do this?
		if ( 0 == $c_data->{length} ) {
#			log_debug { $indent . 'this node has length 0; going to next node' };
			next FILTER_CHILDREN;
		}
#		next if 0 == $c_data->{length};

		if ( ! $c_data->{children} && $c_data->{cumul_len} > ${$args{max}} ) {
			${$args{max}} = $c_data->{cumul_len};
		}

		push @{$children_by_dist->{ $c_data->{cumul_len} }}, $c_data;

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
#					log_debug { 'length mismatch!' };
				}
				$length = $_->{length};
				$_->{length} = 0;
			}
			push @children, { length => $length, cumul_len => $d, children => $children_by_dist->{$d} };
		}
	}
#	log_debug { $indent . 'returning children: ' . Dumper \@children };
	return \@children;
}


sub make_bioperl_tree {
	my $self = shift;
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
			$c_data->{children} = $self->make_bioperl_tree( %args, node => $child );
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


sub prune_bioperl_tree {
	my $self = shift;
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
				$c->{children} = $self->prune_bioperl_tree([ @got_length ]);
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
