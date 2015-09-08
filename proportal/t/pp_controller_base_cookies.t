#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'NetTest';
use HTTP::CookieJar;
use Test::MockModule;

my $jar  = HTTP::CookieJar->new;
my $test = Plack::Test->create( ProPortal->to_app );
my $mm = Test::MockModule->new('ProPortal');
$mm->mock(subname => sub { return ... });

$Plack::Test::Impl = "Server";

# to test $psgi, prefix the request with "proportal/"
my $prefix = "";

subtest 'A empty request' => sub {
    my $res = $test->request( GET '/' );
    ok( $res->is_success, 'Successful request' );
#    is( $res->content '{}', 'Empty response back' );
    $jar->extract_cookies($res);
	ok( ! $jar->as_string, "No cookies present" );
#    ok( $jar->as_string, 'We have cookies!' );
};


subtest 'Login page' => sub {
	my $res = $test->request( GET '/login' );
    ok( $res->is_success, 'Successful request' );
    ok( $res->content =~ / /);
	my @c_arr = $jar->cookies_for( $res );
	say 'Cookie array: ' . Dumper \@c_arr;
	ok ( grep { 'jgi_return' eq $_->{name} && '.jgi-psf.org' eq $_->{domain} } @c_arr );
	ok ( ! grep { 'jgi_session' eq $_->{name} } @c_arr );
};


subtest 'Run login' => sub {



};

subtest 'Logged in' => sub {
	my $res = $test->request( GET '/logged_in' );
	ok( $res->is_success, 'Request successful' );
	ok( $res->content =~ /you are logged in/ );
	# check cookies
	my @c_arr = $jar->cookies_for( $res );
	ok( grep { 'jgi_session' eq $_->{name} } @c_arr );
	ok( grep { 'CGISESSID_proportal' eq $_->{name} } @c_arr );

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
