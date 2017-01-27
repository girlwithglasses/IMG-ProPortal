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
	@dir_arr = map { catdir( $dir, $_ ) } ( 'install/proportal-test', 'install' );
}

use lib @dir_arr;
use IMG::Util::Import;
use WebConfig qw();
use Config::Any;
use IMG::Util::ConfigValidator;

my $cnf = IMG::Util::ConfigValidator::make_config({
	dir => $dir,
	schema => 'schema',
	db => 'db',
#	debug => 'debug'
});

$cnf->{logger} = 'File';
$cnf->{engines}{logger}{File} = {
#	log_dir => catdir( $dir, '../logs/' ),
	log_dir => '/global/homes/a/aireland/logs',
	log_level => 'debug',
	log_file  => 'proportal_test.log'
};

say 'logger conf: ' . Dumper $cnf->{engines};

$cnf->{sso_url_prefix} = 'https://signon.';
$cnf->{sso_domain} = 'jgi.doe.gov';

return $cnf;
