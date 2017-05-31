# $Id: Export.pm 35780 2016-06-15 20:41:20Z klchu $
##########################################################################
package Export;
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
    if(param("exportType") eq "nucleic") {
        $pageTitle = "Gene Export";
    } elsif(param("exportType") eq "amino") {
        $pageTitle = "Gene Export";
    } elsif(param("exportType") eq "tab") {
        $pageTitle = "Gene Export";
    }
    return $pageTitle;
}

sub getAppHeaderData {
    my ($self) = @_;

    my $page = param('page');
    my @a = ();
    if(param("exportType") eq "excel" ) {
        my @gene_oid = param("gene_oid");
        if ( scalar(@gene_oid) == 0 ) {
            @a = ('');
        }
    } elsif(param("exportType") eq "nucleic") {
        @a = ('');
    } elsif(param("exportType") eq "amino") {
        @a = ('');
    } elsif(param("exportType") eq "tab") {
        @a = ('');
    }
    
    return @a;
}

sub dispatch {
    my ( $self, $numTaxon ) = @_;

    if ( param("exportGeneData") ne "" ) {
        require Workspace;
        Workspace::exportGeneFiles('data');
    }
    else {    
        my @gene_oid = param("gene_oid");
    
        if ( param("exportType") eq "excel" ) {
            if ( scalar(@gene_oid) == 0 ) {
                WebUtil::webError("You must select at least one gene to export.");
            }
            require GenerateArtemisFile;
            GenerateArtemisFile::processDataFile( \@gene_oid, 1, 'gene' );
        
        } elsif ( param("exportType") eq "nucleic" ) {
            require GenerateArtemisFile;
            GenerateArtemisFile::prepareProcessGeneFastaFile();
        
        } elsif ( param("exportType") eq "amino" ) {
            require GenerateArtemisFile;
            GenerateArtemisFile::prepareProcessGeneFastaFile(1);
        
        } elsif ( param("exportType") eq "tab" ) {
            print "<h1>Gene Export</h1>\n";
            my @gene_oid = param("gene_oid");
            my $nGenes   = @gene_oid;
            if ( $nGenes == 0 ) {
                print "<p>\n";
                WebUtil::webDie("Select genes to export first.");
            }
            print "</font>\n";
            print "<p>\n";
            print "Export in tab-delimited format for copying and pasting.\n";
            print "</p>\n";
            print "<pre>\n";
            WebUtil::printGeneTableExport( \@gene_oid );
            print "</pre>\n";        
        }        
    }
}

1;
