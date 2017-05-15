############################################################################
# This is used to get XML data objects from server.
# It follows the same logic as main.pl and inner.pl
# see xml.cgi
#
# $Id: xml.pl 36954 2017-04-17 19:34:04Z klchu $
############################################################################
use strict;
use CGI qw( :standard );
use CGI::Session qw/-ip-match/;    # for security - ken
use CGI::Carp qw( carpout set_message fatalsToBrowser );
use perl5lib;
use Data::Dumper;
use FileHandle;
use Module::Load;

use WebConfig;
use WebSession;
use WebDB;
use WebUtil;
use WebSessionPrint;

my $webSession = new WebSession();
my $webDB = new WebDB();
my $webSessionPrint = new WebSessionPrint($webSession, $webDB);

WebUtil::setWebSessionObject($webSession);
WebUtil::setWebDBObject($webDB);
WebUtil::setWebSessionPrint($webSessionPrint);

$| = 1;

my $env                  = getEnv();
my $top_base_dir         = $env->{top_base_dir};
my $base_dir             = $env->{base_dir};
my $default_timeout_mins = $env->{default_timeout_mins};
$default_timeout_mins = 5 if $default_timeout_mins eq "";

timeout( 60 * $default_timeout_mins );

############################################################################
# main
############################################################################

my $section = param("section");

my %validSections = (
AutoRefresh =>'AutoRefresh',
ProPortal => 'ProPortal',
MeshTree => 'MeshTree',
ANI => 'ANI',
GenomeListJSON => 'GenomeListJSON',
PhylumTree => 'PhylumTree',
BinTree => 'BinTree',
BarChartImage => 'BarChartImage',
TaxonList => 'TaxonList',
IMGProteins => 'IMGProteins',
RNAStudies => 'RNAStudies',
PathwayMaps => 'PathwayMaps',
TableUtil => 'TableUtil',
Methylomics => 'Methylomics',
BiosyntheticDetail => 'BiosyntheticDetail',
BiosyntheticStats => 'BiosyntheticStats',
GenomeListFilter => 'GenomeListFilter',
FindGenomesByMetadata => 'FindGenomesByMetadata',
FunctionAlignment => 'FunctionAlignment',
Artemis => 'Artemis',
ACT => 'ACT',
TreeFile => 'TreeFile',
Selection => 'Selection',
TreeFileMgr => 'TreeFileMgr',
GeneCassetteSearch => 'GeneCassetteSearch',
GeneDetail => 'GeneDetail',
Cart => 'Cart',
Check => 'Check',
check => 'Check',
RadialPhyloTree => 'RadialPhyloTree',
Workspace => 'Workspace',
);

#if($section eq 'GenomeListJSON' ) {
#    require GenomeListJSON;
#    GenomeListJSON::printWebPageHeader();
#    GenomeListJSON::dispatch();
#} els

if(exists $validSections{$section}) {

    my $section2 = $validSections{$section};
    load $section2;
    $section2->printWebPageHeader();
    $section2->dispatch();

} elsif ( $section eq "tooltip" ) {
    my $filename = param('filename');
    print header( -type => "text/html" );

    my $file = $top_base_dir . '/docs/tooltips/' . $filename;
    if ( -e $file ) {
        my $str = file2Str($file);
        print $str;
    }

} elsif ( $section eq "yuitracker" ) {
    print header( -type => "text/html" );
    my $file = $env->{yui_export_tracker_log};
    my $afh = newAppendFileHandle( $file, "yui", 1 );

    my $text = param('text');
    my $s    = dateTimeStr() . ' ' . getContactOid() . " $text\n";
    print $afh $s;
    close $afh;

} elsif ( $section eq "config" ) {

    #   sort keys
    $Data::Dumper::Sortkeys = 1;

    # sort keys in reverse order - use either one
    #$Data::Dumper::Sortkeys = sub { [reverse sort keys %{$_[0]}] };
    #$Data::Dumper::Sortkeys = sub { [sort {$b cmp $a} keys %{$_[0]}] };
    #print Dumper($obj);

    print header( -type => "text/plain" );
    print Dumper $env;

} elsif ( $section eq "MessageFile" ) {

    # ajax general message check - see header.js and main.pl footer section
    print header( -type => "text/html" );
    my $message_file = $env->{message_file};
    if ( $message_file ne "" && -e $message_file ) {

        my $str = file2Str($message_file);
        print $str;
    }

} elsif ( $section eq "NewsFile" ) {

    # ajax general message check - see header.js and main.pl footer section
    print header( -type => "text/html" );
    my $message_file = "/webfs/scratch/img/proPortal/news.txt";
    if ( $message_file ne "" && -e $message_file ) {
        my $str = file2Str($message_file);
        print $str;
    }

} elsif ( $section eq 'fitnessblast' ) {
    my $gene_oid = param('gene_oid');
    my $dbh = WebUtil::dbLogin();
    my $aa_residue = WebUtil::geneOid2AASeq($dbh, $gene_oid);
    my $url = "http://fit.genomics.lbl.gov/cgi-bin/seqservice.cgi?html=1&seq=$aa_residue";
    WebUtil::webLog("\n$url\n");
    my $content = WebUtil::urlGet($url);
    print header( -type => "text/html" );
    print $content;

} elsif ( $section eq 'scriptEnv' ) {
    print header( -type => "text/plain" );

    # test
    unsetEnvPath();
    print "PATH:\n";
    print $ENV{PATH} . "\n\n";
    print "LD_LIBRARY_PATH:\n";
    print $ENV{LD_LIBRARY_PATH} . "\n\n";


    my $cmd1 = "perl -version";
    testCmd($cmd1);

    my $cmd1 = "python -V";
    testCmd($cmd1);


    my $cmd1 = "java -version";
    testCmd($cmd1);

    my $cmd1 = "R --version";
    testCmd($cmd1);
    
    my $cmd1 = "/usr/bin/which neighbor";
    testCmd($cmd1);    

    my $cmd1 = "which gs";
    testCmd($cmd1);

    print "\n\nTest Done\n";

    print "\n ip: " . WebUtil::getIpAddress() . " " . $ENV{SERVER_NAME};
    print "\n";
    print "webutil " . WebUtil::getHostname(); 
    print "\n";
    
    print "HTTP_X_FORWARDED_FOR " . $ENV{HTTP_X_FORWARDED_FOR};
    print "\n";


} else {
    print header( -type => "text/plain" );
    print "Unknown section='$section'\n";   
}

$webDB->logout();
WebUtil::webExit(0);

# =================================== 
#
#
sub testCmd {
    my($cmd1) = @_;
    
    print "\nTesting command:\n    $cmd1\n";
    my $fh = new FileHandle("$cmd1 2>\&1 |");

    if ($fh) {
        while ( my $line = $fh->getline() ) {
            chomp $line;
            print "Status: $line\n";
        }
        close $fh;
    }
    
    
}

