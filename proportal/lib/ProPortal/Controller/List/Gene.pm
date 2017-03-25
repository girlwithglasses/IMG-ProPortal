package ProPortal::Controller::List::Gene;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

has '+page_id' => (
	default => 'list/gene'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

has '+filter_domains' => (
	is => 'ro',
	default => sub {
		return [ qw( pp_subset dataset_type locus_type gene_symbol taxon_oid category ) ];
	}
);

=head3 render

List of all genes in the ProPortal, filtered in some manner

@param taxon_oid

@param type =>

proteinCodingGenes
withFunc
withoutFunc
fusedGenes
signalpGeneList
transmembraneGeneList
pseudoGenes  -> IS_PSEUDOGENE
geneCassette
biosynthetic_genes

type = rnas
rnas, locus_type => ( rRNA | tRNA | xRNA )
rnas, locus_type => rRNA, gene_symbol => xxx

=cut

sub _render {
	my $self = shift;

# 	count for paging?
# 	my $count = $self->_core->run_query({
# 		query => 'gene_list_count',
# 		filters => $self->filters
# 	});

	return { results => {
		genes => $self->get_data,
		params => $self->filters
	} };

}

sub get_data {
	my $self = shift;
	return $self->_core->run_query({
		query => 'gene_list',
		filters => $self->filters,
		result_as => $self->output_format
	});

}

1;
