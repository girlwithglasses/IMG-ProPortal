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
use IMG::Util::Base 'NetTest';

use ProPortalPackage;
use Test::More;

my $psgi = Plack::Util::load_psgi( "$dir/proportal/bin/app.psgi" );

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
