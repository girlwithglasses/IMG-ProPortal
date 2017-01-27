#!/usr/bin/env perl

my $dir;
my @dir_arr;
BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib );
}

use lib @dir_arr;
use IMG::Util::Import 'Class';
use IMG::App::Role::ErrorMessages qw( script_die );
use Getopt::Long;
use ProPortal::App::JBrowseGalaxyPrep;
use Dancer2;

my $args = {};
my $opt = GetOptions( $args,
	"taxon_oid|t=s",
	"sequence|s=s",
	"gff|g=s",
	"email|e=s",
#	"test|t"         # flag for test mode
) or script_die( 255, "Error in command line arguments" );

eval {
	ProPortal::App::JBrowseGalaxyPrep->new( config => config, args => $args )->run();
};

script_die( 255, [ $@ ] ) if $@;

exit(0);
