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
		return [ qw( db gene_oid taxon_oid cycog_version ) ];
	}
);

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( datatables ),
		};
	}
);


=head3 function list

Return an array of functions

Currently only functions for CyCOGs

=cut

sub _render {
	my $self = shift;

	my $tcols = [ qw( cycog_id cycog_description cluster_size unique_taxa duplication_events ) ];

	my $domain = 'function';
	my $statement = $self->get_data;
	my $res = $self->page_me( $statement )->all;
	return {
		results => {
			js => {
				arr => $res,
				table_cols => [ 'cbox_' . $domain, @$tcols ]
			},
			paging => $self->paging_helper,
			domain => $domain,
			params => $self->filters,
#			table => $self->get_table('cycog'),
		}
	};

#   "id" TEXT,
#   "cluster_size" TEXT,
#   "unique_taxa" TEXT,
#   "duplication_events" TEXT,
#   "description" TEXT

}

sub get_data {
	my $self = shift;

	if ( ! $self->filters->{db} ) {
		$self->choke({
			err => 'missing',
			subject => 'required "db" query parameters'
		});
	}

	log_debug { 'filters: ' . Dumper $self->filters };

	if ( $self->filters->{cycog_version}
		|| $self->filters->{taxon_oid}
		|| $self->filters->{gene_oid} ) {
		return $self->_core->run_query({
			query =>   'cycog_by_annotation',
			-columns   => [ map { 'cycog.'.$_ } qw( id|cycog_id description|cycog_description cluster_size unique_taxa duplication_events ) ],
			-group_by  => [ map { 'cycog.'.$_ } qw( id description cluster_size unique_taxa duplication_events ) ],
			-order_by  => 'cycog.id',
			-result_as => 'statement',
			filters => $self->filters
		});
	}

	# otherwise, get the proportal subset
	return $self->_core->run_query({
		query => 'cycog_list',
		-columns   => [ map { 'cycog.'.$_ } qw( id|cycog_id description|cycog_description cluster_size unique_taxa duplication_events ) ],
		-result_as => 'statement',
	});
}

sub examples {

	return [{
		url => '/list/function?db=cycog&taxon_oid=2606217312',
		desc => 'list all CyCOGs for taxon 2606217312'
	},{
		url => '/list/function?db=cycog&gene_oid=2650965738',
		desc => 'list all CyCOGs associated with gene 2650965738'
	},{
		url => '/list/function?db=cycog',
		desc => 'retrieve list of all CyCOG functions in ProPortal'
	},{
		url => '/list/function?db=cycog&cycog_version=0.0',
		desc => 'list all CyCOGs in CyCOG version 0.0'
	}];

}

1;
