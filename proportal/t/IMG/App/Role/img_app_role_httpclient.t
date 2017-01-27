#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}
use lib @dir_arr;
use IMG::Util::Import 'Test';

use IMG::App::Core;
use IMG::App::Role::HttpClient;

{
	package TestApp;
	use IMG::Util::Import 'Class';
	extends 'IMG::App::Core';
	with 'IMG::App::Role::HttpClient';
}

subtest 'http_ua role tests' => sub {

	my $obj = TestApp->new();

	isa_ok( $obj->http_ua, 'HTTP::Tiny', 'Checking that we have an HTTP::Tiny object' );

	$obj->set_http_ua( IMG::App::Core->new() );
	isa_ok( $obj->http_ua, 'IMG::App::Core', 'checking that we can add any object as a UA' );

	$obj->set_http_ua({ agent => 'Mr. Biggles', timeout => 5 });

	ok( $obj->http_ua->agent eq 'Mr. Biggles', 'Checking the agent was set correctly' );

};

done_testing();


