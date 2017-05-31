package ProPortal::Controller::Role::CommonQueries;

use IMG::Util::Import 'MooRole';
use List::MoreUtils qw( natatime );

=cut
		return $self->_core->run_query({
			query =>   'cycog_by_annotation',
			-columns   => [ map { 'cycog.'.$_ } qw( id|cycog_id description|cycog_description cluster_size unique_taxa duplication_events ) ],
			-group_by  => [ map { 'cycog.'.$_ } qw( id description cluster_size unique_taxa duplication_events ) ],
			-order_by  => 'cycog.id',
			-result_as => 'statement',
			filters => $self->filters
		});



	my $cycog_list = $self->_core->run_query({
		query =>   'cycog_by_annotation',
		-where =>   { version => $vers->{version} },
		-columns   => [ 'cycog.id|cycog_id', 'cycog.description|cycog_description' ],
		-group_by  => [ 'cycog.id', 'cycog.description' ],
		-order_by  => 'cycog.id',
#		-page_size => 100
	});

=cut

#	uses the value for cycog_version in the filters to retrieve cycog version data

sub get_cycog_version {
	my $self = shift;

	my $stt;
	if ( 'latest' eq lc( $self->filters->{cycog_version} ) ) {
		# retrieve the latest schema
		$stt = $self->_core->run_query({
			query => 'cycog_version_latest',
			-result_as => 'statement'
		});
	}
	else {
		$stt = $self->_core->run_query({
			query => 'cycog_version',
			-where => { version => $self->filters->{cycog_version} },
			-result_as => 'statement'
		});
	}

	my $res = $stt->all;
	log_debug { 'results: ' . Dumper $res };
	if ( scalar @$res != 1 ) {
		$self->choke({
			err => 'no_results',
			subject => 'CyCOG version ' . $self->filters->{cycog_version}
		});
	}

	my $vers = $res->[0];
	return $vers;
}

#	args:
#	version_object =>

sub taxon_list_by_cycog_version {
	my $self = shift;
	my $args = shift;
	my $vers = $args->{version_object};

	log_debug { 'version object: ' . Dumper $vers };

	# get the taxon list
	$vers->expand( 'taxa', ( -columns => 'taxon_oid', -order_by => 'taxon_oid' ) );
	$vers->{n_taxa} = scalar( @{$vers->taxa} );

	my $tax_to_get = [ map { $_->{taxon_oid} } @{ $vers->taxa } ];
	my $tax_objs = [];

	# get 200 at a time
	my $it = natatime 200, @$tax_to_get;
	while (my @subset = $it->())
	{	my $taxon_list = $self->_core->schema( 'img_core' )->table( 'Taxon' )
		->select(
			-columns => [ qw( taxon_oid taxon_display_name ) ],
			-where => { taxon_oid => [ @subset ] },
			-order_by => 'taxon_oid',
			-result_as => 'statement'
		)->all;
		push @$tax_objs, @$taxon_list;
	}

	return $tax_objs;
}

1;
