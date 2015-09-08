#!/usr/bin/perl -w

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );

use IMG::Util::Base 'Test';
use JSON;
use IMG::App::JGISessionClient;
use IMG::App::Core;

# in t/lib:
use MyUserAgent;
use DataModel::IMG_Test;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with qw(
		IMG::App::JGISessionClient
		IMG::IO::HttpClient );
}

my $obj;


# get_jgi_user_json
# check_jgi_session
# _run_request

subtest '_run_request' => sub {

	$obj = TestApp->new();

	throws_ok { $obj->_run_request() } qr[No URL specified for _run_request];

	throws_ok { $obj->_run_request('') } qr[No URL specified for _run_request];

	my @requests = (
		sub {
			return 'GET';
		},
	);
	my @head_req = (
		sub {
			return 'HEAD';
		},
		sub {
			return 'HEAD';
		},
	);

	my $user_agent = MyUserAgent->new(
		get  => sub { shift(@requests)->(@_) },
		head => sub { shift(@head_req)->(@_) },
	);

	$obj->set_http_ua( $user_agent );

	ok( 'HEAD' eq $obj->_run_request( 'URL', 'head' ), 'Checking head response' );

	ok( 'HEAD' eq $obj->_run_request( 'URL', 1 ), 'Checking head response' );

	ok( 'GET' eq $obj->_run_request( 'URL' ), 'Checking get request' );

};


subtest 'get_jgi_user_json' => sub {
	# tests for get_jgi_user_json()
	$obj = TestApp->new();
	throws_ok { $obj->get_jgi_user_json(undef) } qr!No user ID supplied!;
	throws_ok { $obj->get_jgi_user_json(0) } qr[No config found!];
	$obj = TestApp->new( config => { one => 'two' } );
	throws_ok { $obj->get_jgi_user_json(0) } qr!Missing required config parameters: sso_url_prefix!;

	$obj = TestApp->new( config => { sso_url_prefix => 'https://', sso_domain => 'example.com/' });

	# set up a fake user agent
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
	throws_ok { $obj->get_jgi_user_json( 12345 ) } qr[JSON response lacks required fields];

};


subtest 'check_jgi_session' => sub {

	# tests for get_jgi_user_json()
	$obj = TestApp->new();
	throws_ok { $obj->check_jgi_session(undef) } qr!No session ID supplied!;
	throws_ok { $obj->check_jgi_session(0) } qr[No config found!];
	$obj = TestApp->new( config => { one => 'two' } );
	throws_ok { $obj->check_jgi_session(0) } qr!Missing required config parameters: sso_url_prefix!;

	my @requests = (
		sub {
			my $url = shift;
			is(
				$url,
				"https://example.com/api/sessions/12345.json",
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
				"https://example.com/api/sessions/abcdef.json",
				'Correct URL',
			);

			return {
				success => 1,
				status  => 200,
			};
		},

		sub {
			my $url = shift;
			is(
				$url,
				"https://perl.com/api/sessions/blobby.json",
				'Correct URL',
			);

			return {
				success => 1,
				status  => 204,
			};
		},
	);

	my $user_agent = MyUserAgent->new(
		head => sub { shift(@requests)->(@_) },
	);

	$obj = TestApp->new( config => { sso_url_prefix => 'https://', sso_domain => 'example.com/' }, http_ua => $user_agent );

	# no user data
	ok( 0 == $obj->check_jgi_session( 12345 ), '500 error' );

	# valid json
	ok( 1 == $obj->check_jgi_session('abcdef'), 'Valid session' );

	$obj->set_config({ sso_url_prefix => 'https://', sso_domain => 'perl.com' });
	# invalid json
	ok( 1 == $obj->check_jgi_session( 'blobby' ), 'Valid session' );

};


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

