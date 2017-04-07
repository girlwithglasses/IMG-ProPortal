package ProPortal::Controller::List::Function;

use IMG::Util::Import 'Class';

extends 'ProPortal::Controller::Filtered';
with
qw( ProPortal::Controller::Role::TableHelper
	ProPortal::Controller::Role::Paged
);

use Template::Plugin::JSON::Escape;

has '+page_wrapper' => (
    default => 'layouts/default_wide.tt'
);

has '+page_id' => (
	default => 'list/function'
);

has '+filter_domains' => (
	default => sub {
		return [ qw( db gene_oid scaffold_oid taxon_oid ) ];
	}
);

=head3 function list

Return an array of functions

Currently only functions for CyCOGs

=cut

sub _render {
	my $self = shift;

# 	count for paging?
# 	my $count = $self->_core->run_query({
# 		query => 'function_list_count',
# 		filters => $self->filters
# 	});

	my $statement = $self->get_data;
	my $arr = $statement->all;
	my $n_results = $statement->row_count;

	return { results => {
		domain => 'function',
		arr => $arr,
		n_results => $n_results,
		table => $self->get_table('cycog'),
		params => $self->filters,
	} };

}

sub get_data {
	my $self = shift;

	my @valid_prefixes = ( qw( cycog cog ) );

	# get basic function info
	return $self->_core->run_query({
		query => 'cycog_list',
		result_as => 'statement'
	});
}

sub examples {

	return [{
		url => '/list/function?taxon_oid=640069325',
		desc => 'list all functions for taxon 640069325, <i>Prochlorococcus</i> NATL2A'
	},{
		url => '/list/function?gene_oid=xxxxxxx',
		desc => 'list all functions of gene xxxxxx'
	},{
		url => '/list/function?db=cycog',
		desc => 'retrieve list of all CyCOG functions in ProPortal'
	},{
		url => '/list/function?taxon_oid=640069325&db=KEGG',
		desc => 'list all KEGG functions associated with taxon NATL2A'
	}];

}

1;
