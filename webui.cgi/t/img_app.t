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
use IMG::Util::Base 'Test';
use FindBin qw/$Bin/;
use CGI::Session;

my $base = $Bin;

say "Base dir: $base";

$ENV{TESTING} = 1;

use_ok( 'IMG::App' );

my $app = IMG::App->new();
my $config = { pip => 'pap' };
my $session = bless( {}, 'CGI::Session' );
my $core = IMG::App->new( config => $config, session => $session );

say 'App: ' . Dumper $core;

ok( $core->has_session, 'App has session' );

done_testing();
