package IMG::Util::DBIxConnector;

use IMG::Util::Import;

use DBIx::Connector;
use IMG::App::Role::ErrorMessages qw( err );

=head3 get_dbix_connector

Create a database handle for a database using DBIx::Connector

@param      hash of params, including dsn  -- the database name
                                      options   -- DBH options

@output     $conn - database connection object

=cut

sub get_dbix_connector {
	my $arg_h = shift // die err ({ err => 'missing', subject => 'connection parameters' });

	if (! ref $arg_h || ref $arg_h ne 'HASH' ) {
		die err({ err => 'format_err', subject => 'db_conn_params', fmt => 'hashref' });
	}

	if (! $arg_h->{dsn} ) {
		if (! $arg_h->{database} || ! $arg_h->{driver} ) {
			die err ({ err => 'missing', subject => "DSN string or database name and driver" });
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

	return DBIx::Connector->new(
		$arg_h->{dsn},
		$arg_h->{username} // $arg_h->{user} // undef,
		$arg_h->{password} // $arg_h->{pass} // undef,
		$arg_h->{options} // $arg_h->{dbi_params} // { RaiseError => 1 }
	) || die err ({ err => 'db_conn_err', msg => $DBI::errstr });

}

1;
