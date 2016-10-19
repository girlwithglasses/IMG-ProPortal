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
	@dir_arr = map { catdir( $dir, $_ ) } ( 'webui.cgi' );
}

use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;
use CGI;

# find out the host
my $q = CGI->new();
# my $https = $q->https;
# say 'query https: ' . Dumper $https;
#
my $host = $q->virtual_host();
$host =~ s/.*?img-(.*?).jgi.doe.gov/$1/;

push @dir_arr, catdir( $dir, 'install' );
push @dir_arr, catdir( $dir, 'install', $host );

my $vars = {
	PATH => '/usr/bin:/bin',
	LD_LIBRARY_PATH => '',
	PERL5LIB => join ':', reverse @dir_arr
};

my $cmds = join " ", map { $_ . '="' . ( $vars->{$_} || '' ) . '"' } keys %$vars;

system( $cmds . ' /webfs/projectdirs/microbial/img/bin/imgEnv2 perl -T ' . catfile( $dir, 'webui.cgi', 'xml.pl' ) );

if ( $? != 0 ) {
	print "An error has occurred. The command failed with the error:\n"
	. $!
	. "\n"
	. "Please report this error, along with the steps required to reproduce it, to imgsupp at lists.jgi-psf.org.";
}
