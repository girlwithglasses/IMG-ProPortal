package ProPortal::Controller::List::Gene;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';
with 'ProPortal::Controller::Role::Paged';

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

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( datatables ),
		};
	}
);

has 'order_by' => (
	is => 'rwp',
	default => 'gene_oid'
);

has 'table_cols' => (
	is => 'ro',
	default => sub {
		return [ qw( gene_oid gene_display_name gene_symbol taxon_display_name product_name description locus_type locus_tag scaffold_name pp_subset ) ];
	}
);
=head3 render

List of genes, filtered in some manner

=cut

sub _render {
	my $self = shift;

	my $domain = 'gene';
	my $statement = $self->get_data;
	my $res = $self->page_me( $statement )->all;
	return { results => {
		js => {
			arr => $res,
			table_cols => [ 'cbox_' . $domain, @{ $self->table_cols } ]
		},
		paging => $self->paging_helper,
		domain => $domain,
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
		-columns => [ @{$self->table_cols}, 'scaffold_oid', 'taxon_oid' ],
		-order_by => $self->order_by,
		-result_as => 'statement'
	};

	# for scaffold and taxon filters,
	# we don't need to filter by subset
	if ( $self->filters->{scaffold_oid} || $self->filters->{taxon_oid} ) {
		delete $self->filters->{pp_subset};
	}

	## TODO!!

# 	first check the taxon/scaffold
# 	if ( $self->filters->{scaffold_oid} ) {
# 		$self->_core->run_query({
# 			query => 'scaffold_with_taxon_infile'
#
#
# 		});
#
# 	}
# 	elsif ( $self->filters->{taxon_oid} ) {
# 		$self->_core->schema('img_core')->table('Taxon')
# 			->select({
# 				-columns => [ qw( is_obsolete in_file taxon_oid taxon_display_name is_public ) ],
# 				-where => { taxon_oid => $self->filters->{taxon_oid} },
# 				-result_as => 'statement'
# 			});
#
# 	}

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
