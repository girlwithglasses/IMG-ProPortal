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
		return [ qw( pp_subset dataset_type taxon_oid scaffold_oid category db xref scaffold taxon ) ];
	}
);

=head3 render

List of genes, filtered in some manner

=cut

sub _render {
	my $self = shift;

	my $statement = $self->get_data;

	log_debug { 'statement: ' . $statement };

	my $arr = $self->page_me( $statement )->all;

	return { results => {
		domain => 'gene',
		arr => $arr,
		n_results => $statement->row_count,
		n_pages   => $statement->page_count,
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

	my $q_args = {
		query => 'gene_list',
		filters => $self->filters,
		-result_as => 'statement'
	};

	# for scaffold and taxon filters, get the scaffold/taxon and pull up the genes from it
	if ( $self->filters->{scaffold_oid} || $self->filters->{taxon_oid} ) {
		delete $self->filters->{pp_subset};
	#	$q_args->{query} = 'gene_list_by_scaffold';
	}

	return $self->_core->run_query( $q_args );

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
