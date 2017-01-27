package ProPortal::Util::Schema;

use IMG::Util::Import 'MooRole';

with 'ProPortal::Util::DBH';

requires 'config';


1;


package ProPortal::Util::DBH;

use IMG::Util::Import 'MooRole';

use ProPortal::Util::Factory;

requires 'config';

=head3 get_connection_for_schema

=cut

sub get_connection_for_schema {
	my $self = shift;
	my $schema = shift || croak 'No schema specified';
	croak 'No database info in config!' if not defined $self->config->{db};
	croak 'No schemas specified in config' if not defined $self->config->{db}{schema};
	croak "Schema $schema not specified in config" if not defined $self->config->{db}{schema}{$schema};

	my $dbi_class = 'DBI';
	if ( $self->config->{db}{dbi_module} && $self->config->{db}{dbi_module} =~ /datamodel/i ) {
		$dbi_class = 'DBIxDataModel';
	}

#	elsif ( $config->{dbi_module} =~ /(dbic|class)/i ) {
#		$dbi_type = 'DancerDBIC';
#		$dbi_class = 'DBIC';
#	}

	# get the relevant DBH
	my $dbconn = $self->db_connect( $self->config->{db}{schema}{$schema} );

	# now create and return the data access object
	return ProPortal::Util::Factory::create_pp_component( 'IO', $dbi_class, { config => $self->config, %$dbconn } );

}

=head3 db_connect

Return the appropriate DBI connection according to the config given

@param $config - hash of configuration variables

Relevant variables:

- dbi_module => dbi | datamodel

	dbic | dbixclass (deprecated)
	dbic and dbixclass will load DBIx::Class schema
	development has now shifted to using DBIx::DataModel

- db => 'db_name'
	# the database to connect to

- plugins->{Database}
	# use a Dancer2::Plugin::Database-based config
	# does not work with Oracle DBs so Oracle dbs use
	# the standard DBIx::Connector object

- plugins->{DBIC}
	# use a Dancer2::Plugin::DBIC-based config

@return a database handle object for DBI or a DBIx::Class schema for DBIC

=cut

sub db_connect {
	my $self = shift;
	my $db = shift || croak "No database specified in db_connect";

	my $dbi_type = 'DBI';

	croak "No database configurations found!" if not defined $self->config->{db} || not defined $self->config->{db}{conf};

	croak "No database config exists for $db" unless $self->config->{db}{conf}{$db};

	my $conn_conf = $self->config->{db}{conf}{$db};

	croak "No database driver specified" unless $conn_conf->{driver};

	croak "No database name specified" unless $conn_conf->{database};

	# don't use the Dancer DB plugin if it's an Oracle DB
	if ( 'Oracle' eq $conn_conf->{driver} ) {
		$dbi_type = 'DBIxConnector';
		# make sure hash key names are lowercased
		$conn_conf->{options} = {
			%{ $conn_conf->{dbi_params} },
			FetchHashKeyName => 'NAME_lc',
		};
	}
#	else {
#		# we can use DancerDatabase
#		$dbi_type = 'DancerDatabase';
#	}
#	$conn_conf = $conn;

	# create the DB connection
	return ProPortal::Util::Factory::create_pp_component( 'Util', $dbi_type, $conn_conf );

}

=cut
	if ( $self->config->{plugins} || $self->config->{db_conf} ) {
		say "found plugins or db_conf";
		if ( $config->{plugins}{DBIC} ) {
			$dbi_type = 'DancerDBIC';
			$dbi_class = 'DBIC';
		}
		elsif ( $config->{plugins}{Database} || $config->{db_conf} ) {

			my $conn = $config->{plugins}{Database} // $config->{db_conf};

			say "conn looks like this: " . Dumper $conn;

			if ( $conn->{connections} || $config->{db_conf} ) {
				if (! $config->{$db} ) {
					croak "No primary database specified";
				}

				$conn = $conn->{connections} if $conn->{connections};

				if (! $conn->{ $config->{$db} } ) {
					croak "No database config specified for " . $config->{$db};
				}

				$conn = $conn->{ $config->{$db} };
			}
=cut

1;


package ProPortal::Util::DBI;

use IMG::Util::Import;
use DBI;

sub new {
	my $class = shift;
	my $arg_h = shift;
		# make sure we have a dsn string
	if (! $arg_h->{dsn}) {
		if (! $arg_h->{database} || ! $arg_h->{driver}) {

			croak __PACKAGE__ . ' ' . (caller(0))[3]
			. " requires either a DSN string or the database name and driver";
		}
		$arg_h->{dsn} = 'dbi'
			. ':' . $arg_h->{driver}
			. ':' . $arg_h->{database};
	}

	my $dbh = DBI->connect(
		$arg_h->{dsn},
		$arg_h->{username} // $arg_h->{user} // undef,
		$arg_h->{password} // $arg_h->{pass} // undef,
		$arg_h->{options} // $arg_h->{dbi_params} // { RaiseError => 1 }
	) or croak __PACKAGE__ . ' ' . (caller(0))[3] . ": could not create a DB connection: $DBI::errstr";

	return { dbh => $dbh };
}

1;


package ProPortal::Util::DBIxConnector;

use IMG::Util::Import;
use IMG::Util::DBIxConnector;

=head3 new

Create a new DB handle using IMG::Util::DBIxConnector

@param $arg_h - hashref of arguments

@return hashref in the form { dbh => $database_handle }

=cut

sub new {
	my $class = shift;
	my $arg_h = shift;

	# make sure we have a dsn string
	if (! $arg_h->{dsn}) {
		if (! $arg_h->{database} || ! $arg_h->{driver}) {

			croak __PACKAGE__ . ' ' . (caller(0))[3]
			. " requires either a DSN string or the database name and driver";
		}
		$arg_h->{dsn} = 'dbi'
			. ':' . $arg_h->{driver}
			. ':' . $arg_h->{database};
	}

#	say "params: " . Dumper $arg_h;
	my $conn = IMG::Util::DBIxConnector::get_dbix_connector( $arg_h );

	my $dbh = DBI->connect(
		$arg_h->{dsn},
		$arg_h->{username} || undef,
		$arg_h->{password} || undef,
		$arg_h->{options} // $arg_h->{dbi_params} // { RaiseError => 1 }
	) or croak __PACKAGE__ . ' ' . (caller(0))[3] . ": could not create a DB connection: $DBI::errstr";

	return { dbh => $dbh, connector => $conn };

#	return { connector => $conn };

}

1;
