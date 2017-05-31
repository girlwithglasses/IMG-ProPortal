#!/usr/bin/env perl

my @dir_arr;
my $dir;

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir catfile );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } ( 'install/proportal-galaxy', 'install' );
}

use lib @dir_arr;
use IMG::Util::Import;
use WebConfig qw();
use Config::Any;
use IMG::Util::ConfigValidator;

my $cnf = IMG::Util::ConfigValidator::make_config({
	dir => $dir,
	schema => 'schema-server',
	db => 'db-dev',
	logger => 'logger-galaxy',
# 	schema => 'schema-local',
# 	db => 'db-local',
# 	logger => 'logger-local'
});

return $cnf;
