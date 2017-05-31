#
# use with the javascript code in header.js
# to ping the server every 30min for 12 times - 6 hours
# after 6 hours it will idle timeout
#
package AutoRefresh;

use strict;
use CGI qw( :standard);
use CGI::Cookie;
use CGI::Session qw/-ip-match/;    # for security - ken
use CGI::Carp qw( carpout set_message fatalsToBrowser );
use Data::Dumper;
use DBI;
use WebConfig;
use WebUtil;

$| = 1;

my $section              = "AutoRefresh";
my $env                  = getEnv();
my $main_cgi             = $env->{main_cgi};
my $section_cgi          = "$main_cgi?section=$section";
my $verbose              = $env->{verbose};
my $base_dir             = $env->{base_dir};
my $base_url             = $env->{base_url};
my $user_restricted_site = $env->{user_restricted_site};
my $include_metagenomes  = $env->{include_metagenomes};
my $img_internal         = $env->{img_internal};
my $img_er               = $env->{img_er};
my $img_ken              = $env->{img_ken};
my $tmp_dir              = $env->{tmp_dir};
my $workspace_dir        = $env->{workspace_dir};
my $public_nologin_site  = $env->{public_nologin_site};
my $YUI                  = $env->{yui_dir_28};


sub getPageTitle {
    return 'Refresh';
}

sub getAppHeaderData {
    my ($self) = @_;
    my @a = ();
    return @a;
}

sub printWebPageHeader {
	my($self) = @_;
	
	# do nothing for now
}

sub dispatch {
    my ( $self, $numTaxon ) = @_;
    
    my $cookie = WebUtil::makeCookieSession();
    my $cookie_host = WebUtil::makeCookieHostname();
    
    print header( -type => "text/html", -cookie => [ $cookie, $cookie_host ] );    
    print "auto refresh";
}

1;