# Similar idea to WebPrint
# BUT websession and webdb object required
# its used to break alot of "main::foo()" calls
# eg break the loop
#
# - ken
#
# $Id: WebSessionPrint.pm 36998 2017-04-26 21:19:12Z klchu $
package WebSessionPrint;

use strict;
use CGI qw( :standard );
use CGI::Session qw/-ip-match/;
use CGI::Cookie;
use CGI::Carp qw( carpout set_message  );

use WebConfig;
use WebPrint;
use WebIO;
use WebUtil;

my $env                      = getEnv();
my $abc                      = $env->{abc};                        # BC & SM home
my $base_dir                 = $env->{base_dir};
my $base_url                 = $env->{base_url};
my $cgi_dir                  = $env->{cgi_dir};
my $cgi_tmp_dir              = $env->{cgi_tmp_dir};
my $cgi_url                  = $env->{cgi_url};
my $dblock_file              = $env->{dblock_file};
my $default_timeout_mins     = $env->{default_timeout_mins};
my $domain_name              = $env->{domain_name};
my $enable_ani               = $env->{enable_ani};
my $enable_biocluster        = $env->{enable_biocluster};
my $enable_cassette          = $env->{enable_cassette};
my $enable_genomelistJson    = $env->{enable_genomelistJson};
my $enable_mybin             = $env->{enable_mybin};
my $enable_workspace         = $env->{enable_workspace};
my $full_phylo_profiler      = $env->{full_phylo_profiler};
my $http                     = $env->{http};
my $ignore_dblock            = $env->{ignore_dblock};
my $img_edu                  = $env->{img_edu};
my $img_er                   = $env->{img_er};
my $img_geba                 = $env->{img_geba};
my $img_hmp                  = $env->{img_hmp};
my $img_internal             = $env->{img_internal};
my $img_ken                  = $env->{img_ken};
my $img_lite                 = $env->{img_lite};
my $img_pheno_rule           = $env->{img_pheno_rule};
my $img_proportal            = $env->{img_proportal};
my $img_submit_url           = $env->{img_submit_url};
my $img_version              = $env->{img_version};
my $include_img_terms        = $env->{include_img_terms};
my $include_kog              = $env->{include_kog};
my $include_metagenomes      = $env->{include_metagenomes};
my $include_tigrfams         = $env->{include_tigrfams};
my $main_cgi                 = $env->{main_cgi};
my $MESSAGE                  = $env->{message};
my $myimg_job                = $env->{myimg_job};
my $no_phyloProfiler         = $env->{no_phyloProfiler};
my $phyloProfiler_sets_file  = $env->{phyloProfiler_sets_file};
my $public_login             = $env->{public_login};
my $scaffold_cart            = $env->{scaffold_cart};
my $show_myimg_login         = $env->{show_myimg_login};
my $show_private             = $env->{show_private};
my $show_sql_verbosity_level = $env->{show_sql_verbosity_level};
my $tmp_dir                  = $env->{tmp_dir};
my $top_base_url             = $env->{top_base_url};
my $top_base_dir             = $env->{top_base_dir};
my $use_img_clusters         = $env->{use_img_clusters};
my $use_img_gold             = $env->{use_img_gold};
my $user_restricted_site     = $env->{user_restricted_site};
my $user_restricted_site_url = $env->{user_restricted_site_url};
my $verbose                  = $env->{verbose};
my $web_data_dir             = $env->{web_data_dir};
my $webfs_data_dir           = $env->{webfs_data_dir};
my $img_nr                   = $env->{img_nr};
my $virus                    = $env->{virus};
my $enable_carts             = $env->{enable_carts};
my $sso_enabled     = $env->{sso_enabled};
my $sso_url         = $env->{sso_url};
my $sso_cookie_name = $env->{sso_cookie_name};    # jgi_return cookie name
my $imgAppTerm = "IMG";
$imgAppTerm = "IMG/ER"  if ($img_er);
$imgAppTerm = "IMG"     if $include_metagenomes;
$imgAppTerm = "IMG/ER"  if ( $include_metagenomes && $user_restricted_site );
$imgAppTerm = "IMG/ABC" if ($abc);
$imgAppTerm = "IMG" if ($virus);

# key the AppHeader where $current used
# value display
my %breadcrumbs = (
    login            => "Login",
    logout           => "Logout",
    Home             => "Home",
    FindGenomes      => "Find Genomes",
    FindGenes        => "Find Genes",
    FindFunctions    => "Find Functions",
    CompareGenomes   => "Compare Genomes",
    AnaCart          => "Analysis Cart",
    MyIMG            => "My $imgAppTerm",
    about            => "Using $imgAppTerm",
    ImgStatsOverview => "IMG Stats Overview",
    IMGContent       => "IMG Content",
    RNAStudies       => "RNASeq Studies",
    Methylomics      => "Methylomics Experiments",
    Proteomics       => "Protein Expression Studies",
);


my $YUI = $env->{yui_dir_28};

my $jgi_return_url = "";
my $homePage       = 0;
my $pageTitle      = "IMG";

sub new {
    my $class = shift;
    my $webSession = shift;
    my $webDb = shift;

	my $self = {
		_webSession => $webSession,
		_webDb => $webDb,
	};

    bless $self, $class;

    my $webSession = $self->{_webSession};    
    my $cookie = $webSession->makeCookieSession();
    
    $self->{_cookie} = $cookie;

    return $self;
}

# bread crumbs frame
# - bread crumbs
# - loading message
# - help
#
# 3rd div - for other pages - not home page
#
# loading and help
#
# $current - menu
# $help - help links - if blank do not display
#
sub printBreadcrumbsDiv {
    my ($self, $current, $help, $dbh ) = @_;
    if ( $current eq "logout" || $current eq "login" ) {
        return;
    }
    my $webSession = $self->{_webSession};
    my $webDb = $self->{_webDb};
    my $dbh = $webDb->dbLogin(); 

    my $contact_oid = $webSession->getContactOid();
    my $isEditor    = 0;
    if ($user_restricted_site) {
        $isEditor = WebUtil::isImgEditor( $dbh, $contact_oid );
    }

    # find last cart if any
    my $lastCart = $webSession->getSessionParam("lastCart");
    $lastCart = "geneCart" if $lastCart eq "";
    if (
        !$isEditor
        && (   $lastCart eq "imgTermCart"
            || $lastCart eq "imgPwayCart"
            || $lastCart eq "imgRxnCart"
            || $lastCart eq "imgCpdCart"
            || $lastCart eq "imgPartsListCart"
            || $lastCart eq "curaCart" )
      )
    {
        $lastCart = "funcCart";
    }

    my $str = "";
    $str = alink( $main_cgi, "Home" );

    if ( $current ne "" ) {
        my $section = param("section");
        my $page    = param("page");

        my $compare_url   = alink( "main.cgi?section=CompareGenomes&page=compareGenomes", "Compare Genomes" );
        my $synteny_url   = alink( "main.cgi?section=Vista&page=toppage",                 "Synteny Viewers" );
        my $abundance_url = alink( "main.cgi?section=AbundanceProfiles&page=topPage",     "Abundance Profiles Tools" );
        if ( $section eq "Vista" && $page ne "toppage" ) {
            $str .= " &gt; $compare_url &gt; $synteny_url ";
        } elsif ( $section eq "DotPlot" ) {
            $str .= " &gt; $compare_url &gt; $synteny_url ";
        } elsif ( $section eq "Artemis" ) {
            $str .= " &gt; $compare_url &gt; $synteny_url ";
        } elsif ( $section eq "AbundanceProfiles" && $page ne "topPage" ) {
            $str .= " &gt; $compare_url &gt; $abundance_url ";
        } elsif ( $section eq "AbundanceProfileSearch" && $page ne "topPage" ) {
            $str .= " &gt; $compare_url &gt; $abundance_url ";
        } elsif ( $section eq "MyBins" ) {
            my $display = $breadcrumbs{$current};
            $display = alink( "main.cgi?section=MyIMG", $display );
            my $tmp = alink( "main.cgi?section=MyBins", "MyBins" );
            $str .= " &gt; $display &gt; $tmp ";

        } elsif ( $section eq "WorkspaceGeneSet" ) {

            # this should be MyING
            my $display = $breadcrumbs{$current};
            $display = alink( "main.cgi?section=MyIMG", $display );
            my $tmp          = alink( "main.cgi?section=Workspace",        "Workspace" );
            my $gene_set_url = alink( "main.cgi?section=WorkspaceGeneSet", "Gene Sets" );
            $str .= " &gt; $display &gt; $tmp &gt; $gene_set_url ";
            if ( $page ne "" ) {
                my $folder = param("folder");
                if ( $page eq "view" || $page eq "delete" ) {
                    my $tmp = alink( "main.cgi?section=WorkspaceGeneSet", $folder );
                    $str .= " &gt; $tmp ";
                }
                $str .= " &gt; $page ";
            }

        } elsif ( $section eq "WorkspaceFuncSet" ) {

            # this should be MyING
            my $display = $breadcrumbs{$current};
            $display = alink( "main.cgi?section=MyIMG", $display );
            my $tmp          = alink( "main.cgi?section=Workspace",        "Workspace" );
            my $gene_set_url = alink( "main.cgi?section=WorkspaceFuncSet", "Function Sets" );
            $str .= " &gt; $display &gt; $tmp &gt; $gene_set_url ";
            if ( $page ne "" ) {
                my $folder = param("folder");
                if ( $page eq "view" || $page eq "delete" ) {
                    my $tmp = alink( "main.cgi?section=WorkspaceFuncSet", $folder );
                    $str .= " &gt; $tmp ";
                }
                $str .= " &gt; $page ";
            }

        } elsif ( $section eq "WorkspaceGenomeSet" ) {

            # this should be MyING
            my $display = $breadcrumbs{$current};
            $display = alink( "main.cgi?section=MyIMG", $display );
            my $tmp          = alink( "main.cgi?section=Workspace",          "Workspace" );
            my $gene_set_url = alink( "main.cgi?section=WorkspaceGenomeSet", "Genome Sets" );
            $str .= " &gt; $display &gt; $tmp &gt; $gene_set_url ";
            if ( $page ne "" ) {
                my $folder = param("folder");
                if ( $page eq "view" || $page eq "delete" ) {
                    my $tmp = alink( "main.cgi?section=WorkspaceGenomeSet", $folder );
                    $str .= " &gt; $tmp ";
                }
                $str .= " &gt; $page ";
            }

        } elsif ( $section eq "WorkspaceScafSet" ) {

            # this should be MyING
            my $display = $breadcrumbs{$current};
            $display = alink( "main.cgi?section=MyIMG", $display );
            my $tmp          = alink( "main.cgi?section=Workspace",        "Workspace" );
            my $gene_set_url = alink( "main.cgi?section=WorkspaceScafSet", "Scaffold Sets" );
            $str .= " &gt; $display &gt; $tmp &gt; $gene_set_url ";
            if ( $page ne "" ) {
                my $folder = param("folder");
                if ( $page eq "view" || $page eq "delete" ) {
                    my $tmp = alink( "main.cgi?section=WorkspaceScafSet", $folder );
                    $str .= " &gt; $tmp ";
                }
                $str .= " &gt; $page ";
            }

        } elsif ( $section eq "WorkspaceRuleSet" ) {

            # this should be MyING
            my $display = $breadcrumbs{$current};
            $display = alink( "main.cgi?section=MyIMG", $display );
            my $tmp          = alink( "main.cgi?section=Workspace",        "Workspace" );
            my $rule_set_url = alink( "main.cgi?section=WorkspaceRuleSet", "Rule Sets" );
            $str .= " &gt; $display &gt; $tmp &gt; $rule_set_url ";
            if ( $page ne "" ) {
                my $folder = param("folder");
                if ( $page eq "view" || $page eq "delete" ) {
                    my $tmp = alink( "main.cgi?section=WorkspaceRuleSet", $folder );
                    $str .= " &gt; $tmp ";
                }
                $str .= " &gt; $page ";
            }

        } elsif ( $section eq "Workspace" ) {

            # this should be MyING
            my $display = $breadcrumbs{$current};
            $display = alink( "main.cgi?section=MyIMG", $display );
            my $tmp = alink( "main.cgi?section=Workspace", "Workspace" );
            $str .= " &gt; $display &gt; $tmp ";
            if ( $page ne "" ) {
                my $folder = param("folder");
                if ( $page eq "view" || $page eq "delete" ) {
                    my $tmp = alink( "main.cgi?section=Workspace&page=$folder", $folder );
                    $str .= " &gt; $tmp ";
                }
                $str .= " &gt; $page ";
            }

        } else {
            my $display = $breadcrumbs{$current};
            $str .= " &gt; $display";
        }
    }

    print qq{
    <div id="breadcrumbs_frame">
    <div id="breadcrumbs"> $str </div>
    <div id="loading">  <font color='red'> Loading... </font> <img src='$top_base_url/images/ajax-loader.gif'/> </div>
    };

    # when to print help icon
    print qq{
    <div id="page_help">
    };

    if ( $help ne "" ) {
        print qq{
        <a href='$top_base_url/docs/$help' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'printBreadcrumbsDiv', '$help']);">
        <img width="40" height="27" border="0" style="margin-left: 35px;" src="$top_base_url/images/help.gif"/>
        </a>
        };
    } else {
        print qq{
        &nbsp;
        };
    }

    print qq{
    </div>
    <div id="myclear"></div>
    </div>
    };
}

# logout in header under quick search - ken
sub printLogout {
    my($self) = shift;

    my $webSession = $self->{_webSession};

    # in the img.css set the z-index to show the logout link - ken
    if ( $public_login || $user_restricted_site ) {
        my $contact_oid = $webSession->getContactOid();
        return if !$contact_oid;
        return if ( param("logout") ne "" );

        my $name = $webSession->getUserName2();
        if ( $name eq '' ) {
            $name = $webSession->getUserName();
        }

        my $tmp = "<br/> (JGI SSO)";
#        if ($oldLogin) {
#            $tmp = "";
#        }

        print qq{
        <div id="login">
            Hi $name &nbsp; | &nbsp; <a href="main.cgi?section=Caliban&logout=1"> Logout </a>
            $tmp <span style='font-size:8px; color:gray;'>$$</span>
        </div>
        };
    }
}


#
# html header to print 1st div in new layout v3.3
# - Ken
#
# $current - current menu
# $title - page title
# $gwt - google
# $content_js - misc javascript
# $yahoo_js - yahoo js
# $numTaxons - num of taxons saved
#
sub printHTMLHead {
    my ($self, $current, $title, $gwt, $content_js, $yahoo_js, $numTaxons ) = @_;

    my $webSession = $self->{_webSession};
    my $webDb = $self->{_webDb};
    my $dbh = $webDb->dbLogin(); 

    my $str = 0;
    if ( $numTaxons ne '' ) {
        my $url = "$main_cgi?section=GenomeCart&page=genomeCart";
        $url = alink( $url, $numTaxons );
        $str = "$url";
    }

    if ( $current eq "logout" || $current eq "login" ) {
        $str = "";
    }

    my $enable_google_analytics = $env->{enable_google_analytics};
    my $googleStr;
    if ($enable_google_analytics) {
        my ( $server, $google_key ) = WebUtil::getGoogleAnalyticsKey();
        $googleStr = WebPrint::googleAnalyticsJavaScript2( $server, $google_key );
        $googleStr = "" if ( $google_key eq "" );
    }

    my $template;
    $template = HTML::Template->new( filename => "$base_dir/header-v41.html" );
    $template->param( title        => $title );
    $template->param( gwt          => $gwt );
    $template->param( base_url     => $base_url );
    $template->param( YUI          => $YUI );
    $template->param( content_js   => $content_js );
    $template->param( yahoo_js     => $yahoo_js );
    $template->param( googleStr    => $googleStr );
    $template->param( top_base_url => $top_base_url );
    print $template->output;

    if ( $current eq "logout" || $current eq "login" ) {
        my $logofile;
        if ($img_edu) {
            $logofile = 'logo-JGI-IMG-EDU.png';
        } elsif ($virus) {
            $logofile = 'logo-JGI-IMG-VR.png';
        } elsif ($img_hmp) {
            $logofile = 'logo-JGI-IMG-HMP.png';
        } elsif ($abc) {
            $logofile = 'logo-JGI-IMG-ABC.png';

        } elsif ( $img_er && $user_restricted_site && !$include_metagenomes ) {
            $logofile = 'logo-JGI-IMG-ER.png';
        } elsif ( $include_metagenomes && $user_restricted_site ) {

            #$logofile = 'logo-JGI-IMG-MER.png';
            $logofile = 'logo-JGI-IMG-ER.png';
        } elsif ($include_metagenomes) {

            #$logofile = 'logo-JGI-IMG-M.png';
            $logofile = 'logo-JGI-IMG.png';
        } elsif ($img_nr) {
            $logofile = 'logo-JGI-IMG-NR.png';

        } else {
            $logofile = 'logo-JGI-IMG.png';
        }

        print qq{
<header id="jgi-header">
<div id="jgi-logo">
<a href="http://jgi.doe.gov/" title="DOE Joint Genome Institute - $imgAppTerm">
<img width="480" height="70" src="$top_base_url/images/$logofile" alt="DOE Joint Genome Institute's $imgAppTerm logo"/>
</a>
</div>
<nav class="jgi-nav">
    <ul>
    <li><a href="http://jgi.doe.gov">JGI Home</a></li>
    <li><a href="https://sites.google.com/a/lbl.gov/img-form/contact-us">Contact Us</a></li>
    </ul>
</nav>
</header>

};

    } else {
        my $logofile;
        if ($img_edu) {
            $logofile = 'logo-JGI-IMG-EDU.png';
        } elsif ($virus) {
            $logofile = 'logo-JGI-IMG-VR.png';
        } elsif ($img_hmp) {
            $logofile = 'logo-JGI-IMG-HMP.png';
        } elsif ($abc) {
            $logofile = 'logo-JGI-IMG-ABC.png';
        } elsif ( $img_er && $user_restricted_site && !$include_metagenomes ) {
            $logofile = 'logo-JGI-IMG-ER.png';
        } elsif ( $include_metagenomes && $user_restricted_site ) {
            $logofile = 'logo-JGI-IMG-ER.png';
        } elsif ( $include_metagenomes ) {
            $logofile = 'logo-JGI-IMG.png';
        } elsif ($img_nr) {
            $logofile = 'logo-JGI-IMG-NR.png';

        } else {
            $logofile = 'logo-JGI-IMG.png';
        }

        print qq{
<header id="jgi-header">
<div id="jgi-logo">
<a href="http://jgi.doe.gov/" title="DOE Joint Genome Institute - $imgAppTerm">
<img width="480" height="70" src="$top_base_url/images/$logofile" alt="DOE Joint Genome Institute's $imgAppTerm logo"/>
</a>
</div>
};

        my $enable_autocomplete = $env->{enable_autocomplete};
        if ($enable_autocomplete) {
            print qq{
        <div id="quicksearch">
        <form name="taxonSearchForm" enctype="application/x-www-form-urlencoded" action="main.cgi" method="post">
            <input type="hidden" value="orgsearch" name="page">
            <input type="hidden" value="TaxonSearch" name="section">

            <a style="color: black;" href="$base_url/orgsearch.html">
            <font style="color: black;"> Quick Genome Search: </font>
            </a><br/>
            <div id="myAutoComplete" >
            <input id="myInput" type="text" style="width: 110px; height: 20px;" name="taxonTerm" size="12" maxlength="256">
            <input type="submit" alt="Go" value='Go' name="_section_TaxonSearch_x" style="vertical-align: middle; margin-left: 125px;">
            <div id="myContainer"></div>
            </div>
        </form>
        </div>
            };

            my $autocomplete_url = "$top_base_url" . "api/";

            if ($include_metagenomes) {
                $autocomplete_url .= 'autocompleteAll.php';
            } elsif ($img_nr) {
                $autocomplete_url .= 'autocompleteNR.php';
            } else {
                $autocomplete_url .= 'autocompleteIsolate.php';
            }

            print <<EOF;
<script type="text/javascript">
YAHOO.example.BasicRemote = function() {
    // Use an XHRDataSource
    var oDS = new YAHOO.util.XHRDataSource("$autocomplete_url");
    // Set the responseType
    oDS.responseType = YAHOO.util.XHRDataSource.TYPE_TEXT;
    // Define the schema of the delimited results
    oDS.responseSchema = {
        recordDelim: "\\n",
        fieldDelim: "\\t"
    };
    // Enable caching
    oDS.maxCacheEntries = 5;

    // Instantiate the AutoComplete
    var oAC = new YAHOO.widget.AutoComplete("myInput", "myContainer", oDS);

    return {
        oDS: oDS,
        oAC: oAC
    };
}();
</script>

EOF
        }

        if ( $current ne "login" ) {
            # logout in header under quick search - ken
            $self->printLogout();
        }

        if ($img_hmp) {
            print qq{
<a href="http://www.hmpdacc.org">
<img id="hmp_logo" src="https://img.jgi.doe.gov/images/hmp_logo.png" alt="hmp"/>
</a>
            };
        }

        print qq{
</header>
<div id="myclear"></div>
        };

        if ($enable_carts) {

            require ScaffoldCart;
            my $ssize = ScaffoldCart::getSize();
            if ( $ssize > 0 ) {
                $ssize = alink( 'main.cgi?section=ScaffoldCart&page=index', $ssize );
            }

            require FuncCartStor;
            my $c     = new FuncCartStor();
            my $fsize = $c->getSize();
            if ( $fsize > 0 ) {
                $fsize = alink( 'main.cgi?section=FuncCartStor&page=funcCart', $fsize );
            }

            require GeneCartStor;
            my $gsize = GeneCartStor::getSize();
            if ( $gsize > 0 ) {
                $gsize = alink( 'main.cgi?section=GeneCartStor&page=geneCart', $gsize );
            }

            my $genomeUrl    = alink( 'main.cgi?section=GenomeCart&page=genomeCart', 'Genomes' );
            my $scaffoldUrl  = alink( 'main.cgi?section=ScaffoldCart&page=index',    'Scaffolds' );
            my $functionsUrl = alink( 'main.cgi?section=FuncCartStor&page=funcCart', 'Functions' );
            my $genesUrl     = alink( 'main.cgi?section=GeneCartStor&page=geneCart', 'Genes' );

            my $var = {
                str => $str,
                genomeUrl => $genomeUrl,
                ssize => $ssize,
                scaffoldUrl => $scaffoldUrl,
                fsize => $fsize,
                functionsUrl => $functionsUrl,
                gsize => $gsize,
                genesUrl => $genesUrl,
            };

            my $isEditor = 0;
            if ($user_restricted_site) {
                $isEditor = WebUtil::isImgEditorWrap();
            }
            
            if ($isEditor) {
                require CuraCartStor;
                my $c = new CuraCartStor();
                my $cursize = $c->getSize();
                my $curationUrl = alink( 'main.cgi?section=CuraCartStor&page=curaCart', 'Curation' );
                $var->{isEditor} = 1;
                $var->{cursize} = $cursize;
                $var->{curationUrl} = $curationUrl;
                
            }
            
            my $bcCartSize = 0;
            if ( $abc || $img_ken ) {
                require WorkspaceBcSet;
                $bcCartSize = WorkspaceBcSet::getSize();
                my $bcurl = alink( 'main.cgi?section=WorkspaceBcSet&page=viewCart', 'BC' );
                $var->{abc} = 1;
                $var->{bcCartSize} = $bcCartSize;
                $var->{bcurl} = $bcurl;
            }

            if($str || $ssize || $fsize || $gsize || $bcCartSize) {
                $var->{clearAllCartsButton} = 1;
                $var->{top_base_url} = $top_base_url;              
            }

            # TODO clear all button
        my $tt = Template->new({
            INCLUDE_PATH => "$base_dir",
            INTERPOLATE  => 1,
        }) or die "$Template::ERROR\n";
    
       $tt->process("MyAnalysisCarts.tt", $var) or die $tt->error();
            

        } # end if ($enable_carts)

    } # end if ( $current eq "logout" || $current eq "login" ) "else" section

    print qq{
    <div id="myclear"></div>
    };
}

############################################################################
#  get genome cart size
# 
############################################################################
sub printTaxonFilterStatus {
	my($self) = @_;
	
    require GenomeCart;
    return GenomeCart::getSize();
}




############################################################################
# printAppHeader - Show top menu and other web UI framework header code.
#
# $current - which menu to highlight
# $noMenu - no longer used
# $gwtModule - google text to replace $gwt in html header
# $yuijs - yahoo text to replace $yahoo_js in html header
# $content_js - misc. js to load in header replaced $content_js in html header
# $help - html link code for breadcrumb div
# $redirecturl - for old login page redirect url on failed login
#
# return number if save genomes if any. otherwise return "" blank
# - ken 2010-03-08
#
############################################################################
sub printAppHeader {
    my ($self, $current, $noMenu, $gwtModule, $yuijs, $content_js, $help, $redirecturl ) = @_;

    if ( $virus && WebUtil::paramMatch("noHeader") ne "" ) {
        require Viral;
        return;
    }
        
    require HtmlUtil;

    my $cookie = $self->{_cookie};
    # sso
    my $cookie_return = '';
    if ( $sso_enabled && $current eq "login" && $sso_url ne "" ) {
        my $url = $cgi_url . "/" . $main_cgi . $self->redirectform(1);
        $url = $redirecturl if ( $redirecturl ne "" );

        if ( $url =~ /cgi$/ ) {
            $url = $url . '?oldLogin=false';
        } else {
            $url = $url . '&oldLogin=false';
        }

        $cookie_return = WebUtil::makeCookieSsoReturn($url);
        
    } elsif ($sso_enabled) {
        my $url = $cgi_url . "/" . $main_cgi . '?oldLogin=false';
        $cookie_return = WebUtil::makeCookieSsoReturn($url); 
    }

    my $cookie_host = WebUtil::makeCookieHostname();

    if ( $cookie_return ne "" ) {
        print header( -type => "text/html", -cookie => [ $cookie, $cookie_host, $cookie_return ] );
    } else {
        print header( -type => "text/html", -cookie => [ $cookie, $cookie_host ] );
    }

    return if ( $current eq "exit" );

    # genome cart
    my $numTaxons = $self->printTaxonFilterStatus();
    $numTaxons = "" if ( $numTaxons == 0 );

    if ( $current eq "Home" && $abc ) {

        # new abc home page
        # caching home page
        my $sid  = getContactOid();
        my $time = 3600 * 24;                    # 24 hour cache

        $self->printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        WebPrint::printMenuDiv( );
        WebPrint::printErrorDiv();

        HtmlUtil::cgiCacheInitialize("homepage");
        HtmlUtil::cgiCacheStart() or return;
        
        WebPrint::printContentHome();

        my $templateFile = "$base_dir/home-v33a.html";
        my $template = HTML::Template->new( filename => $templateFile );
        print $template->output;

        print qq{  
<div class='largeWidthDiv'>

<div class="shadow" id='bcHomeDiv'>
<h2>Biosynthetic Gene Clusters</h2>
Clusters of genes whose expression leads<br/>to the synthesis of Secondary Metabolites
<br><br>
    <div style="text-align:left;>
};

        require BiosyntheticStats;
        BiosyntheticStats::printStatsHomePage(0);

        print qq{
    </div>
</div>
};

        print qq{
<div class="shadow" id='smHomeDiv'>
<h2>Secondary Metabolites</h2>
Small organic molecules produced<br/>by living organisms<br/>
<div style="text-align:left;>
};

        require MeshTree;
        MeshTree::printTreeAllDivHomePage();

        print qq{
    </div>
</div>
</div> 
};

        # </div>
        HtmlUtil::cgiCacheStop();

    } elsif ( ($virus || ($user_restricted_site && param('section') eq 'Viral')  ) && $current eq "Home" ) {
        #
        # a special case now :( - ken
        # param('section') eq 'Viral' ) - for img/mer workspace blast
        #
        $self->printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        WebPrint::printMenuDiv();
        WebPrint::printErrorDiv();

        my $page = param('page');
        require Viral;
        if ( $page eq "isoHostDetail" ||
             paramMatch("isoHostDetail") ne "" ||
             $page eq "metaHostDetail" ||
             paramMatch("metaHostDetail") ne "" ||
             $page eq "bothHostDetail" ||
             paramMatch("bothHostDetail") ne "" ||
             $page eq "mvcHostDetail" ||
             paramMatch("mvcHostDetail") ne "" ) {
            return;
        }
        elsif ( ! $page || $page eq 'googlemap' ) {
            Viral::printViralHome();
        }

    } elsif ($img_hmp && $current eq "Home" ) {
        # old home page turned off 
        # - but still used for hmp and mer03 - ken

        # caching home page
        my $sid  = getContactOid();
        my $time = 3600 * 24;         # 24 hour cache

        $self->printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        WebPrint::printMenuDiv();
        WebPrint::printErrorDiv();

        HtmlUtil::cgiCacheInitialize("homepage");
        HtmlUtil::cgiCacheStart() or return;

        my $dbh = dbLogin();
        my ( $maxAddDate, $maxErDate ) = $self->getMaxAddDate($dbh);

        # to stop the inline-block or float left from wrapping
        # to the next line - ken
        #print qq{<div style="width: 1200px;">};
        $self->printStatsTableDiv( $maxAddDate, $maxErDate );
        WebPrint::printContentHome();
        my $templateFile = "$base_dir/home-v33.html";
        my $hmpGoogleJs;
        if ( $img_hmp && $include_metagenomes ) {
            $templateFile = "$base_dir/home-hmpm-v33.html";
            my $f = $env->{'hmp_home_page_file'};
            $hmpGoogleJs = file2Str( $f, 1 );
        }

        my ( $sampleCnt, $proposalCnt, $newSampleCnt, $newStudies );
        my $piechar_str;
        my $piechar2_str;
        my $table_str;
        
        if ($include_metagenomes && !$img_hmp) {

            # mer / m
            my $file = $webfs_data_dir . "/hmp/img_m_home_page_v400.txt";

            if ( $env->{home_page} ) {
                # mer 03
                $file = $webfs_data_dir . "/hmp/" . $env->{home_page};
            }

            $table_str = file2Str( $file, 1 );
            $table_str =~ s/__IMG__/$imgAppTerm/;
            
            require MainPageStats;
            my $x = MainPageStats::getMetagenomeEcoSystemCnt();
            $table_str =~ s/__table__/$x/;

        }

        my $rfh = newReadFileHandle($templateFile);
        while ( my $s = $rfh->getline() ) {
            chomp $s;
            if ( $s =~ /__table__/ ) {
                $s =~ s/__table__/$table_str/;
                print "$s\n";
            } elsif ( $s =~ /__news__/ ) {
                my $news = qq{
<p>
For details, see <a href='$top_base_url/docs/releaseNotes.pdf' onClick="_gaq.push(['_trackEvent', 'Document', 'main', 'release notes']);">IMG Release Notes</a> (Dec. 12, 2012),
in particular, the workspace and background computation capabilities  available to IMG registered users.
</p>
};

                #$s =~ s/__news__/$news/;
                $s =~ s/__news__//;
                print "$s\n";
            } elsif ( $img_hmp && $s =~ /__hmp_google_js__/ ) {
                $s =~ s/__hmp_google_js__/$hmpGoogleJs/;
                print "$s\n";
            } elsif ( $img_geba && $s =~ /__pie_chart_geba1__/ ) {
                $s =~ s/__pie_chart_geba1__/$piechar_str/;
                print "$s\n";
            } elsif ( $img_geba && $s =~ /__pie_chart_geba2__/ ) {
                $s =~ s/__pie_chart_geba2__/$piechar2_str/;
                print "$s\n";
            } elsif ( $include_metagenomes && $s =~ /__pie_chart__/ ) {
                $s =~ s/__pie_chart__/$piechar_str/;
                print "$s\n";
            } elsif ( $include_metagenomes && $s =~ /__samples__/ ) {
                $s =~ s/__samples__/$sampleCnt/;
                print "$s\n";
            } elsif ( $include_metagenomes && $s =~ /__proposal__/ ) {
                $s =~ s/__proposal__/$proposalCnt/;
                print "$s\n";
            } elsif ( $include_metagenomes && $s =~ /__newSample__/ ) {
                $s =~ s/__newSample__/$newSampleCnt/;
                print "$s\n";
            } elsif ( $include_metagenomes && $s =~ /__study__/ ) {
                $s =~ s/__study__/$newStudies/;
                print "$s\n";
            } elsif ( $s =~ /__base_url__/ ) {
                $s =~ s/__base_url__/$base_url/;
                print "$s\n";
            } elsif ( $s =~ /__max_add_date__/ ) {
                $s =~ s/__max_add_date__/$maxAddDate/;
                print "$s\n";
            } elsif ( $s =~ /__yui__/ ) {
                $s =~ s/__yui__/$YUI/;
                print "$s\n";

                # $imgAppTerm
            } elsif ( $s =~ /__IMG__/ ) {
                $s =~ s/__IMG__/$imgAppTerm/;
                print "$s\n";
            } else {
                print "$s\n";
            }
        }
        close $rfh;

        # news section
        print "</div>\n";    # end div content on home page

        my $newsStr = WebPrint::getNewsHeaders(10);

        print qq{
            
<fieldset class='newsFieldset'>
<legend class='newsLegend'>News</legend>
$newsStr
<a href="main.cgi?section=Help&page=news">Read more...</a>
</fieldset>


        };

        # no need to print end div for width div above, its printed later - ken

        HtmlUtil::cgiCacheStop();
        
    } elsif ($current eq "Home" ) {
        # TODO new home page testing - ken
        
        $self->printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        WebPrint::printMenuDiv();
        WebPrint::printErrorDiv();
           
        my $cnt = 0;
        my $img_mer = 0;
        $img_mer = 1 if ($user_restricted_site); # testing - ken
        if($img_mer) {
            $cnt = WebUtil::getSessionParam('myprivatescnt');
            if(!$cnt) {
                require MainPageStats;
                $cnt = MainPageStats::getPrivateCounts();
                WebUtil::setSessionParam('myprivatescnt', $cnt);
            }
        }

        my $newsStr = WebPrint::getNewsHeaders(10);
        my $vars = {
            private => $cnt,
            img_mer => $img_mer,
            img_news => $newsStr,
        };

        my $tt = Template->new({
            INCLUDE_PATH => "/webfs/projectdirs/microbial/img/web_data/stats/",
            INTERPOLATE  => 1,
        }) or die "$Template::ERROR\n";
    
    
        if($env->{home_page}) {
            # mer03
            $tt->process("homepage_mer03.tt", $vars) or die $tt->error();
        } elsif($img_mer) {
           $tt->process("homepage_mer.tt", $vars) or die $tt->error();
        } else {
           $tt->process("homepage_m.tt", $vars) or die $tt->error();
        }        
        
    } else {
        $self->printHTMLHead( $current, $pageTitle, $gwtModule, $content_js, $yuijs, $numTaxons );
        WebPrint::printMenuDiv();

        if($current ne 'login' && $current ne 'logout') {
            my $dbh = dbLogin();
            $self->printBreadcrumbsDiv( $current, $help, $dbh );
        }
        
        WebPrint::printErrorDiv();
        WebPrint::printContentOther();
    }

    return $numTaxons;
}




# home page stats table - left side
# 6th div for home page
#
# - OLF code for hmp site support
#
sub printStatsTableDiv {
    my ($self, $maxAddDate, $maxErDate ) = @_;
    my ( $s, $hmp );

    require MainPageStats;
    ( $s, $hmp ) = MainPageStats::replaceStatTableRows();

    print qq{
    <div id="left" class="shadow">
    };

    if ( $hmp ne "" ) {

        print qq{
        <h2>HMP Genomes &amp;<br/> Samples </h2>
        <table >
        <th align='left' valign='bottom'>Category</th>
        <th align='right' valign='bottom' style="padding-right: 5px;"
        title='Funded by HMP: Genomes sequenced as part of the NIH HMP Project'>
        Genome </th>
        <th align='right' valign='bottom'>Sample</th>
        $hmp
        </table>
        <br/>
           };

    }

    if ($img_hmp) {
        print qq{
        <h2>All Genomes &amp;</br> Samples</h2>
        <table >
        <tr>
             <th align="right">Datasets</th>
             <th align="right">JGI</th>
             <th align="right">All</th>
        </tr>
       };
        print $s;
        print qq{
        </table>
        };
    } elsif ( !$abc ) {
        print qq{
         <h2>$imgAppTerm Content</h2>
         <table >
         <tr>
             <th align="right">Datasets</th>
             <th align="right">JGI</th>
             <th align="right">All</th>
         </tr>
        };
        print $s;
        print qq{
        </table>
        };
    }

    # latest genomes added
    my $tmp = '';

    my $img_nr = $env->{img_nr};
    if ( !$img_edu && !$img_nr ) {
        $tmp = qq{
<table>
<tr>
    <td style="font-size:10px;" colspan="2">Last Datasets Added On:</td>
</tr>
<tr>
    <td  style="font-size:10px; border-top-width: 0px;">
    &nbsp;&nbsp;Genome<br>
    &nbsp;&nbsp;Metagenome
    </td>
    
    <td style="font-size:10px; border-top-width: 0px;">
    <a href='main.cgi?section=TaxonList&page=lastupdated&erDate=true'>$maxErDate</a><br>
    <a href='main.cgi?section=TaxonList&page=lastupdated'>$maxAddDate</a>
    </td>
</tr>
</table>
       };
    } elsif ($img_edu) {
        $tmp = qq{
<table>
<tr>
    <td style="font-size:10px;" colspan="2">Last Genome Added:
    <a href='main.cgi?section=TaxonList&page=lastupdated&erDate=true'>$maxErDate</a>
    </td>
</table>
    };
    }
    print qq{
 $tmp
    <div id="training" style="padding-top: 2px;">
    };

    print "<p>\n";
    if ( $use_img_gold && !$include_metagenomes ) {
        print qq{
        <a href="main.cgi?section=TaxonList&page=genomeCategories">Genome by Metadata</a> <br/>
        };
    }

    # google map link
    print qq{
     <a href="main.cgi?section=ImgStatsOverview&page=googlemap&type=genome">Project Map</a><br>
     <a href="main.cgi?section=ImgStatsOverview&page=googlemap&type=metagenome">Metagenome Projects Map</a><br>
     <a href="$top_base_url/systemreqs.html">System Requirements</a><br>
<p style="width: 175px;">
        <img width="80" height="50"  style="float:left; padding-right: 5px;" src="$top_base_url/images/imguser.jpg"/>
            Hands on training available at the
            <p>
            <a href="http://www.jgi.doe.gov/meetings/mgm">Microbial Genomics &amp;
            Metagenomics Workshop</a>

    };

    print "</div>\n";    # end of training

    print "</div>\n";    # <!-- end of left div -->
}

#
# gets genome's max add date - hmp site
# old code to support old hmp site
#
sub getMaxAddDate {
    my ($self, $dbh) = @_;

    my $imgclause = WebUtil::imgClause('t');

    my $sql = qq{
    select to_char(max(t.add_date),'yyyy-mm-dd')
    from taxon t
    where 1 = 1
    $imgclause
    };

    my $cur = WebUtil::execSql( $dbh, $sql, $verbose );
    my ($max) = $cur->fetchrow();

    # this the acutal db ui release date not the genome add_date - ken
    my $maxErDate;
    my $sql2 = qq{
select to_char(release_date, 'yyyy-mm-dd') from img_build
        };
    $cur = WebUtil::execSql( $dbh, $sql2, $verbose );
    ($maxErDate) = $cur->fetchrow();

    return ( $max, $maxErDate );
}


sub redirectform {
    my ($self, $noprint) = @_;

    # get url redirect param
    my @names = param();

    my $url;
    my $count = 0;
    for ( my $i = 0 ; $i <= $#names ; $i++ ) {

        # username  password
        next if ( $names[$i] eq "username" );
        next if ( $names[$i] eq "password" );
        next if ( $names[$i] eq "userRestrictedLogin" );
        next if ( $names[$i] eq "oldLogin" );
        next if ( $names[$i] eq "logout" );
        next if ( $names[$i] eq "login" );
        next if ( $names[$i] eq "jgi_sso" );

        #next if ( $names[$i] eq "forceimg" );
        my $value = param( $names[$i] );

        if ( $names[$i] eq "redirect" ) {

            # case when user login fails and logins in again
            $url = $url . $value;
        } elsif ( $count == 0 ) {
            $url = $url . "?" . $names[$i] . "=" . $value;
        } else {
            $url = $url . "&" . $names[$i] . "=" . $value;
        }
        $count++;
    }

    if ( !$noprint ) {
        print qq{
      <input type="hidden" name='redirect' value='$url' />
    };
    }

    return $url;
}




1;