#!/usr/bin/perl -w

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );

use IMG::Util::Base 'Test';
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
