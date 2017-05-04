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
		return [ qw( pp_subset dataset_type locus_type gene_symbol taxon_oid category scaffold_oid db xref ) ];
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

=cut
	my $table = {
		thead => {
			enum => [ 'cbox', 'gene_oid', 'gene_display_name', 'taxon_oid' ],
			enum_map => {
				scaffold_oid => 'Gene ID',
				scaffold_name => 'Gene Name',
				taxon => 'Taxon'
			}
		},
		transform => {
			cbox => sub {
				my $x = shift;
				return {
					macro => 'checkbox',
					name => "gene_oid[]",
					value => $x->{gene_oid},
					id => 'cbox_' . $x->{gene_oid}
				};
			},
			gene_oid => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					type => 'details',
					params => { domain => 'gene', gene_oid => $x->{gene_oid} },
					text => $x->{gene_oid}
				};
			},
			gene_display_name => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					type => 'details',
					params => { domain => 'gene', gene_oid => $x->{gene_oid} },
					text => $x->{gene_display_name}
				};
			},
			taxon_oid => sub {
				my $x = shift;
				return {
					macro => 'generic_link',
					type => 'details',
					params => { domain => 'taxon', taxon_oid => $x->{taxon_oid} },
					text => $x->{taxon_display_name}
				};
			}
		}
	};
=cut

	my $statement = $self->get_data;
	my $arr = $statement->all;
	my $n_results = $statement->row_count;

	return { results => {
		domain => 'gene',
		arr => $arr,
		n_results => $n_results,
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

	# for scaffold and taxon filters, get the scaffold/taxon and pull up the genes from it
	if ( $self->filters->{scaffold} ) {

	}
	elsif ( $self->filters->{taxon} ) {

	}

	return $self->_core->run_query({
		query => 'gene_list',
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
