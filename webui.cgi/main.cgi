#!/usr/bin/env perl

my @dir_arr;
my $dir;
BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } ( 'webui.cgi' );
}

use CGI;

# find out the host
my $host = virtual_host();
$host =~ s/.jgi.doe.gov//;
push @dir_arr, catdir( $dir, 'proportal/config', $host );

my $vars = {
	PATH => '/usr/bin:/bin',
	LD_LIBRARY_PATH => '',
	PERL5LIB => join ':', reverse @dir_arr
};

for my $k ( keys %$vars ) {
	system( $k . '="' . $vars->{$k} . '"' );
	system( 'export', $k );
}
system( '/webfs/projectdirs/microbial/img/bin/imgEnv2', 'perl', '-T', 'main.pl' );

if ( $? != 0 ) {
	print "An error has occurred. The command failed with the error: <br>"
	. $!
	. "<br>"
	. "Please report this error, along with the steps required to reproduce it, to imgsupp at lists.jgi-psf.org.";
}
