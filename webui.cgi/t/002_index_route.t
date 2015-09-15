#!/usr/bin/perl -w

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "lib", "$Bin/../../proportal/lib");

use IMG::Util::Base 'NetTest';

use Dancer2;
use ProPortalPackage;
use Test::More tests => 2;
use Plack::Test;
use HTTP::Request::Common;

my $app = ProPortalPackage->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/launch' );

ok( $res->is_success, '[GET /launch] successful' );
ok( $res->content =~ m#3... 2... 1... blast off!#;
