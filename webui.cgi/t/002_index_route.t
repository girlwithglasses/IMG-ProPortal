#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib webui.cgi/t/lib );
}
use lib @dir_arr;

use IMG::Util::Base 'NetTest';

use Dancer2;
use ProPortalPackage;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

my $app = ProPortalPackage->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/launch' );

ok( $res->is_success, '[GET /launch] successful' );
ok( $res->content =~ m#3... 2... 1... blast off!#, 'Checking content');

done_testing();
