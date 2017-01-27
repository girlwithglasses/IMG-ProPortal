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

{
	package TestApp;
	use IMG::Util::Import 'Class';
	extends 'IMG::App::Core';
	with qw(
		IMG::App::Role::JGISessionClient
		IMG::App::Role::HttpClient
		IMG::App::Role::ErrorMessages
	);
}


my $app;
my $msg;

# get_jgi_user_json
# check_jgi_session
# _run_request

subtest '_run_request' => sub {

	$app = TestApp->new();

	subtest 'error states' => sub {

		$msg = err({
			err => 'missing',
			subject => 'URL for _run_request'
		});
		throws_ok { $app->_run_request() } qr[$msg];

		throws_ok { $app->_run_request('') } qr[$msg];

	};

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

	$app->set_http_ua( $user_agent );

	subtest 'valid' => sub {

		ok( 'HEAD' eq $app->_run_request( 'URL', 'head' ), 'Checking head response' );

		ok( 'HEAD' eq $app->_run_request( 'URL', 1 ), 'Checking head response' );

		ok( 'GET' eq $app->_run_request( 'URL' ), 'Checking get request' );
	};
};

subtest 'create SSO url' => sub {
	# tests for get_jgi_user_json()
	$app = TestApp->new();
	subtest 'error states' => sub {

		$msg = err({
			err => 'cfg_missing',
			subject => 'sso_config'
		});
		throws_ok { $app->_create_sso_url() } qr[$msg];
		throws_ok { $app->_create_sso_url(undef) } qr[$msg];
		throws_ok { $app->_create_sso_url( 0 ) } qr[$msg];

		my @t_set = qw( get_jgi_user_json check_jgi_session );

		$app = TestApp->new( config => { one => 'two' } );

		throws_ok { $app->_create_sso_url() } qr[$msg];
		throws_ok { $app->_create_sso_url(undef) } qr[$msg];
		throws_ok { $app->_create_sso_url( 0 ) } qr[$msg];

		for ( @t_set ) {
			throws_ok { $app->$_() } qr[$msg];
		}

		$app = TestApp->new( config => { sso_domain => 'here', sso_url_prefix => 'blob' } );

		$msg = err({
			err => 'missing',
			subject => 'ID type'
		});
		throws_ok { $app->_create_sso_url({ pip => 'pop' }) } qr[$msg];


		$msg = err({
			err => 'invalid_enum',
			subject => 'that',
			type => 'ID type',
			enum => [ qw( cookie_val session_id ) ]
		});
		throws_ok { $app->_create_sso_url({ type => 'that'}) } qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'cookie_val'
		});
		throws_ok { $app->_create_sso_url({ type => 'cookie_val' }) } qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'session_id'
		});
		throws_ok { $app->_create_sso_url({ type => 'session_id', this => 'that' }) } qr[$msg];

# 		my $err_type = {
# 			get_jgi_user_json => 'cookie_val',
# 			check_jgi_session => 'session_id'
# 		};
#
# 		for ( @t_set ) {
# 			my $x = $err_type->{ $_ };
#
# 			$msg = err({
# 				err => 'missing',
# 				subject => $x
# 			});
# 			throws_ok { $app->$_() } qr[No $x supplied];
# 			throws_ok { $app->$_(0) } qr[No $x supplied];
# 			throws_ok { $app->$_( undef ) } qr[No $x supplied];
# 			throws_ok { $app->$_( { this => "that" } ) } qr[$x must be a string];
# 		}
	};

	subtest 'valid' => sub {
		my $url = 'https://example.com/api/sessions/1234567890.json';

		$app = TestApp->new( config => { sso_url_prefix => 'https://', sso_domain => 'example.com/' });

		is_deeply( $url,
			$app->_create_sso_url({ type => 'session_id', session_id => 1234567890 }),
			'URL created with session ID'
		);

		is_deeply(
			$url,
			$app->_create_sso_url({ type => 'cookie_val', cookie_val => 'api/sessions/1234567890' }),
			'URL created with cookie value'
		);

	};

};

subtest 'get_jgi_user_json' => sub {

	$app = TestApp->new( config => { sso_url_prefix => 'https://', sso_domain => 'example.com/' });


	$app->set_http_ua( get_test_useragent() );

	subtest 'error states' => sub {

		$msg = err({
			err => 'json_decode_err',
		});
		# invalid json
		throws_ok { $app->get_jgi_user_json( 'invalid_json' ) } qr[$msg];

		# no user data
		local $@;
		my $err = eval { $app->get_jgi_user_json( 'no_user_data' ) };
		is_deeply( $@, { status => 500, title => 'error', message => 'fake' }, 'Checking death is appropriate');


		$msg = err({
			err => 'caliban_err'
		});
		# invalid response
		throws_ok { $app->get_jgi_user_json( 'resp_fmt_invalid' ) } qr[$msg];
	};

	subtest 'valid' => sub {
		# valid json
		is_deeply( $app->get_jgi_user_json('valid'), get_test_data( 'get_jgi_user_json', 'valid' ), 'Valid json returned' );

	};

};


subtest 'check_jgi_session' => sub {

	$app = TestApp->new( config => { sso_url_prefix => 'https://', sso_domain => 'example.com/' }, http_ua => get_test_useragent() );

	# no user data
	ok( 0 == $app->check_jgi_session( 'no_user_data' ), '500 error' );

	# valid json
	ok( 1 == $app->check_jgi_session( 200 ), 'Valid session' );

	$app = TestApp->new( config => { sso_url_prefix => 'https://', sso_domain => 'perl.com' }, http_ua => get_test_useragent() );
	# invalid json
	ok( 1 == $app->check_jgi_session( 204 ), 'Valid session' );

};


done_testing();
