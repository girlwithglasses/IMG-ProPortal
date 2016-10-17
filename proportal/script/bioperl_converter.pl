#!/usr/bin/env perl

my @dir_arr;
BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib );
}

use lib @dir_arr;
use IMG::Util::Base;

# use Dancer2;
use IMG::App::Role::ErrorMessages qw( script_die );
use Getopt::Long;
use ProPortal::App::BioPerlConverter;

my $args = {};
my $opt = GetOptions( $args,
	"outfile|o=s",
	"infile|i=s",
	"from|t=s",
	"to|t=s",
	"test|t"         # flag for test mode
) or script_die( 255, "Error in command line arguments" );

# Dirty switching of suffixes due to Galaxy <=> BioPerl conflicts
for ( $args->{to}, $args->{from} ) {
	if ( 'nhx' eq $_ ) {
		$_ = 'newick';
	}
	elsif ( 'nhxtnd' eq $_ ) {
		$_ = 'nhx';
	}
}

eval {
	ProPortal::App::BioPerlConverter->new(
		#config => config,
		args => $args
	)->convert();
};

script_die( 255, [ $@ ] ) if $@;

exit(0);
