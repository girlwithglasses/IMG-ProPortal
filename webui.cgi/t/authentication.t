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
use CoreStuff;
use Routes::GateKeeper;

my $app = Routes::GateKeeper->to_app;
is( ref $app, 'CODE', 'Got app' );

# turn on SSO enabled, visit

done_testing();

#ok( $res->is_success, '[GET /launch] successful' );
