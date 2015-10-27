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
use IMG::Util::Timed qw( time_this );



subtest 'timed test' => sub {

	my $fn = sub {
		sleep( shift() );
		return 'passed';
	};

	is( 'passed', time_this( 2, $fn, 1 ), 'Checking a timed function' );

	local $@;
	is( undef, time_this( 1, $fn, 2 ), 'Checking another timed function' );
	is( 'timeout', $@, 'Checking timeout message' );

    throws_ok { time_this( $fn ) } qr[Wrong number of parameters];

    throws_ok { time_this( undef, $fn ) } qr[Undef did not pass type constraint "Int"];

};

done_testing();
