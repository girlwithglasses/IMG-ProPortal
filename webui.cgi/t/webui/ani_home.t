#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/../lib", "$Bin/../t/lib", "$Bin/../../webui.cgi" );
use IMG::Util::Base 'Test';
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

subtest 'template rendering' => sub {

	my $dir = $Bin;
	$dir =~ s!webUI/.*!webUI/proportal/!;
	IMG::Views::Templater::init_env( { base_dir => $dir } );
	my $output = IMG::Views::Templater::render_template( 'pages/ani_home.tt', ANI::Home::get_ani_stats() );

	ok( $output =~ m!<strong>$stats->{acount}</strong>! && $output =~ m!Updated $stats->{date}!, 'Checking content' );


};



done_testing();
