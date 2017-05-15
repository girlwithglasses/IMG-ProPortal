#   All CGI called run this section and dispatch is made to relevant
#   for displaying appropriate CGI pages.
#      --es 09/19/2004
#
# $Id: main.pl 36986 2017-04-24 20:21:19Z klchu $
##########################################################################
use strict;
use feature ':5.16';
use CGI qw( :standard  );
use CGI::Cookie;
use CGI::Session qw/-ip-match/;    # for security - ken
use CGI::Carp qw( carpout set_message fatalsToBrowser );
use perl5lib;
use JSON;
use File::Path qw(remove_tree);
use Number::Format;
use Template;
use Module::Load;
use Data::Dumper;
use HTML::Template;

use WebConfig;
use WebSession;
use WebSessionPrint;
use WebDB;
use WebUtil;
use WebPrint;

# -----------------------------------------
#
# NEW objects
#
# -----------------------------------------
my $webSession = new WebSession();
my $webDB = new WebDB();
my $webSessionPrint = new WebSessionPrint($webSession, $webDB);

# hook back into webutil s.t. not to break old code - ken
WebUtil::setWebSessionObject($webSession);
WebUtil::setWebDBObject($webDB);
WebUtil::setWebSessionPrint($webSessionPrint);


my $contact_oid = WebUtil::getContactOid();
#my $cookie = $webSession->makeCookieSession();


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

my $taxon_filter_oid_str;

# sso Caliban
# cookie name: jgi_return, value: url, domain: jgi.doe.gov
my $sso_enabled     = $env->{sso_enabled};
my $sso_url         = $env->{sso_url};
my $sso_cookie_name = $env->{sso_cookie_name};    # jgi_return cookie name

my $jgi_return_url = "";
my $homePage       = 0;
my $pageTitle      = "IMG";

$CGITempFile::TMPDIRECTORY = $TempFile::TMPDIRECTORY = "$cgi_tmp_dir";

timeout( 60 * $default_timeout_mins );

# check the number of cgi processes
WebUtil::maxCgiProcCheck();


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
        $webSessionPrint->printAppHeader("exit");
        printMessage( "Database is currently being serviced.<br/>"
              . "Sorry for the inconvenience.<br/>"
              . "Please try again later.<br/>" );
        WebPrint::printContentEnd();
        WebPrint::printMainFooter($homePage);
    }
    WebUtil::webExit(0);
}


if($virus) {
    WebUtil::setSessionParam( "hideViruses", 'No' );
}


if ( $user_restricted_site || $sso_enabled ) {
    require Caliban;
    if ( !$contact_oid ) {
        #my $dbh_main = dbLogin();
        my $ans      = Caliban::validateUser();

        if ( !$ans ) {
            $webSessionPrint->printAppHeader("login");
            Caliban::printSsoForm();
            WebPrint::printContentEnd();
            WebPrint::printMainFooter(1);
            WebUtil::webExit(0);
        }
        WebUtil::loginLog( 'login', 'sso' );
        require MyIMG;
        MyIMG::loadUserPreferences();
    }

    # logout in genome portal i still have contact oid
    # I have to fix and relogin
    # only an $ans or '1' is a vaildate session any other number will 
    # log you out
    my $ans = Caliban::isValidSession();
    if ( $ans != 1) {
        
        $webSessionPrint->printAppHeader("login");
        Caliban::logout( 1, $ans );
        Caliban::printSsoForm($ans);
        WebPrint::printContentEnd();
        WebPrint::printMainFooter(1);
        WebUtil::webExit(0);
    }
} 



# for adding to genome cart from browser list
#
# TODO Is this used now? - ken 
#
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

#
# lets touch user's chart files
#
#touchCartFiles();

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
        Blast16s => 'Blast16s',
        WorkspaceBlast => 'WorkspaceBlast',
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

        my $numTaxons = $webSessionPrint->printAppHeader(@appArgs) if $#appArgs > -1;
        $section->dispatch($numTaxons);

    } elsif ( ( $public_login || $user_restricted_site ) && param("redirect") ne "" ) {
        my $rurl = param("redirect");
        redirecturl($rurl);

    } else {
        $homePage = 1;
        $webSessionPrint->printAppHeader("Home");
    }
} else {
    my $rurl = param("redirect");
    if ( ( $public_login || $user_restricted_site ) && $rurl ne "" ) {
        redirecturl($rurl);
    } else {
        $homePage = 1;
        $webSessionPrint->printAppHeader("Home");
    }
}

WebPrint::printContentEnd();

# catch all if loading still showing
WebPrint::printMainFooter($homePage);

$webDB->logout();
WebUtil::webExit(0);


# ----------------------------------------------------------------------------
#
# redirect url - for login systems
# when users need to login before viewing a link
#
sub redirecturl {
    my ($url) = @_;

    $webSessionPrint->printAppHeader("Home");
    print qq{
            <script language='JavaScript' type="text/javascript">
             window.open("main.cgi$url", "_self");
             </script>
    };
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
