############################################################################
# Utility subroutines for meta scaffold detail
# $Id: MetaScaffoldDetail.pm 36987 2017-04-24 20:40:20Z klchu $
############################################################################
package MetaScaffoldDetail;

my $section = "MetaScaffoldDetail";

use strict;
use CGI qw( :standard );
use Data::Dumper;
use DBI;
use WebConfig;
use WebUtil;
use HtmlUtil;
use OracleUtil;
use QueryUtil;
use MetaUtil;
use MetaGeneTable;
use WorkspaceUtil;
use PhyloUtil;
use ScaffoldDataUtil;

$| = 1;

my $env      = getEnv();
my $main_cgi = $env->{main_cgi};
my $verbose  = $env->{verbose};
my $base_url = $env->{base_url};
my $YUI      = $env->{yui_dir_28};
my $in_file  = $env->{in_file};
my $user_restricted_site = $env->{user_restricted_site};

my $img_internal = $env->{img_internal};
my $virus = $env->{virus};

my $preferences_url    = "$main_cgi?section=MyIMG&page=preferences";
my $maxGeneListResults = 1000;
if ( getSessionParam("maxGeneListResults") ne "" ) {
    $maxGeneListResults = getSessionParam("maxGeneListResults");
}

sub getPageTitle {
    return 'Microbiome Scaffold Detail';
}

sub getAppHeaderData {
    my ($self) = @_;

    my @a = ('FindGenomes');
    return @a;
}

############################################################################
# dispatch - Dispatch loop.
############################################################################
sub dispatch {
    my ( $self, $numTaxon ) = @_;

    my $page = param("page");

    if ( $page eq "metaScaffoldDetail"
        || paramMatch("metaScaffoldDetail") ne "" )
    {
        printMetaScaffoldDetail();
    } elsif ( $page eq "metaScaffoldGenes"
        || paramMatch("metaScaffoldGenes") ne "" )
    {
        printMetaScaffoldGenes();
    }

}

############################################################################
# printMetaScaffoldDetail: scaffold detail (from file)
#   Inputs:
#     scaffold_oid - scaffold object identifier
############################################################################
sub printMetaScaffoldDetail {
    my $scaffold_oid = param("scaffold_oid");
    my $taxon_oid    = param("taxon_oid");
    my $data_type    = param("data_type");
    if ( !$data_type ) {
        $data_type = 'assembled';
    }

    printMainForm();
    printStatusLine( "Loading ...", 1 );

    print "<h1>Metagenome Scaffold Detail</h1>\n";
    print hiddenVar( "taxon_oid", $taxon_oid );
    print hiddenVar( "data_type", $data_type );

    my $workspace_id = "$taxon_oid $data_type $scaffold_oid";
    print hiddenVar( "scaffold_oid", $workspace_id );

    my ( $scf_seq_len, $scf_gc, $scf_gene_cnt ) = MetaUtil::getScaffoldStats( $taxon_oid, $data_type, $scaffold_oid );

    print "<p>\n";    # paragraph section puts text in proper font.
    print "<table class='img' border='1'>\n";
    printAttrRow( "Scaffold ID", $scaffold_oid );

    # taxon
    my $dbh = dbLogin();
    checkTaxonPerm( $dbh, $taxon_oid );

    my $taxon_name = WebUtil::taxonOid2Name( $dbh, $taxon_oid, 1 );
    $taxon_name = HtmlUtil::appendMetaTaxonNameWithDataType( $taxon_name, $data_type );
    my $url = "$main_cgi?section=MetaDetail" . "&page=metaDetail&taxon_oid=$taxon_oid";
    printAttrRowRaw( "Genome", alink( $url, $taxon_name ) );

    printAttrRow( "Topology",             "linear" );
    printAttrRow( "Sequence Length (bp)", $scf_seq_len );

    #printAttrRow( "GC Content", sprintf( "%.2f%%", $scf_gc ) );
    printAttrRow( "GC Content", $scf_gc );

    if ( $data_type ne 'unassembled' ) {
        my ($scaf_depth) = MetaUtil::getScaffoldDepth( $taxon_oid, $data_type, $scaffold_oid );
        printAttrRow( "Read Depth", "$scaf_depth" );

        my ( $lineage, $percentage, $rank ) = MetaUtil::getScaffoldLineage( $taxon_oid, $data_type, $scaffold_oid );
	if ( $virus ) {
	    my $v_sql = qq{
                select domain, phylum, ir_class, ir_order,
                       family, subfamily, genus, species
                from dt_mvc_taxonomy\@core_v400_musk
                where mvc = ?
                };

	    my $mvc_id = $taxon_oid . "_____" . $scaffold_oid;
	    my $v_cur = execSql( $dbh, $v_sql, $verbose, $mvc_id );
	    my ($v_dom, $v_phy, $v_cla, $v_ord, $v_fam,
		$v_sub_fam, $v_gen, $v_spe) = $v_cur->fetchrow();
	    $v_cur->finish();
	    if ( $v_dom ) {
		$lineage = "$v_dom;$v_phy;$v_cla;$v_ord;$v_fam";
		if ( $v_sub_fam && $v_sub_fam ne 'unclassified' ) {
		    $lineage .= "(" . $v_sub_fam . ")";
		}
		$lineage .= ";$v_gen;$v_spe";
	    }
	}

        if ($lineage) {
            printAttrRow( "Lineage",            "$lineage" );
	    if ( $percentage ) {
		printAttrRow( "Lineage Percentage", "$percentage" );
	    }
        }
    }

    ## habitat
    my $sql = qq{
           select g.habitat
           from gold_sp_habitat g, taxon t
           where t.taxon_oid = ?
           and t.sequencing_gold_id = g.gold_id
           and g.habitat is not null
           order by 1
    };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my $habitat = "";
    for (;;) {
        my ($h2) = $cur->fetchrow();
        last if ! $h2;
        if ( $habitat ) {
            $habitat .= "; " . $h2;
        }
        else {
            $habitat = $h2;
        }
    }
    $cur->finish();
    if ( $habitat ) {
        printAttrRow( "Habitat", $habitat );
    }

    if ( $virus ) {
        require Viral;
	Viral::printViralScafInfo($dbh, $taxon_oid, $scaffold_oid);
    }

    if ($scf_gene_cnt) {
        my $g_url = "$main_cgi?section=MetaScaffoldDetail&page=metaScaffoldGenes";
        $g_url .= "&taxon_oid=$taxon_oid&scaffold_oid=$scaffold_oid";
        printAttrRowRaw( "Gene Count", alink( $g_url, $scf_gene_cnt ) );
    } else {
        printAttrRowRaw( "Gene Count", $scf_gene_cnt );
    }
    print "</table>\n";

    if ( $data_type ne 'unassembled' ) {
        my $name = "_section_ScaffoldCart_addToScaffoldCart";
        print submit(
            -name  => $name,
            -value => "Add to Scaffold Cart",
            -class => "meddefbutton",
        );
    }
    print "</p>\n";

    printMetaScaffoldCrisprDetail( $taxon_oid, $data_type, $scaffold_oid );

    if ( $scf_seq_len > 0 ) {
        print "<h2>User Selectable Coordinate Ranges</h2>\n";

        my $range = "1\.\.$scf_seq_len";
        my $url3  = "$main_cgi?section=MetaScaffoldGraph&page=metaScaffoldGraph";
        $url3 .= "&taxon_oid=$taxon_oid&data_type=$data_type&scaffold_oid=$scaffold_oid";
        $url3 .= "&start_coord=1&end_coord=$scf_seq_len";
        print alink( $url3, $range ) . "<br/>\n";
    }

    if ($scf_gene_cnt) {
        print hiddenVar( "scaffold_oid", "$taxon_oid $data_type $scaffold_oid" );
        PhyloUtil::printPhylogeneticDistributionSection( 0, 1 );
    } else {
        print hiddenVar( "scaffold_oid", $scaffold_oid );
    }

    print end_form();
}

############################################################################
# printMetaScaffoldCrisprDetail
############################################################################
sub printMetaScaffoldCrisprDetail {
    my ( $taxon_oid, $data_type, $scaffold_oid, $scf_start_coord, $scf_end_coord ) = @_;

    if ( !$scaffold_oid ) {
        return "";
    }
    
    my @recs = MetaUtil::getMetaScaffoldCrisprDetail( $taxon_oid, $data_type, $scaffold_oid, $scf_start_coord, $scf_end_coord );
    if ( scalar(@recs) <= 0 ) {
        return "";
    }
   
    ScaffoldDataUtil::printScaffoldCrisprDetailTable(@recs);   
}


############################################################################
# printMetaScaffoldGenes: scaffold genes (from file)
#   Inputs:
#     scaffold_oid - scaffold object identifier
############################################################################
sub printMetaScaffoldGenes {
    my $scaffold_oid = param("scaffold_oid");
    my $taxon_oid    = param("taxon_oid");
    my $data_type    = param("data_type");
    if ( !$data_type ) {
        $data_type = 'assembled';
    }

    printMainForm();
    printStatusLine( "Loading ...", 1 );

    my $dbh = dbLogin();
    checkTaxonPerm( $dbh, $taxon_oid );

    print "<h1>Genes in Scaffold</h1>\n";
    print hiddenVar( "scaffold_oid", $scaffold_oid );
    print hiddenVar( "taxon_oid",    $taxon_oid );
    print hiddenVar( "data_type",    $data_type );

    # get taxon name from database
    my $taxon_name = WebUtil::taxonOid2Name( $dbh, $taxon_oid, 1 );
    HtmlUtil::printMetaTaxonName( $taxon_oid, $taxon_name, $data_type, 1 );

    my $scf_url = "$main_cgi?section=MetaScaffoldDetail&page=metaScaffoldDetail"
    . "&scaffold_oid=$scaffold_oid&taxon_oid=$taxon_oid&data_type=$data_type";
    print "<br/>Scaffold: " . alink( $scf_url, $scaffold_oid ) . "</p>\n";

    printStartWorkingDiv();
    print "<p>Retrieving gene information ...<br/>\n";

    my @genes_on_s = MetaUtil::getScaffoldGenes( $taxon_oid, $data_type, $scaffold_oid );

    my $it = new InnerTable( 1, "genelist$$", "genelist", 1 );
    my $sd = $it->getSdDelim();    # sort delimiter
    $it->addColSpec( "Select" );
    $it->addColSpec( "Gene ID",           "asc", "left" );
    $it->addColSpec( "Locus Type",        "asc", "left" );
    $it->addColSpec( "Locus Tag",         "asc", "left" );
    $it->addColSpec( "Gene Product Name", "asc", "left" );
    $it->addColSpec( "Start Coord",       "asc", "right" );
    $it->addColSpec( "End Coord",         "asc", "right" );
    $it->addColSpec( "Strand",            "asc", "left" );

    my $select_id_name = "gene_oid";

    my $gene_count = 0;
    my $trunc      = 0;
    for my $g (@genes_on_s) {
        my ( $gene_oid, $locus_type, $locus_tag, $gene_display_name, $start_coord, $end_coord, $strand, $seq_id, $source ) =
          split( /\t/, $g );

        my $workspace_id = "$taxon_oid assembled $gene_oid";
        my $r;
        $r .= $sd . "<input type='checkbox' name='$select_id_name' " . "value='$workspace_id' />" . "\t";
        my $url =
            "$main_cgi?section=MetaGeneDetail"
          . "&page=metaGeneDetail&taxon_oid=$taxon_oid"
          . "&data_type=assembled&gene_oid=$gene_oid";
        $r .= $workspace_id . $sd . alink( $url, $gene_oid ) . "\t";
        $r .= $locus_type . $sd . $locus_type . "\t";
        $r .= $locus_tag . $sd . $locus_tag . "\t";

        if ( !$gene_display_name ) {
            my ( $gene_prod_name, $prod_src ) = MetaUtil::getGeneProdNameSource( $gene_oid, $taxon_oid, $data_type );
            $gene_display_name = $gene_prod_name;
        }
        $r .= $gene_display_name . $sd . $gene_display_name . "\t";
        $r .= $start_coord . $sd . $start_coord . "\t";
        $r .= $end_coord . $sd . $end_coord . "\t";
        $r .= $strand . $sd . $strand . "\t";

        $it->addRow($r);
        $gene_count++;
        print ".";
        if ( ( $gene_count % 180 ) == 0 ) {
            print "<br/>\n";
        }
        if ( $gene_count >= $maxGeneListResults ) {
            $trunc = 1;
            last;
        }
    }

    printEndWorkingDiv();

    if ( $gene_count == 0 ) {
        printStatusLine( "$gene_count gene(s) loaded", 2 );
        print end_form();
        return;
    }

    if ($gene_count) {
        WebUtil::printGeneCartFooter() if $gene_count > 10;
        $it->printOuterTable(1);
        WebUtil::printGeneCartFooter();

        MetaGeneTable::printMetaGeneTableSelect();
        WorkspaceUtil::printSaveGeneToWorkspace_withAllMetaScafGenes($select_id_name);
    }

    if ($trunc) {
        my $s = "Results limited to $maxGeneListResults genes.\n";
        $s .= "( Go to " . alink( $preferences_url, "Preferences" ) . " to change \"Max. Gene List Results\". )\n";
        printStatusLine( $s, 2 );
    } else {
        printStatusLine( "$gene_count gene(s) loaded", 2 );
    }

    print end_form();
}

1;
