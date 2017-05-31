package ProPortal::Controller::Details::CycogVersion;

use IMG::Util::Import 'Class'; #'MooRole';
use List::MoreUtils qw( natatime );

extends 'ProPortal::Controller::Filtered';

with qw(
	IMG::Model::DataManager
	ProPortal::Controller::Role::TableHelper
	ProPortal::Controller::Role::CommonQueries
);

has '+page_id' => (
	default => 'details/cycog_version'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( cycog_version ),
		};
	}
);

has '+filter_domains' => (
	default => sub {
		return [ qw( cycog_version ) ];
	}
);

=head3 render

Details page for a CyCOG function

@param function_oid

=cut

sub _render {
	my $self = shift;

	my $results = $self->get_data( @_ );

#	return { vers => $vers, taxon_arr => $tax_objs, cycog_arr => $cycog_list };

	# remove the 'version' string from the table
	$results->{js}{cycog_table_cols} = [ qw( cycog_id cycog_description ) ];
	$results->{js}{taxon_table_cols} = [ qw( cbox_taxon taxon_oid taxon_display_name ) ];

	return { results => $results };
}

sub get_data {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{cycog_version} ) {
		$self->choke({
			err => 'missing',
			subject => 'CyCOG release'
		});
	}

	log_debug { 'filters: ' . Dumper $self->filters };

	my $vers = $self->get_cycog_version;

	my $tax_objs = $self->taxon_list_by_cycog_version({ version_object => $vers });

	# cycog count
	my $count = $self->_core->schema('cycog')->table('GeneCycogGroups')
	->select(
		-columns => 'count(distinct(id))|count',
		-where => { version => $vers->{version} },
	);
	$vers->{n_clusters} = $count->[0]{count};

	# cycog list
	my $cycog_list = $self->_core->run_query({
		query =>   'cycog_by_annotation',
		-where =>   { version => $vers->{version} },
		-columns   => [ 'cycog.id|cycog_id', 'cycog.description|cycog_description' ],
		-group_by  => [ 'cycog.id', 'cycog.description' ],
		-order_by  => 'cycog.id',
#		-page_size => 100
	});

#	log_debug { 'results: ' . Dumper $gene_list };

	return { vers => $vers, js => { taxon_arr => $tax_objs, cycog_arr => $cycog_list  } };
}

sub examples {
	return [{
		url => '/details/cycog_version/$vers',
		desc => 'release metadata for CyCOG <var>$vers</var>'
	},{
		url => '/details/cycog_version/latest',
		desc => 'metadata for the latest CyCOG release v0.0'
	}];
}

1;
