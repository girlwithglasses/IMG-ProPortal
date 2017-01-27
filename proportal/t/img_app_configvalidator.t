#!/usr/bin/env perl

my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'proportal-dev';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib install );
}

use lib @dir_arr;
use IMG::Util::Import 'Test';
use Dancer2;
#use Config::Any;

say 'config: ' . Dumper config;

exit(0);

#require 'proportal-test/WebConfig.pm';
my $env = WebConfig::getEnv();
#say 'env: ' . Dumper $env;

my $cfg = Config::Any->load_stems({
	stems => [ $dir . '/proportal/environments/proportal-test' ],
	use_ext => 1,
	flatten_to_hash => 1
});

say 'resulting config: ' . Dumper $cfg;

#use IMG::App::ConfigValidator;



# subtest 'config loading' => sub {
#
# 	my $cfg = IMG::App::ConfigValidator::make_config(   );
#
#
#
# };

# my @files = ( catfile( $dir, 'proportal/t/files/test_cfg.pl' ) );
# my $cfg = Config::Any->load_files({
# 	files => [ @files ],
# 	use_ext => 1,
# 	flatten_to_hash => 1
# });
#
# say 'config: ' . Dumper $cfg;


done_testing();
