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
use CGI::Session;

use_ok( 'IMG::App' );

my $app = IMG::App->new();

is_deeply( $app->config, {}, 'no config args' );
ok( ! $app->has_session, 'no session' );

$app = IMG::App->new( config => { pip => 'pap' }, session => bless( {}, 'CGI::Session' ) );

is_deeply( $app->config, { pip => 'pap' }, 'checking config' );

ok( $app->has_session, 'App has session' );
isa_ok( $app->session, 'CGI::Session' );

done_testing();
