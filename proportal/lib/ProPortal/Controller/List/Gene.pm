package ProPortal::Controller::List::Gene;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';
with
qw( ProPortal::Controller::Role::TableHelper
	ProPortal::Controller::Role::Paged
);

has '+page_id' => (
	default => 'list/gene'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( pp_subset dataset_type locus_type gene_symbol taxon_oid category scaffold_oid db xref scaffold taxon ) ];
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

	my $statement = $self->get_data;

	log_debug { 'statement: ' . $statement };

	my $arr = $statement->all;

	return { results => {
		domain => 'gene',
		arr => $arr,
		n_results => $statement->row_count,
		table => $self->get_table('gene'),
		params => $self->filters
	} };

}

sub get_data {
	my $self = shift;

	if ( $self->filters->{db} || $self->filters->{xref} ) {
		if ( ! $self->filters->{db} || ! $self->filters->{xref} ) {
			$self->choke({
				err => 'missing',
				subject => 'valid function reference supplied; both "db" and "xref" must be'
			});
		}
		# otherwise, we need to structure our query differently
		if ( 'cycog' ne $self->filters->{db} ) {
			$self->choke({
				err => 'not_implemented'
			});
		}
	}

	my $query = 'gene_list';
	# for scaffold and taxon filters, get the scaffold/taxon and pull up the genes from it
	if ( $self->filters->{scaffold_oid} ) {
		$query = 'gene_list_by_scaffold';
	}
	elsif ( $self->filters->{taxon_oid} ) {
		$query = 'gene_list_by_taxon';
	}

	return $self->_core->run_query({
		query => $query,
		filters => $self->filters,
		result_as => 'statement'
	});

}

sub examples {

	return [{
		url => '/list/gene?taxon_oid=640069325',
		desc => 'list all genes for taxon NATL2A (taxon_oid 640069325)'
	},{
		url => '/list/gene?db=cycog&xref=0000001',
		desc => 'list all genes for function CyCOG:0000001'
	},{
		url => '/list/gene?scaffold_oid=xxxxxxx',
		desc => 'list all genes on scaffold xxxxxx'
	}];

}

1;
