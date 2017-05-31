package ProPortal::Controller::PhyloViewer::Results;

use IMG::Util::Import 'Class';

extends 'ProPortal::Controller::Base';
with 'ProPortal::Util::DataStructure';

has '+page_id' => (
	default => 'proportal/phylo_viewer/results'
);

has '+tmpl' => (
	default => 'pages/proportal/phylo_viewer/results.tt'
);

has '+tmpl_includes' => (
	default => sub {
		return { tt_scripts => qw( phylo_viewer ) };
	}
);

use JSON qw( encode_json decode_json );
use Text::CSV_XS qw[ csv ];


=head3 render

Will require JSON plugin for rendering data set

=cut

sub _render {
	my $self = shift;
	my $args = shift || $self->_core->args;

	my $treeio = $self->_core->read_tree_file({
		file => $args->{newick},
		format => 'newick'
	});
	my $uniq;

	my $gp_data = $self->_core->read_gene_taxon_file({
		file => $args->{gene_taxon_file}
	});

	# extract the unique taxa from the taxon list
	for ( @$gp_data ) {

		$uniq->{taxa}{ $_->{taxon_oid} }++;
		$uniq->{gene}{ $_->{gene_oid} } = $_;
	}

	my $db_results = $self->_core->get_metadata_for_taxa({
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
			children => $self->make_pruned_bioperl_tree(
				root => $tree->get_root_node,
				node => $tree->get_root_node,
				tree => $tree,
				data => $taxon_data,
				max => \$max
			),
		};
	}

#	log_debug { Dumper $ds };

	if ( scalar @$ds > 1 ) {
		die 'Too many roots!';
	}

#	$ds->[0]{children} = prune_tree_ds( $ds->[0]{children} );

#	log_debug { 'Finished tree pruning: tree now:' };
#	log_debug { Dumper $ds };

	return { results => {
		js => {
			gene_data => $uniq->{gene},
			taxon_data => $taxon_data,
			array => $db_results,
			tree => $ds->[0],
			max_length => $max,
			n_leaves => $leaves,
		}
	} };

}

1;
