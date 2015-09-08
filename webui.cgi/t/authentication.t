#!/usr/bin/perl -w

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/lib", "$Bin/../../proportal/lib");

use IMG::Util::Base 'NetTest';

use Dancer2;
use CoreStuff;
use Routes::GateKeeper;

my $app = Routes::GateKeeper->to_app;
is( ref $app, 'CODE', 'Got app' );

done_testing();

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/launch' );

#ok( $res->is_success, '[GET /launch] successful' );
