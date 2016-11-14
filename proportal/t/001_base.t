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
use Dancer2;

{
	package MiniContr;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::Controller';
	1;
}

use_ok 'AppCore';

use_ok 'ProPortal::Controller::Base';

use_ok 'ProPortalPackage';


my $pp = ProPortal::Controller::Base->new( config );

ok( $pp->controller->can('tmpl'), "ProPortal controller can do a template!");

ok (! $pp->controller->can('valid_filters'), "No filters by default");

ok( ! $pp->controller->has_tmpl_includes, "No default tmpl includes");


my $app = ProPortalPackage->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/launch' );

ok( $res->is_success, '[GET /launch] successful' );
ok( $res->content =~ m#3... 2... 1... blast off!#, 'Checking content');

say 'app: ' . Dumper $app;

say 'test: ' . Dumper $test;

ok( $test->{app}->does( 'IMG::App::Role::Schema' ), 'Checking the app does schema' );



done_testing();
