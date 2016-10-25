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
	@dir_arr = map { catdir( $dir, $_ ) } ( 'install/proportal-local', 'install' );
}

use lib @dir_arr;
use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;
use WebConfig qw();
use Config::Any;

my $conf = WebConfig::getEnv();

# valid levels: production, development, testing
my @pieces = qw( schema_local debug db );
#
# {
# 	schema => 'schemafile.pl',
# 	level  => 'development'
# }

my @files = map { catfile( $dir, 'proportal/environments', $_  ) } @pieces;

my $cfg = Config::Any->load_stems({
	stems => [ @files ],
	use_ext => 1,
#	flatten_to_hash => 1,
});

my $hash = {};
for ( @$cfg ) {
	my $vals = ( values %$_ )[0];
	$hash = { %$hash, %$vals };
}

my $rtn = { %$conf, %$hash };

say Dumper $rtn;

# return { img => $conf, %$hash };
return { %$conf, %$hash };
