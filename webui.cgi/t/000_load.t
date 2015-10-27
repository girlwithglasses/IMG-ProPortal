#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib webui.cgi/t/lib );
}
use lib @dir_arr;
use IMG::Util::Base 'Test';

plan tests => 1;

BEGIN {
    use_ok( 'IMG::App' ) || print "Bail out!\n";
}

diag( "Testing IMG::App $IMG::App::VERSION, Perl $], $^X" );
