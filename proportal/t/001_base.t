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

{
	package MiniContr;
	use IMG::Util::Base 'Class';
	with 'IMG::App::Role::Controller';
	1;
}


use IMG::Util::Base 'NetTest';

use_ok 'AppCore';

use_ok 'ProPortal::Controller::Base';

my $cfg = { dbi_module => 'TSV' };

my $pp = ProPortal::Controller::Base->new($cfg);

ok( $pp->can('tmpl'), "ProPortal controller can do a template!");

ok (! $pp->can('valid_filters'), "No filters by default");

ok( ! $pp->has_tmpl_includes, "No default tmpl includes");


done_testing();
