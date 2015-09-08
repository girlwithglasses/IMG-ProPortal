#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';

use IMG::App::Core;
use IMG::IO::DbConnection;
use IMG::Util::DBIxConnector;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with 'IMG::IO::DbConnection';
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

	throws_ok { $test->db_conn() } qr!Specify a connection to return!, 'db_conn, no args';
	throws_ok { $test->db_conn_no_create() } qr!Specify a connection to return!, 'db_conn_no_create, no args';
	throws_ok { $test->create_db_conn() } qr!Specify a connection to create!, 'create_db_conn, no args';
	throws_ok { $test->set_db_conn() } qr!No name supplied for dbh!, 'set_db_conn, no args';

	throws_ok { $test->connection_for_schema() } qr[No schema specified];

	# missing arg
	throws_ok { $test->set_db_conn('pip') } qr[No database handle supplied], 'set_db_conn, one arg';

	# no config
	throws_ok { $test->db_conn('blobby') } qr[No db conf found for blobby];

	throws_ok { $test->connection_for_schema('complete_rubbish') } qr[No configuration data found for complete_rubbish];

	# crap config
	throws_ok { $test->db_conn('complete_rubbish') } qr[database connections require either a DSN string or the database name and driver];

	# crap config
	throws_ok { $test->connection_for_schema('nonsense') } qr[database connections require either a DSN string or the database name and driver];

	TODO : {
		local $TODO = 'Add DB connection timeout code';
		# TO DO: add test for DB connection time out (or similar error)
		ok( undef, 'Add a test for DB connection time out here!' );

	}

	# this will die!
	# type matching fail...
	throws_ok { $test->set_db_conn('pip', { a => 'b' } ) } qr[did not pass type constraint], 'type matching fail';

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


