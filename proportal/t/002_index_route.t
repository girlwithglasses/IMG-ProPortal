#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/../lib", "$Bin/../../webui.cgi" );
use IMG::Util::Base 'NetTest';
use ProPortal;

# set up the app
my $psgi = Plack::Util::load_psgi( "$Bin/../bin/app.psgi" );

my $pp = ProPortal->to_app;
is( ref $pp, 'CODE', 'Got app' );
is( ref $psgi, 'CODE', 'Got psgi app' );

$Plack::Test::Impl = "Server";

# to test $psgi, prefix the request with "proportal/"
my $prefix = "";
for my $app ($pp, $psgi) {

	test_psgi $app, sub {
		my $cb = shift;

		my @pages = qw( home data_type clade location );

		for my $p (@pages) {
			my $r = $cb->( GET "/$prefix$p" );
			ok( $r->is_success, "GET /$prefix$p successful!" );
			ok( $r->content =~ /$p\.tt/, "page template name should be $p.tt" );
			if ( $r->content !~ /$p\.tt/) {
				say "page content: " . $r->content;
			}
		}
	};
	$prefix = "proportal/";
}
	# pages requiring arguments: taxon/{\d+}

# check that it uses home.tt
# ok( $res-> 'home.tt'

done_testing();
