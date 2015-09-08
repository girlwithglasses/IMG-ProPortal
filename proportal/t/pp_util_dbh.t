#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'Test';

use Config::Any;
use Try::Tiny;
use ProPortal;

my $base = dirname( $Bin );

my $t_files_dir = $base . '/t/files/';


$Data::Dumper::Indent = 1;
$Data::Dumper::Sortkeys = 1;
$ENV{DBI_TRACE} = 3;
$ENV{DBIC_TRACE} = 1;

#ProPortal::Util::DBH::db_connect(





use TestApp;
{
    package TestApp;
    use Dancer2;
    use parent 'ProPortal';
    set log => 'debug';
}


# read in the config file, get the DB schema
my @files = map { $t_files_dir.$_ } qw( db_conf_dbi db_conf_multi );
my $conf = Config::Any->load_stems( { stems => [ @files ], use_ext => 1, flatten_to_hash => 1 } );

use_ok( 'ProPortal::Util::DBH' );

# db_conf_dbi.pl

my $mods = {
	"" => 'ProPortal::IO::DBI',
	dbi => 'ProPortal::IO::DBI',
	datamodel => 'ProPortal::IO::DBIxDataModel',
};

my $dbs = {
	missing => undef,
	valid => 'imgsqlite',
	invalid => 'Mr. Blobby',
};

# by default, the app's data access object is a DBI handle
# conf files have no dbi_module set

for my $f (sort keys %$conf) {

	# specify DBI or DataModel
#	for my $m (sort keys %$mods) {
		# specify a primary db, valid or otherwise!
		for my $d (keys %$dbs) {
			say "";
			say "config file: $f";
			say "input db arg: $d";
				try {

					my $p2 = TestApp->to_app;

					( undef, {
						%{$conf->{$f}},
					#	dbi_module => $m,
						primary_db => $dbs->{$d}
					} );
					isa_ok( $p2, 'ProPortal::Controller::Home', 'checking app type' );
				#	ok( $p2->has_dao, 'Checking the PP dao handle' );
				#	isa_ok( $p2->dao, $mods->{$m}, 'Checking type of PP DAO class');
				}
				catch {
					warn "Caught an error: $_";
				}
		}
#	}

=cut
	my $pp = ProPortal::bootstrap( 'Details', $conf->{$f} );
	isa_ok( $pp, 'ProPortal::Controller::Details', 'checking app type' );
	ok( $pp->has_dao, 'Checking the PP dao handle' );
	isa_ok( $pp->dao->dbh, 'Dancer::Plugin::Database::Core::Handle' );
=cut
}


=cut
my $t4 = ProPortal::bootstrap( 'Details', { dbi_module => 'dbi', plugins => { %{$conf_h->{1}{plugins}}, %{$conf_h->{2}{plugins}} } } );
isa_ok( $t4, 'ProPortal::Controller::Details', 'checking app type' );
ok( $t4->has_dao, 'Checking the PP dbi handle' );
isa_ok( $t4->dao->dbh, 'Dancer::Plugin::Database::Core::Handle' );


	my $c = $conf->{$f};
	my $pp = ProPortal::bootstrap('Details', $c);

my $t = ProPortal::bootstrap(undef, $conf_h->{1});
isa_ok( $t, 'ProPortal::Controller::Home', 'checking PP app isa ProPortal controller' );
ok( $t->has_dao, 'Checking the PP data access object' );
isa_ok( $t->dao->schema, 'DbSchema::IMG_Core' );


my $t3 = ProPortal::bootstrap( 'Home', { dbi_module => 'dbic', plugins => { %{$conf_h->{1}{plugins}}, %{$conf_h->{2}{plugins}} } } );
isa_ok( $t3, 'ProPortal::Controller::Home', 'checking PP app isa ProPortal controller' );
ok( $t3->has_dao, 'Checking the PP dbi handle' );
isa_ok( $t3->dao->schema, 'DbSchema::IMG_Core' );
=cut


my $t5 = ProPortal::bootstrap( 'Home', $conf->{'/Users/gwg/img-vagrant/proportal/t/files/db_conf_multi.pl'} );
isa_ok( $t5, 'ProPortal::Controller::Home', 'checking app type' );
ok( $t5->has_dao, 'Checking the PP dbi handle' );
isa_ok( $t5->dao->dbh, 'Dancer::Plugin::Database::Core::Handle' );
my $res = $t5->dao->taxon_oid_display_name();
say "Data sources: " . Dumper $t5->dao->dbh->private_attribute_info;

#say Dumper $res;

done_testing();


sub get_schema {
	my $cfg = shift;

	if (scalar keys %$cfg == 1) {
		my @arr = values %$cfg;
		$cfg = $arr[0];
	}
	say Dumper $cfg;

	my $args = $cfg->{plugins}{DBIC}{default} || confess "Unexpected config format!";

	say "Running schema init";

	if ( try_load_class $args->{schema_class} ) {

		my $class = $args->{schema_class};
		my $schema = $class->connect(
			$args->{dsn},
			$args->{user} || undef,
			$args->{password} || undef,
			$args->{options} || { RaiseError => 1 }
		) or die $DBI::errstr;

		return $schema;
	}

	confess "Could not load schema class " . $args->{schema_class};

}

