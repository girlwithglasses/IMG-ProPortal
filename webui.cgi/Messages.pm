# $Id: Messages.pm 35780 2016-06-15 20:41:20Z klchu $
##########################################################################
package Messages;
use strict;
use CGI qw( :standard );
use Data::Dumper;
use WebConfig;
use WebUtil;

my $env                  = getEnv();
my $main_cgi             = $env->{main_cgi};
my $verbose              = $env->{verbose};
my $tmp_dir              = $env->{tmp_dir};
my $user_restricted_site = $env->{user_restricted_site};
my $img_internal         = $env->{img_internal};
my $img_lite             = $env->{img_lite};
my $use_img_gold         = $env->{use_img_gold};
my $tmp_url              = $env->{tmp_url};
my $base_url             = $env->{base_url};
my $taxonomy_base_url    = $env->{taxonomy_base_url};
my $YUI                  = $env->{yui_dir_28};
my $yui_tables           = $env->{yui_tables};
my $include_metagenomes  = $env->{include_metagenomes};
my $in_file              = $env->{in_file};
my $img_er_submit_url    = $env->{img_er_submit_url};
my $img_mer_submit_url   = $env->{img_mer_submit_url};

sub getPageTitle {
    my $page = param('page');
    my $pageTitle = '';
    if($page eq 'message') {
        $pageTitle = "Message";
    } elsif ($page eq 'znormNote') {
        $pageTitle = "Z-normalization";
    }    
    return $pageTitle;
}

sub getAppHeaderData {
    my ($self) = @_;

    my $page = param('page');
    my @a = ('');
    if($page eq 'message') {
        my $message       = param("message");
        my $menuSelection = param("menuSelection");        
        @a = ($menuSelection);
    } elsif ($page eq 'znormNote') {
        @a = ('FindGenes');
    }    
    return @a;
}

sub dispatch {
    my ( $self, $numTaxon ) = @_;
    my $page = param('page');

    if($page eq 'message') {
        my $message       = param("message");
        my $menuSelection = param("menuSelection");
        print "<div id='message'>\n";
        print "<p>\n";
        print WebUtil::escapeHTML($message);
        print "</p>\n";
        print "</div>\n";        
    } elsif ($page eq 'znormNote') {
        WebUtil::printZnormNote();
    }
}

1;
