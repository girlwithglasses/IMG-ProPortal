#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'NetTest';
use File::Basename;
my $base = dirname($Bin);

use ProPortalPackage;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;
use HTTP::Cookies;
use Plack::Util;

my $psgi = Plack::Util::load_psgi( "$base/bin/app.psgi" );

my $pp = ProPortalPackage->to_app;
is( ref $pp, 'CODE', 'Got app' );
is( ref $psgi, 'CODE', 'Got psgi app' );

$Plack::Test::Impl = "Server";

# to test $psgi, prefix the request with "proportal/"
my $prefix = "";

my $jar  = HTTP::Cookies->new;
my $test = Plack::Test->create( ProPortal->to_app );

subtest 'A empty request' => sub {
    my $res = $test->request( GET '/' );
    ok( $res->is_success, 'Successful request' );
#    is( $res->content '{}', 'Empty response back' );
    $jar->extract_cookies($res);
	ok( ! $jar->as_string, "No cookies present" );
#    ok( $jar->as_string, 'We have cookies!' );
};


subtest 'Login' => sub {
	my $res = $test->request( GET '/login' );
    ok( $res->is_success, 'Successful request' );
    ok( $res->content =~ //);
    $jar->extract_cookies($res);
	say "jar looks like this: " . $jar->as_string;
	ok( $jar->as_string =~ /jgi_return/ );
    ok( $jar->as_string, 'created a cookie!' );
};

=cut
subtest 'Request with user' => sub {
    my $req = GET '/?user=sawyer_x';
    $jar->add_cookie_header($req);
    my $res = $test->request($req);
    ok( $res->is_success, 'Successful request' );
    is( $res->content '{"user":"sawyer_x"}', 'Empty response back' );
    $jar->extract_cookies($res);

    ok( ! $jar->as_string, 'All cookies deleted' );
};
=cut

done_testing();
