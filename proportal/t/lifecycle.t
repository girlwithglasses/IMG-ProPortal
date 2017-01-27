#!/usr/bin/env perl
use strict;
use warnings;

package TestServer;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Import;
use Data::Dumper::Concise;
use Dancer2;
use Dancer2::Session::CGISession;
use base 'ProPortal';

#my $s = setting 'session';

#say $s;

#say "application: " . Dumper app;
set session => "CGISession";



=cut

set engines => {
	session => {
		CGISession => {
			name => 'CGISESSID_proportal',
			cookie_name => 'CGISESSID_proportal',
			cookie_domain => 'jgi-psf.org',
			driver_params => {
				Directory => '/tmp',
				cookie_duration => '1.5 hours',
				cookie_name => 'CGISESSID_proportal',
			},
		},
	},
};

=cut

get '/no_session_data' => sub {
    return "session not modified";
};

get '/set_session/*' => sub {
    my ($name) = splat;
    session name => $name;
	say Dumper session;
#	say Dumper engine 'session';

};

get '/read_session' => sub {
    my $name = session 'name';
    return "name='$name'";
};

get '/destroy_session' => sub {
    my $name = session('name') || '';
    app->destroy_session;
    return "destroyed='$name'";
};

get '/churn_session' => sub {
    app->destroy_session;
    session name => 'damian';
    return "churned";
};

get '/logout' => sub {
	app->destroy_session;
};

1;

package main;
use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Import 'NetTest';
use ProPortal;
use Dancer2;

my $test = Plack::Test->create( TestServer->to_app );
my $pp = Plack::Test->create( ProPortal->to_app );


my $jar = HTTP::Cookies->new( autosave => 1, );
my $req = GET 'http://localhost/no_session_data';
$jar->add_cookie_header($req);
my $res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
$jar->extract_cookies($res);
ok( !$jar->as_string, 'No cookie as nothing stored in session');

$req = GET 'http://localhost/set_session/John';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
$jar->extract_cookies($res);

ok( $jar->as_string, 'Session created, cookie set' );
my $jar_content = $jar->as_string;
say "jar contents: " . $jar_content;

$req = GET 'http://localhost/login';
$jar->add_cookie_header($req);
$res = $test->request(GET '/login');
ok( $res->code == 404, "Unsuccessful request" );

$req = GET 'http://localhost/read_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "name='John'", 'Correct value retrieved from session');
$jar->extract_cookies($res);
ok( $jar->as_string, 'Cookie is still there' );
is( $jar->as_string, $jar_content, "Session cookie did not change");
$jar_content = $jar->as_string;

$req = GET 'http://localhost/churn_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "churned", 'Correct value' );
$jar->extract_cookies($res);
ok( $jar->as_string, 'Cookie is there' );
isnt( $jar->as_string, $jar_content, "Session cookie did change");
$jar_content = $jar->as_string;

$req = GET 'http://localhost/read_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "name='damian'", 'Correct value retrieved from session after churn');
$jar->extract_cookies($res);
ok( $jar->as_string, 'Cookie is still there' );
is( $jar->as_string, $jar_content, "Session cookie did not change");
$jar_content = $jar->as_string;

$req = GET 'http://localhost/destroy_session';
$jar->add_cookie_header($req);
$res = $test->request( $req );
ok( $res->is_success, 'Successful request' );
is( $res->content, "destroyed='damian'", 'Correct value retrieved from session');
$jar->extract_cookies($res);
ok( !$jar->as_string, 'Cookie has been trashed' );

$req = GET 'http://localhost/login';
$jar->add_cookie_header($req);
$res = $pp->request( $req );
ok( $res->code == 200, "Checking for a successful request" );
$jar->extract_cookies($res);
ok( $jar->as_string =~ /jgi_return/, "JGI return cookie found" );

# check we have the jgi_return cookie
#ok( cookies->{jgi_return} && cookies->{jgi_return} eq 'http://localhost/logged_in', "checking JGI return cookie" );

#say "response: " . Dumper $res;
$req = GET '/proportal/location';
$jar->add_cookie_header( $req );
$res = $pp->request( $req );
ok( $res->content =~ /login.tt/, "Redirected to login page" );

# after a successful login, we will have a JGI session cookie
$jar->set_cookie( '', 'jgi_session', '%2Fapi%2Fsessions%2Fda02caa2628274b12a0612487dd206a6', '/', 'jgi-psf.org' );
$req = GET '/proportal/location';
$jar->add_cookie_header( $req );
$res = $pp->request( $req );
ok( $res->code == 200, "Checking for a successful request" );
say "page content now: " . Dumper $res->content;

ok( $res->content =~ /location.tt/, "checking page content");

$jar->extract_cookies($res);
say "cookies now: " . Dumper $jar;


done_testing;
