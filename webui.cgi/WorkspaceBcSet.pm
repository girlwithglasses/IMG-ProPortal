########################################################################
# Workspace BC set / cart
#
# There is no BC set as of yet because of changing BC ids.
# This is as of now a BC cart but the temp storage will be in the workspace
#
# for workspace the temp cart file is teh unsaved buffer file
#
# $Id: WorkspaceBcSet.pm 36225 2016-09-26 19:05:04Z jinghuahuang $
########################################################################
package WorkspaceBcSet;

use strict;
use CGI qw( :standard);
use Data::Dumper;
use DBI;
use Tie::File;
use File::Copy;
use File::Path;
use Template;
use FileHandle;
use TabHTML;
use InnerTable;
use HtmlUtil;
use WebConfig;
use WebUtil;
use Workspace;
use Command;
use OracleUtil;
use QueryUtil;
use Cwd;
use BcUtil;

$| = 1;

my $section              = "WorkspaceBcSet";
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
my $mer_data_dir         = $env->{mer_data_dir};
my $cgi_tmp_dir          = $env->{cgi_tmp_dir};
my $enable_workspace     = $env->{enable_workspace};
my $ncbi_base_url        = $env->{ncbi_entrez_base_url};
my $sid                  = WebUtil::getContactOid();
my $contact_oid          = $sid;
my $BC_DIR               = $workspace_dir . '/' . $sid . '/bc/';
my $top_base_url = $env->{top_base_url};
my $abc                      = $env->{abc};

my $GENOME_FOLDER = "genome";
my $GENE_FOLDER   = "gene";
my $SCAF_FOLDER   = "scaffold";
my $FUNC_FOLDER   = "function";
my $BC_FOLDER = "bc";


sub getPageTitle {
    return 'Workspace';
}

sub getAppHeaderData {
    my ($self) = @_;

    my @a = ();
    if ( WebUtil::paramMatch("noHeader") ne "" ) {
        return @a;
    } else {

        #push(@a, "MyIMG", '', '', '', '', 'IMGWorkspaceUserGuide.pdf');
        push( @a, "AnaCart" );
        return @a;
    }
}

# add button "add to BC Cart / workspace buffer"
# https://img-stage.jgi-psf.org/cgi-bin/img_ken_m/main.cgi?section=BiosyntheticDetail&page=biosynthetic_clusters&taxon_oid=637000129
# and here too
# https://img-stage.jgi-psf.org/cgi-bin/img_ken_m/main.cgi?section=BcNpIDSearch
# bc id search was 160320026
#
# url to BC cart or set directory listing
# https://img-stage.jgi-psf.org/cgi-bin/img_ken_m/main.cgi?section=WorkspaceBcSet
#
sub dispatch {
    my ( $self, $numTaxon ) = @_;

    my $page      = param('page');

    my $sid = WebUtil::getContactOid();
    #return if ( $sid == 0 || $sid < 1 || $sid eq '901' );

    # check to see user's folder has been created
    Workspace::initialize();

    if ( $page eq 'addToBcBuffer' || paramMatch("addToBcBuffer") ne "" ) {
        addToBcBuffer();
        return;        
    } elsif ( $page eq 'addToGenomeCart' || paramMatch("addToGenomeCart") ne "" ) {
        addToOtherCart($GENOME_FOLDER);
        return;        
    } elsif ( $page eq 'addToScaffoldCart' || paramMatch("addToScaffoldCart") ne "" ) {
        addToOtherCart($SCAF_FOLDER);
        return;        
    } elsif ( $page eq 'addToGeneCart' || paramMatch("addToGeneCart") ne "" ) {
        addToOtherCart($GENE_FOLDER);
        return;        
    } elsif ( $page eq 'addToFunctionCart' || paramMatch("addToFunctionCart") ne "" ) {
        addToOtherCart($FUNC_FOLDER);
        return;        
    } elsif ( $page eq 'removeFromBuffer' || paramMatch("removeFromBuffer") ne "" ) {
        removeFromBcBuffer();
        return;        
    } elsif ( $page eq 'delete' || paramMatch("delete") ne "" ) {
        Workspace::deleteFile();
        return;
    } elsif ( $page eq 'findPairwiseSimilarity' || paramMatch('findPairwiseSimilarity') ne '' ) {
        findPairwiseSimilarity(); # from BiosyntheticDetail page tab 8
        return;
    }

    if ( $page eq 'viewCart' ) {
        printBuffer();
    } elsif ( $page eq 'viewSet' ) {
        printBcSetDetail();
    } elsif ($page eq 'uploadBcCart' || paramMatch("uploadBcCart") ne "") {
        # import bc cart
        uploadToBcCart();
        printBuffer();
    } elsif ($page eq 'exportBc' || paramMatch("exportBc") ne "") {
        # export the bc cart
        exportInCart();
    } else {
        if ($enable_workspace) {
            printBcSetMainForm();
        } else {
            printBuffer();
        }
    }
}

############################################################################
#Searching for clusters similar to 160328918 (This should take a couple of minutes)
#.............................. 30 seconds elapsed
#.............................. 60 seconds elapsed
#.............................. 90 seconds elapsed
#.............................. 120 seconds elapsed
#.............................. 150 seconds elapsed
#.............................. 180 seconds elapsed
#.............................. 210 seconds elapsed
#.............................. 240 seconds elapsed
#.............................. 270 seconds elapsed
#.............................. 300 seconds elapsed
#.............................. 330 seconds elapsed
#.............................. 360 seconds elapsed
#.............................. 390 seconds elapsed
#.............................. 420 seconds elapsed
#.............................. 450 seconds elapsed
#..........
#Parsing results.
# 54423 hits found. Listing 100 top hits
#bc_id  DuplicationScore    Jaccard Common_PFAMs
#
# no '#' for the results
#160324345   0.597   0.483   42
#161315262   0.496   0.432   38
############################################################################
sub findPairwiseSimilarity {
    my $clusterId = param('clusterId');
    my $taxon_oid = param('taxon_oid');

    return if ( WebUtil::blankStr($clusterId) || !WebUtil::isInt($clusterId) );

    if ( $clusterId =~ /^(.*)$/ ) { $clusterId = $1; }    # untaint
    timeout( 60 * 10 );                                   # 10 minutes

    print qq{
        <h1>Biosynthetic Cluster - Pairwise Similarity</h1>
    };

    my $dbh = dbLogin();
    my $sql = qq{
        select t.taxon_display_name
        from taxon t
        where t.taxon_oid = ?
    };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my ($taxon_name) = $cur->fetchrow();

    print qq{
    <p style="width: 650px;">
    Genome: <a href="main.cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=$taxon_oid">$taxon_name</a>
    <br>
    Cluster ID: <a href="main.cgi?section=BiosyntheticDetail&page=cluster_detail&cluster_id=$clusterId">$clusterId</a>
    </p>
    };

    #my $cmd = '/global/dna/projectdirs/microbial/omics-biosynthetic/pairwiseSimilarities/retrieveSimilarBC_sqlite.py';
    #$cmd .= " $clusterId";
    my $cmd = 'python /global/dna/projectdirs/microbial/omics-biosynthetic/pairwiseSimilarities/findSimilarBCs_OnDemand.py';
    $cmd .= " $clusterId";
    $cmd .= " | sort -k 3nr | head -n 100";
    #print "$cmd <br>\n";

    my $sid        = WebUtil::getContactOid();
    my $stderrFile = "/webfs/scratch/img/tmp/bcPairwise_${sid}_$$.stderr";
    #print "$stderrFile <br>\n";
    
    # http://www.perlmonks.org/?node=How+can+I+capture+STDERR+from+an+external+command?

    printStartWorkingDiv();

    my $cfh;
    my @resultsLine;
    my $totalLine;

    $cfh = new FileHandle("$cmd 2>$stderrFile |");
    if ( !$cfh ) {
        webLog("Failure: runCmd $cmd\n");
        WebUtil::webExit(-1);
    }

    my @clusterIds;
    while ( my $s = $cfh->getline() ) {
        chomp $s;
        next if ( WebUtil::blankStr($s) );
        if ( $s =~ /^#/ ) {
            $totalLine = $s if ( $s =~ /hits found/ );
            print "$s <br/>\n";
        } else {
            push( @resultsLine, $s );
            my ( $bcId, $score, $jaccard, $comPfams ) = split( /\s+/, $s );
            push( @clusterIds, $bcId );
        }
    }
    $cfh->close();

    if ( -e $stderrFile && -s $stderrFile > 10 ) {
        print "<span style='color:red;'>Error: </span>see file $stderrFile<br>\n";
        my $rfh = WebUtil::newReadFileHandle($stderrFile);
        print "<pre style='color:red;'>\n";
        while ( my $s = $rfh->getline() ) {
            print "$s";
        }
        close $rfh;
        print "</pre>\n";
    }

    my %bcid2taxon;
    my %bcid2scaffold;
    my %bcid2geneCnt;
    my %bcid2pfamCnt;
    my %bcid2genbankAcc;
    my %bcid2bcType;
    my %bcid2evidence;
    my %bcid2prob;
    my %bcid2startCoord;
    my %bcid2endCoord;
    my %bcid2np;
    my %genbankId2np;
    my %npId2name;
    my %taxonOids;
    my %taxon_in_file;
    my %taxonOid2Name;
    my %taxonOid2Phylum;
    my %taxonOid2GoldId;
    my %golId2Habitat;

    if ( $#clusterIds > -1 ) {
        my $cluster_ids_str    = OracleUtil::getFuncIdsInClause( $dbh, @clusterIds );
        my $cluster_ids_clause = " and g.cluster_id in ($cluster_ids_str) ";

        # TODO get cluster gene count
        my $sql = qq{
        select g.cluster_id, g.taxon, g.scaffold, count(distinct bcf.feature_id), count(distinct bcf.pfam_id)
        from bio_cluster_features_new bcf, bio_cluster_new g
        where bcf.feature_type = 'gene'
        and g.cluster_id = bcf.cluster_id
        $cluster_ids_clause
        group by g.cluster_id, g.taxon, g.scaffold
        };

        my $aref = OracleUtil::execSqlCached( $dbh, $sql, 'findPairwiseSimilarity', 1 );
        foreach my $inner_aref (@$aref) {
            my ( $cluster_id, $taxon_oid, $scaffold_oid, $gene_count, $pfam_count ) = @$inner_aref;
            last if !$cluster_id;
            $taxonOids{$taxon_oid}      = $taxon_oid;
            $bcid2taxon{$cluster_id}    = $taxon_oid;
            $bcid2scaffold{$cluster_id} = $scaffold_oid;
            $bcid2geneCnt{$cluster_id}  = $gene_count;
            $bcid2pfamCnt{$cluster_id}  = $pfam_count;
        }

        print "Getting taxons ...<br/>\n";
        my @taxon_oids = keys %taxonOids;

        #print Dumper \@taxon_oids;
        #print "<br>\n";
        my $oid_str = OracleUtil::getNumberIdsInClause( $dbh, @taxon_oids );
        my $sql     = qq{
            select t.taxon_oid, t.in_file, t.taxon_display_name, 
            t.domain || '; ' || t.phylum || '; ' || t.ir_class || '; ' || t.ir_order || '; ' || t.family || '; ' || t.genus || '; ' || t.species,
            t.sequencing_gold_id
            from taxon t 
            where t.taxon_oid in ($oid_str)
        };

        my $cur = execSql( $dbh, $sql, $verbose );
        for ( ; ; ) {
            my ( $tid, $in_file, $name, $phylum, $goldId ) = $cur->fetchrow();
            last if !$tid;
            $taxon_in_file{$tid} = $in_file;
            $taxonOid2Name{$tid} = $name;
            $taxonOid2Phylum{$tid} = $phylum;
            $taxonOid2GoldId{$tid} = $goldId;
        }

        #print Dumper \%taxon_in_file;
        #print "<br>\n";

        print "Getting Habitat ...<br/>\n";
        my @goldIds = values %taxonOid2GoldId;
        if($#goldIds > -1) {
            my $str = WebUtil::joinSqlQuoted( ',', @goldIds );
            require GenomeList;
            my $sbh = GenomeList::dbLoginProject();
            my $sql = qq{
            select gold_id, p.habitat
            from project_info p
            where gold_id in($str);
            };
            WebUtil::webLog("$sql\n");
            my $cur = $sbh->prepare($sql);
            $cur->execute();
            for ( ; ; ) {
                my ( $gid, $habitat ) = $cur->fetchrow_array();
                last if !$gid;
                $golId2Habitat{$gid} = $habitat; 
            }
            $cur->finish();
            $sbh->disconnect();            
        }

        print "Getting pfam count per cluster ...<br/>\n";

        ## count experimental
        $sql = qq{
        select g.cluster_id, count(distinct gpf.pfam_family)
        from bio_cluster_new g, bio_cluster_features_new bcf,
             gene_pfam_families gpf
        where g.cluster_id = bcf.cluster_id
        and bcf.gene_oid = gpf.gene_oid
        and g.taxon = gpf.taxon
        $cluster_ids_clause
        group by g.cluster_id
        };
        my $cur = execSql( $dbh, $sql, $verbose );
        for ( ; ; ) {
            my ( $bc_id, $cnt ) = $cur->fetchrow();
            last if !$bc_id;
            $bcid2pfamCnt{$bc_id} = $cnt;
        }
        $cur->finish();

        print "Getting biosynthetic cluster attributes...<br/>\n";

        $sql = qq{
        select bcd.cluster_id, bcd.genbank_acc, bcd.probability,
               bcd.evidence, bcd.bc_type, g.start_coord, g.end_coord
        from bio_cluster_data_new bcd, bio_cluster_new g
        where bcd.cluster_id = g.cluster_id
        $cluster_ids_clause
        };
        my $cur = execSql( $dbh, $sql, $verbose );
        for ( ; ; ) {
            my ( $bc_id, $acc2, $prob2, $evid2, $bc_type2, $start2, $end2 ) = $cur->fetchrow();
            last if !$bc_id;

            $bcid2genbankAcc{$bc_id} = $acc2;
            $bcid2bcType{$bc_id}     = $bc_type2;
            $bcid2prob{$bc_id}       = sprintf( "%.2f", $prob2 );
            $bcid2evidence{$bc_id}   = $evid2;
            $bcid2startCoord{$bc_id} = $start2;
            $bcid2endCoord{$bc_id}   = $end2;
        }

        print "Getting secondary metabolites ...<br/>\n";
        $sql = qq{
        select distinct np.compound_oid, np.cluster_id, np.ncbi_acc, c.compound_name
        from np_biosynthesis_source np, img_compound c, bio_cluster_new g
        where np.cluster_id = g.cluster_id
        and np.compound_oid = c.compound_oid
        $cluster_ids_clause
        };

        my $cur = execSql( $dbh, $sql, $verbose );
        for ( ; ; ) {
            my ( $np_id, $bc_id, $genbank_id, $np_name ) = $cur->fetchrow();
            last if !$np_id;

            if ($bc_id) {
                my $nps_ref = $bcid2np{$bc_id};
                if ($nps_ref) {
                    push( @$nps_ref, $np_id );
                } else {
                    my @nps = ($np_id);
                    $bcid2np{$bc_id} = \@nps;
                }
            }
            if ($genbank_id) {
                my $nps_ref = $genbankId2np{$genbank_id};
                if ($nps_ref) {
                    push( @$nps_ref, $np_id );
                } else {
                    my @nps = ($np_id);
                    $genbankId2np{$genbank_id} = \@nps;
                }
            }
            $npId2name{$np_id} = $np_name;
        }
        $cur->finish();

        OracleUtil::truncTable( $dbh, "gtt_func_id" ) if ( $cluster_ids_clause =~ /gtt_func_id/i );
    }

    if ($img_ken) {
        printEndWorkingDiv( '', 1 );
    } else {
        printEndWorkingDiv();
    }

    my $url = 'main.cgi?section=BiosyntheticDetail&page=cluster_detail&cluster_id=';

    $totalLine =~ s/^#//;
    chomp $totalLine;

#    print "<p>$totalLine</p>";

    my $it = new InnerTable( 1, "processbc$$", "processbc", 2 );
    my $sd = $it->getSdDelim(); # sort delimiter

    # columns headers
    $it->addColSpec( "Select" );
    $it->addColSpec( "Cluster ID",       "asc",  "right" );
    $it->addColSpec( "Adjusted Jaccard", "desc", "right" );
    $it->addColSpec( "Jaccard Score",    "asc",  "right" );
    $it->addColSpec( "Common PFAMs",     "asc",  "right" );
    $it->addColSpec( "Pfam Count",       "asc",  "right" );
    $it->addColSpec( "Gene Count",       "desc", "right" );

    $it->addColSpec( "BC Length",                 "asc",  "right" );
    $it->addColSpec( "Evidence Type",             "asc",  "left" );
    $it->addColSpec( "Prediction Probability",    "desc", "right" );
    $it->addColSpec( "Biosynthetic Cluster Type", "asc",  "left" );
    $it->addColSpec( "Secondary Metabolite",      "asc",  "left" );

    $it->addColSpec( "Organism name", "asc", "left" );
    $it->addColSpec( "Phylum", "asc", "left" );
    $it->addColSpec( "Habitat", "asc", "left" );

    $it->addColSpec( "Scaffold",    "asc", "right" );
    $it->addColSpec( "Start Coord", "asc", "right" );
    $it->addColSpec( "End Coord",   "asc", "right" );
    $it->addColSpec( "Genbank ID",  "asc", "left" );

    print qq{
    <form id="processbc_frm" 
    name="mainForm" 
    enctype="multipart/form-data" 
    action="main.cgi" method="post" 
    onsubmit="removeDups ('processbc_frm', 'processbc'); " 
    onreset="handleReset ('processbc_frm', 'processbc'); ">
    };

    my $count = 0;
    my $url   = 'main.cgi?section=BiosyntheticDetail&page=cluster_detail&cluster_id=';

    foreach my $line (@resultsLine) {
        my ( $bcId, $score, $jaccard, $comPfams ) = split( /\s+/, $line );
        next if ( !$bcId );

        my $taxon_oid = $bcid2taxon{$bcId};
        
        # select
        my $row = $sd . "<input type='checkbox' name='bc_id' value='$bcId' />\t";
        
        # bc id
        my $tmp = alink( $url . $bcId, $bcId );
        $row .= $bcId . $sd . $tmp . "\t";

        # Adjusted Jaccard
        $row .= $score . $sd . $score . "\t";
        
        # Jaccard score
        $row .= $jaccard . $sd . $jaccard . "\t";
        
        # common pfams
        $row .= $comPfams . $sd . $comPfams . "\t";

        # pfam count
        my $pfam_count = $bcid2pfamCnt{$bcId};
        if ( $pfam_count > 0 ) {
            my $url3 =
                "main.cgi?section=BiosyntheticDetail&page=bioClusterPfamList&taxon_oid=$taxon_oid"
              . "&type=bio&cluster_id=$bcId";
            $row .= $pfam_count . $sd . alink( $url3, $pfam_count ) . "\t";
        } else {
            $row .= $sd . "\t";
        }

        # gene count
        my $gene_count = $bcid2geneCnt{$bcId};
        if ( $gene_count > 0 ) {
            my $url2 =
                "main.cgi?section=BiosyntheticDetail&page=cluster_viewer&taxon_oid=$taxon_oid"
              . "&type=bio&cluster_id=$bcId&genecount=$gene_count";
            $row .= $gene_count . $sd . alink( $url2, $gene_count ) . "\t";
        } else {
            $row .= $sd . "\t";
        }

        # bc length
        my $start_coord = $bcid2startCoord{$bcId};
        my $end_coord = $bcid2endCoord{$bcId};
        my $scf_length = $end_coord - $start_coord + 1;
        $row .= $scf_length . $sd . $scf_length . "\t";

        # evidence type
        my $evidence = $bcid2evidence{$bcId};
        $row .= $evidence . $sd . $evidence . "\t";

        # Prediction Probability
        my $probablity = $bcid2prob{$bcId};
        $row .= $probablity . $sd . $probablity . "\t";

        # bc type
        my $bcType = $bcid2bcType{$bcId};
        $row .= $bcType . $sd . $bcType . "\t";

        # Secondary Metabolite link
        my $genbank_id = $bcid2genbankAcc{$bcId};
        my $nps_ref = $bcid2np{$bcId};
        if ( !$nps_ref ) {
            $nps_ref = $genbankId2np{$genbank_id};
        }
        my ( $np_ids, $np_links );
        my $i = 0;
        foreach my $np (@$nps_ref) {
            if ( $i > 0 ) {
                $np_links .= '<br/>';
            }
            $np_ids .= $np;
            my $nplink = "$main_cgi?section=ImgCompound&page=imgCpdDetail&compound_oid=$np";
            $np_links .= alink( $nplink, $np );
            my $np_name = $npId2name{$np};
            $np_links .= "  $np_name";
            $i++;
        }
        if ($np_ids) {
            $row .= $np_ids . $sd . $np_links . "\t";
        } else {
            $row .= ''. $sd . '' . "\t";
        }

        # taxon name
        my $name = $taxonOid2Name{$taxon_oid};
        $row .= $name . $sd . 
	    alink("main.cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=$taxon_oid", $name) . "\t";
        
        # phylum
        my $phylum = $taxonOid2Phylum{$taxon_oid};
        $row .= $phylum . $sd . $phylum . "\t";
        
        # habitat
        my $gid = $taxonOid2GoldId{$taxon_oid};
        my $hab = $golId2Habitat{$gid} if ($gid);
        if ($hab) { 
            $row .= $hab . $sd . $hab . "\t";
        } else {
            $row .= '' . $sd . '' . "\t";
        }

        # scaffold oid
        my $scaffold_oid = $bcid2scaffold{$bcId};
        my $s_url        = "$main_cgi?section=ScaffoldDetail&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
        if ( $taxon_in_file{$taxon_oid} eq 'Yes' ) {
            $s_url =
                "$main_cgi?section=MetaScaffoldDetail"
              . "&page=metaScaffoldDetail&taxon_oid=$taxon_oid"
              . "&scaffold_oid=$scaffold_oid";
        }
        $row .= $scaffold_oid . $sd . alink( $s_url, $scaffold_oid ) . "\t";

        # start coord
        $row .= $start_coord . $sd . $start_coord . "\t";

        # end coord
        $row .= $end_coord . $sd . $end_coord . "\t";

        # genbank id
        if ($genbank_id) {
            $row .= $genbank_id . $sd . alink( "${ncbi_base_url}$genbank_id", $genbank_id ) . "\t";
        } else {
            $row .= ''. $sd . '' . "\t";
        }

	print hiddenVar("$bcId", " [$evidence: $bcType, Adjusted Jaccard: $score, Jaccard Score: $jaccard]");
        $it->addRow($row);
        $count++;
    }

    print "<script src='$top_base_url/js/checkSelection.js'></script>\n";
    require BcUtil;

    print "<p>\n";
    print "<input type='checkbox' name='bc_id' value='$clusterId' checked />\n";
    my $url = "$main_cgi?section=BiosyntheticDetail&page=cluster_detail&cluster_id=$clusterId";
    my $link = alink( $url, $clusterId );
    print "Add query cluster $link to selection";
    print hiddenVar("$clusterId", " [query cluster]");
    print hiddenVar("query_cluster", $clusterId);
    print hiddenVar("from", "pairwise_similarity");
    print "</p>\n";

    BcUtil::printTableFooter("processbc") if $count > 10;
    $it->printOuterTable(1) if $count > 0;
    BcUtil::printTableFooter("processbc") if $count > 0;

    print end_form();
    printStatusLine( "$totalLine", 2 ) if $count > 0;
}

############################################################################
# printBcSetMainForm
############################################################################
sub printBcSetMainForm {
    my ($text) = @_;

    my $folder = $BC_FOLDER;

    print qq{
        <h1>Biosynthetic Cluster Workspace List</h1>  
    };

    my %file2Size;    # bc set file names to bc id count
    my $bufferFilename = '';
    my $bufferIdCount  = 0;

    print qq{
        <h2>Biosynthetic Cluster Cart</h2>
    };

    print "<p>\n";
    if ( !isEmptyCart() ) {
        # show the buffer
        $bufferFilename = getBufferFile();

        # get the ids count
        my $aref = getAllIdsInBuffer();
        $bufferIdCount = $#$aref + 1;

        print qq{
            You have <a href='main.cgi?section=WorkspaceBcSet&page=viewCart'> $bufferIdCount BC IDs</a> in your cart.  
            Your cart data will be lost when you logout or close your browser.<br/>
        };

        if ($enable_workspace) {
            print qq{
                View <a href='main.cgi?section=WorkspaceBcSet&page=viewCart'>BC Cart</a> to save the selected into your workspace.<br> 
            };
        } else {
            return;    # public site no workspace
        }

    } else {
        print "0 BC(s) in cart.\n";
    }
    print "</p>\n";

    print qq{ 
        <h2>Biosynthetic Cluster Sets List</h2>
    };

    # read bc file list
    #
    my @files = getAllBcSetFilenames();

    # get all the set sizes
    foreach my $f (@files) {
        my $aref = getAllIdsInBuffer($f);
        my $cnt  = $#$aref + 1;
        $file2Size{$f} = $cnt;
    }

    my $txTableName = "bctable";
    my $it          = new InnerTable( 1, "$txTableName$$", $txTableName, 1 );
    my $sd          = $it->getSdDelim(); # sort delimiter

    # columns headers
    $it->addColSpec("Select");
    $it->addColSpec( "File Name",        'num asc', "right" );
    $it->addColSpec( "Number of BC IDs", "desc",    "right" );

    my $count = 0;
    foreach my $file ( keys %file2Size ) {
        my $row = $sd . "<input type='checkbox' name='filename' value='$file' />\t";
        $row .= $file . $sd . $file . "\t";

        my $size = $file2Size{$file};
        my $url  = "main.cgi?section=$section&page=viewSet&filename=$file";
        $url = alink( $url, $size );
        $row .= $size . $sd . $url . "\t";

        $it->addRow($row);
        $count++;
    }

    print qq{
        <script type="text/javascript" src="$top_base_url/js/Workspace.js" >
        </script>
    };
    
    print $text;

    printMainForm();
    TabHTML::printTabAPILinks("bcsetTab");
    my @tabIndex = ( "#bcsettab1", "#bcsettab2"); #,      "#bcsettab3" );
    my @tabNames = ( "BC Sets",    "Import & Export");#, "Pairwise" );
    TabHTML::printTabDiv( "bcsetTab", \@tabIndex, \@tabNames );

    # tab 1
    print "<div id='bcsettab1'>";
    if ($count) {
        WorkspaceUtil::printSetMainTableButtons( $section, $BC_FOLDER, 'BC' ) if ( $count > 10 );
        $it->printOuterTable(1);
        WorkspaceUtil::printSetMainTableButtons( $section, $BC_FOLDER, 'BC' );        
        print hiddenVar( "directory", "$folder" );

    } else {
        print "<h5>No workspace BC sets.</h5>\n";
    }

    print "</div>\n";

    # tab 2
    print "<div id='bcsettab2'>";
    # Import/Export
    Workspace::printImportExport($folder);
    print "</div>\n";

    # tab 3
    #printPairwiseTab();

    print end_form();

}

############################################################################
# printPairwiseTab
############################################################################
sub printPairwiseTab {
    print "<div id='bcsettab3'>";

    print qq{
    <h2>Submit as Computation Job Using Message System</h2>
    <p>
    You may submit a BC set(s) for BC Pairwise computation to run in the background.     
<p>    
<input type="radio" checked="" value="save" name="bcPairwise_save_mode">
Save as a new job with name: 
<input type="text" title="All special characters will be removed and spaces converted to _ " name="bcPairwise_job_result_name" maxlength="60" size="25">
<p>
<input type="submit" class="medbutton" onclick="return checkSetsIncludingShareAndFilled('bcPairwise_job_result_name', 'bc');" value="Submit Computation" name="_section_WorkspaceBcSet_submitPairwise">
    };

    print "</div>\n";
}

############################################################################
# getAllBcSetFilenames
############################################################################
sub getAllBcSetFilenames {
    opendir( DIR, "$BC_DIR" ) or webDie("failed to open folder list");
    my @files = readdir(DIR);
    closedir(DIR);

    # filter out . and ..
    my @a;
    foreach my $f (@files) {
        next if ( $f eq '.' || $f eq '..' );
        push( @a, $f );
    }
    return @a;
}

############################################################################
# this should show the contents of a bc cart or set bc set
#
# $filename - full absolute path to bc cart file or set
############################################################################
sub printBuffer {

    print qq{
      <h1>Biosynthetic Cluster Cart</h1\>  
    };

    my $filename = getBufferFile();

    my $list_aref = getAllIdsInBuffer();

    printValidationJS();

    TabHTML::printTabAPILinks("bcTab");
    my @tabIndex = ( "#bccarttab1", "#bccarttab2", "#bccarttab3", "#bccarttab4",  "#bccarttab5");
    my @tabNames = ( "BC in Cart",  "Upload & Export & Save", "Function HeatMap", "Similarity Network", "Neighborhoods");
    TabHTML::printTabDiv( "bcTab", \@tabIndex, \@tabNames );

    print "<div id='bccarttab1'>";

    printMainForm();
    printStatusLine( "Loading", 1 );

    my $count = $#$list_aref + 1;
    if ($count > 0) {
        printBufferButtons() if ($count > 10);
        
        my $dbh = dbLogin();
        require BiosyntheticDetail;
        BiosyntheticDetail::processBiosyntheticClusters($dbh, '', $list_aref, '', '', '', 1);

        printBufferButtons();
    } else {
        print "<p>\n";
        print "0 BC(s) in cart.<br/>\n";
        print qq{
            In order to view BC(s) you need to
            select / upload BC(s) into BC cart.
        };
        print "</p>\n";
    }

    #printCartTab1End($count);
    printStatusLine( "$count BC(s) in cart.", 2 );
    print "</div>";

    # end bccarttab1
    #printCartTab2($count);
    print "<div id='bccarttab2'>";
    print "<h2>Upload BC Cart</h2>";
    print "<p style='width: 650px;'>";
    print "You may upload a genome cart from a tab-delimited file.<br/> ";
    print "The file should have a column header 'bc_id'.<br/>\n";
    print qq{
        (This file may initially be obtained by using the
        <font color="blue"><u>Export BC</u></font> section below.)<br/>\n
    };
    print "<br/>\n";

    my $textFieldId = "cartUploadFile";
    print "File to upload:<br/>\n";
    print "<input id='$textFieldId' type='file' name='uploadFile' size='45'/>";
    print "<br/>\n";

    my $name = "_section_${section}_uploadBcCart";
    print submit(
        -name    => $name,
        -value   => "Upload from File",
        -class   => "medbutton",
        -onClick => "return uploadFileName('$textFieldId');",
    );

    if ( $enable_workspace ) {
        print nbsp(1);
        my $url = "$main_cgi?section=WorkspaceBcSet";
        print WebUtil::buttonUrl( $url, "Upload from Workspace", "medbutton" );
    }
    print "</p>\n";

    print "<h2>Export BC</h2>";
    print "<p>\n";
    print "You may select BCs from the cart to export.";
    print "</p>\n";

    my $name = "_section_${section}_exportBc_noHeader";
    my $str = HtmlUtil::trackEvent( "Export", $contact_oid, "img button $name", "return validateSelection(1);" );
    print qq{
        <input class='medbutton' name='$name' type="submit" value="Export BC" $str>
    };

    if ( $enable_workspace ) {
        WorkspaceUtil::printSaveBcToWorkspace('bc_id');
    }
    
    print "</div>";    # end bccarttab2

    print "<div id='bccarttab3'>";
    print "<h2>Download Function Matrix</h2>";
    print "<p style='width: 650px;'>";
    print "You may select BC(s) from the cart for Function Matrix.  The downloaded file is comma separated, which can be imported into Gene-e for visualization.<br/> ";
    print "<br/>\n";

    my $name = "_section_${section}_downloadFunctionMatrix_noHeader";
    print button(
        -name    => $name,
        -value   => "Download Matrix",
        -class   => "medbutton heatmapbutton",
        -onClick => "if ( validateSelection(1) ) window.clickHeatmapDownload();",
    );
    print nbsp(1);
    print button(
        -name    => "plotHeatmapButton",
        -value   => "Plot",
        -class   => "medbutton heatmapbutton",
        -onClick => "if ( validateSelection(1) ) window.clickHeatmapPlot();",
    );
    print "</p>\n";

    my $HEATMAP_HTML = <<END_HTML;
<img id="heatmap_loading_image" src="%s/images/loading-large.gif" style="display: none;" />
<script src="/js/d3.min.js"></script>
<script src="/js/jquery-2.0.3.min.js"></script>
<script src="/js/kinetic-v5.1.0.min.js"></script>
<script src="/js/inchlib-1.2.0.min.js"></script>
<script src="/js/sigma/sigma.min.js" charset="utf-8"></script>
<script src="/js/sigma/plugins/sigma.layouts.forceLink.min.js" charset="utf-8"></script>
<script src="/js/sigma/plugins/sigma.exporters.image.min.js" charset="utf-8"></script>
<script src="/js/ABCCommon.js"></script>
<script src="/js/ABCHeatmapUI.js"></script>
<table>
  <tr><td style="vertical-align: top;"><div id="inchlib"></div></td>
    
  <td style="vertical-align: top;"><div id="heatmap_detail" style="border-style:solid; border-width: 1px;"></div></td>
</table>
END_HTML

    printf $HEATMAP_HTML, $base_url;

    print "</div>";    # end bccarttab3


    print "<div id='bccarttab4'>";
    print "<h2>Similarity Network</h2>";
    print "<p style='width: 650px;'>";
    print "You may select BC(s) from the cart for Similarity Network.  The downloaded file is comma separated.<br/> ";
    print "<br/>\n";

    print button(
        -name    => "SimilarityDownloadButton",
        -value   => "Download Data",
        -class   => "medbutton simnetbutton",
        -onClick => "if ( validateSelection(1) ) window.clickSimilarityDownload();",
    );
    print nbsp(1);

    print button(
        -name    => "SimilarityPlotButton",
        -value   => "Plot",
        -class   => "medbutton simnetbutton",
        -onClick => "if ( validateSelection(1) ) window.clickSimilarityPlot();",
    );
    print "</p>\n";

    my $SIMILARITY_HTML = <<END_HTML;
<img id="similarity_loading_image" src="%s/images/loading-large.gif" style="display: none;" />
<div id="SimilarityPlotDiv" style="display:none">

<table><tr>
  <td style="vertical-align: top;" rowspan="2">
    <div style="z-index: 1; position: absolute; top: 180px; left: 20px;">
      <input type="button" value ="Download" onclick="window.clickDownloadPlot(); return false;"></input>
      <input type="button" value ="Reset" onclick="window.clickResetView(); return false;"></input>
      <input type="button" value ="+" onclick="window.clickZoomIn(); return false;"></input>
      <input type="button" value ="-" onclick="window.clickZoomOut(); return false;"></input>
      <div class="sigma-poweredby" style="background: rgba(255, 255, 255, 0.701961);"><a href="https://linkurio.us" target="_blank" style="font-family:'Helvetica Neue',Arial,Helvetica,sans-serif; font-size:11px"> Linkurious</a></div>
    </div>
    <div id="viewport">
    </div>
  </td>
  <td style="vertical-align: top;">
    <div id="bcdetails" style="border-style:solid; border-width: 1px;"></div>
    <p>
      <label for="color_by_selection">Color Nodes By:</label>
      <select id="color_by_selection" onchange="window.updateSimilarityPlotColors()"></select>
      <table id="legend"></table>
    </p>
  </td>
  </tr>
</table>
</div>
<script src="/js/ABCSimilarityNetworkUI.js"></script>
END_HTML

    printf $SIMILARITY_HTML, $base_url;

    print "</div>";    # end bccarttab4


    print "<div id='bccarttab5'>";
    print "<h2>Neighborhoods</h2>\n";
    
    print submit(
        -name  => "_section_BiosyntheticDetail_selectedNeighborhoods",
        -value => "View Selected BCs Neighborhoods",
        -class => 'meddefbutton',
        -onClick => "return validateSelection(1);",
    );
    print nbsp(1);    
    
    print "</div>";    # end bccarttab5

    TabHTML::printTabDivEnd();

    print end_form();
    
    my $size = getSize();
    
    print qq{
        <script>
        document.getElementById("bc_cart").innerHTML = "$size";
        </script>    
    }    
    
}

############################################################################
# printValidationJS
############################################################################
sub printValidationJS {
    print qq{
        <script language='JavaScript' type='text/javascript'>
        function validateSelection(num) {
            var startElement = document.getElementById("bccarttab1");
            var els = startElement.getElementsByTagName('input');

            var count = 0;
            for (var i = 0; i < els.length; i++) {
                var e = els[i];

                if (e.type == "checkbox" &&
                    e.name == "bc_id" &&
                    e.checked == true) {
                    count++;
                }
            }

            if (count < num) {
                if (num == 1) {
                    alert("Please select some BCs");
                } else {
                    alert("Please select at least "+num+" BCs");
                }
                return false;
            }

            return true;
        }
        </script>
    };
}


############################################################################
# printBufferButtons
############################################################################
sub printBufferButtons {

    print submit(
        -name  => '_section_WorkspaceBcSet_addToGenomeCart',
        -value => 'Add Selected to Genome Cart',
        -class => 'meddefbutton',
        -onClick => "return validateSelection(1);",
    );
    print nbsp(1);
    print submit(
        -name  => '_section_WorkspaceBcSet_addToScaffoldCart',
        -value => 'Add Selected to Scaffold Cart',
        -class => 'meddefbutton',
        -onClick => "return validateSelection(1);",
    );
    print nbsp(1);
    print submit(
        -name  => '_section_WorkspaceBcSet_addToGeneCart',
        -value => 'Add Selected to Gene Cart',
        -class => 'meddefbutton',
        -onClick => "return validateSelection(1);",
    );
    print nbsp(1);
    print submit(
        -name  => '_section_WorkspaceBcSet_addToFunctionCart',
        -value => 'Add Selected Pfam to Function Cart',
        -class => 'meddefbutton',
        -onClick => "return validateSelection(1);",
    );
    print "<br/>";

#    print submit(
#        -name  => "_section_BiosyntheticDetail_selectedNeighborhoods",
#        -value => "View Selected Neighborhoods",
#        -class => 'meddefbutton',
#        -onClick => "return validateSelection(1);",
#    );
#    print nbsp(1);

    WebUtil::printButtonFooterInLineWithToggle();
    print nbsp(1);

    print submit(
        -id    => "remove",
        -name  => "_section_WorkspaceBcSet_removeFromBuffer",
        -value => "Remove Selected",
        -class => "meddefbutton",
        -onClick => "return validateSelection(1);",
    );
    
}


############################################################################
# printBcSetDetail
############################################################################
sub printBcSetDetail {
    
    my $filename = param('filename');
    if ( $filename && !blankStr($filename) ) {
        WebUtil::checkFileName($filename);
        $filename = WebUtil::validFileName($filename);

        $filename =~ s/\W+/_/g;
    }

    my $path = $BC_DIR . $filename;
    if ( !-e $path ) {
        webDie("$filename does not exists.");
        return;
    }

    printMainForm();

    print "<h1>My Workspace - Biosynthetic Cluster Sets - Individual BC Set</h1>";
    print "<h2>Set Name: <i>" . escapeHTML($filename) . "</i></h2>\n";

    my @ids;
    my $cnt;
    my $rfh = newReadFileHandle($path);
    while ( my $id = $rfh->getline() ) {
        chomp $id;
        next if ( $id eq "" );
        push( @ids, $id );
        $cnt++;
    }
    close $rfh;

    print "<div id='bcsettab1'>";
    BcUtil::printSetDetailFooter() if ($cnt > 10);
    my $dbh = dbLogin();
    require BiosyntheticDetail;
    my $count = BiosyntheticDetail::processBiosyntheticClusters($dbh, '', \@ids, '', '', '', 1); 
    BcUtil::printSetDetailFooter();
    print "</div>\n";

    print "<div id='bcsettab2'>";
    WorkspaceUtil::printSaveBcToWorkspace('bc_id');
    print "</div>\n";
    
    print end_form();
    printStatusLine( "$count rows", 2 ) if $count > 0;
}

############################################################################
# addToBcBuffer
############################################################################
sub addToBcBuffer {

    my @filenames = param('filename');    # to workspace set
    my @bcIds     = param('bc_id');
    addBcIds( \@bcIds, $filenames[0] );
    printBuffer();

}

############################################################################
# add a list of bc ids to the cart / set
#
# array ref to bc ids
# $filename - workspace filename not path - blank for bc cart
############################################################################
sub addBcIds {
    my ( $bcId_aref, $filename ) = @_;

    if ( $filename eq '' ) {
        $filename = getBufferFile();
    } else {
        $filename = $BC_DIR . $filename;
    }

    # TODO remove duplicates - ken
    my %distinct;
    my $rfh = newReadFileHandle($filename);
    while ( my $id = $rfh->getline() ) {
        chomp $id;
        next if ( $id eq "" );
        $distinct{$id} = $id;
    }
    close $rfh;
    my $afh = WebUtil::newAppendFileHandle($filename);

    foreach my $bcId (@$bcId_aref) {
        if ( exists $distinct{$bcId} ) {
            #print "skipping id: $bcId <br>\n";
        } else {
            #print "adding: $bcId <br>";
            print $afh "$bcId\n";
        }
    }
    close $afh;
}

############################################################################
# remove a list of bc ids from Buffer
############################################################################
sub removeFromBcBuffer {

    my @filenames = param('filename');    # to workspace set
    my @bcIds     = param('bc_id');

    deleteBcIds( \@bcIds, $filenames[0] );
    printBuffer();

}

############################################################################
# delete a list of bc ids
############################################################################
sub deleteBcIds {
    my ( $bcId_aref, $filename ) = @_;

    if ( $filename eq '' ) {
        $filename = getBufferFile();
    } else {
        $filename = $BC_DIR . $filename;
    }

    my %deleteIds = array2Hash(@$bcId_aref);

    # open file file to read
    # open a temp file to write
    # move temp file to read file

    my $tempfile = getBufferFile() . '_' . $$;
    my $rfh      = newReadFileHandle($filename);
    my $wfh      = newWriteFileHandle($tempfile);
    while ( my $line = $rfh->getline() ) {
        chomp $line;
        if ( !exists $deleteIds{$line} ) {
            print $wfh "$line\n";
        }
    }

    close $wfh;
    close $rfh;

    # do i have to unlink $filename first?
    move( $tempfile, $filename );
}

############################################################################
# delete a bc id from cart or set
#
# bc id to delete
# $filename - workspace filename not path - blank for bc cart
# not used
############################################################################
sub deleteBcId {
    my ( $bcId, $filename ) = @_;

    if ( $filename eq '' ) {
        $filename = getBufferFile();
    } else {
        $filename = $BC_DIR . $filename;
    }

    my @array;
    my $j = -1;
    tie @array, 'Tie::File', $filename or die "delete from failed $!\n";
    for ( my $i = 0 ; $i <= $#array ; $i++ ) {
        if ( $bcId eq $array[$i] ) {
            $j = $i;
            last;
        }
    }

    if ( $j > -1 ) {
        splice @array, $j, 1;
    }

    untie @array;    # done and should close the open file
}


############################################################################
# downloadFile
############################################################################
sub downloadFile {
    my ($filename, $name, $isTxt) = @_;

    if ( !-e $filename ) {
        webErrorHeader("File $filename not found.");
    }

    my $sz = fileSize($filename);
    if ($isTxt) {
        WebUtil::printTxtHeader($name, $sz);        
    }
    else {
        WebUtil::printExcelHeader($name, $sz);        
    }

    my $rfh = newReadFileHandle( $filename, "download" );
    while ( my $s = $rfh->getline() ) {
        chomp $s;
        print "$s\n";
    }
    close $rfh;
}

############################################################################
# all ids in cart
#
# # $filename - workspace filename not path - blank for bc cart
############################################################################
sub getAllIdsInBuffer {
    my ($filename) = @_;

    if ( $filename eq '' ) {
        $filename = getBufferFile();
    } else {
        $filename = $BC_DIR . $filename;
    }

    my @records = ();
    my $res = newReadFileHandle( $filename, "runJob", 1 );
    if ( !$res ) {
        return \@records;
    }
    while ( my $line = $res->getline() ) {
        chomp $line;
        next if ( $line eq "" );
        next if (WebUtil::blankStr($line));
        #my ( $s_oid, $contact_oid, $batch_id, $name ) = split( /\t/, $line );
        
        push( @records, $line );
    }
    close $res;
    return \@records;

}

############################################################################
# gets cart size
############################################################################
sub getSize {
    my $aref = getAllIdsInBuffer();
    my $size = $#$aref + 1;
    return $size;
}

############################################################################
# the cart name or buffer
# return full absolute path to file
############################################################################
sub getBufferFile {

    # temp file - cart file or the unsaved workspace set
    my $BUFFER_DIR         = WebUtil::getSessionDir() . '/';
    my $BC_PREFIX_CARTNAME = 'tempBcCart_';

    # fyi this file will be cleanup by a nightly cronjob
    my $tempFilename = $BUFFER_DIR . $BC_PREFIX_CARTNAME . $contact_oid;

    if ( !-e $tempFilename ) {

        # make a empty file
        open( MYFILE, ">>$tempFilename" );    # won't erase the contents if already exists
        close MYFILE;
    }

    return $tempFilename;
}

############################################################################
# delete the cart / buffer on exit or ui
#
# what happens if the user does not exit / logout
# - no logout for publoc ABC
#
# - session files will build up see deleteOldCarts()
############################################################################
sub deleteBufferFile {
    unlink getBufferFile();
}


############################################################################
# is the cart / buffer file empty
#
# I've tried with -z and -s but a newline / blank lines in the file are causing issues too - ken
############################################################################
sub isEmptyCart {
    my $res = newReadFileHandle( getBufferFile(), "runJob", 1 );
    if ( !$res ) {
        return 1;
    }
    while ( my $line = $res->getline() ) {
        chomp $line;
        next if ( $line eq "" );
        close $res;
        return 0;
    }
    close $res;
    return 1;
}

############################################################################
# export bc cart
############################################################################
sub exportInCart {
    my @bc_ids = param("bc_id");

    if ( $#bc_ids < 0 ) {
        main::printAppHeader();
        webError("You must select at least one BC to export.");
    }

    WebUtil::printExcelHeader("bccart_export$$.xls");
    print "bc_id\n";

    foreach my $id (@bc_ids) {
        print "$id\n";
    }

    WebUtil::webExit(0);
}

############################################################################
# upload into bc cart
############################################################################
sub uploadToBcCart {
    
    my @bc_oids;
    my %upload_cart_names;
    my @recs_ids;
    my $dbh = dbLogin();
    my $errmsg;

    #if ( !MyIMG::uploadOidsFromFile( "bc_id", \@bc_oids, \$errmsg) ) {
    if ( !MyIMG::uploadIdsFromFile( "bc_id", \@bc_oids, \$errmsg) ) {
        printStatusLine( "Error.", 2 );
        webError($errmsg);
    }    
    
    addBcIds(\@bc_oids);
}

############################################################################
# add to Genome or Scaffold or Gene or Function cart
############################################################################
sub addToOtherCart {
    my ($folder) = @_;

    #selected bc ids
    my @bcids =  param('bc_id');
    if ( scalar(@bcids) == 0 ) {
        webError("Please select some BC IDs.");
        return;
    }

    my $dbh = dbLogin();
    my @ids;

    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
    
    my ( $dbClusterIds_ref, $metaClusterIds_ref );
    if ( scalar(@bcids) > 0 ) {
        ( $dbClusterIds_ref, $metaClusterIds_ref ) = MerFsUtil::splitDbAndMetaOids( @bcids);        
    }

    if ( $dbClusterIds_ref && scalar(@$dbClusterIds_ref) > 0 ) {
        my $cluster_ids_str = OracleUtil::getNumberIdsInClause( $dbh, @$dbClusterIds_ref );
    
        my $sql;
        if ( $folder eq $GENOME_FOLDER || $folder eq $SCAF_FOLDER ) {
            my $col;
            if ( $folder eq $GENOME_FOLDER ) {
                $col = ' g.taxon ';
            }
            elsif ( $folder eq $SCAF_FOLDER ) {
                $col = ' g.scaffold ';
            }
            $sql = qq{
                select distinct $col
                from bio_cluster_new g
                where g.cluster_id in ($cluster_ids_str)
                $rclause
                $imgClause
            };
        }
        elsif ( $folder eq $GENE_FOLDER ) {
            $sql = qq{
                select distinct bcf.gene_oid
                from bio_cluster_new g, bio_cluster_features_new bcf
                where g.cluster_id in ($cluster_ids_str)
                and g.cluster_id = bcf.cluster_id
                $rclause
                $imgClause
            };
        }
        elsif ( $folder eq $FUNC_FOLDER ) {
            $sql = qq{
                select distinct gpf.PFAM_FAMILY
                from bio_cluster_new g, bio_cluster_features_new bcf, GENE_PFAM_FAMILIES gpf
                where g.cluster_id in ($cluster_ids_str)
                and g.cluster_id = bcf.cluster_id
                and g.taxon = gpf.taxon
                and bcf.gene_oid = gpf.gene_oid
                $rclause
                $imgClause
            };
        }
        my $cur = execSql( $dbh, $sql, $verbose );
    
        for ( ;; ) {
            my ( $id ) = $cur->fetchrow();
            last if !$id;
            push(@ids, $id);
        }
        $cur->finish();
        OracleUtil::truncTable( $dbh, "gtt_num_id" ) 
            if ( $cluster_ids_str =~ /gtt_num_id/i );
    }

    if ( $metaClusterIds_ref && scalar(@$metaClusterIds_ref) > 0 ) {

        if ( $folder eq $GENOME_FOLDER || $folder eq $SCAF_FOLDER ) {
            my %scaffolds;
            for my $metaId (@$metaClusterIds_ref) {
                my ( $scaffold_oid, $start_coord, $end_coord ) = split( / /, $metaId );
                $scaffolds{$scaffold_oid} = 1;
            }
            my @scaffolds = keys %scaffolds;    
            my $scaffold_ids_str = OracleUtil::getNumberIdsInClause( $dbh, @scaffolds );

            my $col;
            if ( $folder eq $GENOME_FOLDER ) {
                $col = ' g.taxon ';
            }
            elsif ( $folder eq $SCAF_FOLDER ) {
                $col = ' g.scaffold_oid ';
            }
            my $sql = qq{
                select distinct $col
                from scaffold g
                where g.scaffold_oid in ($scaffold_ids_str)
                $rclause
                $imgClause
            };
            my $cur = execSql( $dbh, $sql, $verbose );
        
            for ( ;; ) {
                my ( $id ) = $cur->fetchrow();
                last if !$id;
                push(@ids, $id);
            }
            $cur->finish();
            OracleUtil::truncTable( $dbh, "gtt_num_id" ) 
                if ( $scaffold_ids_str =~ /gtt_num_id/i );

        }
        elsif ( $folder eq $GENE_FOLDER || $folder eq $FUNC_FOLDER ) {
            #use: "and ((g.end_coord > ? and g.end_coord <= ?) or (g.start_coord >= ? and g.start_coord < ?))"
            #instead of "and g.start_coord >= ? and g.end_coord <= ?"
            #to make sure that the genes that starts below the starting range but ends within the range, 
            #or starts below the ending range but ends beyond the ending range, get in
            my $sql = qq{
                select distinct g.gene_oid
                from scaffold s, gene g
                where s.scaffold_oid = ?
                and g.scaffold = s.scaffold_oid
                and ((g.end_coord > ? and g.end_coord <= ?) or (g.start_coord >= ? and g.start_coord < ?))
                and g.start_coord > 0 
                and g.end_coord > 0
                and g.obsolete_flag = 'No'
                and s.ext_accession is not null
                $rclause
                $imgClause
            };
            
            my @genes;
            for my $metaId (@$metaClusterIds_ref) {
                my ( $scaffold_oid, $start_coord, $end_coord ) = split( / /, $metaId );
    
                my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid,
                    $start_coord, $end_coord, $start_coord, $end_coord );
                for ( ;; ) {
                    my ( $id ) = $cur->fetchrow();
                    last if !$id;
                    push(@genes, $id);
                }
                $cur->finish();
            }

            if ( $folder eq $GENE_FOLDER ) {
                push(@ids, @genes);
            }
            elsif ( $folder eq $FUNC_FOLDER ) {
                my $gene_ids_str = OracleUtil::getNumberIdsInClause( $dbh, @genes );
                my $sql = qq{
                    select distinct g.PFAM_FAMILY
                    from GENE_PFAM_FAMILIES g
                    where g.gene_oid in ($gene_ids_str)
                    $rclause
                    $imgClause
                };
                my $cur = execSql( $dbh, $sql, $verbose );
            
                for ( ;; ) {
                    my ( $id ) = $cur->fetchrow();
                    last if !$id;
                    push(@ids, $id);
                }
                $cur->finish();
                OracleUtil::truncTable( $dbh, "gtt_num_id" ) 
                    if ( $gene_ids_str =~ /gtt_num_id/i );
            }
        }

    }

    if ( scalar(@ids) > 0 ) {
        if ( $folder eq $GENOME_FOLDER ) {
            require GenomeCart;
            GenomeCart::addToGenomeCart( \@ids );
            GenomeCart::dispatch();        
        }
        elsif ( $folder eq $SCAF_FOLDER ) {
            require ScaffoldCart;
            ScaffoldCart::addToScaffoldCart( \@ids );
            ScaffoldCart::printIndex();        
        }        
        elsif ( $folder eq $GENE_FOLDER ) {
            require GeneCartStor;
            my $gc = new GeneCartStor();
            $gc->addGeneBatch( \@ids );
            $gc->printGeneCartForm( "", 1 );
        }
        elsif ( $folder eq $FUNC_FOLDER ) {
            require FuncCartStor;
            my $fc = new FuncCartStor();
            $fc->addFuncBatch( \@ids );
            $fc->printFuncCartForm( '', 1 );
        }        
    }
    
}


1;
