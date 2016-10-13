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
use IMG::Util::Base 'Test';
use Dancer2;
use Test::MockObject::Extends;
my $base = "$dir/proportal/t/files";

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App', 'Dancer2::Session::CGISession';
 	with 'Dancer2::Core::Role::SessionFactory', 'ProPortal::IO::DBIxDataModel';
	has "driver_params" => (
		is => 'ro',
		default => sub { { Directory => $base . '/sessions' } }
	);
	1;
}

my $app;
my $msg;

# first make sure the module loaded OK
use_ok('IMG::App::Role::UserChecks');    # test 1

# subtest 'create session' => sub {
#
# 	my $app = TestApp->new();
# 	my $session = $app->create();
# 	say 'session: ' . Dumper $session;
# 	say Dumper $app;
# };

#exit(0);
my %cfg = (
	config => {
		workspace_dir => $base . "/workspace",
		cgi_tmp_dir => $base  . "/sessions",
	},
);

subtest 'load_user_preferences' => sub {

	# session dir: files/sessions/
	$app = TestApp->new( %cfg );
	$app->set_session( $app->retrieve( id => 'fake_session') );

	# user ID: 111602
	$app->load_user_preferences();
	ok( 500 == $app->session->read('maxParalogGroups'), 'Checking prefs');
	is( undef, $app->session->read('maxProfileCandidateTaxons'), 'undefined pref');
	is( 'No', $app->session->read('genomeListColPrefs'), 'Checking prefs');
    is( 'No', $app->session->read('groupSharingDisplay'), 'Checking prefs');

	$app = TestApp->new( %cfg );
	$app->set_session( $app->retrieve( id => 'fake_session_2' ) );
	# user without prefs
	$app->load_user_preferences();
	is( undef, $app->session->read('hideGFragment'), 'no prefs' );
	is( undef, $app->session->read('maxParalogGroups'), 'no prefs' );

};

subtest 'touch_cart_files' => sub {

	$app = TestApp->new( %cfg );
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

# tests for check_banned_users()

subtest 'check_banned_users' => sub {

	$app = TestApp->new( config => test_config() );

	subtest 'error states' => sub {

		$msg = err({
			err => 'missing',
			subject => 'user names or emails'
		});

		throws_ok {
			$app->check_banned_users();
		} qr[$msg];

		throws_ok {
			$app->check_banned_users({ test => [ undef, undef, undef ] });
		} qr[$msg];

		$app = TestApp->new( config => test_config() );

		# username / email match: die with 403 error
		{	local $@;

	#		[ 'EVIL@ACME.ORG' , 'Dr. Evil' ],
	#		[ 'carmen@broderbund.org', 'carmen sandiego' ],

			my $err = eval { $app->check_banned_users({
				test => [ 'dodgy@villain.com', 'carmen sandiego' ]
			}) };

			if ( $@ ) {
				is_deeply(
				$@,
				{	status  => 403,
					title   => 'Access denied',
					message => err({ err => 'acc_locked' }),
				},
				'Checking error returned by banned user' );
			}
			else {
				ok( undef, 'Did not find banned user!' );
			}
		}

		# make sure that we're getting the correct query constructed
		Test::MockObject::Extends->new($app);
		$app->mock( 'run_query', sub {
			my $self = shift;
			my $args = shift;
			die $args->{where}[1];
		});

		{	local $@;
			my $err = eval { $app->check_banned_users({
				test => [ 'dodgy@villain.com', 'carmen sandiego', 'dodgy@villain.com', 'dodgy@villain.com' ]
			}) };

			if ( $@ ) {
				is_deeply(
				[ sort @{$@} ],
				[ 'carmen sandiego', 'dodgy@villain.com' ],
				'Checking database query' ) or diag explain $@;
			}
			else {
				ok( undef, 'database query incorrectly formed' );
			}
		}


	};

	subtest 'valid' => sub {

		$app = TestApp->new( config => test_config() );

		# user is OK
		lives_ok { $app->check_banned_users({ test => [ qw(pip pap pop) ] } ) };

	};
};



# tests for run_user_checks()

# 	my $self = shift;
# 	my $u_id = shift // $self->choke({ err => 'missing', subject => 'user ID' });
#
	# ping the server
# 	my $user_data = $self->get_jgi_user_json( $u_id );
#
# 	my $db_data = $self->get_db_contact_data({ caliban_id => $user_data->{user}{id} });
#
# 	# this will die if all is not well
# 	if ( ! $self->has_session || ! $self->session->read('banned_checked') ) {
# 		$self->check_banned_users({
# 			test => [ $db_data->{email}, $user_data->{user}{email_address}, $db_data->{username} ]
# 		});
# 	}
#
# 	# create a user object
# 	my $user = IMG::Model::Contact->new({ db_data => $db_data, user_data => $user_data });
# 	$self->_set_user( $user );
# 	return { db_data => $db_data, user_data => $user_data };

# TestApp->new( config => { sso_url_prefix => 'https://', sso_domain => 'example.com/' });


subtest 'run_user_checks' => sub {

	$app = TestApp->new(
		config => test_config(),
		user_agent => get_test_useragent()
	);

	subtest 'error states' => sub {

		$msg = err({ err => 'missing', subject => 'user ID' });
		throws_ok {
			$app->run_user_checks();
		} qr[$msg];

		throws_ok {
			$app->run_user_checks( undef );
		} qr[$msg];

		# get_jgi_user_json fail
# 		$app->mock( 'get_jgi_user_json', sub {
# 			return {
# 				# valid data
# 			};
# 		});
		$msg = err({
			err => 'json_decode_err',
		});
		# invalid json
		throws_ok { $app->run_user_checks( 'invalid_json' ) } qr[$msg];

		# no user data
		local $@;
		my $err = eval { $app->run_user_checks( 'no_user_data' ) };
		is_deeply( $@, { status => 500, title => 'error', message => 'fake' }, 'Checking death is appropriate');


		$msg = err({
			err => 'caliban_err'
		});
		# invalid response
		throws_ok { $app->run_user_checks( 'resp_fmt_invalid' ) } qr[$msg];

# 		# get_db_contact_data fail
# 		$app->mock( 'get_db_contact_data', sub {
# 			return { # VALID DATA!
#
# 			};
# 		});

		# no args
		$msg = err({ err => 'missing', subject => "identifier for contact" });
		throws_ok {
			$app->get_db_contact_data;
		} qr[$msg];

		throws_ok {
			$app->get_db_contact_data({});
		} qr[$msg];

		$msg = err({
			err => 'invalid_enum',
			type => 'identifier for contact',
			subject => 'user_id',
			enum => [ qw( caliban_id contact_oid email ) ]
		});
		throws_ok {
			$app->get_db_contact_data({ user_id => 5});
		} qr[$msg];

		$msg = err({
			err => 'invalid',
			subject => 'img_core',
			type => 'schema'
		});

		# no db config
		throws_ok {
			$app->get_db_contact_data({ caliban_id => 0 });
		} qr[$msg];

		# load the test db
		$app = TestApp->new( config => test_config() );

		$msg = err({
			err => 'no_results',
			subject => 'users',
		});
		# ID not in database
		throws_ok {
			$app->get_db_contact_data({ caliban_id => 25 });
		} qr[$msg];

		# too many results!
		$msg = err({
			subject => 'users with matching user IDs',
			err => 'unexpected',
			msg => 'expected one result, but got 3'
		});

		Test::MockObject::Extends->new($app);
		$app->mock( 'run_query', sub {
			return [
		bless( {
			__schema => 1,
			contact_oid => 11,
			email => "NCKyrpides\@lbl.gov",
			img_editing_level => undef,
			img_editor => "Yes",
			img_group => 400,
			name => "Nikos Kyrpides",
			super_user => "Yes",
			username => "nikos"
		}, 'DataModel::IMG_Test::Contact' ),
		bless( {
			__schema => 1,
			contact_oid => 12,
			email => "ALykidis\@lbl.gov",
			img_editing_level => undef,
			img_editor => "No",
			img_group => 400,
			name => "Thanos Lykidis",
			super_user => "No",
			username => "thanos"
		}, 'DataModel::IMG_Test::Contact' ),
		bless( {
			__schema => 1,
			contact_oid => 14,
			email => "phugenholtz\@lbl.gov",
			img_editing_level => undef,
			img_editor => "Yes",
			img_group => undef,
			name => "Phil Hugenholtz",
			super_user => "No",
			username => "MISSING username!!"
		}, 'DataModel::IMG_Test::Contact' )
			];
		} );

# 		my $results = $obj->run_query({
# 			query => 'user_data',
# 			where => {}
# 		});
# 		say 'results: ' . Dumper $results;


		throws_ok {
			$app->get_db_contact_data({ caliban_id => 1 });
		} qr[$msg];

		# check_banned_users -- no session OR session banned_checked is true
		# carmen sandiego should trigger a fail

	};

	subtest 'valid' => sub {
		# load the test db
		$app = TestApp->new( config => test_config() );

		# working result
		my $user = $app->get_db_contact_data({ caliban_id => 4 });
		ok( $user->{contact_oid} == 14 && ! defined $user->{img_group} && $user->{super_user} eq 'No', 'Checking user details' );
	};



# 		#
# 		$app->mock( 'check_banned_users', sub { return; } );
#


#	};


	subtest 'valid' => sub {

		# set up

# 		my $got = $app->run_user_checks( $user_id );
#
# 		is_deeply(
# 			$got,
# 			{ db_data => ..., user_data => ... },
# 			'valid data for user checks'
# 		) or diag explain $got;
#
# 		ok( '' eq $app->user->email, 'checking email' );
# 		ok( '' eq $app->user->contact_id, 'checking contact ID' );

	};


#ok( $obj->run_user_checks(0), '' );
#ok( $obj->run_user_checks(''), '' );
#ok( $obj->run_user_checks('some','args'), '' );

# direct calls in case you want them....
#ok( IMG::App::Role::User::run_user_checks(undef), '' );
#ok( IMG::App::Role::User::run_user_checks(0), '' );
#ok( IMG::App::Role::User::run_user_checks(''), '' );
#ok( IMG::App::Role::User::run_user_checks('some','args'), '' );
};

=cut

done_testing();

# oo tests
#=cut
my $obj = Test::MockModule('IMG::App::Role::UserObj');
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

=cut
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

