package ProPortal::Controller::Details::CycogVersion;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Filtered';

with 'IMG::Model::DataManager', 'ProPortal::Controller::Role::TableHelper';

has '+page_id' => (
	default => 'details/cycog_version'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

# has '+filter_domains' => (
# 	default => sub {
# 		return [ qw( version ) ];
# 	}
# );

=head3 render

Details page for a CyCOG function

@param function_oid

=cut

sub _render {
	my $self = shift;

	my $results = $self->get_data( @_ );

	$results->{cycog_table} = $self->get_table('cycog');
	# remove the 'version' string from the table
	$results->{cycog_table}{thead}{enum} = [ qw( cbox id description ) ];

	$results->{taxon_table} = $self->get_table('taxon');
	$results->{taxon_table}{thead}{enum} = [ qw( cbox taxon_oid taxon_display_name ) ];

	return { results => $results };
}

sub get_data {
	my $self = shift;
	my $args = shift;

	if ( ! $args || ! $args->{version} ) {
		$self->choke({
			err => 'missing',
			subject => 'CyCOG release'
		});
	}

# 	$self->choke({
# 		err => 'not_implemented'
# 	}) unless 'cycog' eq $args->{db};

	my $res;

	if ( 'latest' eq lc( $args->{version} ) ) {
		# retrieve the latest schema
		$res = $self->_core->run_query({
			query => 'cycog_version_latest'
		});
	}
	else {
		$res = $self->_core->run_query({
			query => 'cycog_version',
			-where => { version => $args->{version} }
		});
	}

	if ( scalar @$res != 1 ) {
		$self->choke({
			err => 'no_results',
			subject => 'CyCOG version ' . $args->{version}
		});
	}

	my $vers = $res->[0];

	# get the taxon and cycog lists and populate the data

	my $cycog_list = $self->_core->run_query({
		query =>   'cycog_by_annotation',
		-where =>   { version => $vers->{version} },
		-columns   => [ map { 'cycog.'.$_ } qw( id description ) ],
		-group_by  => [ map { 'cycog.'.$_ } qw( id description ) ],
		-order_by  => 'cycog.id',
	});

	log_debug { $cycog_list };
#   "cycog_oid" TEXT,
#   "name" TEXT,
#   "cluster_size" TEXT,
#   "unique_taxa" TEXT,
#   "duplication_events" TEXT,
#   "description" TEXT


	log_debug { 'version object: ' . Dumper $vers };

	# get the taxon list
	$vers->expand( 'taxa', ( -columns => 'taxon_oid' ) );

	my $taxon_list = $self->_core->schema( 'img_core' )->table( 'Taxon' )
		->select(
			-columns => [ qw( taxon_oid taxon_display_name ) ],
			-where => { taxon_oid => [ map { $_->{taxon_oid} } @{ $vers->taxa } ] },
			-order_by => 'taxon_display_name',
			-result_as => 'statement'
		)->all;

#	log_debug { 'results: ' . Dumper $gene_list };

	return { vers => $vers, taxon_arr => $taxon_list, cycog_arr => $cycog_list };

}

sub examples {
	return [{
		url => '/details/cycog_version/$vers',
		desc => 'release metadata for CyCOG <var>$vers</var>'
	},{
		url => '/details/cycog_version/$vers',
		desc => 'metadata for CyCOG release v0.0'
	}];
}

1;
