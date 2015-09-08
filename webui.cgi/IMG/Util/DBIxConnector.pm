package IMG::Util::DBIxConnector;

use IMG::Util::Base;

use DBIx::Connector;

=head3 get_dbix_connector

Create a database handle for a database using DBIx::Connector

@param      hash of params, including dsn  -- the database name
                                      options   -- DBH options

@output     $conn - database connection object

=cut

sub get_dbix_connector {
	my $arg_h = shift // die "No connection parameters specified!";

	if (! ref $arg_h || ref $arg_h ne 'HASH' ) {
		die "database connection params should be specified as a hash ref";
	}

	if (! $arg_h->{dsn} ) {
		if (! $arg_h->{database} || ! $arg_h->{driver} ) {
			die "database connections require either a DSN string or the database name and driver";
		}
		$arg_h->{dsn} = 'dbi'
			. ':' . $arg_h->{driver}
			. ':' . $arg_h->{database};
	}

	return __connector( $arg_h );

}

=head3 __connector

Args validated

=cut

sub __connector {
	my $arg_h = shift;

	#say "dsn: " . $arg_h->{dsn};

	return DBIx::Connector->new(
		$arg_h->{dsn},
		$arg_h->{username} // $arg_h->{user} // undef,
		$arg_h->{password} // $arg_h->{pass} // undef,
		$arg_h->{options} // $arg_h->{dbi_params} // { RaiseError => 1 }
	) or die "DB connection error: $DBI::errstr";

}

1;
