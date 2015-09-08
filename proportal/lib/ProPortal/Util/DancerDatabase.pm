package ProPortal::Util::DancerDatabase;

use IMG::Util::Base;
use Dancer2;
use Dancer2::Plugin::Database;

=head3 new

Create a new DB handle using the Dancer2 Database plugins

@param $args - hashref of arguments

@return hashref in the form { dbh => $database_handle }

If more than one database config is present, use 'primary_db' to specify the DB
to load; i.e.

    primary_db => 'my_fave_db'

=cut

sub new {
	my $class = shift;
	my $db = shift;

	say "args to Database: " . Dumper $db;

	my $dbh;
	local $@;
	eval {
		$dbh = database( $db );
	};

	say "dbh: " . Dumper $dbh;

	croak "DBH creation failed: $@" if $@;
	return { dbh => $dbh };

}

=head3 manual_dbh

Create a database handle manually if the Database plugin doesn't work.

=cut

sub manual_dbh {

	my $conf = shift;

	my $dbh = DBI->connect(
		'dbi:' . $conf->{driver} . ':' . $conf->{database},
		$conf->{username} || undef,
		$conf->{password} || undef,
		$conf->{dbi_params} || { RaiseError => 1, FetchHashKeyName => 'NAME_lc' }
	) or croak $DBI::errstr;

	return $dbh;

}



1;
