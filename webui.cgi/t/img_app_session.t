#!/usr/bin/perl -w

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );

use IMG::Util::Base 'Test';
use IMG::App::User;
use IMG::App::Core;
use IMG::IO::DbConnection;
use IMG::Util::DBIxConnector;
use IMG::IO::HttpClient;
use JSON;

# in t/lib:
use MyUserAgent;
use DataModel::IMG_Test;

{
	package IMG::App::UserObj;
	use IMG::Util::Base 'Class';
	extends 'IMG::App';
#	with qw(
#		IMG::App::Session
#		IMG::App::JGISessionClient
#		IMG::IO::HttpClient
#		IMG::Schema
#		IMG::IO::DbConnection
#		IMG::App::User );
}

my $obj;
=cut
subtest 'valid jgi session' => sub {
	# tests for get_jgi_user_json()
	$obj = IMG::App::UserObj->new();
	throws_ok { $obj->get_jgi_user_json(undef) } qr[No session ID];
	throws_ok { $obj->get_jgi_user_json(0) } qr[Missing required config param sso_api_url];
	$obj = IMG::App::UserObj->new( config => { one => 'two' } );
	throws_ok { $obj->get_jgi_user_json(0) } qr[Missing required config param sso_api_url];

	$obj = IMG::App::UserObj->new( config => { sso_url_prefix => 'https://', sso_domain => 'example.com/' });

	# set up a fake user agent
	my $user_data = { data => 1 };
	my @requests = (
		sub {
			my $url = shift;
			is(
				$url,
				"https://example.com/12345.json",
				'Correct URL',
			);

			return {
				success => 0,
				status => 500,
				reason => 'error',
				content => 'fake',
			};
		},

		sub {
			my $url = shift;
			is(
				$url,
				"https://example.com/abcdef.json",
				'Correct URL',
			);

			return {
				success => 1,
				content => encode_json valid_response(),
			};
		},

		sub {
			my $url = shift;
			is(
				$url,
				"https://example.com/blobby.json",
				'Correct URL',
			);

			return {
				success => 1,
				content => '{"ip":"24.23.163.18","id":"164204433980c73e76e55c7add829d51","user":{"created_at":"2015-06-04T18:54:00Z","id":123456,"last_authenticated_at":"2015-08-18T23:12:22Z"'
			};
		},

		sub {
			my $url = shift;
			is(
				$url,
				"https://example.com/12345.json",
				'Correct URL',
			);

			return {
				success => 1,
				content => encode_json invalid_response(),
			};
		},
	);

	my $user_agent = MyUserAgent->new(
		get => sub { shift(@requests)->(@_) },
	);

	$obj->set_http_ua( $user_agent );

	# no user data
	{	local $@;
		my $err = eval { $obj->get_jgi_user_json( 12345 ) };

		is_deeply( $@, { status => 500, title => 'error', message => 'fake' }, 'Checking death is appropriate');
	}

	# valid json
	is_deeply( $obj->get_jgi_user_json('abcdef'), valid_response(), 'Valid json returned' );

	# invalid json
	throws_ok { $obj->get_jgi_user_json( 'blobby' ) } qr[JSON decoding error];

	# invalid response
	throws_ok { $obj->run_user_checks( 12345 ) } qr[JSON response lacks required fields];

};

# tests for get_db_contact_data()

#$obj = IMG::App::UserObj->new();
# oo tests
subtest 'get_contact_data' => sub {

	throws_ok { $obj->get_db_contact_data(undef) } qr[No Caliban ID supplied];

	# no db config
	throws_ok { $obj->get_db_contact_data(0) } qr[DB schema configuration for img_core not found];

#	# db connection error
#	throws_ok {  } qr[  ];

	# load the test db
	$obj = IMG::App::UserObj->new( config => test_config() );

	# no result found
	throws_ok { $obj->get_db_contact_data( 25 ) } qr[User not found];

	# working result
	my $user = $obj->get_db_contact_data( 4 );
	ok( $user->{contact_oid} == 14 && ! defined $user->{img_group} && $user->{super_user} eq 'No', 'Checking user details' );

};


# tests for check_banned_users()

#$obj = IMG::App::UserObj->new();
# oo tests
subtest 'check_banned_users' => sub {

	throws_ok { $obj->check_banned_users() } qr[No user names or emails supplied];
	throws_ok { $obj->check_banned_users( undef, undef, undef ) } qr[No user names or emails supplied];

	$obj = IMG::App::UserObj->new( config => test_config() );

	# no db connection

	# username / email match: die with 403 error
	{	local $@;

#		[ 'EVIL@ACME.ORG' , 'Dr. Evil' ],
#		[ 'carmen@broderbund.org', 'carmen sandiego' ],


		my $err = eval { $obj->check_banned_users( 'dodgy@villain.com', 'carmen sandiego' ) };
		if ( $@ ) {
			is_deeply( $@,
			{
				status  => 403,
				title   => 'Access denied',
				message => 'Your account has been locked. If you believe this is an error, please email us at <a href="mailto:imgsupp@lists.jgi-psf.org">imgsupp@lists.jgi-psf.org</a>.',
			}, 'Checking error returned by banned user' );
		}
		else {
			ok( undef, 'Did not find banned user!' );
		}
	}
	# user is OK
	lives_ok { $obj->check_banned_users( qw(pip pap pop) ) };
};


# tests for run_user_checks()

subtest 'run_user_checks' => sub {

	$obj = IMG::App::UserObj->new();

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

ok(1);

done_testing();

# oo tests

sub test_config {
	return {
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

sub config {

	return {
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

