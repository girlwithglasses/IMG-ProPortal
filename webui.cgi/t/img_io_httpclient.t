#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';

use IMG::App::Core;
use IMG::IO::HttpClient;

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with 'IMG::IO::HttpClient';
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


