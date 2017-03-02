#   All CGI called run this section and dispatch is made to relevant
#   for displaying appropriate CGI pages.
#      --es 09/19/2004
#
# $Id: main.pl 36612 2017-03-01 18:40:47Z klchu $
##########################################################################
use strict;
use feature ':5.16';
use CGI qw( :standard  );
use CGI::Cookie;
use CGI::Session qw/-ip-match/;    # for security - ken
use CGI::Carp qw( carpout set_message fatalsToBrowser );
use perl5lib;
use HTML::Template;
use JSON;
use File::Path qw(remove_tree);
use Number::Format;
use WebConfig;
use WebUtil;
use HtmlUtil;
use Template;
use Module::Load;
use Data::Dumper;
use MainPageStats;

$| = 1;

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

$default_timeout_mins = 5 if $default_timeout_mins eq "";
my $use_func_cart = 1;

my $imgAppTerm = "IMG";
$imgAppTerm = "IMG/ER"  if ($img_er);
$imgAppTerm = "IMG"     if $include_metagenomes;
$imgAppTerm = "IMG/ER"  if ( $include_metagenomes && $user_restricted_site );
$imgAppTerm = "IMG/ABC" if ($abc);
$imgAppTerm = "IMG" if ($virus);

my $YUI = $env->{yui_dir_28};
my $taxon_filter_oid_str;

# sso Caliban
# cookie name: jgi_return, value: url, domain: jgi.doe.gov
my $sso_enabled     = $env->{sso_enabled};
my $sso_url         = $env->{sso_url};
my $sso_cookie_name = $env->{sso_cookie_name};    # jgi_return cookie name

my $jgi_return_url = "";
my $homePage       = 0;
my $pageTitle      = "IMG";

timeout( 60 * $default_timeout_mins );

# check the number of cgi processes
maxCgiProcCheck();
blockRobots();

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

############################################################################
# main
############################################################################

# new for 3.3
# is db locked
# if file not empty dump html from it
if ( -e $dblock_file && !$img_ken ) {
    my $s = file2Str( $dblock_file, 1 );
    if ( !blankStr($s) ) {
        print header( -type => "text/html", -status => '503' );
        print $s;
    } else {
        printAppHeader("exit");
        printMessage( "Database is currently being serviced.<br/>"
              . "Sorry for the inconvenience.<br/>"
              . "Please try again later.<br/>" );
        printContentEnd();
        printMainFooter($homePage);
    }
    WebUtil::webExit(0);
}

## Check and purge temp directory for files "too old".
# for v40 I have a cronjob to purge
# the default is to do purge as part of teh main.pl
# only the production code will it be disable and the cronjob to do the purge
#
# we still need to purge the htdocs/<site>/tmp directory files - ken
# web farm also has purge to clean up setup by Jeremy
#
#if($enable_purge) {
#my ( $nPurged, $nFiles ) = purgeTmpDir();
#}

#
# check for https for login sites
#

my $cgi   = WebUtil::getCgi();
my $https = 1;                   #$cgi->https();       # if on its not null
if ( ( $public_login || $user_restricted_site ) && $https eq '' && $env->{ssl_enabled} ) {
    my $REQUEST_METHOD = uc( $ENV{REQUEST_METHOD} );
    if ( $REQUEST_METHOD eq 'GET' ) {
        my $seconds = 30;
        my $url     = $cgi_url . "/" . $main_cgi . redirectform(1);
        print header( -type => "text/html", -status => '497 HTTP to HTTPS (Nginx)' );
        my $template = HTML::Template->new( filename => "$base_dir/Nginx.html" );
        $template->param( seconds => $seconds );
        $template->param( url     => $url );
        print $template->output;
        WebUtil::webExit(0);
    }

    # POST - do nothing so far
}


my $contact_oid = getContactOid();
my $cookie = WebUtil::makeCookieSession();

if($virus) {
    setSessionParam( "hideViruses", 'No' );
}

my $oldLogin = getSessionParam("oldLogin");
$oldLogin = 0 if param('oldLogin') eq 'false';
if ( param('oldLogin') eq 'true' || $oldLogin ) {
    setSessionParam( "oldLogin", 1 );
    $oldLogin = 1;
} else {
    setSessionParam( "oldLogin", 0 );
    $oldLogin = 0;
}

if ( !$oldLogin && $sso_enabled ) {
    require Caliban;
    if ( !$contact_oid ) {
        #my $dbh_main = dbLogin();
        my $ans      = Caliban::validateUser();

        if ( !$ans ) {
            printAppHeader("login");
            Caliban::printSsoForm();
            printContentEnd();
            printMainFooter(1);
            WebUtil::webExit(0);
        }
        WebUtil::loginLog( 'login', 'sso' );
        require MyIMG;
        MyIMG::loadUserPreferences();
    }

    # logout in genome portal i still have contact oid
    # I have to fix and relogin
    my $ans = Caliban::isValidSession();
    if ( !$ans ) {

        printAppHeader("login");
        Caliban::logout( 1, 1 );


        Caliban::printSsoForm();
        printContentEnd();
        printMainFooter(1);
        WebUtil::webExit(0);
    }
} elsif ( ( $public_login || $user_restricted_site ) && !$contact_oid ) {
    require Caliban;
    my $username = param("username");
    $username = param("login") if ( blankStr($username) );    # single login form for sso or img
    my $password = param("password");
    if ( blankStr($username) ) {
        printAppHeader("login");
        Caliban::printSsoForm();
        printContentEnd();
        printMainFooter(1);
        WebUtil::webExit(0);
    } else {
        my $redirecturl = "";
        if ($sso_enabled) {

            # do redirect via cookie
            # return cookie name
            my %cookies = CGI::Cookie->fetch;
            if ( exists $cookies{$sso_cookie_name} ) {
                $redirecturl = $cookies{$sso_cookie_name}->value;
                $redirecturl = "" if ( $redirecturl =~ /main.cgi$/ );

                #$redirecturl = "" if ( $redirecturl =~ /forceimg/ );
            }
        }

        require MyIMG;
        my $b = MyIMG::validateUserPassword( $username, $password );
        if ( !$b ) {
            Caliban::logout();
            printAppHeader( "login", '', '', '', '', '', $redirecturl );
            print qq{
<p>
    <span style="color:red; font-size: 14px;">
    Invalid Username or Password. Try again. <br>
    For JGI SSO accounts please use the login form on the right side
    <span style="color:#336699; font-weight:bold;"> "JGI Single Sign On (JGI SSO)"</span></span>
</p>
            };
            Caliban::printSsoForm();
            printContentEnd();
            printMainFooter(1);
            WebUtil::webExit(0);
        }
        Caliban::checkBannedUsers( $username, $username, $username );
        WebUtil::loginLog( 'login', 'img' );
        MyIMG::loadUserPreferences();
        setSessionParam( "oldLogin", 1 );

        $redirecturl =~ s/oldLogin=false/oldLogin=true/;
        Caliban::migrateImg2JgiSso($redirecturl);

        if ( $sso_enabled && $redirecturl ne "" ) {
            print header( -type => "text/html", -cookie => $cookie );
            print qq{
                    <p>
                    Redirecting to: <a href='$redirecturl'> $redirecturl </a>
                    <script language='JavaScript' type="text/javascript">
                     window.open("$redirecturl", "_self");
                    </script>
            };
            WebUtil::webExit(0);
        }
    }
}

# for adding to genome cart from browser list
if ( param("setTaxonFilter") ne "" ) {
    my @taxon_filter_oid = param("taxon_filter_oid");
    if ( scalar(@taxon_filter_oid) eq 0 ) {
        @taxon_filter_oid = param("taxon_oid");
    }
    my %h = WebUtil::array2Hash(@taxon_filter_oid);    # get unique taxon_oid's
    @taxon_filter_oid = sort( keys(%h) );
    $taxon_filter_oid_str = join( ",", @taxon_filter_oid );

    # add genomes to genome cart
    WebUtil::setTaxonSelections($taxon_filter_oid_str);
    if ( !blankStr($taxon_filter_oid_str) ) {
        setSessionParam( "blank_taxon_filter_oid_str", "0" );
    }
}

# I believe is this not used anywhere - ken 2015-10-23
if ( param("deleteAllCartGenes") ne "" ) {
    setSessionParam( "gene_cart_oid_str", "" );
}

#
# lets touch user's chart files
#
touchCartFiles();

# for w and m use the public autocomplete file
#
# create a private autocomplete file
#
# this feature is not used yet - ken
#
#if ( $user_restricted_site && $enable_workspace ) {
#
#    # php files like the autocompleteAll.php
#    require GenomeListJSON;
#    my $myGenomesFile = GenomeListJSON::getMyAutoCompleteFile();
#
#    if ( !-e $myGenomesFile ) {
#        GenomeListJSON::myAutoCompleteGenomeList($myGenomesFile);
#    }
#}

# remap the section param if required
coerce_section();

############################################################
# main viewer dispatch
############################################################
if ( param() ) {

    my $page    = param('page');
    my $section = param('section');

    # for generic section loading new a section checker to ensure no one
    # tries to enter a bad section name :) - ken
    # default is the home page
    my %validSections = (
        ClusterScout                 => 'ClusterScout',
        WorkspaceBcSet               => 'WorkspaceBcSet',
        AbundanceProfileSearch       => 'AbundanceProfileSearch',
        GenomeList                   => 'GenomeList',
        ImgStatsOverview             => 'ImgStatsOverview',
        BiosyntheticDetail           => 'BiosyntheticDetail',
        GeneCassetteProfiler         => 'GeneCassetteProfiler',
        GenomeCart                   => 'GenomeCart',
        Caliban                      => 'Caliban',
        StudyViewer                  => 'StudyViewer',
        GeneCassette                 => 'GeneCassette',
        GeneCassetteSearch           => 'GeneCassetteSearch',
        ANI                          => 'ANI',
        ProjectId                    => 'ProjectId',
        TreeFile                     => 'TreeFile',
        ScaffoldSearch               => 'ScaffoldSearch',
        MeshTree                     => 'MeshTree',
        AbundanceProfiles            => 'AbundanceProfiles',
        AbundanceTest                => 'AbundanceTest',
        AbundanceComparisons         => 'AbundanceComparisons',
        AbundanceComparisonsSub      => 'AbundanceComparisonsSub',
        AbundanceToolkit             => 'AbundanceToolkit',
        Artemis                      => 'Artemis',
        np                           => 'NaturalProd',
        NaturalProd                  => 'NaturalProd',
        ClustalW                     => 'ClustalW',
        CogCategoryDetail            => 'CogCategoryDetail',
        CompareGenomes               => 'CompareGenomes',
        CompareGenomesTab            => 'CompareGenomes',
        GenomeGeneOrtholog           => 'GenomeGeneOrtholog',
        Pangenome                    => 'Pangenome',
        CompareGeneModelNeighborhood => 'CompareGeneModelNeighborhood',
        CuraCartStor                 => 'CuraCartStor',
        CuraCartDataEntry            => 'CuraCartDataEntry',
        DataEvolution                => 'DataEvolution',
        EbiIprScan                   => 'EbiIprScan',
        EgtCluster                   => 'EgtCluster',
        EmblFile                     => 'EmblFile',
        BcSearch                     => 'BcSearch',
        BiosyntheticStats            => 'BiosyntheticStats',
        BcNpIDSearch                 => 'BcNpIDSearch',
        ClusterScout                 => 'ClusterScout',
        FindFunctions                => 'FindFunctions',
        FindFunctionMERFS            => 'FindFunctionMERFS',
        FindGenes                    => 'FindGenes',
        FindGenesLucy                => 'FindGenesLucy',
        FindGenesBlast               => 'FindGenesBlast',
        FindGenomes                  => 'FindGenomes',
        FunctionAlignment            => 'FunctionAlignment',
        FuncCartStor                 => 'FuncCartStor',
        FuncCartStorTab              => 'FuncCartStor',
        FuncProfile                  => 'FuncProfile',
        FunctionProfiler             => 'FunctionProfiler',
        DotPlot                      => 'DotPlot',
        DistanceTree                 => 'DistanceTree',
        RadialPhyloTree              => 'RadialPhyloTree',
        Kmer                         => 'Kmer',
        GenBankFile                  => 'GenBankFile',
        GeneAnnotPager               => 'GeneAnnotPager',
        GeneCartChrViewer            => 'GeneCartChrViewer',
        GeneCartStor                 => 'GeneCartStor',
        GeneCartStorTab              => 'GeneCartStor',
        MyGeneDetail                 => 'MyGeneDetail',
        Help                         => 'Help',
        GeneDetail                   => 'GeneDetail',
        geneDetail                   => 'GeneDetail',
        MetaGeneDetail               => 'MetaGeneDetail',
        MetaGeneTable                => 'MetaGeneTable',
        GeneNeighborhood             => 'GeneNeighborhood',
        FindClosure                  => 'FindClosure',
        MetagPhyloDist               => 'MetagPhyloDist',
        Cart                         => 'Cart',
        HorizontalTransfer           => 'HorizontalTransfer',
        ImgTermStats                 => 'ImgTermStats',
        KoTermStats                  => 'KoTermStats',
        HmpTaxonList                 => 'HmpTaxonList',
        Interpro                     => 'Interpro',
        MetaCyc                      => 'MetaCyc',
        AnalysisProject              => 'AnalysisProject',
        GenePageEnvBlast             => 'GenePageEnvBlast',
        GeneProfilerStor             => 'GeneProfilerStor',
        GenomeProperty               => 'GenomeProperty',
        GreenGenesBlast              => 'GreenGenesBlast',
        HomologToolkit               => 'HomologToolkit',
        ImgCompound                  => 'ImgCompound',
        ImgCpdCartStor               => 'ImgCpdCartStor',
        ImgTermAndPathTab            => 'ImgTermAndPathTab',
        ImgNetworkBrowser            => 'ImgNetworkBrowser',
        ImgPwayBrowser               => 'ImgPwayBrowser',
        ImgPartsListBrowser          => 'ImgPartsListBrowser',
        ImgPartsListCartStor         => 'ImgPartsListCartStor',
        ImgPartsListDataEntry        => 'ImgPartsListDataEntry',
        ImgPwayCartDataEntry         => 'ImgPwayCartDataEntry',
        ImgPwayCartStor              => 'ImgPwayCartStor',
        ImgReaction                  => 'ImgReaction',
        ImgRxnCartStor               => 'ImgRxnCartStor',
        ImgTermBrowser               => 'ImgTermBrowser',
        ImgTermCartDataEntry         => 'ImgTermCartDataEntry',
        ImgTermCartStor              => 'ImgTermCartStor',
        KeggMap                      => 'KeggMap',
        KeggPathwayDetail            => 'KeggPathwayDetail',
        PathwayMaps                  => 'PathwayMaps',
        Metagenome                   => 'Metagenome',
        AllPwayBrowser               => 'AllPwayBrowser',
        MpwPwayBrowser               => 'MpwPwayBrowser',
        GenomeHits                   => 'GenomeHits',
        ScaffoldHits                 => 'ScaffoldHits',
        ScaffoldDetail               => 'ScaffoldDetail',
        MetaScaffoldDetail           => 'MetaScaffoldDetail',
        ScaffoldCart                 => 'ScaffoldCart',
        MetagenomeHits               => 'MetagenomeHits',
        MetaFileHits                 => 'MetaFileHits',
        MetagenomeGraph              => 'MetagenomeGraph',
        MetaFileGraph                => 'MetaFileGraph',
        MissingGenes                 => 'MissingGenes',
        MyFuncCat                    => 'MyFuncCat',
        MyIMG                        => 'MyIMG',
        ImgGroup                     => 'ImgGroup',
        Workspace                    => 'Workspace',
        WorkspaceGeneSet             => 'WorkspaceGeneSet',
        WorkspaceFuncSet             => 'WorkspaceFuncSet',
        WorkspaceGenomeSet           => 'WorkspaceGenomeSet',
        WorkspaceScafSet             => 'WorkspaceScafSet',
        WorkspaceRuleSet             => 'WorkspaceRuleSet',
        WorkspaceJob                 => 'WorkspaceJob',
        MyBins                       => 'MyBins',
        About                        => 'About',
        NcbiBlast                    => 'NcbiBlast',
        NrHits                       => 'NrHits',
        Operon                       => 'Operon',
        OtfBlast                     => 'OtfBlast',
        PepStats                     => 'PepStats',
        PfamCategoryDetail           => 'PfamCategoryDetail',
        PhyloCogs                    => 'PhyloCogs',
        PhyloDist                    => 'PhyloDist',
        PhyloOccur                   => 'PhyloOccur',
        PhyloProfile                 => 'PhyloProfile',
        PhyloSim                     => 'PhyloSim',
        PhyloClusterProfiler         => 'PhyloClusterProfiler',
        PhylogenProfiler             => 'PhylogenProfiler',
        ProteinCluster               => 'ProteinCluster',
        ProfileQuery                 => 'ProfileQuery',
        PdbBlast                     => 'PdbBlast',
        SixPack                      => 'SixPack',
        Sequence                     => 'Sequence',
        ScaffoldGraph                => 'ScaffoldGraph',
        MetaScaffoldGraph            => 'MetaScaffoldGraph',
        TaxonCircMaps                => 'TaxonCircMaps',
        GenerateArtemisFile          => 'GenerateArtemisFile',
        TaxonDetail                  => 'TaxonDetail',
        TaxonDeleted                 => 'TaxonDeleted',
        MetaDetail                   => 'MetaDetail',
        TaxonList                    => 'TaxonList',
        TaxonSearch                  => 'TaxonSearch',
        TigrBrowser                  => 'TigrBrowser',
        TreeQ                        => 'TreeQ',
        Vista                        => 'Vista',
        IMGContent                   => 'IMGContent',
        IMGProteins                  => 'IMGProteins',
        Methylomics                  => 'Methylomics',
        RNAStudies                   => 'RNAStudies',
        Questions                    => 'Questions',
        Messages                     => 'Messages',
        znormNote                    => 'Messages',
        CogDetail                    => 'CogDetail',
        Viral                        => 'Viral',
        GeneInfoPager                => 'GeneInfoPager',
        Export                       => 'Export',
        WorkspacePublicSet           => 'WorkspacePublicSet',
    );

    # testing sections
    if ( $img_internal || $img_ken ) {
        $validSections{ProPortal} = 'ProPortal';
        $validSections{Portal}    = 'Portal';
    }

    if (   exists $validSections{$section}
        || param("exportGenes")    ne ""
        || param("exportGeneData") ne ""
        || param("setTaxonFilter") ne "" )
    {

        # TODO a better section loader  - ken
        $section = $validSections{$section};    # we need to untaint the $section..so get it from valid hash

        if ( param("exportGenes") ne "" || param("exportGeneData") ne "" ) {
            $section = 'Export';
        } elsif ( param("setTaxonFilter") ne "" ) {
            $section = 'GenomeList';
        } 

        load $section;
        $pageTitle = $section->getPageTitle();

        my @appArgs = $section->getAppHeaderData();

        my $numTaxons = printAppHeader(@appArgs) if $#appArgs > -1;
        $section->dispatch($numTaxons);

    } elsif ( ( $public_login || $user_restricted_site ) && param("redirect") ne "" ) {
        my $rurl = param("redirect");
        redirecturl($rurl);

    } else {
        $homePage = 1;
        #WebUtil::webLog("inside param 1 homePage=$homePage<br/>\n");
        printAppHeader("Home");
    }
} else {
    my $rurl = param("redirect");
    if ( ( $public_login || $user_restricted_site ) && $rurl ne "" ) {
        redirecturl($rurl);
    } else {
        $homePage = 1;
        #WebUtil::webLog("inside param 2 homePage=$homePage<br/>\n");
        printAppHeader("Home");
    }
}

printContentEnd();

# catch all if loading still showing
printMainFooter($homePage);
WebUtil::webExit(0);

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
    my ( $current, $title, $gwt, $content_js, $yahoo_js, $numTaxons ) = @_;

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
        $googleStr = googleAnalyticsJavaScript2( $server, $google_key );
        $googleStr = "" if ( $google_key eq "" );
    }

    my $template;

    #if($img_ken) {
    $template = HTML::Template->new( filename => "$base_dir/header-v41.html" );

    #} else {
    #    $template = HTML::Template->new( filename => "$base_dir/header-v40.html" );
    #}
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
        } elsif ($img_proportal) {
            $logofile = 'logo-JGI-IMG-ProPortal.png';
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
        } elsif ($img_proportal) {
            $logofile = 'logo-JGI-IMG-ProPortal.png';
        } elsif ( $img_er && $user_restricted_site && !$include_metagenomes ) {
            $logofile = 'logo-JGI-IMG-ER.png';
        } elsif ( $include_metagenomes && $user_restricted_site ) {

            #$logofile = 'logo-JGI-IMG-MER.png';
            $logofile = 'logo-JGI-IMG-ER.png';
        } elsif ( $img_proportal || $include_metagenomes ) {

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
};

        # if ( $current ne "logout" && $current ne "login" ) {
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

            # https://localhost/~kchu/preComputedData/autocompleteAll.php
            my $autocomplete_url = "$top_base_url" . "api/";

            #my $autocomplete_url = "https://localhost/~kchu/api/";

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

        #}

        if ( $current ne "login" ) {
            printLogout();
        }

        if ($img_proportal) {
            print qq{
        <a href="http://proportal.mit.edu/">
        <img id='mit_logo' src="$top_base_url/images/MIT_logo.gif" alt="MIT ProPortal logo" title="MIT ProPortal"/>
        </a>
            };
        } elsif ($img_hmp) {
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

            my $isEditor = 0;
            my $cursize  = 0;
            if ($user_restricted_site) {
                $isEditor = WebUtil::isImgEditorWrap();
            }
            if ($isEditor) {
                require CuraCartStor;
                my $c = new CuraCartStor();
                $cursize = $c->getSize();
                if ( $cursize > 0 ) {
                    $cursize = alink( 'main.cgi?section=CuraCartStor&page=curaCart', $cursize );
                }
            }
            my $bcCartSize = 0;
            if ( $abc || $img_ken ) {
                require WorkspaceBcSet;
                $bcCartSize = WorkspaceBcSet::getSize();
            }

# delete icon <img onclick=>
            my $clearallButton = '';
            if($str || $ssize || $fsize || $gsize || $bcCartSize) {
                $clearallButton = qq{
&nbsp;&nbsp; |&nbsp;&nbsp; 
<img onclick="ConfirmDelete()" title='Clear All Analysis Carts' src='$top_base_url/images/cancel.png'
style="width: 15px;height: 15px;vertical-align: middle; cursor:pointer;">
<script>
function ConfirmDelete()
{
  var x = confirm("Are you sure you want to delete?");
  if (x) {
      alert("do delete now - TODO");
      return true;
  } else {
    return false;
  }
}
</script>
                };
            }

            print qq{
<div id="cart">
 &nbsp;&nbsp; <span title="Carts are unsaved sets and are lost during session logouts">My Analysis Carts**:</span>
 &nbsp;&nbsp; <span id='genome_cart'>$str</span> $genomeUrl &nbsp;&nbsp;
|&nbsp;&nbsp; <span id='scaffold_cart'>$ssize</span> $scaffoldUrl &nbsp;&nbsp;
|&nbsp;&nbsp; <span id='function_cart'>$fsize</span> $functionsUrl &nbsp;&nbsp;
|&nbsp;&nbsp; <span id='gene_cart'>$gsize</span> $genesUrl
        };

            if ($isEditor) {
                my $curationUrl = alink( 'main.cgi?section=CuraCartStor&page=curaCart', 'Curation' );
                print qq{
  &nbsp;&nbsp; |&nbsp;&nbsp; <span id='curation_cart'>$cursize</span> $curationUrl
          };
            }

            if ( $abc || $img_ken ) {
                my $bcurl = alink( 'main.cgi?section=WorkspaceBcSet&page=viewCart', 'BC' );
                print qq{
  &nbsp;&nbsp; |&nbsp;&nbsp; <span id='bc_cart'>$bcCartSize</span> $bcurl
          };
            }

            print $clearallButton if($img_ken);

            print "</div>";
        } # end if ($enable_carts)

    } # end if ( $current eq "logout" || $current eq "login" ) "else" section

    print qq{
    <div id="myclear"></div>
    };
}

sub printMenuDiv {

    # menu file json data
    # read file
    my $content;
    if ( $abc ) {
      $content = WebUtil::file2Str("$base_dir/menu-abc.json");
    } else {
      $content = WebUtil::file2Str("$base_dir/menu.json");
    }

    my $aref = decode_json($content);
    print "<div id='menu'>\n";
    printMenuRow( $aref, 0 );
    print qq{
        </div> <!-- end menu div -->
<div id="myclear"></div>
<div id="container">
    };
}

sub printMenuRow {
    my ( $aref, $level ) = @_;
    return if ( $aref eq '' );

    my $subarrowRight = "<img class='subarrow' src='../../images/ArrowNav.gif'/>";
    my $subarrowLeft  = "<img class='subarrow_left' src='../../images/ArrowNav_left.gif'/>";

    if ( $level == 0 ) {
        print "<ul id='nav'>\n";
    } elsif ( $level == 1 ) {
        print "    <ul>\n";
    } else {
        print "        <ul>\n";
    }

    foreach my $menutop_href (@$aref) {
        my $name              = $menutop_href->{'name'};
        my $level             = $menutop_href->{'level'};
        my $title             = $menutop_href->{'title'};
        my $url               = $menutop_href->{'url'};
        my $icon              = $menutop_href->{'icon'};
        my $arrow             = $menutop_href->{'arrow'};
        my $not_avaiable_href = $menutop_href->{'not avaiable'};
        if ( !$not_avaiable_href ) {
            $not_avaiable_href = $menutop_href->{'not in'};
        }
        my $submenu_aref = $menutop_href->{'submenu'};
        my $onClick      = $menutop_href->{'onClick'};

        next if ( $abc                 && exists $not_avaiable_href->{'abc'} );
        next if ( $img_edu             && exists $not_avaiable_href->{'edu'} );
        next if ( $img_hmp             && exists $not_avaiable_href->{'hmp'} );
        next if ( $img_proportal       && exists $not_avaiable_href->{'proportal'} );
        next if ( $virus               && exists $not_avaiable_href->{'vr'} );
        next if ( $include_metagenomes && !$user_restricted_site && exists $not_avaiable_href->{'m'} );
        next if (!$img_ken && $include_metagenomes && $user_restricted_site && exists $not_avaiable_href->{'mer'} );
        next if (exists $not_avaiable_href->{'public'} && !$public_login && !$user_restricted_site);

        my $arrowStr = '';
        if ( $arrow eq 'right' ) {
            $arrowStr = $subarrowRight;
        } elsif ( $arrow eq 'left' ) {
            $arrowStr = $subarrowLeft;
        }

        my $iconStr = '';
        if ($icon) {
            $iconStr = "<img class='menuimg' src='../../images/$icon'/>";
        }

        my $titleStr = '';
        if ($title) {
            $titleStr = "title='$title'";
        }

        if ( $level == 0 && $name ne 'Help' ) {
            print qq{    <li><a href="$url"> $name </a>\n};
        } elsif ( $level == 0 && $name eq 'Help' ) {
            print qq{    <li class="rightmenu"><a href="$url"> $name </a>\n};
        } elsif ( $level == 1 && $submenu_aref ne '' && $#$submenu_aref < 0 ) {
            print qq{        <li class="sub" $titleStr><a href="$url">$iconStr $name </a>\n};
        } elsif ( $level == 1 && $submenu_aref ne '' && $#$submenu_aref > -1 ) {
            if ( $arrow eq 'right' ) {
                print qq{        <li class="sub2" $titleStr><a href="$url">$iconStr $name $arrowStr</a>\n};
            } elsif ( $arrow eq 'left' ) {
                print qq{        <li class="sub2" $titleStr><a href="$url">$arrowStr $iconStr $name </a>\n};
            } else {
                print qq{       <li class="sub2" $titleStr><a href="$url">$iconStr $name </a>\n};
            }
        } elsif ( $level == 2 ) {
            print qq{           <li class="sub3" $titleStr><a href="$url">$iconStr $name </a>\n};
        }

        if ( $submenu_aref ne '' && $#$submenu_aref > -1 ) {
            printMenuRow( $submenu_aref, $level + 1 );
        }
        if ( $level == 0 ) {
            print "    </li>\n";
        } elsif ( $level == 1 ) {
            print "        </li>\n";
        } else {
            print "            </li>\n";
        }

    }

    if ( $level == 0 ) {
        print "</ul>\n";
    } elsif ( $level == 1 ) {
        print "    </ul>\n";
    } else {
        print "        </ul>\n";
    }
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
    my ( $current, $help, $dbh ) = @_;
    if ( $current eq "logout" || $current eq "login" ) {
        return;
    }

    my $contact_oid = getContactOid();
    my $isEditor    = 0;
    if ($user_restricted_site) {
        $isEditor = isImgEditor( $dbh, $contact_oid );
    }

    # find last cart if any
    my $lastCart = getSessionParam("lastCart");
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

        my $compare_url   = alink( "$main_cgi?section=CompareGenomes&page=compareGenomes", "Compare Genomes" );
        my $synteny_url   = alink( "$main_cgi?section=Vista&page=toppage",                 "Synteny Viewers" );
        my $abundance_url = alink( "$main_cgi?section=AbundanceProfiles&page=topPage",     "Abundance Profiles Tools" );
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

# error frame - test to see if js enabled
# if enabled you can use div's id "error_content" innerHtml to display an error message
# and
# error frame - hidden by default but to display set an in-line style:
#  style="display: block" to override the default css
# 4th div
sub printErrorDiv {
    my $section = param('section');

    my $template = HTML::Template->new( filename => "$base_dir/error-message-tmpl.html" );
    $template->param( base_url => $base_url );

    print $template->output;

    # message from the web config file - ken
    if ( $MESSAGE ne "" ) {
        print qq{
	    <div id="message_content" class="message_frame shadow" style="display: block" >
	    <img src='$top_base_url/images/announcementsIcon.gif'/>
	    $MESSAGE
	    </div>
	};
    }
}

# home page stats table - left side
# 6th div for home page
#
sub printStatsTableDiv {
    my ( $maxAddDate, $maxErDate ) = @_;
    my ( $s, $hmp );

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

    #    if ( $homePage && !$img_hmp && !$img_edu && !$abc && !$img_proportal ) {
    #
    #        # news section on the home for all data marts except hmp, edu and proportal
    #        print "</p>\n";
    #        printNewsDiv();
    #    }

    print "</div>\n";    # end of training

    print "</div>\n";    # <!-- end of left div -->
}

# home page content div
sub printContentHome {
    if ($abc) {
        print qq{
    <div id="content" class='content contentABC'>
    };

    } else {
        print qq{
	<div id="content" class='content'>
    };
    }
}

# other pages content div
sub printContentOther {
    print qq{
	<div id="content_other">
    };
}

# end content div
sub printContentEnd {
    print qq{
	</div> <!-- end of content div  -->
        <div id="myclear"></div>
    };

    #    if($abc) {
    #        # end of the large div width such that content
    #        print '</div>';
    #    }

    print qq{
    </div> <!-- end of container div  -->
    };

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
    my ( $current, $noMenu, $gwtModule, $yuijs, $content_js, $help, $redirecturl ) = @_;

    if ( $virus && WebUtil::paramMatch("noHeader") ne "" ) {
        #WebUtil::webLog("main::printAppHeader() noHeader<br/>\n"); 
        require Viral;
        return;
    }
        
    # sso
    my $cookie_return = '';
    if ( $sso_enabled && $current eq "login" && $sso_url ne "" ) {
        my $url = $cgi_url . "/" . $main_cgi . redirectform(1);
        $url = $redirecturl if ( $redirecturl ne "" );

        if ( $url =~ /cgi$/ ) {
            $url = $url . '?oldLogin=false';
        } elsif ( $url =~ /oldLogin=true/ ) {
            $url =~ s/oldLogin=true/oldLogin=false/;
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
    my $numTaxons = printTaxonFilterStatus();    # if ( $current ne "Home" );
    $numTaxons = "" if ( $numTaxons == 0 );

    if ( $current eq "Home" && $abc ) {

        # new abc home page
        # caching home page
        my $sid  = getContactOid();
        my $time = 3600 * 24;                    # 24 hour cache

        printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        printMenuDiv( );
        printErrorDiv();

        HtmlUtil::cgiCacheInitialize("homepage");
        HtmlUtil::cgiCacheStart() or return;
        
        my $dbh = dbLogin();
        my ( $maxAddDate, $maxErDate ) = getMaxAddDate($dbh);

        #print qq{
        #  <div style='width:2000px'>
        #};

        printContentHome();

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

    } elsif ( $virus && $current eq "Home" ) {
        # caching home page
        printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        printMenuDiv();
        printErrorDiv();

        my $page = param('page');
        #print "main::printAppHeader() page=$page<br/>\n";
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


    } elsif ( $img_ken && $current eq "Home" ) {
        # TODO new home page testing - ken

        # caching home page
        my $sid  = getContactOid();
        my $time = 3600 * 24;         # 24 hour cache
        
        printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        printMenuDiv(  );
        printErrorDiv();

    
        print "NEW home page TODO<br>\n"; 
       
        my $cnt = 0;
        my $img_mer = 1;
        $img_mer = 0 if (param('public') == 1); # testing - ken
        if($img_mer) {
        	$cnt = WebUtil::getSessionParam('myprivatescnt');
        	if(!$cnt) {
        		$cnt = MainPageStats::getPrivateCounts();
        		WebUtil::setSessionParam('myprivatescnt', $cnt);
        	}
        }

        my $vars = {
            private => $cnt,
            img_mer => $img_mer,
        };

        my $tt = Template->new({
            INCLUDE_PATH => "/webfs/projectdirs/microbial/img/web_data/stats/",
            INTERPOLATE  => 1,
        }) or die "$Template::ERROR\n";
    
        if($img_mer) {
    	   $tt->process("homepage_mer.tt", $vars) or die $tt->error();
        } else {
    	   $tt->process("homepage_m.tt", $vars) or die $tt->error();
        }

    } elsif ( $current eq "Home" ) {

        # caching home page
        my $sid  = getContactOid();
        my $time = 3600 * 24;         # 24 hour cache

        printHTMLHead( $current, "JGI IMG Home", $gwtModule, "", "", $numTaxons );
        printMenuDiv(  );
        printErrorDiv();

        HtmlUtil::cgiCacheInitialize("homepage");
        HtmlUtil::cgiCacheStart() or return;

        my $dbh = dbLogin();
        my ( $maxAddDate, $maxErDate ) = getMaxAddDate($dbh);

        # to stop the inline-block or float left from wrapping
        # to the next line - ken
        #print qq{<div style="width: 1200px;">};
        printStatsTableDiv( $maxAddDate, $maxErDate );
        printContentHome();
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

        my $newsStr = getNewsHeaders(10);

        print qq{

<fieldset class='newsFieldset'>
<legend class='newsLegend'>News</legend>
$newsStr
<a href="main.cgi?section=Help&page=news">Read more...</a>
</fieldset>


        };

        # no need to print end div for width div above, its printed later - ken

        HtmlUtil::cgiCacheStop();
    } else {
        printHTMLHead( $current, $pageTitle, $gwtModule, $content_js, $yuijs, $numTaxons );
        printMenuDiv();

        if($current ne 'login' && $current ne 'logout') {
        	my $dbh = dbLogin();
        	printBreadcrumbsDiv( $current, $help, $dbh );
        }
        
        printErrorDiv();
        printContentOther();
    }

    return $numTaxons;
}

sub printNewsDiv {

    # read news  file
    my $file = '/webfs/scratch/img/news.html';
    if ( -e $file ) {
        print qq{
            <span id='news2'>News</span>
            <div id='news'>
        };

        print getNewsHeaders(3);

        print qq{
            <a href='main.cgi?section=Help&page=news'>Read more...</a>
            </div>
        };
    }
}

sub getNewsHeaders {
    my ($maxLines) = @_;
    $maxLines = 3 if ( !$maxLines );
    my $file  = '/webfs/scratch/img/news.html';
    my $lines = '';

    my $line;
    my $rfh = newReadFileHandle($file);
    my $i   = 0;
    while ( my $line = $rfh->getline() ) {
        last if ( $i > $maxLines );
        if ( $line =~ /^<b id='subject'>/ ) {
            $line =~ s/<br>//;
            $line =~ s/<\/br>//;
            my $tmp = $i + 1;
            $lines .= "<a href='main.cgi?section=Help&page=news#$tmp'>" . $line . "</a><br>";
            $i++;
        }
    }
    close $rfh;

    return $lines;
}

#
# gets genome's max add date
#
sub getMaxAddDate {
    my ($dbh) = @_;

    my $imgclause = WebUtil::imgClause('t');

    my $sql = qq{
	select to_char(max(t.add_date),'yyyy-mm-dd')
    from taxon t
    where 1 = 1
    $imgclause
    };

    my $cur = execSql( $dbh, $sql, $verbose );
    my ($max) = $cur->fetchrow();

    # this the acutal db ui release date not the genome add_date - ken
    my $maxErDate;
    my $sql2 = qq{
select to_char(release_date, 'yyyy-mm-dd') from img_build
        };
    $cur = execSql( $dbh, $sql2, $verbose );
    ($maxErDate) = $cur->fetchrow();

    return ( $max, $maxErDate );
}

# logout in header under quick search - ken
sub printLogout {

    # in the img.css set the z-index to show the logout link - ken
    if ( $public_login || $user_restricted_site ) {
        my $contact_oid = getContactOid();
        return if !$contact_oid;
        return if ( param("logout") ne "" );

        my $name = WebUtil::getUserName2();
        if ( $name eq '' ) {
            $name = WebUtil::getUserName();
        }

        my $tmp = "<br/> (JGI SSO)";
        if ($oldLogin) {
            $tmp = "";
        }

        print qq{
	    <div id="login">
            Hi $name &nbsp; | &nbsp; <a href="main.cgi?section=Caliban&logout=1"> Logout </a>
            $tmp <span style='font-size:8px; color:gray;'>$$</span>
	    </div>
        };
    }
}

############################################################################
# printMainFooter - Show main footer information.  Reads from footer
#   template file.
############################################################################
sub printMainFooter {
    my ( $homeVersion, $postJavascript ) = @_;
    WebUtil::printMainFooter( $homeVersion, $postJavascript );
}

sub googleAnalyticsJavaScript {
    my ( $server, $google_key ) = @_;

    my $str = file2Str( "$top_base_dir/js/google.js", 1 );
    $str =~ s/__google_key__/$google_key/g;
    $str =~ s/__server__/$server/g;

    return $str;
}

# newer version using async
sub googleAnalyticsJavaScript2 {
    my ( $server, $google_key ) = @_;

    my $str = file2Str( "$top_base_dir/js/google2.js", 1 );
    $str =~ s/__google_key__/$google_key/g;
    $str =~ s/__server__/$server/g;

    return $str;
}

############################################################################
# printTaxonFilterStatus - Show current selected number of genomes.
#  WARNING: very convoluted code.
############################################################################
sub printTaxonFilterStatus {

    require GenomeCart;
    my $taxon_oids = GenomeCart::getAllGenomeOids();
    if ( $taxon_oids ne '' ) {
        my $size = $#$taxon_oids + 1;
        return $size;
    }
    return 0;
}

############################################################################
#	coerce_section
#
#	set the 'section' param when the submit button naming convention is used
############################################################################

sub coerce_section {

    # From submit button naming convention
    #  section_<sectionName>_<action>, not URL link.
    my $p = paramMatch("^_section");
    if ($p) {
        my @arr = split /_/, $p;
        ## Force setting.
        param( "section", $arr[2] );
    }
}

sub redirectform {
    my ($noprint) = @_;

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

#
# redirect url - for login systems
# when users need to login before viewing a link
#
sub redirecturl {
    my ($url) = @_;

    printAppHeader("Home");
    print qq{
            <script language='JavaScript' type="text/javascript">
             window.open("main.cgi$url", "_self");
             </script>
    };
}

############################################################################
# getRequestAcctAttr
############################################################################
sub getRequestAcctAttr {
    my @attrs = (
        "name\tYour Name\tchar\t80\tY",                "title\tTitle\tchar\t80\tN",
        "department\tDepartment\tchar\t255\tN",        "email\tYour Email\tchar\t255\tY",
        "phone\tPhone Number\tchar\t80\tN",            "organization\tOrganization\tchar\t255\tY",
        "address\tAddress\tchar\t255\tN",              "city\tCity\tchar\t80\tY",
        "state\tState\tchar\t80\tN",                   "country\tCountry\tchar\t80\tY",
        "username\tPreferred Login Name\tchar\t20\tY", "group_name\tGroup (if known)\tchar\t80\tN",
        "comments\tReason(s) for Request\ttext\t60\tY"
    );

    return @attrs;
}

# touch user's cart files if any
# why?
# because user cart file can be over 90 mins old
# but the user is still using img
# after the 90 mins the user's charts are purged.
# -ken
sub touchCartFiles {

    require GeneCartStor;
    my $c    = new GeneCartStor();
    my $file = $c->getStateFile();
    WebUtil::fileTouch($file) if -e $file;

    require FuncCartStor;
    $c    = new FuncCartStor();
    $file = $c->getStateFile();
    WebUtil::fileTouch($file) if -e $file;

    if ($user_restricted_site) {
        require CuraCartStor;
        $c    = new CuraCartStor();
        $file = $c->getStateFile();
        WebUtil::fileTouch($file) if -e $file;
    }

    require ScaffoldCart;
    $file = ScaffoldCart::getStateFile();
    WebUtil::fileTouch($file) if -e $file;

    require GenomeCart;
    $file = GenomeCart::getStateFile();
    WebUtil::fileTouch($file) if -e $file;
    $file = GenomeCart::getColIdFile();
    WebUtil::fileTouch($file) if -e $file;

    # touch cart directory s.t. it does not get purge
    my ( $cartDir, $sessionId ) = WebUtil::getCartDir();
    WebUtil::fileTouch($cartDir);
}

sub render_template {

    my $tmpl_name = shift || die "No template name specified!";
    my $data = shift // {};

    my $tt = Template->new(
        {
            INCLUDE_PATH => [ "$base_dir/views", "$base_dir/views/pages", "$base_dir/views/layouts", "$base_dir/views/inc" ],
        }
    ) || die "Template error: $Template::ERROR\n";
    $data->{env} = getEnv();

    $tt->process( $tmpl_name, $data ) || die $tt->error() . "\n";

}
