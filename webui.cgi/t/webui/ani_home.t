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
use FindBin qw/ $Bin /;
use Test::MockModule;

use_ok( 'ANI::Home' );

my $ani_home = Test::MockModule->new( 'ANI::Home' );

my $stats = {
  acount => "8,030",
  bcount => "22,476",
  ccount => "5,075",
  date => "Wed Sep 16 2015",
  dcount => "6,046",
  ecount => "3,697",
  print_stats => 1,
  xcount => "33,009",
  ycount => "283,409,637",
  zcount => "14,200,127"
};



subtest 'get ani stats' => sub {

	$ani_home->mock('get_stats_file', sub { return 'not_a_file' } );

	is_deeply( ANI::Home::get_ani_stats(), {}, 'Checking results without a stats file' );

	$ani_home->mock('get_stats_file', sub { return 't/files/bcNp/anistats.stor'; } );

	is_deeply( ANI::Home::get_ani_stats(), $stats, 'Checking results with a stats file' );

};

{   package TemplateApp;
    use IMG::Util::Base 'Class';
    has 'config' => ( is => 'ro' );
    with 'IMG::App::Role::LinkManager', 'IMG::App::Role::Templater';
    1;
}

subtest 'template rendering' => sub {

	my $dir = $Bin;
	$dir =~ s!webUI/.*!webUI/proportal/!;

#    TODO: test template with or without stats

    my $tmpl_app = TemplateApp->new( { base_dir => $dir } );
	my $output = $tmpl_app->render_template( 'pages/ani_home.tt', ANI::Home::get_ani_stats() );

	ok( $output =~ m!<strong>$stats->{acount}</strong>! && $output =~ m!Updated $stats->{date}!, 'Checking content' );


};



done_testing();
