#!/usr/bin/perl -w

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';

my $base = "$Bin/files/sessions";

$ENV{TESTING} = 1;

use IMG::App;


{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App', 'Dancer2::Session::CGISession';
	with 'Dancer2::Core::Role::SessionFactory', 'IMG::App::UserChecks';
	has "driver_params" => (
		is => 'ro',
		default => sub { { Directory => $base } }
	);
}

my $obj;

# first make sure the module loaded OK
use_ok('IMG::App::UserChecks');    # test 1

# subtest 'create session' => sub {
#
# 	my $app = TestApp->new();
# 	my $session = $app->create();
# 	say 'session: ' . Dumper $session;
# 	say Dumper $app;
# };

#exit(0);
my %cfg = ( config => {
		workspace_dir => "$Bin/files/workspace",
		cgi_tmp_dir => "$Bin/files/sessions",
	},
);

subtest 'load_user_preferences' => sub {

	# session dir: files/sessions/
	my $app = TestApp->new( %cfg );
	$app->set_session( $app->retrieve( id => 'fake_session') );

	# user ID: 111602
	$app->load_user_preferences();
	ok( 500 == $app->session->read('maxParalogGroups'), 'Checking prefs');
	is( undef, $app->session->read('maxProfileCandidateTaxons'), 'undefined pref');
	is( 'No', $app->session->read('genomeListColPrefs'), 'Checking prefs');

	$app = TestApp->new( %cfg );
	$app->set_session( $app->retrieve( id => 'fake_session_2' ) );
	# user without prefs
	$app->load_user_preferences();
	is( undef, $app->session->read('hideGFragment'), 'no prefs' );
	is( undef, $app->session->read('maxParalogGroups'), 'no prefs' );

};

subtest 'touch_cart_files' => sub {

	my $app = TestApp->new( %cfg );
	$app->set_session( $app->retrieve( id => '1a8ad3512d8d8d47073afb7d8a964ccb' ) );

	my $time = time();
	$app->touch_cart_files();
	# session ID: 1a8ad3512d8d8d47073afb7d8a964ccb
	ok(74 == $app->session->read('genome_cart_state'), 'genome cart');
	ok(1000 == $app->session->read('scaf_cart_state'), 'scaffold cart');
	ok(96 == $app->session->read('func_cart_state'), 'functions');
	ok(14 == $app->session->read('gene_cart_state'), 'gene cart');

	$app = TestApp->new( %cfg );
	$app->set_session( $app->retrieve( id => '93078af1a34d731e32b5365ab1ede128' ) );
	$app->touch_cart_files();
	# session ID: 93078af1a34d731e32b5365ab1ede128
	ok(0 == $app->session->read('func_cart_state'), 'functions');
	ok(10 == $app->session->read('genome_cart_state'), 'genome cart');
	is(undef, $app->session->read('scaf_cart_state'), 'scaffold cart');
	is(undef, $app->session->read('gene_cart_state'), 'gene cart');

	ok( ! -e $app->get_filename('gene_cart_state'), 'file not autocreated');

};

# tests for run_user_checks()
=cut
subtest 'run_user_checks' => sub {

	$obj = TestApp->new();

	throws_ok { $obj->run_user_checks() } qr[No user ID supplied];
	# no config
	throws_ok { $obj->run_user_checks( 12345 ) } qr[No config found!];


#ok( $obj->run_user_checks(0), '' );
#ok( $obj->run_user_checks(''), '' );
#ok( $obj->run_user_checks('some','args'), '' );

# direct calls in case you want them....
#ok( IMG::App::User::run_user_checks(undef), '' );
#ok( IMG::App::User::run_user_checks(0), '' );
#ok( IMG::App::User::run_user_checks(''), '' );
#ok( IMG::App::User::run_user_checks('some','args'), '' );
};
=cut

done_testing();

# oo tests
=cut
my $obj = Test::MockModule('IMG::App::UserObj');
$obj->mock( get_jgi_user_json => sub {  } );
$obj->mock( get_imgcore_contact_data => sub {  } );
$obj->mock( check_banned_users => sub {  } );

throws_ok { $obj->run_user_checks(undef) } qr!No user ID supplied!;
        my $mock = Test::MockModule('Foo');
        $mock->mock(foo => sub { print "Foo!\n"; });

        my $foo = Foo->new();
        $foo->foo(); # prints "Foo!\n"
}
=cut

sub test_config {
	return {
		dev_site => 1,
		# schema and db connection required
		schema => {
			img_core => { db => 'test', module => 'DataModel::IMG_Test' },
			img_gold => { db => 'test', module => 'DataModel::IMG_Test' },
		},
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
		}
	};
}

sub no_core_config {

	return {
		dev_site => 1,
		# schema and db connection required
		schema => {
			img_gold => { db => 'img_gold', module => 'DataModel::IMG_Gold' },
			nonsense => { db => 'complete_rubbish', module => 'Absolute::Bunkum' },
		},
		db => {
			# config details
			imgsqlite => {
				driver => 'SQLite',
				database => 'memory',
				dbi_params => {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
				},
		#		log_queries => 1,
			},
			omglite => {
				driver => 'SQLite',
				database => 'memory',
			},
			complete_rubbish => {
				foo => 'bar',
				pip => 'pap',
				pop => 'pup'
			},
		}
	};
}


sub config {

	return {
		dev_site => 1,
		# schema and db connection required
		schema => {
			img_core => { db => 'img_core', module => 'DataModel::IMG_Core' },
			img_gold => { db => 'img_gold', module => 'DataModel::IMG_Gold' },
			nonsense => { db => 'complete_rubbish', module => 'Absolute::Bunkum' },
		},
		db => {
			# config details
			imgsqlite => {
				driver => 'SQLite',
				database => 'memory',
				dbi_params => {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
				},
		#		log_queries => 1,
			},
			omglite => {
				driver => 'SQLite',
				database => 'memory',
			},
			complete_rubbish => {
				foo => 'bar',
				pip => 'pap',
				pop => 'pup'
			},
		}
	};
}

sub valid_response {
	return {
		'ip' => '24.23.163.18',
		'user' => {
			'email' => 'fatman@blobby.com',
			'contact_id' => 999,
			'id' => 666,
			'email_address' => 'fatman@blobby.com',
			'login' => 'mr_blobby',
		},
		'id' => '164204433980c73e76e55c7add829d51'
	};
}

sub invalid_response {
	return {
		'ip' => '24.23.163.18',
		'user' => {
			'email' => 'fatman@blobby.com',
			'contact_id' => 999,
			'id' => 666,
		},
		'id' => '164204433980c73e76e55c7add829d51'
	};
}

