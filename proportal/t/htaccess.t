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
use FindBin qw/ $Bin /;
use IMG::Util::Import 'Test';

use WWW::Mechanize;
use IO::Socket::SSL;

# Add URLs to be tested here:
my $test_urls = [ 'https://img-proportal-dev.jgi-psf.org/jbrowse_assets/css/genome.css' ];

my @bots = qw(
    accelobot
    AI-Agent
    Axel
    BecomeBot
    crawler
    curl
    Darwin
    FirstGov
    Java
    Jeeves
    libwww
    lwp
    Mechanize
    NimbleCrawler
    Python
    slurp
    Sphider
    wget
    ysearch
);

my $mech = WWW::Mechanize->new( ssl_opts => { verify_hostname => 0 } );

my $count = 0;
my @b_list = split '\|', 'binlar|casper|cmsworldmap|comodo|diavol|dotbot|feedfinder|flicky|ia_archiver|kmccrew|nutch|planetwork|purebot|skygrid|sucker|turnit|vikspider|zmeu';
my %other_bots;
my $dumped;
undef @other_bots{ @b_list };
my %bot_h;
undef @bot_h{@bots};


subtest 'standard issue bots' => sub {
    for my $t ( @$test_urls ) {
        $count = 0;
        for ( keys %other_bots ) {
            $mech->agent( $_ );
            local $@;
            eval { $mech->get( $test_urls->[0] ); };
#             if ( $@ ) {
#                 say 'Error getting page: ' . $@;
#             }

            ok( 403 == $mech->status, 'Checking mech ' . $_ . ' failure' ) or diag explain $mech->status;

            $count++;
            last if 5 == $count;
        }
    }
};

subtest 'Exceptional browsers' => sub {

    my @exceptions = ( 'Lynx/2.8.7rel.2 libwww-FM/2.14 SSL-MM/1.4.1 OpenSSL/1.0.0a' );
    for my $t ( @$test_urls ) {
        for my $e ( @exceptions ) {
            $mech->agent( $e );
#             say 'setting agent to ' . $mech->agent;
            local $@;
            eval { $mech->get( $t ); };
            ok( 200 == $mech->status, 'Checking ' . $e . ' is OK' ) or diag explain $mech->status;
        }
    }
};

subtest 'valid UAs' => sub {

    my @valid = WWW::Mechanize::known_agent_aliases();
    for my $t ( @$test_urls ) {
        for ( @valid ) {
            $mech->agent_alias( $_ );
            local $@;
            eval { $mech->get( $t ); };
            ok( 200 == $mech->status, 'Checking mech ' . $_ . ' status' ) or diag explain $mech->status;
        }
    }
};

subtest 'IMG bots' => sub {

    for my $t ( @$test_urls ) {
        $count = 0;
        for (keys %bot_h) {
            $mech->agent( $_ );
            local $@;
            eval { $mech->get( $t ); };
#             if ( $@ ) {
#                 say 'Error getting page: ' . $@;
#             }
            ok( 403 == $mech->status, 'Checking mech ' . $_ . ' failure' ) or diag explain $mech->status;
            $count++;
            last if 5 == $count;
        }
    }
};

done_testing();
