package ProPortal::IO::DBIxDataModel;

use IMG::Util::Import 'MooRole';

use Time::HiRes;
use IMG::Model::UnitConverter;

use DBIx::DataModel;

use DataModel::IMG_Core;
use DataModel::IMG_Gold;

requires 'schema', 'choke';

with 'ProPortal::IO::DBIxDataModelQueryLib';

has 't0' => (
	is => 'lazy',
);

sub _build_t0 {
	my $self = shift;
	return Time::HiRes::gettimeofday;
}

has 'query_library' => (
	is => 'lazy',
	default => sub {
		my $self = shift;
		my $ql = ProPortal::IO::DBIxDataModelQueryLibrary->new( _core => $self );
		return $ql;
	}
);


=head3 run_query

Run a database query

If there is no database handle set, takes care of doing the login first

This is a thin wrapper around DBIx::DataModel; see that module for
specifics on how to write specific SQL.

https://metacpan.org/pod/DBIx::DataModel

The queries themselves are in ProPortal::IO::DBIxDataModelQueryLib

@param $args    hashref with keys

    query     the name of the query to be run
              (i.e. the name of the method in this package)

    where     the query parameter(s), e.g.
              { taxon_oid => [ 123, 456, 789 ] }

    filters       (optional) hashref of standardised filters,
                  e.g. implemented by ProPortalFilters

    return_as     (optional) return the statement object in a specific
                  format, e.g. result_as => 'flat_arrayref'
                  see DBIx::DataModel for options

    check_results (optional) run check_results on the db results
                  specify params for check_results as hashref, i.e.

                  check_results => {
                  	param => 'taxon_oid',
                  	query => [ 123, 456, 789 ],
                  	subject => 'taxon_oids'
                  }

	TODO: count results, return paged results

@return $output - returns $statement->all unless return_as is specified

=cut

sub run_query {
	my $self = shift;

	# set the timer
	$self->t0;

	my $args;
	if ( @_ && 1 < scalar( @_ ) ) {
		$args = { @_ } ;
	}
	else {
		$args = shift;
	}

	#	query is the name of the method to run
	#	args->{params} will contain filter params

	my $query = $args->{query}
		# no query specified
		or $self->choke({
			err => 'missing',
			subject => 'database query'
		});

	if (! $self->can($query)) {
		$self->choke({
			err => 'invalid',
			subject => $query,
			type => 'database query'
		});
	}

	# get the query as a statement
	my $stt = $self->$query( $args );

	return unless defined $stt;
#	log_debug { 'statement: ' . Dumper $stt };

	# add filters
	if ($args->{filters}) {
		$stt = $self->add_filters({
			statement => $stt,
			filters => $args->{filters}
		});
	}

=cut

   -columns       => \@columns,
     # OR : -columns => [-DISTINCT => @columns],
   -where         => \%where_criteria,
     # OR : -fetch => $key,
     # OR : -fetch => \@key,
   -where_on      => \%where_on_criteria,
   -group_by      => \@groupings,
   -having        => \%having_criteria,
   -order_by      => \@order,
   -for           => $purpose,
   -post_SQL      => sub {...},
   -pre_exec      => sub {...},
   -post_exec     => sub {...},
   -post_bless    => sub {...},
   -prepare_attrs => \%attrs,
   -limit         => $limit,
   -offset        => $offset,
   -page_size     => $page_size,
   -page_index    => $page_index,
   -column_types  => \%column_types,
   -result_as     => 'rows'      || 'firstrow'
                  || 'hashref'   || [hashref => @cols]
                  || 'sth'       || 'sql'
                  || 'subquery'  || 'flat_arrayref'
                  || 'statement' || 'fast_statement'

=cut

	my @valid_result_as = ( qw( rows firstrow hashref sth sql subquery statement
		flat_arrayref fast_statement ) );

	log_debug { 'result as: ' . Dumper $args->{result_as} };

	if ( $args->{result_as} && 'html' ne $args->{result_as} ) {
#		if ( 'csv' eq $args->{result_as} ) {
			return $stt->refine( -result_as => 'statement' );
#		}
#		elsif ( grep { $_ eq $args->{result_as} } @valid_result_as ) {
#			return $stt->refine( -result_as => $args->{result_as} );
#		}
	}

	if ( $args->{dbixdm} ) {
		return $stt->refine( %{$args->{dbixdm}} );
	}

	if ( $args->{check_results} ) {
		return $self->check_results({
			results => $stt->all,
			%{$args->{check_results}}
		});
	}

#	log_debug { 'statement: ' . Dumper $stt };

	return $stt->all;

}


=head2 check_results

Make sure that we got all the results we were hoping for!

@param $args    hashref with keys

	param    - parameter of the result objects to examine
	query    - arrayref containing the original query
	results  - arrayref of results (from run_query or elsewhere)
	subject  - human-readable string representing param
	           (for the error message)

@return     dies on failure with an error message

=cut

sub check_results {
	my $self = shift;
	my $args = shift;

	for ( qw( param query results subject ) ) {
		if ( ! defined $args->{$_} ) {
			$self->choke({
				err => 'missing',
				subject => 'check_results parameter "' . $_ . '"'
			});
		}
	}

	if ( ! scalar @{$args->{results}} ) {
		$self->choke({
			err => 'no_results',
			subject => $args->{subject}
		});
	}
	my $results = $args->{results};
	my %all;

	@all{ @{$args->{ query } } } = ( 1 ) x scalar @{ $args->{query} };

	for ( @$results ) {
		delete $all{ $_->{ $args->{param} } };
	}

	if ( keys %all ) {
		$self->choke({
			err => 'missing_results',
			subject => $args->{subject},
			ids => [ keys %all ]
		});
	}
	return $results;
}


=head2 add_filters

Add the filters for the query

@param $args    hashref with keys

	statement   - the DBIx::DataModel statement object
	filters     - whatever filters are to be applied
	              (see ProPortal::IO::ProPortalFilters for examples)

@return  $stt   modified statement object

=cut

sub add_filters {

	my $self = shift;
	my $args = shift;

	if ( ! $args->{statement} ) {
		$self->choke({
			err => 'missing',
			subject => 'DBIxDataModel statement object'
		});
	}

	if ( ! $args->{filters} ) {
		return $args->{statement};
	}

	## This is implemented by ProPortal::IO::ProPortalFilters
	my $f = $self->filter_sqlize( $args->{filters} );

	$args->{statement}->refine( -where => $f );

	return $args->{statement};

}

1;
