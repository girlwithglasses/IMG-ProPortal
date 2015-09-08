#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.16';

use URI::Escape;
use LWP::UserAgent;
use JSON;

use FindBin qw/ $Bin /;
use File::Basename;

# parent of parent dir of script
my $base = dirname( $Bin );

say "base: $base";

my $ua = LWP::UserAgent->new();
my $out;
open $out, ">", "$base/tmp/ga_stats-2.txt" or die "Could not open file: $!";

my %params = (
	'start-date'   => '2014-07-01',
	'end-date'     => 'yesterday',
	'max-results'  => '10000',
	dimensions     => 'ga:pagePathLevel3',
	metrics        => 'ga:pageviews',
	ids            => 'ga:31289304',
	'start-index'  => 232001,
);

my $q_url = 'https://www.googleapis.com/analytics/v3/data/ga?'
	. join "&",
	map {
		$_ . "=" . uri_escape( $params{$_} )
	} keys %params;

my $q = 'https://www.googleapis.com/analytics/v3/data/ga?ids=ga%3A31289304&start-date=2014-07-01&end-date=yesterday&metrics=ga%3Apageviews&dimensions=ga%3ApagePathLevel3&sort=-ga%3Apageviews&filters=ga%3ApagePath%3D%40main.cgi&start-index=232000&max-results=10&access_token=ya29.wAFWWu5mN2Ow9hE8OYx4fpy18bZHpxoIo9nDqmj5G3yNUP8ZhBxm9ZINl3TW3TPORdr78Q';


# this may need to be renewed -- expires after 1 hr
my $tok = '&access_token=ya29.wAFWWu5mN2Ow9hE8OYx4fpy18bZHpxoIo9nDqmj5G3yNUP8ZhBxm9ZINl3TW3TPORdr78Q';

run_query( $q_url );

sub run_query {
	my $query = shift;

	while ( defined $query ) {
		say "getting $query";
		my $out = fetch( $query . $tok );

		if ( $out->{rows} && scalar @{$out->{rows}} > 0 ) {
			print_output( $out->{rows} );
		}
		if ( $out->{nextLink} ) {
			$query = $out->{nextLink};
		}
		else {
			say "No nextLink found!";
			last;
		}
	}
}


sub fetch {
	my $url = shift;
	my $res = $ua->get( $url );

	if ( $res->is_success ) {
		return decode_json( $res->decoded_content );
	}

	die "error: " . $res->status_line;
}

sub print_output {
	my $results = shift;
	for my $r ( @$results ) {
		print { $out } join ( "\t", @$r ) . "\n";
	}
}
