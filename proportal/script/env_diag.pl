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

my $out;
if ( $ARGV[0] ) {
	open ( $out, '>', $ARGV[0] ) or die 'Could not open ' . $ARGV[0] . ': ' . $!;
}
else {
	$out = \*STDOUT;
}

printf { $out } "Perl version: v%vd\n", $^V;

print  { $out } '@inc: ' . "\n" . join "\n", @INC;

print  { $out } "\n\nenvironment: " . Dumper { %ENV };

exit(0);
