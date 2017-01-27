#!/usr/bin/env perl
my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Import 'NetTest';
use Dancer2;
use AppCore;
use Cookie::Baker;

{	package TestApp;
	use Dancer2;

	any '/login' => sub {

		my $c = Dancer2::Core::Cookie->new(
			name => 'jgi_return',
			value => '/',
			domain => config->{sso_domain},
	#		path => '/',
			expires => '5 mins'
		);

		cookie return_to => 'blob', expires => '5 mins', domain => config->{sso_domain};

		cookie cookie_name => 'Bob', expires => '10 mins', domain => 'example.com', value => 'trinity';

		push_response_header 'Set-Cookie' => $c->to_header;

	#	return '';
		redirect 'https://example.com';

	};

}
use Plack::Test;

my $app = Plack::Test->create( TestApp->to_app );
is( ref $app, 'CODE', 'Got app' );
my $jar  = HTTP::Cookies->new();

my $res = $app->request( GET '/login' );
is( $res->code, 302, '[GET /login] Correct code' );

is(
	$res->headers->header('Location'),
	config->{sso_domain},
	'Correct Location header',
);
$jar->extract_cookies( $res );

my $ha = $res->header('Cookie');
say 'ha: ' . Dumper $ha;
say 'response: ' . Dumper $res;
say 'cookies: ' . $jar->as_string;
say 'headers: ' . Dumper $res->headers;

my $c_h;
my $h = $res->headers->header('Set-Cookie');
say Dumper $h;

for ( @{$res->headers->header('Set-Cookie')} ) {
	push @$c_h, crush_cookie( $_ );
}
say Dumper $c_h;

is(
	$res->headers->header('Set-Cookie'),
	'jgi_return',
	'Correct Set-Cookie header',
);

# login successful. Now log out!


done_testing();

#ok( $res->is_success, '[GET /launch] successful' );
