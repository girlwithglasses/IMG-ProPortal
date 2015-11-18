########################################################################
# Workspace BC set / cart
#
# There is no BC set as of yet because of changing BC ids.
# This is as of now a BC cart but the temp storage will be in the workspace
#
# for workspace the temp cart file is teh unsaved buffer file
#
# $Id: WorkspaceBcSet.pm 34725 2015-11-17 23:02:58Z klchu $
########################################################################
package WorkspaceBcSet;

use strict;
use CGI qw( :standard);
use Data::Dumper;
use DBI;
use Tie::File;
use File::Copy;
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
    my @filenames = param('filename');    # to workspace set
    my @bcIds     = param('bc_id');

    my $sid = WebUtil::getContactOid();
    return if ( $sid == 0 || $sid < 1 || $sid eq '901' );

    # check to see user's folder has been created
    Workspace::initialize();

    if ( $page eq 'addToBcBuffer' || paramMatch("addToBcBuffer") ne "" ) {
        addBcIds( \@bcIds, $filenames[0] );
    } elsif ( $page eq 'deleteBcIds' || paramMatch("deleteBcIds") ne "" ) {
        deleteBcIds( \@bcIds, $filenames[0] );
    } elsif ( $page eq 'delete' || paramMatch("delete") ne "" ) {
        deleteSelectedFiles();
    } elsif ( $page eq 'saveBc' || paramMatch("saveBc") ne "" ) {
        saveToWorkspace();
    } elsif ( $page eq 'findPairwiseSimilarity' || paramMatch('findPairwiseSimilarity') ne '' ) {
        findPairwiseSimilarity(); # from BiosyntheticDetail page tab 8
        return;
    }

    if ( $page eq 'viewCart' ) {
        printBuffer();
    } elsif ( $page eq 'viewSet' ) {
        printSetList();
    } else {
        printWorkspaceSets();
    }
}

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
#
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

    my $cmd = '/global/dna/projectdirs/microbial/omics-biosynthetic/pairwiseSimilarities/retrieveSimilarBC_sqlite.py';
    $cmd .= " $clusterId";

    printStartWorkingDiv();

    print "$cmd <br>\n";

    my $cfh;
    my @resultsLine;
    my $totalLine;

    my $sid        = WebUtil::getContactOid();
    my $stderrFile = "/webfs/scratch/img/tmp/bcPairwise_${sid}_$$.stderr";

    #    if (0) {
    #        # command way
    #        print "Calling Pairwise api<br/>\n";
    #        my ( $cmdFile, $stdOutFilePath ) = Command::createCmdFile($cmd);
    #        my $stdOutFile = Command::runCmdViaUrl( $cmdFile, $stdOutFilePath );
    #        if ( $stdOutFile == -1 ) {
    #
    #            # close working div but do not clear the data
    #            printEndWorkingDiv( '', 1 );
    #            printStatusLine( "Error.", 2 );
    #            WebUtil::webExit(-1);
    #        }
    #        print "Done<br/>\n";
    #        print "Reading output $stdOutFile<br/>\n";
    #        $cfh = WebUtil::newReadFileHandle($stdOutFile);
    #
    #    } elsif(0) {
    #        # test dump of:
    #        # /global/dna/projectdirs/microbial/omics-biosynthetic/pairwiseSimilarities/retrieveSimilarBC.py 160320026
    #        #
    #        $cmd = "/global/u1/k/klchu/Dev/svn/webUI/pairwiseDump.pl";
    #print "$cmd <br>\n";
    #        $cfh = new FileHandle("$cmd |");
    #        if ( !$cfh ) {
    #            webLog("Failure: runCmd $cmd\n");
    #            WebUtil::webExit(-1);
    #        }
    #    } else {
    # runs on web servers - slow
    #$cfh = new FileHandle("$cmd 2>\&1 |");
    # http://www.perlmonks.org/?node=How+can+I+capture+STDERR+from+an+external+command?
    print "$stderrFile <br>\n";
    $cfh = new FileHandle("$cmd 2>$stderrFile |");
    if ( !$cfh ) {
        webLog("Failure: runCmd $cmd\n");
        WebUtil::webExit(-1);
    }

    #    }

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
        my $s_url        = "$main_cgi?section=ScaffoldCart&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
        if ( $taxon_in_file{$taxon_oid} eq 'Yes' ) {
            $s_url =
                "$main_cgi?section=MetaDetail"
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

# print list bc workspace sets
sub printWorkspaceSets {
    print qq{
        <h1>Biosynthetic Cluster Workspace List</h1>  
    };

    my %file2Size;    # bc set file names to bc id count
    my $bufferFilename = '';
    my $bufferIdCount  = 0;

    print qq{
        <h2>Biosynthetic Cluster Cart</h2>
        <p>
    };

    if ( !isEmptyCart() ) {

        # show the buffer
        $bufferFilename = getBufferFile();

        # get the ids count
        my $aref = getAllIds();
        $bufferIdCount = $#$aref + 1;

        print qq{
            You have <a href='main.cgi?section=WorkspaceBcSet&page=viewCart'> $bufferIdCount BC Ids</a> in your cart.<br>
        };

        if ($enable_workspace) {
            print qq{
                <a href='main.cgi?section=WorkspaceBcSet&page=viewCart'>View BC cart</a> to save it to your workspace. <br> 
                Your cart data will be lost when you logout or close your browser
            };
        } else {
            return;    # public site no workspace
        }

    } else {
        print "Your BC Cart is empty.";
    }

    print qq{ </p>
        <h2>Biosynthetic Cluster Sets List</h2>
    };

    # read bc file list
    #
    my @files = getAllBcSetFilenames();

    # get all the set sizes
    foreach my $f (@files) {
        my $aref = getAllIds($f);
        my $cnt  = $#$aref + 1;
        $file2Size{$f} = $cnt;
    }

    my $txTableName = "bctable";
    my $it          = new InnerTable( 1, "$txTableName$$", $txTableName, 1 );
    my $sd          = $it->getSdDelim(); # sort delimiter

    # columns headers
    $it->addColSpec("Select");
    $it->addColSpec( "File Name",        'num asc', "right" );
    $it->addColSpec( "Number of BC Ids", "desc",    "right" );

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

    printMainForm();
    TabHTML::printTabAPILinks("bcsetTab");
    my @tabIndex = ( "#bcsettab1", "#bcsettab2",      "#bcsettab3" );
    my @tabNames = ( "BC Sets",    "Import & Export", "Pairwise" );
    TabHTML::printTabDiv( "bcsetTab", \@tabIndex, \@tabNames );

    # tab 1
    print "<div id='bcsettab1'>";
    if ($count) {
        WebUtil::printButtonFooterInLine();

        print nbsp(1);
        print submit(
            -name    => "_section_" . $section . "_delete",
            -value   => 'Remove Selected',
            -class   => 'medbutton',
            -onClick => "return confirmDelete('bc');"
        );

        $it->printOuterTable(1);

    } else {
        print "<h5>No workspace BC sets.</h5>\n";
    }

    print "</div>\n";

    # tab 2
    printImportExportTab();

    # tab 3
    printPairwiseTab();

    print end_form();

}

sub printImportExportTab {
    print "<div id='bcsettab2'>";
    print "</div>\n";
}

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

# this should show the contents of a bc cart or set bc set
#
# $filename - full absolute path to bc cart file or set
sub printBuffer {
    print qq{
      <h1>Biosynthetic Cluster Cart</h1\>  
    };

    my $filename = getBufferFile();

    my $list_aref = getAllIds();

    my $txTableName = "bctable";
    my $it          = new InnerTable( 1, "$txTableName$$", $txTableName, 1 );
    my $sd          = $it->getSdDelim(); # sort delimiter

    # columns headers
    $it->addColSpec("Select");
    $it->addColSpec( "BC Id", 'num asc', "right" );

    my $url = 'main.cgi?section=BiosyntheticDetail&page=cluster_detail&cluster_id=';

    my $count = 0;
    foreach my $bcId (@$list_aref) {
        my $row = $sd . "<input type='checkbox' name='bc_id' value='$bcId' />\t";
        my $tmp = alink( $url . $bcId, $bcId );
        $row .= $bcId . $sd . $tmp . "\t";
        $it->addRow($row);
        $count++;
    }

    #printCartTab1Start();
    TabHTML::printTabAPILinks("bcTab");
    my @tabIndex = ( "#bccarttab1", "#bccarttab2" );
    my @tabNames = ( "BC in Cart",  "Upload & Export & Save" );
    TabHTML::printTabDiv( "bcTab", \@tabIndex, \@tabNames );

    print "<div id='bccarttab1'>";

    printMainForm();
    printStatusLine( "Loading", 1 );

if($count > 0) {
    WebUtil::printButtonFooterInLineWithToggle();
    print nbsp(1);

    print submit(
        -id    => "remove",
        -name  => "_section_WorkspaceBcSet_deleteBcIds",
        -value => "Remove Selected",
        -class => "meddefbutton"
    );
}

    if($count > 0) {
    $it->printOuterTable(1);
    printSave2BcSet();
    } else {
        print "Your BC Cart is empty<br>\n";
    }

    #printCartTab1End($count);
    printStatusLine( "$count BC(s) in cart.", 2 );
    print "</div>";

    # end genomecarttab1
    #printCartTab2($count);
    print "<div id='bccarttab2'>";
    print "<h2>Upload BC Cart</h2>";

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

    print "<h2>Export BC</h2>";
    print "<p>\n";
    print "You may select BC from the cart to export.";
    print "</p>\n";

    my $name = "_section_${section}_exportBc_noHeader";
    my $str = HtmlUtil::trackEvent( "Export", $contact_oid, "img button $name" );
    print qq{
    <input class='medbutton' name='$name' type="submit" value="Export BC" $str>
    };

    print "</div>";    # end bccarttab2

    TabHTML::printTabDivEnd();

    print end_form();
    
}

sub printSetList {
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

    print qq{
        <h1>Biosynthetic Cluster Set $filename</h1>
    };

    my $rfh = newReadFileHandle($path);
    my @ids;

    while ( my $id = $rfh->getline() ) {
        chomp $id;
        next if ( $id eq "" );
        push( @ids, $id );
    }

    close $rfh;

    my $txTableName = "bctable";
    my $it          = new InnerTable( 1, "$txTableName$$", $txTableName, 1 );
    my $sd          = $it->getSdDelim(); # sort delimiter

    # columns headers
    $it->addColSpec( "Select" );
    $it->addColSpec( "Cluster ID", "asc", "right" );

    my $count = 0;
    my $url   = 'main.cgi?section=BiosyntheticDetail&page=cluster_detail&cluster_id=';
    foreach my $bcId (@ids) {
        my $row = $sd . "<input type='checkbox' name='bc_id' value='$bcId' />\t";
        my $tmp = alink( $url . $bcId, $bcId );
        $row .= $bcId . $sd . $tmp . "\t";
        $it->addRow($row);
        $count++;
    }

    $it->printOuterTable(1);
    printStatusLine( "$count rows", 2 ) if $count > 0;
}

#
# print Save to BC My workpsace section
#
sub printSave2BcSet {
    my @files  = getAllBcSetFilenames();
    my @sorted = sort @files;

    print qq{
<h2>Save BC to My Workspace</h2>
<p>
Save <b>selected BC</b> to <a href="main.cgi?section=Workspace">My Workspace</a>.<br/>(<i>Special characters in file name will be removed and spaces converted to _ </i>)<br/><br/>

<input type='radio' name='ws_save_mode' value='save' checked />
Save to File name:&nbsp; <input id='workspace' type='text' name='workspacefilename' size='25' maxLength='60' title='All special characters will be removed and spaces converted to _' /><br/>
<input type='radio' name='ws_save_mode' value='append' /> Append to the following genome set: <br/>
<input type='radio' name='ws_save_mode' value='replace' /> Replacing the following genome set: <br/>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
<select name='selectedwsfilename'>
    };

    foreach my $f (@sorted) {
        print "<option value='$f'>$f</option>\n";
    }

    print qq{
</select>
<br/>
<input type="submit" name="_section_WorkspaceBcSet_saveBc" value="Save Selected to Workspace" 
onclick="" class="medbutton" />
</p>
};

}

# save to workspace
#
#
sub saveToWorkspace {
    my $saveMode           = param('ws_save_mode');
    my $selectedwsfilename = param('selectedwsfilename');    # replace mode
    my $filename           = param('workspacefilename');
    my @bcIds              = param('bc_id');
    my $sid                = WebUtil::getContactOid();

    if ( $filename && !blankStr($filename) ) {
        WebUtil::checkFileName($filename);
        $filename = WebUtil::validFileName($filename);

        $filename =~ s/\W+/_/g;
    }

    if ( $saveMode eq 'save' ) {
        if ( -e "$workspace_dir/$sid/bc/$filename" ) {
            webError("File name $filename already exists. Please enter a new file name.");
            return;
        }

        my $path = "$workspace_dir/$sid/bc/$filename";
        my $wfh  = newWriteFileHandle($path);
        foreach my $id (@bcIds) {
            print $wfh "$id\n";
        }
        close $wfh;

    } elsif ( $saveMode eq 'append' ) {

        # TODO check for duplicates and do not add duplicate ids
        my $path = "$workspace_dir/$sid/bc/$selectedwsfilename";
        my $wfh  = newAppendFileHandle($path);
        foreach my $id (@bcIds) {
            print $wfh "$id\n";
        }
        close $wfh;

    } elsif ( $saveMode eq 'replace' ) {
        my $path = "$workspace_dir/$sid/bc/$selectedwsfilename";
        my $wfh  = newWriteFileHandle($path);
        foreach my $id (@bcIds) {
            print $wfh "$id\n";
        }
        close $wfh;
    }
}

#
# add a list of bc ids to the cart / set
#
# array ref to bc ids
# $filename - workspace filename not path - blank for bc cart
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

# delete a bc id from cart or set
#
# bc id to delete
# $filename - workspace filename not path - blank for bc cart
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

#
# delete a list of bc ids
#
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

# all ids in cart
#
# # $filename - workspace filename not path - blank for bc cart
sub getAllIds {
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

# gets cart size
sub getSize {
    my $aref = getAllIds();
    my $size = $#$aref + 1;
    return $size;
}

#
# the cart name or buffer
# return full absolute path to file
#
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

# delete the cart / buffer on exit or ui
#
# what happens if the user does not exit / logout
# - no logout for publoc ABC
#
# - session files will build up see deleteOldCarts()
#
sub deleteBufferFile {
    unlink getBufferFile();
}

#
# is the cart / buffer file empty
#
# I've tried with -z and -s but a newline / blank lines in the file are causing issues too - ken
#
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

sub deleteSelectedFiles {
    my @files = param('filename');

    foreach my $f (@files) {
        if ( $f eq getBufferFile() ) {
            deleteBufferFile();
        } else {
            unlink $BC_DIR . $f;
        }

    }
}

1;
