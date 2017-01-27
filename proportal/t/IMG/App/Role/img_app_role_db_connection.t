#!/usr/bin/env perl

my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Import 'Test';
use Dancer2;

use IMG::App::Core;
use IMG::App::Role::DbConnection;
use IMG::Util::DBIxConnector;
use Test::MockModule;

{
	package TestApp;
	use IMG::Util::Import 'Class';
    extends 'IMG::App::Core';
	with qw( IMG::App::Role::DbConnection IMG::App::Role::ErrorMessages );
}

my $cfg = {
	# schema and db connection required
	schema => {
		img_core => { db => 'img_core' },
		img_gold => { db => 'test' },
		nonsense => { db => 'complete_rubbish' },
	},
	# db configs
	db => {
		test => {
			driver => 'SQLite',
			database => 't/files/test.db',
			dbi_params => {
				RaiseError => 1,
				FetchHashKeyName => 'NAME_lc',
			},
	#		log_queries => 1,
		},
		omglite => {
			driver => 'SQLite',
			database => 'dbname=:memory:',
			dbi_params => {
				RaiseError => 1,
				AutoCommit => 1,
			},
		},
		complete_rubbish => {
			foo => 'bar',
			pip => 'pap',
			pop => 'pup'
		}
	}
};

subtest 'successful tests' => sub {

	my $app = TestApp->new( config => $cfg );

	ok( ! $app->has_db_connection_h, 'Checking that there is no db connection hash' );

	ok( ! $app->db_conn_no_create('omglite'), 'uninitialised db connection' );

	# create a connection
	my $conn = $app->db_conn('omglite');

	ok( $conn->can( 'dbh' ), 'checking that the connection can reveal a DB handle');

	is_deeply( $app->db_conn('omglite'), $conn, 'Checking retrieved value' );

	my $dbh = $app->dbh('omglite');

	ok( $dbh->can('selectall_arrayref'), 'getting the db handle directly' );

	$app->clear_db_connection_h();

	ok( ! $app->has_db_connection_h, 'Cleared connections successfully' );

	# do some database stuff
	ok( $app->dbh('omglite')->get_info( 17 ) eq 'SQLite', 'Checked DBH info' );

	ok( $app->has_db_connection_h, 'We have connections!' );

	my $data = [
		[ 'evil_001', 'EVIL@ACME.ORG' , 'Dr. Evil' ],
		[ 'evil_002', 'carmen@broderbund.org', 'carmen sandiego' ],
	];
	is_deeply( $app->dbh('test')->selectall_arrayref('SELECT id, email, username FROM cancelled_user ORDER BY id'), $data, 'Checking data retrieval' );

	is_deeply( $app->db_conn('test')->dbh->selectall_arrayref('SELECT username FROM cancelled_user WHERE id = "evil_002"'), [ ['carmen sandiego'] ], 'Checking data retrieval with new dbh' );

	ok( ! $app->db_conn_no_create('blobby'), q!don't have this connection! );

	$dbh = IMG::Util::DBIxConnector::get_dbix_connector({
		driver => 'SQLite',
		database => 't/files/test.db',
		dbi_params => {
			RaiseError => 1,
			FetchHashKeyName => 'NAME_lc',
		}
	});

	is_deeply( [ $app->db_conn('test')->{_args}->() ], [ $dbh->{_args}->() ], 'Raw dbh vs role version' );

	ok( $app->set_db_conn('copied_conn', $dbh), 'Setting a valid connection' );

	is_deeply( [ $app->db_conn('copied_conn')->{_args}->() ], [ $app->db_conn('test')->{_args}->() ], 'Making sure that we get the same connection back' );

	$app = TestApp->new( config => memory_config() );

	$conn = $app->connection_for_schema('img_gold');
	ok ( $conn->can('dbh'), 'Checking we got a dbh' );

};

subtest 'testing errors' => sub {
	my $test = TestApp->new( config => $cfg );

	my $msg = err({
		err => 'missing',
		subject => 'db_conn',
	});

	for my $m ( qw( db_conn dbh db_conn_no_create create_db_conn ) ) {
		throws_ok { $test->$m } qr[$msg], "$m, no args";
	}

#	throws_ok { $test->db_conn() } qr[$msg], 'db_conn, no args';
#	throws_ok { $test->dbh } qr[$msg];
	$msg = err({
		err => 'missing',
		subject => 'schema'
	});
	throws_ok { $test->connection_for_schema() } qr[$msg];

	# missing arg(s)
	$msg = err({ err => 'missing', subject => 'database connection ID' });
	throws_ok { $test->set_db_conn() } qr[$msg];
	$msg = err({ err => 'missing', subject => 'dbh' });
	throws_ok { $test->set_db_conn('pip') } qr[$msg], 'set_db_conn, one arg';

	# no config for this
	$msg = err({
		err => 'invalid',
		subject => 'blobby',
		type => 'db_conf'
	});
	throws_ok { $test->db_conn('blobby') } qr[$msg];

	$msg = err({
		err => 'invalid',
		subject => 'complete_rubbish',
		type => 'schema'
	});
	throws_ok { $test->connection_for_schema('complete_rubbish') } qr[$msg];

	# crap config
	$msg = err ({ err => 'missing', subject => "DSN string or database name and driver" });
	throws_ok { $test->db_conn('complete_rubbish') } qr[$msg];

	# crap config
	throws_ok { $test->connection_for_schema('nonsense') } qr[$msg];

	# this will die!
	# type matching fail...
	$msg = err({
		err => 'format_err', subject => 'db_conn_params'
	});
	throws_ok { $test->set_db_conn('pip', { a => 'b' } ) } qr[$msg];

	#qr[did not pass type constraint], 'type matching fail';

	$msg = err({
		err => 'cfg_missing',
		subject => 'db'
	});
	throws_ok {
		$test = TestApp->new();
		$test->create_db_conn('blob');
	} qr[$msg];

	$msg = err({
		err => 'cfg_missing',
		subject => 'schema'
	});
	throws_ok {
		$test->connection_for_schema('blob');
	} qr[$msg];
};

subtest 'timeout test' => sub {
    $cfg->{db_connect_timeout} = 1;
	my $test = TestApp->new( config => $cfg );


    my $mock = Test::MockModule->new( 'IMG::Util::DBIxConnector' );
    $mock->mock('get_dbix_connector', sub { my $x; say 'Running this mockery!'; while (1) { $x++; } } );

    throws_ok { $test->create_db_conn('test') } qr[Timed out while attempting to connect to database];

};

sub memory_config {
	return {
		# schema and db connection required
		schema => {
			img_core => { db => 'memory' },
			img_gold => { db => 'memory' },
		},
		db => {
			# config details
			memory => {
				driver => 'SQLite',
				database => 'memory',
				dbi_params => {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
				},
		#		log_queries => 1,
			},
		},
	};
}


done_testing();


