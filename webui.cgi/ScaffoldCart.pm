############################################################################
# ScaffoldCart.pm - Cart for Scaffolds
# $Id: ScaffoldCart.pm 36437 2016-11-17 08:16:30Z jinghuahuang $
############################################################################
package ScaffoldCart;

my $section = "ScaffoldCart";

use strict;
use CGI qw( :standard );
use Data::Dumper;
use WebUtil;
use WebConfig;
use POSIX qw(ceil floor);
use DataEntryUtil;
use ChartUtil;
use InnerTable;
use OracleUtil;
use QueryUtil;
use MerFsUtil;
use MetaUtil;
use GeneDetail;
use GenerateArtemisFile;
use GeneCartStor;
use FuncCartStor;
use WorkspaceUtil;
use CartUtil;
use HtmlUtil;
use HistogramUtil;

my $env                  = getEnv();
my $main_cgi             = $env->{main_cgi};
my $section_cgi          = "$main_cgi?section=$section";
my $inner_cgi            = $env->{inner_cgi};
my $all_fna_files_dir    = $env->{all_fna_files_dir};
my $taxon_lin_fna_dir    = $env->{taxon_lin_fna_dir};
my $cgi_tmp_dir          = $env->{cgi_tmp_dir};
my $include_metagenomes  = $env->{include_metagenomes};
my $content_list         = $env->{content_list};
my $verbose              = $env->{verbose};
my $yui_tables           = $env->{yui_tables};
my $img_er               = $env->{img_er};
my $user_restricted_site = $env->{user_restricted_site};
my $base_url             = $env->{base_url};
my $tmp_url              = $env->{tmp_url};
my $enable_biocluster    = $env->{enable_biocluster};
my $img_ken                = $env->{img_ken};
my $img_internal = $env->{img_internal};
my $virus = $env->{virus};

my $include_img_terms        = $env->{include_img_terms};
my $max_export_scaffold_list = 100000;
my $max_artemis_scaffolds    = 10000;
my $artemis_scaffolds_switch = 100;

my $merfs_timeout_mins = $env->{merfs_timeout_mins};
if ( ! $merfs_timeout_mins ) {
    $merfs_timeout_mins = 60;
}

my $max_gene_cnt_for_taxon = 200000000;

my $contact_oid;

sub getPageTitle {
    return 'Scaffold Cart';
}

sub getAppHeaderData {
    my ($self) = @_;
    my @a = ();
        if (   WebUtil::paramMatch("exportScaffoldCart") ne ""
            || WebUtil::paramMatch("exportFasta") ne "" )
        {

            # export excel
            WebUtil::setSessionParam( "lastCart", "scaffoldCart" );
        } elsif ( WebUtil::paramMatch("addSelectedToGeneCart") ne "" ) {
            # 
        } else {
            WebUtil::setSessionParam( "lastCart", "scaffoldCart" );
            @a = ("AnaCart");
        }
    return @a;
}


############################################################################
# dispatch - Dispatch loop.
############################################################################
sub dispatch {
    my ( $self, $numTaxon ) = @_;
    #timeout( 60 * $merfs_timeout_mins );
    timeout( 60 * 60 );

    my $page = param("page");
    $contact_oid = getContactOid();

    if ( $page eq "addToScaffoldCart"
        || paramMatch("addToScaffoldCart") ne "" )
    {
        my $type = addToScaffoldCart();
        $page = 'index';
    	$page = '' if $type eq "sets";
    }
    elsif ( $page eq "viralScaffolds" ) {
    	my $taxon_oid = param("taxon_oid");
    	my $viral_scaffolds_aref = getViralScaffoldsForGenome($taxon_oid);
    	addToScaffoldCart($viral_scaffolds_aref, 'virus');
    	$page = 'index';
    }
    elsif ( $page eq "scaffoldCart" ) {
        $page = 'index';
    }
    elsif ( paramMatch("removeFromScaffoldCart") ne "" ) {
        removeFromScaffoldCart();
        $page = 'index';
    }
    elsif ( paramMatch("addGeneScaffold") ne "" ) {
        addGeneScaffoldToCart();
        $page = 'index';
    }
    elsif ( $page eq 'addGenomeScaffold' ||
	    paramMatch("addGenomeScaffold") ne "" ) {
        addGenomeScaffoldToCart();
        $page = 'index';
    }
    elsif ( paramMatch("addSelectedToGeneCart") ne "" ) {
        addSelectedScaffoldGenesToCart();
        return;
    }
    elsif ( paramMatch("addBinScaffold") ne "" ) {
        addBinScaffoldToCart();
        $page = 'index';
    }
    elsif ( paramMatch("scaffoldFuncProfile") ne "" ) {
        scaffoldFuncProfile();
    }
    elsif ( paramMatch("geneWithFunc") ne "" ) {
        require ScaffoldDetail;
        ScaffoldDetail::scaffoldGenesWithFunc();
        return;
    }
    elsif ( paramMatch("exportScaffoldCart") ne "" ) {
        exportScaffoldCart();
        return;
    }
    elsif ( paramMatch("exportFasta") ne "" ) {
        exportFasta();
    }
    elsif ( paramMatch("exportGenbank") ne "" ) {
        exportGenbankForm();
        return;
    }
    elsif ( paramMatch("showHistogram") ne "" ) {
        printHistogram();
        return;
    }
    elsif ( paramMatch("showPhyloDist") ne "" ) {
        my $isSingleScafDetail = param("isSingleScafDetail");
        require WorkspaceScafSet;
        WorkspaceScafSet::printScafPhyloDist(0, $isSingleScafDetail);
        return;
    } elsif ( $page eq "ir_class"
        || $page eq "ir_order"
        || $page eq "family"
        || $page eq "genus"
        || $page eq "species" ) {
        require WorkspaceScafSet;
        WorkspaceScafSet::printScafTaxonomyPhyloDist( $page );
        return;
    } elsif ( $page eq "taxonomyMetagHits" ) {
        require WorkspaceScafSet;
        WorkspaceScafSet::printScafTaxonomyMetagHits();
        return;
    }
    elsif ( paramMatch("printUploadScaffoldCartForm") ne "" ) {
        printUploadScaffoldCartForm();
        return;
    }
    elsif ( paramMatch("uploadScaffoldCart") ne "" ) {
        uploadScaffoldCart();
        $page = 'index';
    }
    elsif ( paramMatch("updateScaffoldCartName") ne "" ) {
        updateCartName();
        $page = 'index';
    }
    elsif ( paramMatch("saveScaffoldDistToCart") ) {
        saveScaffoldDistToCart();
        $page = 'index';
    }

    if ( $page eq 'index' ) {
        printIndex();
    }
    elsif ( $page eq "scaffoldDetail" ) {
        require ScaffoldDetail;
        ScaffoldDetail::printScaffoldDetail();
        return;
    }
    elsif ( $page eq "geneWithFunc" ) {
        require ScaffoldDetail;
        ScaffoldDetail::scaffoldGenesWithFunc();
        return;
    }
    elsif ( $page eq "scaffoldGenes" ) {
        require ScaffoldDetail;
        ScaffoldDetail::scaffoldGenesWithFunc();
        return;
    }
    elsif ( $page eq 'selectedScaffolds' ) {
        require ScaffoldDetail;
        ScaffoldDetail::printSelectedScaffolds();
        return;
    }
    elsif ( $page && !blankStr($page) ) {
        print "<h1>Incorrect Page: $page</h1>\n";
    }
}

sub getViralScaffoldsForGenome {
    my ($taxon_oid) = @_;
    my $rclause   = WebUtil::urClause('t');
    my $imgClause = WebUtil::imgClause('t');
    my $sql = qq{                                                                                         
        select v.scaffold_id
        from taxon t, dt_virals_from_metag\@core_v400_musk v
        where t.taxon_oid = v.taxon_oid
        and t.obsolete_flag = 'No'
        and t.taxon_oid = ?
        $rclause
        $imgClause
    };
    
    my $dbh = dbLogin();
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my @scaffolds;
    for ( ;; ) {
	my ( $scaffold_id ) = $cur->fetchrow();
	last if !$scaffold_id;
	push( @scaffolds, "$taxon_oid assembled $scaffold_id" );
    }
    $cur->finish();
    return \@scaffolds;
}

############################################################################
# printIndex - Show index entry to this section.
############################################################################
sub printIndex {
    print "<h1>Scaffold Cart</h1>\n";
    CartUtil::printMaxNumMsg('scaffolds');

    # force "Toggle Selected" button to appear on same line as others
    print <<CSS;
    <style type="text/css">
	div#content_other { width:100%; }
    </style>
CSS

    printMainForm();

    my $records_aref = readCartFile();
    my $cnt = $#$records_aref + 1;
    if ( $cnt == 0 ) {
        printNoScaffoldCartForm();
        return;
    }

    printStatusLine( "Loading", 1 );

# TODO test dot thread
printStartWorkingDiv();
require Command;
Command::startDotThread(240); # 20 minutes

    my @recs_ids;
    my %batch_ids;
    my %names;
    my %virtuals;

    foreach my $line (@$records_aref) {
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid )
	    = split( /\t/, $line );
        $s_oid = WebUtil::strTrim($s_oid);
        push( @recs_ids, $s_oid );
        $batch_ids{$s_oid} = $batch_id;
        $names{$s_oid}     = $name;
        $virtuals{$s_oid}  = $virtual_taxon_oid;
    }
    #print "printIndex() recs_ids: @recs_ids<br/>\n";

    my ( $dbOids_ref, $metaOids_ref ) =
      MerFsUtil::splitDbAndMetaOids(@recs_ids);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;
    #print "printIndex() metaOids: @metaOids<br/>\n";

    # InnerTable ID; used to determine YUI table name
    my $itID = "scaffoldCart";

    my $it = new InnerTable( 0, "$itID$$", $itID, 1 );
    my $sd = $it->getSdDelim();
    $it->addColSpec( "Select" );
    $it->addColSpec( "Scaffold ID", "asc", "left" );
    $it->addColSpec( "Scaffold Name", "asc", "left" );
    $it->addColSpec( "Genome ID", "asc", "right" );
    $it->addColSpec( "Genome", "asc", "left" );
    $it->addColSpec( "Gene Count", "asc", "right" );
    $it->addColSpec( "Sequence Length<br/>(bp)", "asc", "right" );
    $it->addColSpec( "GC Content", "asc", "right" );

    if ($virus) {
	## add additional viral fields
	$it->addColSpec( "Perc VPFs", "asc", "right" );
	$it->addColSpec( "Viral Cluster", "asc", "left" );
    }

    if ( $include_metagenomes || $virus ) {
        $it->addColSpec( "Read Depth", "asc", "right" );
        $it->addColSpec( "Lineage Domain", "asc", "left" );
        $it->addColSpec( "Lineage Phylum", "asc", "left" );
        $it->addColSpec( "Lineage Class", "asc", "left" );
        $it->addColSpec( "Lineage Order", "asc", "left" );
        $it->addColSpec( "Lineage Family", "asc", "left" );
        $it->addColSpec( "Lineage Genus", "asc", "left" );
        $it->addColSpec( "Lineage Species", "asc", "left" );
        $it->addColSpec( "Lineage Percentage", "asc", "right" );
    }

    ## add ecosystem
    $it->addColSpec( "Ecosystem", "asc", "left" );
    $it->addColSpec( "Ecosystem Category", "asc", "left" );
    $it->addColSpec( "Ecosystem Type", "asc", "left" );
    $it->addColSpec( "Ecosystem Subtype", "asc", "left" );
    $it->addColSpec( "Specific Ecosystem", "asc", "left" );

    my $select_id_name = "scaffold_oid";

    my $dbh = dbLogin();
    $cnt = 0;

    my %eco_h =
	QueryUtil::fetchTaxonOid2EcosystemHash( $dbh, '' );

    my %viral_scaf_h;
    my $v_sql = qq{
           select host_domain, host_phylum, host_class,
                  host_order, host_family, host_genus, host_species
           from dt_viral_host_assignment
           where taxon_oid = ?
           and scaffold_id = ?
           order by 1, 2, 3, 4, 5, 6, 7
           };

    if ( scalar(@dbOids) > 0 ) {
        my $db_str = OracleUtil::getNumberIdsInClause( $dbh, @dbOids );
        my $sql = QueryUtil::getScaffoldDataSql($db_str);
        my $cur = execSql( $dbh, $sql, $verbose );

        for ( ; ; ) {
            my (
                $scaffold_oid,       $scaffold_name, $ext_acc,    $taxon_oid,
                $seq_length,         $gc_percent,    $read_depth, $gene_count,
                $taxon_display_name, $genome_type

            ) = $cur->fetchrow();
            last if !$scaffold_oid;

            my $batch_id = $batch_ids{$scaffold_oid};

            my $r;
            $r .= "$sd<input type='checkbox' name='$select_id_name' value='$scaffold_oid' />\t";

            my $url2 = "$main_cgi?section=ScaffoldDetail"
		     . "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
            $r .= $scaffold_oid . $sd . alink( $url2, $scaffold_oid ) . "\t";
            $r .= $scaffold_name . $sd . "$scaffold_name\t";

            $r .= $taxon_oid . $sd . $taxon_oid . "\t";

            $taxon_display_name .= " (*)"
              if ( $genome_type eq "metagenome" );

            my $url = "$main_cgi?section=TaxonDetail"
		    . "&page=taxonDetail&taxon_oid=$taxon_oid";
            $r .= $taxon_display_name . $sd
                . alink( $url, $taxon_display_name ) . "\t";

            my $url3 =
                "$main_cgi?section=ScaffoldDetail"
              . "&page=scaffoldGenes"
              . "&scaffold_oid=$scaffold_oid";
            if ( $gene_count eq "" ) {
                $r .= "0" . $sd . "0" . "\t";
            }
            else {
                $r .= $gene_count . $sd . alink( $url3, $gene_count ) . "\t";
            }

            my $scaf_len_url =
            "$main_cgi?section=ScaffoldGraph" .
            "&page=scaffoldGraph&scaffold_oid=$scaffold_oid" .
            "&taxon_oid=$taxon_oid" .
            "&start_coord=1&end_coord=$seq_length" .
            "&seq_length=$seq_length";
            $r .= $seq_length . $sd . alink( $scaf_len_url, $seq_length ) . "\t";

            if ( $gc_percent ) {
                $gc_percent = sprintf( " %.2f", $gc_percent );
            }
            $r .= $gc_percent . $sd . "$gc_percent\t";

	    if ($virus) {
                $r .= $sd . "\t"; #perc vpfs
                $r .= $sd . "\t"; #viral cluster
	    }

	    if ( $include_metagenomes || $virus ) {
                $r .= $read_depth . $sd . "$read_depth\t";
                $r .= $sd . "\t"; #lineage
                $r .= $sd . "\t"; #lineage
                $r .= $sd . "\t"; #lineage
                $r .= $sd . "\t"; #lineage
                $r .= $sd . "\t"; #lineage
                $r .= $sd . "\t"; #lineage
                $r .= $sd . "\t"; #lineage
                $r .= $sd . "\t"; #lineage percentage
            }

            $it->addRow($r);
            $cnt++;
        }
        $cur->finish();

        OracleUtil::truncTable( $dbh, "gtt_num_id" )
          if ( $db_str =~ /gtt_num_id/i );
    }

    if ( scalar(@metaOids) > 0 ) {
        my %scaf_id_h;
        my %taxon_oid_h;
        for my $s_oid (@metaOids) {
            $scaf_id_h{$s_oid} = 1;
            my @vals = split( / /, $s_oid );
            if ( scalar(@vals) >= 3 ) {
                $taxon_oid_h{ $vals[0] } = 1;
            }
        }
        my @taxonOids = keys(%taxon_oid_h);

        my %taxon_name_h;
        my %genome_type_h;
        if ( scalar(@taxonOids) > 0 ) {
            my ( $taxon_name_h_ref, $genome_type_h_ref ) =
              QueryUtil::fetchTaxonOid2NameGenomeTypeHash( $dbh,
                \@taxonOids );
            %taxon_name_h  = %$taxon_name_h_ref;
            %genome_type_h = %$genome_type_h_ref;
        }

        my %scaffold_h;
        MetaUtil::getAllScaffoldInfo( \%scaf_id_h, \%scaffold_h, 1 );

        for my $s_oid (@metaOids) {
            my ( $taxon_oid, $data_type, $scaffold_oid ) =
              split( / /, $s_oid );    #$s_oid is $workspace_id
            if ( !exists( $taxon_name_h{$taxon_oid} ) ) {
                #$taxon_oid not in hash, probably due to permission
                webLog("ScaffoldCart::printIndex() $taxon_oid not retrieved from database, probably due to permission.");
                next;
            }

            my $batch_id = $batch_ids{$s_oid};

            my $r;
            $r .= "$sd<input type='checkbox' name='$select_id_name' value='$s_oid' />\t";

            my $url2 =
                "$main_cgi?section=MetaScaffoldDetail"
              . "&page=metaScaffoldDetail&scaffold_oid=$scaffold_oid"
              . "&taxon_oid=$taxon_oid&data_type=$data_type";
            $r .= $s_oid . $sd . alink( $url2, $scaffold_oid ) . "\t";

            $r .= '' . $sd . "\t";    #scaffold_name

            $r .= $taxon_oid . $sd . $taxon_oid . "\t";

            # taxon
            my $taxon_display_name = $taxon_name_h{$taxon_oid};
            my $genome_type        = $genome_type_h{$taxon_oid};

            $taxon_display_name .= " (*)"
              if ( $genome_type eq "metagenome" );
            $taxon_display_name = HtmlUtil::appendMetaTaxonNameWithDataType
		( $taxon_display_name, $data_type );

            my $url =
                "$main_cgi?section=MetaDetail"
              . "&page=metaDetail&taxon_oid=$taxon_oid";
            $r .= $taxon_display_name . $sd . alink( $url, $taxon_display_name ) . "\t";

            my ( $seq_length, $gc_percent, $gene_count, $read_depth, $lineage, $lineage_perc, $rank ) =
            split( /\t/, $scaffold_h{$s_oid} );
            #print "printIndex() $s_oid: $seq_length, $gc_percent, $gene_count, $read_depth, $lineage, $lineage_perc, $rank<br/>\n";

            if ( $gene_count ) {
                my $url3 =
                    "$main_cgi?section=MetaScaffoldDetail"
                  . "&page=metaScaffoldGenes&scaffold_oid=$scaffold_oid"
                  . "&taxon_oid=$taxon_oid";
                $r .= $gene_count . $sd . alink( $url3, $gene_count ) . "\t";
            }
            else {
                if ( $data_type eq 'assembled' ) {
                    $r .= "0" . $sd . "0" . "\t";
                }
                else {
                    $r .= $sd . "\t";
                }
            }

            if ( $seq_length ) {
                my $scaf_len_url =
                "$main_cgi?section=MetaScaffoldGraph" .
                "&page=metaScaffoldGraph&scaffold_oid=$scaffold_oid" .
                "&taxon_oid=$taxon_oid&data_type=$data_type" .
                "&start_coord=1&end_coord=$seq_length" .
                "&seq_length=$seq_length";
                $r .= $seq_length . $sd . alink( $scaf_len_url, $seq_length ) . "\t";
            }
            else {
                $r .= $seq_length . $sd . "$seq_length". "\t";
            }

            if ( $gc_percent ) {
                $gc_percent = sprintf( " %.2f", $gc_percent );
            }
            $r .= $gc_percent . $sd . "$gc_percent\t";

	    if ($virus) {
		my $workspace_id = "$taxon_oid assembled $scaffold_oid";
		my $str = $viral_scaf_h{$workspace_id};
		if ( ! $str ) {
		    require Viral;
		    Viral::getViralScafInfo($taxon_oid, \%viral_scaf_h);
		    $str = $viral_scaf_h{$workspace_id};
		}
		my ($perc_vpfs, $viral_cluster, @rest) = split(/\t/, $str);
                $r .= $perc_vpfs . $sd . $perc_vpfs . "\t"; #perc vpfs
		my $v_url = "$main_cgi?section=Viral&page=viralClusterDetail" .
		    "&viral_cluster_id=$viral_cluster";
                $r .= $viral_cluster . $sd . alink($v_url, $viral_cluster) 
		    . "\t"; #viral cluster
	    }

	    if ( $include_metagenomes || $virus ) {
                if ( !$read_depth && $data_type eq 'assembled' ) {
                    $read_depth = 1;
                }
                $r .= $read_depth . $sd . "$read_depth\t";

                #$r .= $lineage . $sd . "$lineage\t";
                my ($linDomain, $linPhylum, $linClass, $linOrder, $linFamily, $linGenus, $linSpecies ) = split(/;/, $lineage);
		if ( $virus ) {
		    my $v_cur = execSql( $dbh, $v_sql, $verbose, $taxon_oid, $scaffold_oid );
		    my ($v_dom, $v_phy, $v_cla, $v_ord, $v_fam,
			$v_gen, $v_spe) = $v_cur->fetchrow();
		    $v_cur->finish();
		    if ( $v_dom ) {
			$linDomain = $v_dom;
			$linPhylum = $v_phy;
			$linClass = $v_cla;
			$linOrder = $v_ord;
			$linFamily = $v_fam;
			$linGenus = $v_gen;
			$linSpecies = $v_spe;
		    }
		}

                $r .= $linDomain . $sd . "$linDomain\t";
                $r .= $linPhylum . $sd . "$linPhylum\t";
                $r .= $linClass . $sd . "$linClass\t";
                $r .= $linOrder . $sd . "$linOrder\t";
                $r .= $linFamily . $sd . "$linFamily\t";
                $r .= $linGenus . $sd . "$linGenus\t";
                $r .= $linSpecies . $sd . "$linSpecies\t";

                $r .= $lineage_perc . $sd . "$lineage_perc\t";
            }

	    ## ecosystem
	    my ($ecosystem, $ecosystem_category, $ecosystem_type,
		$ecosystem_subtype, $specific_ecosystem) =
		    split(/\t/, $eco_h{$taxon_oid});
            $r .= $ecosystem . $sd . $ecosystem . "\t";
            $r .= $ecosystem_category . $sd . $ecosystem_category . "\t";
            $r .= $ecosystem_type . $sd . $ecosystem_type . "\t";
            $r .= $ecosystem_subtype . $sd . $ecosystem_subtype . "\t";
            $r .= $specific_ecosystem . $sd . $specific_ecosystem . "\t";

            $it->addRow($r);
            $cnt++;
        }

    }



# TODO test dot thread
Command::killDotThread();
if($img_ken) {
    printEndWorkingDiv('', 1);
} else {
    printEndWorkingDiv();
}

    #$dbh->disconnect();

    print hiddenVar( "section", $section );

    if ( $cnt == 0 ) {
        printNoScaffoldCartForm();
        return;
    }

    print "<p>\n";
    print "$cnt scaffold(s) in cart\n";
    print "</p>\n";

    printValidationJS();

    require TabHTML;
    TabHTML::printTabAPILinks("scaffoldcartTab");
    my @tabIndex = ("#scaffoldcarttab1", "#scaffoldcarttab2",
		    "#scaffoldcarttab3", "#scaffoldcarttab4",
		    "#scaffoldcarttab5");
    my @tabNames = ("Scaffolds in Cart",
		    "Upload & Export & Save",
		    "Function Profile",
		    "Histogram",
		    "Kmer Analysis");
    my $idx = 6;

    if ( !$img_er ) {
        push @tabIndex, "#scaffoldcarttab" . $idx;
        push @tabNames, "Phylogenetic Distribution";
        $idx++;
    }

    TabHTML::printTabDiv( "scaffoldcartTab", \@tabIndex, \@tabNames );

    print "<div id='scaffoldcarttab1'>";
    printScaffoldCartButtons() if $cnt > 10;
    $it->printOuterTable(1);
    printScaffoldCartButtons();
    print "</div>";    # end scaffoldcarttab1

    print "<div id='scaffoldcarttab2'>";
    print "<h2>Upload Scaffold Cart</h2>";
    printUploadScaffoldCartFormContent('Yes');

    print "<h2>Export Scaffold Data</h2>";
    print "<p>You may export data for scaffolds selected in the cart.\n";
    print "<p>\n";

    my $name = "_section_${section}_exportFasta_noHeader";
    print submit(
        -name    => $name,
        -value   => 'Fasta Nucleic Acid File',
        -class   => 'meddefbutton',
        -onClick => "_gaq.push(['_trackEvent', 'Export', '$contact_oid', 'img button $name']); return validateSelection(1);"
    );
    print nbsp(1);
    $name = "_section_${section}_exportGenbank";
    print submit(
        -name    => $name,
        -value   => 'Genbank File',
        -class   => 'medbutton',
        -onClick => "_gaq.push(['_trackEvent', 'Export', '$contact_oid', 'img button $name']); return validateSelection(1);"
    );
    print nbsp(1);
    $name = "_section_${section}_exportScaffoldCart_noHeader";
    print submit(
        -name    => $name,
        -value   => 'Scaffold Cart in Excel',
        -class   => 'medbutton',
        -onClick => "_gaq.push(['_trackEvent', 'Export', '$contact_oid', 'img button $name']); return validateSelection(1);"
    );

    # Workspace
    WorkspaceUtil::printSaveScaffoldToWorkspace($select_id_name);

    # My Bins
    if ($user_restricted_site) {
        require MyBins;
        MyBins::printSaveBinToWorkspace();
    }

    print "</div>";    # end scaffoldcarttab2

    print "<div id='scaffoldcarttab3'>";

    print "<h2>Function Profile</h2>";
    print "<p>To display the function profile for selected scaffolds "
    . "vs. all functions in function cart.</p>";

    $name = "_section_${section}_scaffoldFuncProfile";
    print submit(
        -name    => $name,
        -value   => 'Show Profile',
        -class   => 'meddefbutton',
        -onClick => 'return validateSelection(1);'
    );

    print "</div>";    # end scaffoldcarttab3

    print "<div id='scaffoldcarttab4'>";
    print "<h2>Histogram</h2>";
    print "<p>You may compare selected scaffolds by: ";
    print "     <select name='histogram_type' class='img' size='1'>\n";
    print "        <option value='gene_count'>Gene Count</option>\n";
    print "        <option value='seq_length'>Sequence Length</option>\n";
    print "        <option value='gc_percent'>GC Content</option>\n";
    print "        <option value='read_depth'>Read Depth</option>\n";
    print "     </select>\n";
    print "</p>";

    $name = "_section_${section}_showHistogram";
    print submit(
        -name    => $name,
        -value   => 'Show Histogram',
        -class   => 'meddefbutton',
        -onClick => 'return validateSelection(1);'
    );
    print "</div>";    # end scaffoldcarttab4

    print "<div id='scaffoldcarttab5'>";
    # Kmer Tool
    print "<h2>Scaffold Consistency Check</h2>";
    print "<p>You may analyze selected scaffolds for purity "
	. "using Kmer Frequency Analysis.</p>\n";
    $name = "_section_Kmer_plotScaffolds";
    print submit(
            -name    => $name,
            -value   => 'Kmer Frequency Analysis',
            -class   => 'lgdefbutton',
            -onClick => 'return validateSelection(1);'
    );
    print "</div>";  # end scaffoldcarttab5

    if ( !$img_er ) {
        print "<div id='scaffoldcarttab6'>";
        printHint("Limit the numbers of scaffolds to avoid timeout.");
        PhyloUtil::printPhylogeneticDistributionSection();
        print "</div>";    # end scaffoldcarttab6
    }

    TabHTML::printTabDivEnd();
    print end_form();

    if ( $cnt == 1 ) {
        printStatusLine( "1 scaffold in cart", 2 );
    }
    else {
        printStatusLine( "$cnt scaffolds in cart", 2 );
    }
}

sub printNoScaffoldCartForm {
    print "<p>\n";
    print "0 scaffolds in cart.\n";
    print qq{
            In order to compare scaffolds you need to
            select / upload scaffolds into scaffold cart.
        };
    print "</p>\n";
    printStatusLine( "0 scaffolds in cart", 2 );
    print "<h2>Upload Scaffold Cart</h2>\n";
    printUploadScaffoldCartFormContent();
    print end_form();
}


############################################################################
# printScaffoldCartButtons
############################################################################
sub printScaffoldCartButtons {
    my $name = "_section_GenomeCart_addScaffoldGenome";
    print submit(
        -name    => $name,
        -value   => "Add Genomes of Selected Scaffolds to Cart",
        -class   => 'lgdefbutton',
        #-onClick => 'return validateSelection(1);'
    );
    print nbsp(1);

    my $name = "_section_ScaffoldCart_addSelectedToGeneCart_noHeader";
    #my $name = "_section_ScaffoldCart_addSelectedToGeneCart";
    print submit(
        -name    => $name,
        -value   => "Add Genes of Selected Scaffolds To Cart",
        -class   => 'lgdefbutton',
        #-onClick => 'return validateSelection(1);'
    );
    print "<br/>";

    WebUtil::printButtonFooterInLineWithToggle();

    $name = "_section_${section}_removeFromScaffoldCart";
    print submit(
        -name  => $name,
        -value => 'Remove Selected',
        -class => 'smdefbutton',
        #-onClick => 'return validateSelection(1);'
    );
}

############################################################################
# printScaffoldDetail
############################################################################
sub printScaffoldDetail {
    my ($scaffold_oid) = @_;

    my $contact_oid = getContactOid();
    if ( blankStr($contact_oid) ) {
        main::printAppHeader("AnaCart");
        webError("Your login has expired.");
        return;
    }

    if ( !$scaffold_oid ) {
        main::printAppHeader("AnaCart");
        webError("No scaffold has been selected.");
        return;
    }

    $section = param("section") || $section;

    printMainForm();

    print "<h1>Scaffold Detail</h1>\n";

    print "<p>\n";    # paragraph section puts text in proper font.

    # check permission
    my $rclause   = urClause("s.taxon");
    my $imgClause = WebUtil::imgClauseNoTaxon('s.taxon');

    my $dbh = dbLogin();
    my $sql = qq{
    	select s.scaffold_oid, s.scaffold_name, s.taxon,
               s.mol_topology, s.mol_type,
               to_char(s.add_date, 'yyyy-mm-dd'),
               to_char(s.last_update, 'yyyy-mm-dd'),
               s.read_depth, st.seq_length, st.gc_percent,
               st.count_total_gene, st.count_rna
    	from scaffold s, scaffold_stats st
    	where s.scaffold_oid = ?
    	and s.scaffold_oid = st.scaffold_oid
    	$rclause
        $imgClause
    };

    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my ($s_oid,      $scaffold_name, $taxon_oid,   $mol_topo,
        $mol_type,   $add_date,      $last_update, $read_depth,
        $seq_length, $gc_percent,    $gene_count,  $rna_count
      ) = $cur->fetchrow();
    $cur->finish();

    if ( !$s_oid ) {
        #$dbh->disconnect();
        webError("Scaffold does not exist.");
        return;
    }

    print hiddenVar( "scaffold_oid", $scaffold_oid );

    print "<table class='img' border='1'>\n";
    printAttrRow( "Scaffold ID",  $s_oid );
    printAttrRow( "Scaffold Name", $scaffold_name );

    # taxon
    my $taxon_name = taxonOid2Name( $dbh, $taxon_oid, 1 );
    my $url = "$main_cgi?section=TaxonDetail"
	    . "&page=taxonDetail&taxon_oid=$taxon_oid";
    printAttrRowRaw( "Genome", alink( $url, $taxon_name ) );

    printAttrRow( "Topology",        $mol_topo );
    printAttrRow( "Type",            $mol_type );
    printAttrRow( "Sequence Length", $seq_length );
    printAttrRow( "GC Content",      $gc_percent );

    # gene count
    my $url2 = "$main_cgi?section=ScaffoldDetail"
	     . "&page=scaffoldGenes"
	     . "&scaffold_oid=$scaffold_oid";
    printAttrRowRaw( "Gene Count", alink( $url2, $gene_count ) );

    # RNA count
    printAttrRow( "RNA Count", $rna_count );

    # ecosystem
    my $sql = qq{
           select g.ecosystem, g.ecosystem_category,
                  g.ecosystem_type, g.ecosystem_subtype,
                  g.specific_ecosystem
           from gold_sequencing_project\@imgsg_dev g, taxon t
           where t.taxon_oid = ?
           and t.sequencing_gold_id = g.gold_id
           };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my ($ecosystem, $eco_category, $eco_type, $eco_subtype,
        $specific_eco) =
	    $cur->fetchrow();
    $cur->finish();

    if ( $ecosystem ) {
        printAttrRow( "Ecosystem", $ecosystem );
    }
    if ( $eco_category ) {
        printAttrRow( "Ecosystem Category", $eco_category );
    }
    if ( $eco_type ) {
        printAttrRow( "Ecosystem Type", $eco_type );
    }
    if ( $eco_subtype ) {
        printAttrRow( "Ecosystem Subtype", $eco_subtype );
    }
    if ( $specific_eco ) {
        printAttrRow( "Specific Ecosystem", $specific_eco );
    }

    ## habitat
    $sql = qq{
           select g.habitat
           from gold_sp_habitat\@imgsg_dev g, taxon t
           where t.taxon_oid = ?
           and t.sequencing_gold_id = g.gold_id
           and g.habitat is not null
           order by 1
           };
    $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
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

    # bins?
    my @bins = ();
    my $sql  = qq{
        select s.scaffold, s.bin_oid
        from bin_scaffolds s
        where s.scaffold = ?
    	$rclause
        $imgClause
        and s.bin_oid is not null
        order by 1
    };
    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    for ( ; ; ) {
        my ( $id, $val ) = $cur->fetchrow();
        last if !$id;

        if ( !blankStr($val) ) {
            push @bins, ("$id\t$val");
        }
    }

    if ( scalar(@bins) > 0 ) {
        my $bin_str = "";
        for my $val (@bins) {
            my ( $s_oid2, $bin_oid ) = split( /\t/, $val );
            my $url3 = "$main_cgi?section=Metagenome"
		     . "&page=binDetail"
		     . "&bin_oid=$bin_oid";

            $bin_str .= " " . alink( $url3, $bin_oid );
        }
        printAttrRowRaw( "Bins", $bin_str );
    }

    # add date and mod date
    printAttrRow( "Add Date",    $add_date );
    printAttrRow( "Last Update", $last_update );
    print "</table>\n";

    my $name = "_section_ScaffoldCart_addToScaffoldCart";
    print submit(
        -name    => $name,
        -value   => "Add to Scaffold Cart",
        -class   => "meddefbutton",
    );


    print "<h2>User Selectable Coordinate Ranges</h2>\n";
    print "<p>\n";

    my $pageSize = $env->{scaffold_page_size};

    if ( $seq_length < $pageSize ) {
        my $range = "1\.\.$seq_length";
        my $url   = "$main_cgi?section=ScaffoldGraph&page=scaffoldGraph";
        $url .= "&scaffold_oid=$scaffold_oid";
        $url .= "&start_coord=1&end_coord=$seq_length";
        if ( $seq_length > 0 ) {
            print alink( $url, $range ) . "<br/>\n";
        }
    }
    else {
        my $last = 1;
        for ( my $i = $pageSize ; $i < $seq_length ; $i += $pageSize ) {
            my $curr  = $i;
            my $range = "$last\.\.$curr";
            my $url   = "$main_cgi?section=ScaffoldGraph&page=scaffoldGraph";
            $url .= "&scaffold_oid=$scaffold_oid";
            $url .= "&start_coord=$last&end_coord=$curr";
            $url .= "&seq_length=$seq_length";
            if ( $seq_length > 0 ) {
                print alink( $url, $range ) . "<br/>\n";
            }
            else {
                print nbsp(1);
            }
            $last = $curr + 1;
        }
        if ( $last < $seq_length ) {
            my $range = "$last\.\.$seq_length";
            my $url   = "$main_cgi?section=ScaffoldGraph&page=scaffoldGraph";
            $url .= "&scaffold_oid=$scaffold_oid";
            $url .= "&start_coord=$last&end_coord=$seq_length";
            if ( $seq_length > 0 ) {
                print alink( $url, $range ) . "<br/>\n";
            }
        }
    }

    print "<h2>User Enterable Coordinates</h2>\n";
    printHint( "WARNING: Some browsers may be overwhelmed by a large coordinate range." );

    print hiddenVar( "scaffold_oid_len", "$scaffold_oid:$seq_length" );

    print "<p>\n";
    print "Start ";
    print "<input type='text' name='start_coord' size='10' />\n";
    print nbsp(1);
    print "End ";
    print "<input type='text' name='end_coord' size='10' />\n";
    print "<br/>\n";

    if ($img_internal) {
        print "Mark phantom gene coordinates in red (optional): ";
        print "Start ";
        print "<input type='text' name='phantom_start_coord' size='10' />\n";
        print "End ";
        print "<input type='text' name='phantom_end_coord' size='10' />\n";
        print "Strand ";
        print popup_menu(
            -name   => "phantom_strand",
            -values => [ "pos", "neg" ]
        );
        print " (experimental)";
        print "<br/>\n";
    }
    print "</p>\n";
    my $name = "_section_ScaffoldGraph_userScaffoldGraph";
    print submit(
        -name  => $name,
        -value => "Go",
        -class => "smdefbutton"
    );
    print nbsp(1);
    print reset( -class => "smbutton" );

    PhyloUtil::printPhylogeneticDistributionSection(0, 1);

    print end_form();
}

############################################################################
# getNextBatchId
############################################################################
sub getNextBatchId {
    my ($records_aref) = @_;

    my $max_id = 0;
    foreach my $line (@$records_aref) {
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        if ( $batch_id > $max_id ) {
            $max_id = $batch_id;
        }
    }
    if ( !$max_id ) {
        return 1;
    }

    $max_id++;
    return $max_id;
}

# get next virtual taxon oid
# only for names scaffolds
# ids are negative starting from -1
#
sub getNextVirtualTaxonOid {
    my ($records_aref) = @_;

    my $max_id = 0;
    foreach my $line (@$records_aref) {
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        if ( $virtual_taxon_oid < $max_id ) {
            $max_id = $virtual_taxon_oid;
        }
    }

    $max_id--;
    return $max_id;

}

# get  virtual taxon ids for a given cart name
sub getVirtualTaxonIdForName {
    my ($cartname) = @_;
    my $records_aref = readCartFile();

    foreach my $line (@$records_aref) {
        chomp $line;
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );

        #print "$cartname == $line <br/>\n";

        if ( $cartname eq $name ) {
            return $virtual_taxon_oid;
        }
    }
    return 0;    # no id found
}

# get cart name for a given virtual taxon oid
sub getCartNameForTaxonOid {
    my ($toid) = @_;

    my $records_aref = readCartFile();

    foreach my $line (@$records_aref) {
        chomp $line;
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        if ( $toid eq $virtual_taxon_oid ) {
            return $name;
        }
    }
    return "";    # no name found
}

############################################################################
# addToScaffoldCart
############################################################################
sub addToScaffoldCart {
    my ($scaffold_oids_aref) = @_;

    my @scaffold_oids = param('scaffold_oid');
    my $scaffoldsStr = param('scaffolds');    # from url

    if ( $scaffoldsStr ) {
    	my @scfs = split( ",", $scaffoldsStr );
    	my %sets;
    	foreach my $id (@scfs) {
    	    # KiNG applet does not allow spaces, so use "-" to join
    	    # metagenome [taxon_oid data_type scaffold]
    	    my ($id0, $set0) = split(":", $id);
    	    my @sids = split("-", $id0);
    	    my $scfid = join(" ", @sids);
    	    push @scaffold_oids, $scfid;
    	    push @{$sets{ $set0 }}, $scfid if $set0 && $set0 ne "";
    	}
    	if (scalar keys %sets > 0) {
    	    require WorkspaceScafSet;
    	    WorkspaceScafSet::printDetailForSets(\%sets);
    	    return "sets";
    	}
    }

    if ( $#scaffold_oids <= 0 ) {
        @scaffold_oids = @$scaffold_oids_aref if $scaffold_oids_aref;
    }

    if ( scalar(@scaffold_oids) == 0 ) {
        webError("No scaffolds have been selected.");
        return;
    }

    my $records_aref = readCartFile();
    my $recsNum = scalar(@$records_aref);

    if ( !$recsNum || $recsNum < CartUtil::getMaxDisplayNum() ) {
        my ( $dbOids_ref, $metaOids_ref ) =
    	MerFsUtil::splitDbAndMetaOids(@scaffold_oids);
        my @dbOids   = @$dbOids_ref;
        my @metaOids = @$metaOids_ref;

        my $dbh = dbLogin();
        @scaffold_oids = ();
        if ( scalar(@dbOids) > 0 ) {
            #not working using QueryUtil::fetchValidScaffoldOids
            #@scaffold_oids = QueryUtil::fetchValidScaffoldOids( $dbh, @dbOids );
            push( @scaffold_oids, @dbOids );
        }

        if ( scalar(@metaOids) > 0 ) {
            my %taxon_oid_hash =
    	    MerFsUtil::fetchValidMetaTaxonOidHash( $dbh, @metaOids );
            for my $oid (@metaOids) {
                my ( $taxon_oid, $data_type, $scaffold_oid ) = split( / /, $oid );

                #if ( !($data_type eq 'assembled') ) {
                #    #only allow assembled into the cart
                #    next;
                #}
                if ( !exists( $taxon_oid_hash{$taxon_oid} ) ) {
                    #print "addToScaffoldCart() $taxon_oid not permitted<br/>\n";
                    #$taxon_oid not in hash due to permission
                    next;
                }
                push( @scaffold_oids, $oid );
            }
        }

        # check what's already in the cart
        my %s_carts;
        my %cart_names;
        foreach my $line (@$records_aref) {
            my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
              split( /\t/, $line );
            $s_oid = WebUtil::strTrim($s_oid);
            $s_carts{$s_oid}    = 1;
            $cart_names{$s_oid} = "$name\t$virtual_taxon_oid";
        }

        my $next_batch = getNextBatchId($records_aref);

        my $res = newAppendFileHandle( getStateFile(), "append 1" );
        foreach my $scaffold_oid (@scaffold_oids) {
            if ( $s_carts{$scaffold_oid} ) {
                next;  # already there
            }

            $s_carts{$scaffold_oid} = 1;    # make sure there are no duplicates

            # add - $virtual_taxon_oid was added
            my $name = $cart_names{$scaffold_oid};
            print { $res } "$scaffold_oid\t$contact_oid\t$next_batch\t$name\n";

            $recsNum++;
            if ( $recsNum >= CartUtil::getMaxDisplayNum() ) {
                last;
            }
        }
        close $res;
    }
}

############################################################################
# removeFromScaffoldCart
############################################################################
sub removeFromScaffoldCart {
    printMainForm();

    print "<p>\n";    # paragraph section puts text in proper font.

    my @scaffold_oids = param('scaffold_oid');
    if ( scalar(@scaffold_oids) == 0 ) {
        webError("No scaffolds have been selected.");
        return;
    }

    my $aref = readCartFile();
    my %hash;         # ids to remove

    # convert to array to hash
    foreach my $scaffold_oid (@scaffold_oids) {
        $hash{$scaffold_oid} = $scaffold_oid;
    }

    my $res = newWriteFileHandle( getStateFile(), "runJob" );

    foreach my $line (@$aref) {
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        $s_oid = WebUtil::strTrim($s_oid);
        if ( exists $hash{$s_oid} ) {

            # delete
            # do nothing
            # next
        }
        else {
            print $res "$line\n";
        }
    }

    close $res;
}

############################################################################
# addGeneScaffoldToCart
############################################################################
sub addGeneScaffoldToCart {
    my @gene_oids = param('gene_oid');
    if ( scalar(@gene_oids) == 0 ) {
        printMainForm();
        webError("No genes have been selected.");
        return;
    }

    my $dbh = dbLogin();
    my $scaffoldId_href = getScaffoldOidsFromGeneOids( $dbh, \@gene_oids );
    my @scaffold_oids = keys %$scaffoldId_href;
    addToScaffoldCart(\@scaffold_oids);
}

#
# get all the scaffolds from a list of gene oids
# returns a hash  of scaffold keys
#
sub getScaffoldOidsFromGeneOids {
    my ( $dbh, $gene_oids_ref ) = @_;

    my ( $dbOids_ref, $metaOids_ref ) =
      MerFsUtil::splitDbAndMetaOids(@$gene_oids_ref);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;

    # found scaffold ids
    my %foundIds;

    if ( scalar(@dbOids) > 0 ) {
        %foundIds = QueryUtil::fetchGeneScaffoldOidsHash( $dbh, @dbOids );
    }

    if ( scalar(@metaOids) > 0 ) {
        my %taxon_oid_hash =
          MerFsUtil::fetchValidMetaTaxonOidHash( $dbh, @metaOids );
        for my $oid (@metaOids) {
            my ( $taxon_oid, $data_type, $gene_oid ) = split( / /, $oid );
            #if ( !($data_type eq 'assembled') ) {
            #    #only allow assembled
            #    next;
            #}
            if ( !exists( $taxon_oid_hash{$taxon_oid} ) ) {
                #$taxon_oid not in hash due to permission
                next;
            }

            my ($id) =
              MetaUtil::getGeneScaffoldWorkspaceId( $taxon_oid, $data_type,
                $gene_oid );
            $foundIds{$id} = 1;
        }
    }

    return \%foundIds;
}

############################################################################
# addGenomeScaffoldToCart
############################################################################
sub addGenomeScaffoldToCart {
    my @genome_oids = param('taxon_filter_oid');
    if ( scalar(@genome_oids) == 0 ) {
        printMainForm();
        webError("No genomes have been selected.");
        return;
    }

    my $dbh = dbLogin();
    my %taxon_in_file = MerFsUtil::fetchTaxonsInFile($dbh, @genome_oids);
    my @metaTaxons = keys(%taxon_in_file);
    if ( scalar(@metaTaxons) > 0 ) {
        if ( scalar(@metaTaxons) > 1 ) {
            webError("Only one selected metagenome can have its scaffolds added into cart!");
        }

        my %taxon_gene_cnt_hash = QueryUtil::fetchTaxonOid2GeneCntHash($dbh, \@metaTaxons);
        foreach my $t_oid (keys(%taxon_gene_cnt_hash)) {
            my $total_gene_cnt = $taxon_gene_cnt_hash{$t_oid};
            if ( $total_gene_cnt > $max_gene_cnt_for_taxon ) {
                webError("Selected genome $t_oid is too large to have its scaffolds added into cart!");
            }
        }
    }

    my $scaffoldId_href = getScaffoldOidsFromGenomeOids( $dbh, \@genome_oids );
    my @scaffold_oids = keys %$scaffoldId_href;
    addToScaffoldCart(\@scaffold_oids);
}

#
# get all the scaffolds from a list of genome oids
# returns a hash of scaffold keys
#
sub getScaffoldOidsFromGenomeOids {
    my ( $dbh, $genome_oids_ref ) = @_;

    my ( $dbOids_ref, $metaOids_ref ) =
	MerFsUtil::findTaxonsInFile($dbh, @$genome_oids_ref);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;

    # found scaffold ids
    my %foundIds;

    if ( scalar(@dbOids) > 0 ) {
        my ($foundIds_href, $id2name_href, $taxon_foundIds_href) = QueryUtil::fetchGenomeScaffoldOidsHash( $dbh, @dbOids );
        %foundIds = %$foundIds_href;
    }

    if ( scalar(@metaOids) > 0 ) {
        for my $oid (@metaOids) {
	    my @ids = MetaUtil::getGenomeScaffoldWorkspaceId($oid, "assembled");
            if (scalar(@ids) > 0) {
                for my $scaf_id (@ids) {
                    $foundIds{$scaf_id} = 1;
                }
            }
        }
    }

    return \%foundIds;
}


############################################################################
# addBinScaffoldToCart
############################################################################
sub addBinScaffoldToCart {
    my @bin_oids = param('selected_bin');
    if ( scalar(@bin_oids) == 0 ) {
        printMainForm();
        webError("No bins have been selected.");
        return;
    }

    my $cart_name = param('cart_name');

    # check what's already in the cart
    my %s_carts;
    my $records_aref = readCartFile();
    my $recsNum = scalar(@$records_aref);
    #print "addBinScaffoldToCart() recsNum=$recsNum<br/>\n";
    if ( !$recsNum || $recsNum < CartUtil::getMaxDisplayNum() ) {

        foreach my $line (@$records_aref) {
            my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
              split( /\t/, $line );
            $s_oid = WebUtil::strTrim($s_oid);
            $s_carts{$s_oid} = 1;
        }
        my $next_batch = getNextBatchId($records_aref);

        my $dbh = dbLogin();
        OracleUtil::truncTable( $dbh, "gtt_num_id" );
        OracleUtil::insertDataArray( $dbh, "gtt_num_id", \@bin_oids );

        # taxon permission
        my $rclause   = WebUtil::urClause('s.taxon');
        my $imgClause = WebUtil::imgClauseNoTaxon('s.taxon');
        my $sql       = qq{
            select bs.scaffold
            from bin_scaffolds bs, scaffold s
            where bs.bin_oid in ( select id from gtt_num_id )
            and bs.scaffold = s.scaffold_oid
            $rclause
            $imgClause
        };
        my $cur = execSql( $dbh, $sql, $verbose );
        my %bin_recs;
        for ( ; ; ) {
            my ($id) = $cur->fetchrow();
            last if !$id;
            $bin_recs{$id} = $next_batch;
        }
        $cur->finish();
        OracleUtil::truncTable( $dbh, "gtt_num_id" );
        #$dbh->disconnect();

        # write to file
        my $res = newWriteFileHandle( getStateFile(), "runJob" );
        foreach my $line (@$records_aref) {
            my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
              split( /\t/, $line );
            if ( exists $bin_recs{$s_oid} ) {

                # new batch id
                print $res
                  "$s_oid\t$contact_oid\t$next_batch\t$name\t$virtual_taxon_oid\n";
            }
            else {
                print $res "$line\n";
                $bin_recs{$s_oid};
            }
        }

        foreach my $id ( keys %bin_recs ) {
            next if ( exists $s_carts{$id} );
            $s_carts{$id} = 1;    # make sure no duplicates added
            print $res "$id\t$contact_oid\t$next_batch\t\t\n";
            $recsNum++;
            if ( $recsNum >= CartUtil::getMaxDisplayNum() ) {
                last;
            }
        }

        close $res;
    }
}

############################################################################
# scaffoldFuncProfile
############################################################################
sub scaffoldFuncProfile {
    my $oids_aref     = getSelectedCartOids();
    my @scaffold_oids = @$oids_aref;

    if ( scalar(@scaffold_oids) == 0 ) {
        webError("No scaffolds have been selected.");
        return;
    }

    #test use
    #foreach my $oid (@scaffold_oids) {
    #    print "ScaffoldCart::scaffoldFuncProfile() scaffold oid: $oid<br/>\n";
    #}

    my $fc       = new FuncCartStor();
    my $recs     = $fc->{recs};            # get records
    my @func_ids = sort( keys(%$recs) );
    my $count    = @func_ids;
    if ( $count == 0 ) {
        webError("Function Cart is empty.");
        return;
    }

    my ($cog_ids_ref, $kog_ids_ref, $pfam_ids_ref, $tigr_ids_ref,
        $ec_ids_ref, $ko_ids_ref, $tc_fam_nums_ref, $bc_ids_ref, $metacyc_ids_ref,
        $iterm_ids_ref,  $ipway_ids_ref, $plist_ids_ref,
        $unrecognized_ids_ref, $unsurported_func_ids_ref) = CartUtil::separateFuncIds( @func_ids );

    if (   scalar(@$cog_ids_ref) <= 0
        && scalar(@$kog_ids_ref) <= 0
        && scalar(@$pfam_ids_ref) <= 0
        && scalar(@$tigr_ids_ref) <= 0
        && scalar(@$ec_ids_ref) <= 0
        && scalar(@$ko_ids_ref) <= 0
        && scalar(@$tc_fam_nums_ref) <= 0
        && ( scalar(@$bc_ids_ref) <= 0 && $enable_biocluster )
        && scalar(@$metacyc_ids_ref) <= 0
        && scalar(@$iterm_ids_ref) <= 0
        && scalar(@$ipway_ids_ref) <= 0
        && scalar(@$plist_ids_ref) <= 0
        && (scalar(@$unrecognized_ids_ref) > 0 || scalar(@$unsurported_func_ids_ref)) > 0 )
    {
        webError("Unspported (such as GO and Interpro) or unrecognized functions in Function Profile.");
    }

    printMainForm();

    print "<h1>Scaffold Function Profile</h1>\n";

    if (scalar(@$unsurported_func_ids_ref) > 0) {
        print "<h5>Unspported functions: @$unsurported_func_ids_ref</h5>";
    }

    if (scalar(@$unrecognized_ids_ref) > 0) {
        print "<h5>Unrecognized functions: @$unrecognized_ids_ref</h5>";
    }

    my $it = new InnerTable( 1, "ScaffoldProfile$$", "ScaffoldProfile", 0 );
    my $sd = $it->getSdDelim();            # sort delimiter

    $it->addColSpec( "Scaffold", "asc" );
    for my $func_id (@func_ids) {
        $it->addColSpec( $func_id, "desc", "right" );
    }

    # YUI tables look better with more vertical padding +BSJ 04/20/10
    my $vPadding = ($yui_tables) ? 4 : 0;

    my ( $dbOids_ref, $metaOids_ref ) =
      MerFsUtil::splitDbAndMetaOids(@scaffold_oids);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;

    if ( scalar(@dbOids) > 0 ) {
        my $dbh = dbLogin();

        my $db_oid_str = OracleUtil::getNumberIdsInClause( $dbh, @dbOids );

        my $rclause   = WebUtil::urClause('s.taxon');
        my $imgClause = WebUtil::imgClauseNoTaxon('s.taxon');
        my $sql       = qq{
    	    select s.scaffold_oid, s.scaffold_name, s.ext_accession, s.taxon
    	    from scaffold s
    	    where s.scaffold_oid in ($db_oid_str)
            $rclause
            $imgClause
    	};
        my $cur = execSql( $dbh, $sql, $verbose );

        my %scaf2name;
        my %scaf2taxon;
        for ( ; ; ) {
            my ( $s_oid, $s_name, $ext_acc, $taxon_oid ) = $cur->fetchrow();
            last if !$s_oid;
            $scaf2name{$s_oid} = $s_name;
            $scaf2taxon{$s_oid} = $taxon_oid;
        }
        $cur->finish();
        OracleUtil::truncTable( $dbh, "gtt_num_id" )
          if ( $db_oid_str =~ /gtt_num_id/i );

        for my $scaffold_oid (@dbOids) {
            my $row;

            my $scaffold_name = $scaf2name{$scaffold_oid};
            if ( $scaffold_name ) {
                $row .= $scaffold_name . $sd . escapeHTML($scaffold_name) . "\t";
            }
            else {
                $row .= "Scaffold $scaffold_oid not found" . $sd;
                $row .= "Scaffold $scaffold_oid not found" . "\t";
                $it->addRow($row);
                next;
            }

            my $taxon_oid = $scaf2taxon{$scaffold_oid};

            my %funcId2geneCnt;
            if ( scalar(@$cog_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'COG', $cog_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
            }

            if ( scalar(@$kog_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'KOG', $kog_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
            }

            if ( scalar(@$pfam_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'pfam', $pfam_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
            }

            if ( scalar(@$tigr_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'TIGR', $tigr_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
            }

            if ( scalar(@$ec_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'EC', $ec_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
            }

            if ( scalar(@$ko_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'KO', $ko_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
            }

            if ( scalar(@$tc_fam_nums_ref) > 0 ) {
                processProfileForFunc( $dbh, 'TC', $tc_fam_nums_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
            }

            if ( scalar(@$bc_ids_ref) > 0 && $enable_biocluster ) {
                processProfileForFunc( $dbh, 'BC', $bc_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt, '', 'BC:' );
            }

            if ( scalar(@$metacyc_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'MetaCyc', $metacyc_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt, '', 'MetaCyc:' );
            }

            if ( scalar(@$iterm_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'ITERM', $iterm_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt, 1, 'ITERM:' );
            }

            if ( scalar(@$ipway_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'IPWAY', $ipway_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt, 1, 'IPWAY:' );
            }


            if ( scalar(@$plist_ids_ref) > 0 ) {
                processProfileForFunc( $dbh, 'PLIST', $plist_ids_ref,
                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt, 1, 'PLIST:' );
            }

#            if ( scalar(@$nog_ids_ref) > 0 ) {
#                processProfileForFunc( $dbh, 'NOG', $nog_ids_ref,
#                    $scaffold_oid, $taxon_oid, \%funcId2geneCnt );
#            }


            for my $func_id (@func_ids) {
                if ( $funcId2geneCnt{$func_id} ) {
                    my $gene_cnt = $funcId2geneCnt{$func_id};
                    my $url      =
                        "$main_cgi?section=ScaffoldDetail"
                      . "&page=geneWithFunc"
                      . "&scaffold_oid=$scaffold_oid"
                      . "&func_id=$func_id";
                    $row .= $gene_cnt . $sd;
                    $row .=
                        "<span style='background-color:lightgreen; "
                      . "padding:${vPadding}px 10px;'>";
                    $row .= alink( $url, $gene_cnt ) . "</span>\t";
                }
                else {
                    $row .=
                        "0" . $sd
                      . "<span style='padding:${vPadding}px 10px;'>0</span>\t";
                }
            }
            $it->addRow($row);
        }
        $cur->finish();
        #OracleUtil::truncTable( $dbh, "gtt_func_id" );
        #$dbh->disconnect();
    }

    if ( scalar(@metaOids) > 0 ) {
        my %func_ids_h;
        for my $func_id (@func_ids) {
            $func_ids_h{$func_id} = 1;
        }

        for my $scaffold_oid (@metaOids) {
            my $row;

            my ( $taxon_oid, $data_type, $s_oid ) = split( / /, $scaffold_oid );

            if ( !$s_oid ) {
                $row .= "Scaffold $scaffold_oid not found" . $sd;
                $row .= "Scaffold $scaffold_oid not found" . "\t";
                $it->addRow($row);
                next;
            }

            $row .= $s_oid . $sd . escapeHTML($s_oid) . "\t";

            my %funcId2genes =
              MetaUtil::getScaffoldFuncId2GenesInOneHash( $taxon_oid, $data_type,
                $s_oid, \%func_ids_h );
            #print "scaffoldFuncProfile() funcId2genes:<br/>\n";
            #print Dumper(\%funcId2genes);
            #print "<br/>\n";

            for my $func_id (@func_ids) {
                my $val = $funcId2genes{$func_id};
                #print "scaffoldFuncProfile() $func_id=$val<br/>\n";

                if ($val) {
                    my @geneVals = split( /\t/, $val );
                    my $gene_cnt = scalar(@geneVals);

                    my $url =
                        "$main_cgi?section=ScaffoldDetail"
                      . "&page=geneWithFunc"
                      . "&scaffold_oid=$scaffold_oid"
                      . "&func_id=$func_id";
                    $row .= $gene_cnt . $sd;
                    $row .=
                        "<span style='background-color:lightgreen; "
                      . "padding:${vPadding}px 10px;'>";
                    $row .= alink( $url, $gene_cnt ) . "</span>\t";
                }
                else {
                    $row .=
                        "0" . $sd
                      . "<span style='padding:${vPadding}px 10px;'>0</span>\t";
                }
            }
            $it->addRow($row);
        }
    }

    $it->printOuterTable(1);

    print end_form();
}

sub processProfileForFunc {
    my ( $dbh, $func_type, $func_ids_ref, $scaffold_oid, $taxon_oid,
	 $funcId2geneCnt_ref, $isNum, $symbToAdd ) = @_;

    #print "ScaffoldCart::processProfileForFunc() scaffold_oid: $scaffold_oid, taxon_oid: $taxon_oid<br/>\n";

    my $func_id_str;
    if ( $isNum ) {
	$func_id_str = OracleUtil::getNumberIdsInClause( $dbh, @$func_ids_ref );
    }
    else {
	$func_id_str = OracleUtil::getFuncIdsInClause( $dbh, @$func_ids_ref );
    }

    my ( $funcsql, @bindList ) =
	getScaffoldFuncGeneCountQuery( $func_type, $func_id_str, $scaffold_oid,
				       $taxon_oid );

    my $funccur = execSqlBind( $dbh, $funcsql, \@bindList, $verbose );
    for ( ; ; ) {
	my ( $id, $gene_count ) = $funccur->fetchrow();
	last if !$id;

	my $symbId = "$symbToAdd$id";
	$funcId2geneCnt_ref->{$symbId} = $gene_count;
    }
    $funccur->finish();

    if ( $isNum ) {
	OracleUtil::truncTable( $dbh, "gtt_num_id" )
	    if ( $func_id_str =~ /gtt_num_id/i );
    }
    else {
	OracleUtil::truncTable( $dbh, "gtt_func_id" )
	    if ( $func_id_str =~ /gtt_func_id/i );
    }
}

sub getScaffoldFuncGeneCountQuery {
    my ( $func_type, $func_id_str, $scaffold_oid, $taxon_oid ) = @_;

    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');

    my $sql;
    my @bindList = ();

    if ( $func_type eq 'COG' ) {
        $sql = qq{
            select g.cog, count( distinct g.gene_oid )
            from gene_cog_groups g
            where g.cog in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.cog
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'KOG' ) {
        $sql = qq{
            select g.kog, count( distinct g.gene_oid )
            from gene_kog_groups g
            where g.kog in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.kog
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'pfam' ) {
        $sql = qq{
            select g.pfam_family, count( distinct g.gene_oid )
            from gene_pfam_families g
            where g.pfam_family in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.pfam_family
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'TIGR' ) {
        $sql = qq{
            select g.ext_accession, count( distinct g.gene_oid )
            from gene_tigrfams g
            where g.ext_accession in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.ext_accession
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'KO' ) {
        $sql = qq{
            select g.ko_terms, count( distinct g.gene_oid )
            from gene_ko_terms g
            where g.ko_terms in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.ko_terms
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'EC' ) {
        $sql = qq{
            select g.enzymes, count( distinct g.gene_oid )
            from gene_ko_enzymes g
            where g.enzymes in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.enzymes
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'TC' ) {
        $sql = qq{
            select g.tc_family, count( distinct g.gene_oid)
            from gene_tc_families g
            where g.tc_family in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.tc_family
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'BC' ) {
        $sql = qq{
            select bcg.cluster_id, count( distinct bcg.gene_oid )
            from bio_cluster_features_new bcg, gene g
            where bcg.cluster_id in ($func_id_str)
            and bcg.gene_oid = g.gene_oid
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by bcg.cluster_id
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ( $func_type eq 'MetaCyc' ) {
        $sql = qq{
            select brp.in_pwys, count( distinct g.gene_oid )
            from biocyc_reaction_in_pwys brp, biocyc_reaction br,
                 gene_biocyc_rxns g
            where brp.in_pwys in ($func_id_str)
            and brp.unique_id = br.unique_id
            and br.unique_id = g.biocyc_rxn
            and br.ec_number = g.ec_number
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by brp.in_pwys
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ($func_type eq 'ITERM') {
        $sql = qq{
            select g.function, count( distinct g.gene_oid )
            from gene_img_functions g
            where g.function in ($func_id_str)
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by g.function
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ($func_type eq 'IPWAY') {
        $sql = qq{
            select new.pathway_oid, count( distinct new.gene_oid )
            from (
                select ipr.pathway_oid pathway_oid, g.gene_oid gene_oid
                from img_pathway_reactions ipr, img_reaction_catalysts irc,
                    gene_img_functions g
                where ipr.pathway_oid in ($func_id_str)
                and ipr.rxn = irc.rxn_oid
                and irc.catalysts = g.function
                and g.scaffold = ?
                and g.taxon = ?
                $rclause
                $imgClause
                union
                select ipr.pathway_oid pathway_oid, g.gene_oid gene_oid
                from img_pathway_reactions ipr, img_reaction_t_components itc,
                    gene_img_functions g
                where ipr.pathway_oid in ($func_id_str)
                and ipr.rxn = itc.rxn_oid
                and itc.term = g.function
                and g.scaffold = ?
                and g.taxon = ?
                $rclause
                $imgClause
            ) new
            group by new.pathway_oid
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ($func_type eq 'PLIST') {
        $sql = qq{
            select pt.parts_list_oid, count( distinct g.gene_oid )
            from img_parts_list_img_terms pt, gene_img_functions g
            where pt.parts_list_oid in ($func_id_str)
            and pt.term = g.function
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by pt.parts_list_oid
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    elsif ($func_type eq 'NOG') {
        $sql = qq{
            select ge.nog_id, count( distinct g.gene_oid )
            from gene_eggnogs ge, gene g
            where ge.gene_oid = g.gene_oid
            and ge.type like '%NOG'
            and g.scaffold = ?
            and g.taxon = ?
            $rclause
            $imgClause
            group by ge.nog_id
        };
        push( @bindList, $scaffold_oid );
        push( @bindList, $taxon_oid );
    }
    #print "getScaffoldGeneFuncQuery() $func_type sql: $sql<br/>\n";
    #print "getScaffoldGeneFuncQuery() bindList: @bindList<br/>\n";

    return ( $sql, @bindList );
}

############################################################################
# exportScaffoldCart
############################################################################
sub exportScaffoldCart {

    my $contact_oid = getContactOid();
    if ( blankStr($contact_oid) ) {
        main::printAppHeader("AnaCart");
        webError("Your login has expired.");
        return;
    }

    my $scaffold_oids_aref = getSelectedCartOids();
    if ( scalar(@$scaffold_oids_aref) == 0 ) {
        main::printAppHeader("AnaCart");
        webError("No scaffolds have been selected.");
        return;
    }

    # print Excel Header
    WebUtil::printExcelHeader("scaffold_cart$$.xls");
    printScaffoldDataFile( $scaffold_oids_aref );
    WebUtil::webExit(0);
}

############################################################################
# printScaffoldDataFile
############################################################################
sub printScaffoldDataFile {
    my ( $scaffold_oids_aref, $outFile ) = @_;

    my $wfh;
    if ( $outFile ) {
        $wfh = newAppendFileHandle( $outFile, "writeScaffoldFastaFile" );
    }

    if ( $wfh ) {
        # print header
        print $wfh "Scaffold ID\t";
        print $wfh "Scaffold Name\t";
        print $wfh "Genome ID\t";
        print $wfh "Genome\t";
        print $wfh "Gene Count\t";
        print $wfh "Sequence Length\t";
        print $wfh "GC Content";
        if ($include_metagenomes) {
            print $wfh "\t";
            print $wfh "Read Depth\t";
            print $wfh "Lineage Domain\t";
            print $wfh "Lineage Phylum\t";
            print $wfh "Lineage Class\t";
            print $wfh "Lineage Order\t";
            print $wfh "Lineage Family\t";
            print $wfh "Lineage Genus\t";
            print $wfh "Lineage Species\t";
            print $wfh "Lineage Percentage";
        }
        print $wfh "\r\n";
    }
    else {
        # print header
        print "Scaffold ID\t";
        print "Scaffold Name\t";
        print "Genome ID\t";
        print "Genome\t";
        print "Gene Count\t";
        print "Sequence Length\t";
        print "GC Content";
        if ($include_metagenomes) {
            print "\t";
            print "Read Depth\t";
            print "Lineage Domain\t";
            print "Lineage Phylum\t";
            print "Lineage Class\t";
            print "Lineage Order\t";
            print "Lineage Family\t";
            print "Lineage Genus\t";
            print "Lineage Species\t";
            print "Lineage Percentage";
        }
        print "\r\n";
    }

    my ( $dbOids_ref, $metaOids_ref ) =
      MerFsUtil::splitDbAndMetaOids(@$scaffold_oids_aref);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;

    # export data
    my $dbh = dbLogin();

    if ( scalar(@dbOids) > 0 ) {
        my $rclause   = WebUtil::urClause('tx');
        my $imgClause = WebUtil::imgClause('tx');

        my $sql = qq{
            select s.scaffold_oid, s.scaffold_name, s.ext_accession, 
            tx.taxon_oid, tx.taxon_name, st.seq_length,
            st.gc_percent, s.read_depth,
            st.count_total_gene
            from scaffold s, scaffold_stats st, taxon tx
            where s.scaffold_oid = ?
            and s.scaffold_oid = st.scaffold_oid
            and s.taxon = tx.taxon_oid
            $rclause
            $imgClause
        };
        my $cur = prepSql( $dbh, $sql, $verbose );
        for my $scaffold_oid (@dbOids) {
            execStmt( $cur, $scaffold_oid );
            my ( $s_oid, $scaffold_name, $ext_acc, $t_oid, $taxon, $seq_length,
                $gc_percent, $read_depth, $gene_count )
              = $cur->fetchrow();
            if ($s_oid) {
                $gc_percent = sprintf( " %.2f", $gc_percent );
                if ( $wfh ) {
                    print $wfh "$s_oid\t$scaffold_name\t$t_oid\t$taxon\t"
                      . "$gene_count\t$seq_length\t$gc_percent";
                    if ($include_metagenomes) {
                        print $wfh "\t";
                        print $wfh "$read_depth\t";
                        print $wfh "\t\t\t\t\t\t\t";
                    }
                    print $wfh "\r\n";
                }
                else {
                    print "$s_oid\t$scaffold_name\t$t_oid\t$taxon\t"
                      . "$gene_count\t$seq_length\t$gc_percent";
                    if ($include_metagenomes) {
                        print "\t";
                        print "$read_depth\t";
                        print "\t\t\t\t\t\t\t";
                    }
                    print "\r\n";
                }
            }
        }
        $cur->finish();
    }

    if ( scalar(@metaOids) > 0 ) {
        my %scaf_id_h;
        my %taxon_oid_h;
        for my $s_oid (@metaOids) {
            $scaf_id_h{$s_oid} = 1;
            my @vals = split( / /, $s_oid );
            if ( scalar(@vals) >= 3 ) {
                $taxon_oid_h{ $vals[0] } = 1;
            }
        }
        my @taxonOids = keys(%taxon_oid_h);

        my %taxon_name_h;
        my %genome_type_h;
        if ( scalar(@taxonOids) > 0 ) {
            my ( $taxon_name_h_ref, $genome_type_h_ref ) =
              QueryUtil::fetchTaxonOid2NameGenomeTypeHash( $dbh,
                \@taxonOids );
            %taxon_name_h  = %$taxon_name_h_ref;
            %genome_type_h = %$genome_type_h_ref;
        }

        my %scaffold_h;
        MetaUtil::getAllScaffoldInfo( \%scaf_id_h, \%scaffold_h, 1 );

        for my $s_oid (@metaOids) {
            #$s_oid is $workspace_id
            my ( $taxon_oid, $data_type, $scaffold_oid ) = split( / /, $s_oid );
            if ( !exists( $taxon_name_h{$taxon_oid} ) ) {
                #$taxon_oid not in hash, probably due to permission
                webLog("ScaffoldCart::exportScaffoldCart() $taxon_oid not retrieved from database, probably due to permission.\n");
                next;
            }

            # taxon
            my $taxon_display_name = $taxon_name_h{$taxon_oid};
            my $genome_type        = $genome_type_h{$taxon_oid};

            $taxon_display_name .= " (*)"
              if ( $genome_type eq "metagenome" );

            my ( $seq_length, $gc_percent, $gene_count, $read_depth, $lineage, $lineage_perc, $rank )
                = split( /\t/, $scaffold_h{$s_oid} );
            #webLog("ScaffoldCart::exportScaffoldCart() $s_oid: $seq_length, $gc_percent, $gene_count, $read_depth, $lineage, $lineage_perc, $rank\n");

            $gc_percent = sprintf( " %.2f", $gc_percent );
            if ( $wfh ) {
                print $wfh "$s_oid\t";
                print $wfh "\t";    #scaffold_name
                print $wfh "$taxon_oid\t";
                print $wfh "$taxon_display_name\t";
                print $wfh "$gene_count\t";
                print $wfh "$seq_length\t";
                print $wfh "$gc_percent";
                if ($include_metagenomes) {
                    print $wfh "\t";
                    if ( !$read_depth && $data_type eq 'assembled' ) {
                        $read_depth = 1;
                    }
                    print $wfh "$read_depth\t";
                    my ($linDomain, $linPhylum, $linClass, $linOrder, $linFamily, $linGenus, $linSpecies ) = split(/;/, $lineage);
                    print $wfh "$linDomain\t";
                    print $wfh "$linPhylum\t";
                    print $wfh "$linClass\t";
                    print $wfh "$linOrder\t";
                    print $wfh "$linFamily\t";
                    print $wfh "$linGenus\t";
                    print $wfh "$linSpecies\t";
                    print $wfh "$lineage_perc";
                }
                print $wfh "\r\n";
            }
            else {
                print "$s_oid\t";
                print "\t";    #scaffold_name
                print "$taxon_oid\t";
                print "$taxon_display_name\t";
                print "$gene_count\t";
                print "$seq_length\t";
                print "$gc_percent";
                if ($include_metagenomes) {
                    print "\t";
                    if ( !$read_depth && $data_type eq 'assembled' ) {
                        $read_depth = 1;
                    }
                    print "$read_depth\t";
                    my ($linDomain, $linPhylum, $linClass, $linOrder, $linFamily, $linGenus, $linSpecies ) = split(/;/, $lineage);
                    print "$linDomain\t";
                    print "$linPhylum\t";
                    print "$linClass\t";
                    print "$linOrder\t";
                    print "$linFamily\t";
                    print "$linGenus\t";
                    print "$linSpecies\t";
                    print "$lineage_perc";
                }
                print "\r\n";
            }
        }
    }

    if ( $wfh ) {
        close $wfh;
    }

}

############################################################################
# fastaFileForScaffolds - makes fasta file for selected scaffolds
############################################################################
sub fastaFileForScaffolds {
    my ($name_first) = @_;
    if ($name_first eq "") {
    	$name_first = 0;
    }

    my $contact_oid = getContactOid();
    if ( blankStr($contact_oid) ) {
        main::printAppHeader("AnaCart");
        webError("Your login has expired.");
        return;
    }

    my $oids_aref = getSelectedCartOids();
    my @scaffold_oids = @$oids_aref;

    if ( scalar(@scaffold_oids) == 0 ) {
        main::printAppHeader("AnaCart");
        webError("No scaffolds have been selected.");
        return;
    }

    require SequenceExportUtil;
    return SequenceExportUtil::getFastaFileForScaffolds(\@scaffold_oids, $name_first);
}

sub exportFasta {
    my $tmpFile = fastaFileForScaffolds();

    # download
    my $sz = fileSize($tmpFile);
    print "Content-type: text/plain\n";
    print "Content-Disposition: inline;filename=exportFasta\n";
    print "Content-length: $sz\n";
    print "\n";

    my $rfh = newReadFileHandle( $tmpFile, "downloadFastaFile" );
    while ( my $s = $rfh->getline() ) {
        chomp $s;
        print "$s\n";
    }
    close $rfh;
    wunlink($tmpFile);

    WebUtil::webExit(0);
}

## Too dependent on inconsistent assumptions of in all.fna.files.
## Use taxon.lin.fna/ instead via WebUtil::readLinearFasta().
## --es 09/28/09
sub exportFasta_old {
    my $contact_oid = getContactOid();
    if ( blankStr($contact_oid) ) {
        main::printAppHeader("AnaCart");
        webError("Your login has expired.");
        return;
    }

    my @scaffold_oids = param('scaffold_oid');
    if ( scalar(@scaffold_oids) == 0 ) {
        main::printAppHeader("AnaCart");
        webError("No scaffolds have been selected.");
        return;
    }

    my @all_files = ();

    # export data
    my $dbh = dbLogin();
    my $sz  = 0;
    for my $scaffold_oid (@scaffold_oids) {
        my $sql = QueryUtil::getSingleScaffoldTaxon();
        my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
        my ( $taxon_oid, $ext_acc ) = $cur->fetchrow();
        $cur->finish();

        if ( !$taxon_oid || !$ext_acc ) {
            next;
        }

        $taxon_oid = sanitizeInt($taxon_oid);

        # download fasta file
        checkTaxonPermHeader( $dbh, $taxon_oid );

        my $path = "$all_fna_files_dir/$taxon_oid/$ext_acc.fna";
        if ( !-e $path ) {
            webErrorHeader("File does not exist for download.");
        }

        push @all_files, ($path);
        $sz += fileSize($path);
    }
    #$dbh->disconnect();

    # download
    if ( scalar(@all_files) > 0 ) {
        print "Content-type: text/plain\n";
        print "Content-Disposition: inline;filename=exportFasta\n";
        print "Content-length: $sz\n";
        print "\n";

        for my $path (@all_files) {
            my $rfh = newReadFileHandle( $path, "downloadFastaFile" );
            #	    my $sz = fileSize( $path );
            while ( my $s = $rfh->getline() ) {
                chomp $s;
                print "$s\n";
            }
            close $rfh;
        }
    }

    WebUtil::webExit(0);
}

############################################################################
# exportGenbankForm - Print form for generating GenBank file.
############################################################################
sub exportGenbankForm {
    my $scaffold_oids_aref = getSelectedCartOids();
    my @scaffold_oids      = @$scaffold_oids_aref;
    my $scaffold_count     = scalar(@scaffold_oids);
    if ( $scaffold_count == 0 ) {
        webError("No scaffolds have been selected.");
        return;
    }

    my ( $dbOids_ref, $metaOids_ref ) =
      MerFsUtil::splitDbAndMetaOids(@scaffold_oids);
    if ( scalar(@$metaOids_ref) > 0 ) {
        my $extracted_oids_str =
          MerFsUtil::getExtractedMetaOidsJoinString(@$metaOids_ref);
        webError("You have selected scaffolds ($extracted_oids_str), which are MER-FS metagenomes from file.  They are not supported in generating GenBank File.");
    }

    my $dbh = dbLogin();
    my $sql = '';

    my $scaffold_oid_str =
	OracleUtil::getNumberIdsInClause( $dbh, @scaffold_oids );
    my $scaffoldInClause = " in ( $scaffold_oid_str ) ";

    my $rclause   = WebUtil::urClause('scf.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('scf.taxon');

    $sql = qq{
        select scf.scaffold_oid, scf.ext_accession,
	       scf.scaffold_name, ss.seq_length
        from scaffold scf, scaffold_stats ss
        where scf.scaffold_oid $scaffoldInClause
        and scf.scaffold_oid = ss.scaffold_oid
        $rclause
        $imgClause
        order by ss.seq_length desc, scf.ext_accession
    };

    GenerateArtemisFile::printGenerateForm
	( $dbh, $sql, '', '', \@scaffold_oids,
	  scalar(@scaffold_oids) );
}

#############################################################################
# printHistogram
#############################################################################
sub printHistogram {
    my $contact_oid = getContactOid();
    if ( blankStr($contact_oid) ) {
        webError("Your login has expired.");
        return;
    }

    my $oids_aref     = getSelectedCartOids();
    my @scaffold_oids = @$oids_aref;

    if ( scalar(@scaffold_oids) == 0 ) {
        webError("No scaffolds have been selected.");
        return;
    }

    printStatusLine( "Loading ...", 1 );
    printMainForm();

    foreach my $scaffold_oid (@scaffold_oids) {
        print hiddenVar( 'scaffold_oid', $scaffold_oid );
    }

    my $h_type = param('histogram_type');
    if ( ! $h_type ) {
        $h_type = 'gene_count';
    }
    my $data_type = param('data_type_h');
    HistogramUtil::printScaffoldHistogram
	( $h_type, \@scaffold_oids, $data_type );

    printStatusLine( "Loaded", 2 );
    print end_form();

    printHistogramJS();
}

###########################################################################
# addSelectedScaffoldGenesToCart
###########################################################################
sub addSelectedScaffoldGenesToCart {
    my @scaffold_oids = param('scaffold_oid');

    if ( scalar(@scaffold_oids) == 0 ) {
        main::printAppHeader("AnaCart");
        webError("No scaffolds have been selected.");
        return;
    }

    my ( $dbOids_ref, $metaOids_ref ) =
      MerFsUtil::splitDbAndMetaOids(@scaffold_oids);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;

    my $dbh       = dbLogin();
    my @gene_oids = ();

    if ( scalar(@dbOids) > 0 ) {
        my %oid_hash = QueryUtil::fetchScaffoldGeneOidsHash( $dbh, @dbOids );
        push( @gene_oids, keys(%oid_hash) );
    }

    if ( scalar(@metaOids) > 0 ) {
        my %taxon_oid_hash =
          MerFsUtil::fetchValidMetaTaxonOidHash( $dbh, @metaOids );
        for my $oid (@metaOids) {
            my ( $taxon_oid, $data_type, $scaffold_oid ) = split( / /, $oid );
            if ( !exists( $taxon_oid_hash{$taxon_oid} ) ) {
                #$taxon_oid not in hash due to permission
                next;
            }

            my @genes_on_s =
              MetaUtil::getScaffoldGenes( $taxon_oid, $data_type,
                $scaffold_oid );
            for my $g (@genes_on_s) {
                my (
                    $gene_oid,          $locus_type,  $locus_tag,
                    $gene_display_name, $start_coord, $end_coord,
                    $strand,            $seq_id,      $source
                  )
                  = split( /\t/, $g );
                my $workspace_id = "$taxon_oid assembled $gene_oid";
                push( @gene_oids, $workspace_id );
            }
        }

    }

    #$dbh->disconnect();

    # show gene cart
    setSessionParam( "lastCart", "geneCart" );
    main::printAppHeader("AnaCart");
    my $gc = new GeneCartStor();
    $gc->addGeneBatch( \@gene_oids );
    $gc->printGeneCartForm( '', 1 );
}

#
# scaffold cart file
sub getStateFile {
    my ($cartDir, $sessionId) = WebUtil::getCartDir();
    my $sessionFile = "$cartDir/scaffoldCart.$sessionId.stor";
    #print "getStateFile() sessionFile: $sessionFile<br/>\n";
    return $sessionFile;
}

sub getSize {
    my $aref = readCartFile();
    if($aref eq '') {
        return 0;
    }
    
    my $s = $#$aref + 1;
    return $s;
}

#
# read session scaffold cart
sub readCartFile {
    my @records;
    my $res = newReadFileHandle( getStateFile(), "runJob", 1 );
    if ( !$res ) {
        return \@records;
    }
    while ( my $line = $res->getline() ) {
        chomp $line;
        next if ( $line eq "" );

        #my ( $s_oid, $contact_oid, $batch_id, $name ) = split( /\t/, $line );
        push( @records, $line );
    }
    close $res;
    return \@records;
}

sub printUploadScaffoldCartForm {
    print "<h1>Upload Scaffold Cart</h1>\n";

    # need a different ENCTYPE for file upload
    print start_form(
        -name    => "mainForm",
        -enctype => "multipart/form-data",
        -action  => "$section_cgi"
    );
    printUploadScaffoldCartFormContent();
    print end_form();
}

sub printUploadScaffoldCartFormContent {
    my ($fromUploadSection) = @_;

    print "<p>\n";
    print "You may upload a scaffold cart from a tab-delimited file.<br/>\n";
    print "The file should have the column headers 'Scaffold ID'.<br/>\n";
    if ( $fromUploadSection eq 'Yes' ) {
        print qq{
           (This file can be created by selecting
            <font color="blue"><u>Scaffold Cart in Excel</u></font> button below.)<br/>\n
        };
    }
    else {
        print "(This file may initially be obtained by exporting "
          . "scaffolds in a scaffold cart to Excel.)<br/>\n";
    }
    print "<br/>\n";

    my $textFieldId = "cartUploadFile";
    print "File to upload:<br/>\n";
    print
      "<input id='$textFieldId' type='file' name='uploadFile' size='45'/>\n";

    print "<br/>\n";
    my $name = "_section_ScaffoldCart_uploadScaffoldCart";
    print submit(
        -name    => $name,
        -value   => "Upload from File",
        -class   => "medbutton",
        -onClick => "return uploadFileName('$textFieldId');",
    );

    if ($user_restricted_site) {
        print nbsp(1);
        my $url = "$main_cgi?section=WorkspaceScafSet&page=home";
        print buttonUrl( $url, "Upload from Workspace", "medbutton" );
    }

    print "</p>\n";
}

# import from text files - reset batch id
sub uploadScaffoldCart {
    my ($self) = @_;

    require MyIMG;
    my @scaffold_oids;
    my %upload_cart_names;
    my $errmsg;
    if (
        !MyIMG::uploadIdsFromFile(
            "Scaffold,Scaffold OID,Scaffold ID", \@scaffold_oids,
            \$errmsg,       "Cart Name",
            \%upload_cart_names
        )
      )
    {
        printStatusLine( "Error.", 2 );
        webError($errmsg);
    }

    # check what's already in the cart
    my %s_carts;    # file scaffold oids
    my $records_aref = readCartFile();
    my %cart_names;      # file cart names
    my %cartname2oid;    # scaffold cart name => virtual taxon oid
    foreach my $line (@$records_aref) {
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        $s_oid = WebUtil::strTrim($s_oid);
        $s_carts{$s_oid}     = $batch_id;
        $cart_names{$s_oid}  = "$name\t$virtual_taxon_oid";
        $cartname2oid{$name} = $virtual_taxon_oid;
    }

    my $next_batch             = getNextBatchId($records_aref);
    my $next_virtual_taxon_oid = getNextVirtualTaxonOid($records_aref);

    my @sqlList;         # new scaffolds to add

    # what is uploaded
    foreach my $scaffold_oid (@scaffold_oids) {
        #if ( !isInt($scaffold_oid) ) {
        #    my ( $taxon_oid, $data_type, $s_oid ) = split( / /, $scaffold_oid );
        #    if ( !($data_type eq 'assembled') ) {
        #        #only allow assembled
        #        next;
        #    }
        #}
        if ( exists $s_carts{$scaffold_oid} ) {
            $s_carts{$scaffold_oid}    = $next_batch;
            $cart_names{$scaffold_oid} = $upload_cart_names{$scaffold_oid};

        }
        else {
            $s_carts{$scaffold_oid}    = $next_batch;
            $cart_names{$scaffold_oid} = $upload_cart_names{$scaffold_oid};

            # new to be added
            my $name              = $cart_names{$scaffold_oid};
            my $virtual_taxon_oid = "";
            if ( $name ne "" && exists $cartname2oid{$name} ) {
                $virtual_taxon_oid = $cartname2oid{$name};
            }
            elsif ( $name ne "" ) {
                $virtual_taxon_oid = $next_virtual_taxon_oid;
                $cartname2oid{$name} = $virtual_taxon_oid;
                $next_virtual_taxon_oid--;
            }
            push @sqlList,
"$scaffold_oid\t$contact_oid\t$next_batch\t$name\t$virtual_taxon_oid\n";
        }
    }

    # write to file
    my $res = newWriteFileHandle( getStateFile(), "runJob" );
    foreach my $line (@$records_aref) {
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );

        # new batch id
        $name = $cart_names{$s_oid};
        print $res
          "$s_oid\t$contact_oid\t$next_batch\t$name\t$virtual_taxon_oid\n";

    }

    foreach my $line (@sqlList) {
        print $res "$line\n";
    }
    close $res;
}

# update  scaffold cart name
sub updateCartName {
    my $cart_name     = param("cart_name");
    my @scaffold_oids = param('scaffold_oid');

    if ( scalar(@scaffold_oids) == 0 ) {
        webError("Please select at least 1 scaffold for the cart.");
        return;
    }
    if ( $cart_name eq "" ) {
        webError("Please provide a name for your cart.");
        return;
    }
    my %scaffold_oids_hash;
    foreach my $sid (@scaffold_oids) {
        $scaffold_oids_hash{$sid} = $cart_name;
    }

    # what's already in the cart
    my @s_carts;
    my $records_aref = readCartFile();

    # get next virtual taxon oid
    my $next_virtual_taxon_oid = getNextVirtualTaxonOid($records_aref);

    my $res = newWriteFileHandle( getStateFile(), "update" );
    foreach my $line (@$records_aref) {
        chomp $line;
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        $s_oid = WebUtil::strTrim($s_oid);
        if ( exists $scaffold_oids_hash{$s_oid} ) {
            print $res
"$s_oid\t$contact_oid\t$batch_id\t$cart_name\t$next_virtual_taxon_oid\n";
        }
        else {
            print $res "$line\n";
        }
    }

    close $res;
}

# gets scaffold oids by scaffold cart name
# return aref of scaffold  oids, empty if nothing found
sub getScaffoldByCartName {
    my ($cart_name) = @_;
    my $records_aref = readCartFile();
    my @soids;
    foreach my $line (@$records_aref) {
        chomp $line;
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        $s_oid = WebUtil::strTrim($s_oid);
        if ( $name eq $cart_name ) {
            push( @soids, $s_oid );
        }
    }
    return \@soids;
}

# get distinct list of scaffold cart names
# return hash ref name => name
sub getCartNames {
    my $records_aref = readCartFile();
    my %hash;
    foreach my $line (@$records_aref) {
        chomp $line;
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        if ( $name ne "" ) {
            $hash{$name} = $name;
        }
    }
    return \%hash;
}

# get distinct list of scaffold cart names with aref of scaffold oids
# return hash ref name => aref of scaffold oids
#
sub getCartNamesWithSoids {
    my $records_aref = readCartFile();
    my %hash;
    foreach my $line (@$records_aref) {
        chomp $line;
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        $s_oid = WebUtil::strTrim($s_oid);
        if ( $name ne "" ) {
            if ( exists $hash{$name} ) {
                my $aref = $hash{$name};
                push( @$aref, $s_oid );
            }
            else {
                my @a = ($s_oid);
                $hash{$name} = \@a;
            }
        }
    }
    return \%hash;
}

# all scaffold oids in cart
sub getAllScaffoldOids {
    my $records_aref = readCartFile();
    my @list;
    foreach my $line (@$records_aref) {
        chomp $line;
        my ( $s_oid, $contact_oid, $batch_id, $name, $virtual_taxon_oid ) =
          split( /\t/, $line );
        $s_oid = WebUtil::strTrim($s_oid);
        push( @list, $s_oid );
    }
    return \@list;
}

#
# get selected scaffold oids
#
sub getSelectedCartOids {
    my @scaffold_oids = param('scaffold_oid');
    return \@scaffold_oids;
}

sub isCartEmpty {
    my $res = newReadFileHandle( getStateFile(), "runJob", 1 );
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

###############################################################################
# saveScaffoldDistToCart: save to scaffold cart based on scaffold distribution
###############################################################################
sub saveScaffoldDistToCart {

    my $taxon_oid = param('taxon_oid');
    if ( !$taxon_oid ) {
        webError("Unknown Taxon ID.");
        return;
    }
    my $dist_type = param('dist_type');
    #print "saveScaffoldDistToCart() dist_type=$dist_type<br/>\n";
    if ( !$dist_type ) {
        webError("Distribution type unknown.");
        return;
    }

    # selected scaffold counts or lengths
    my @ids = param($dist_type);
    #print "saveScaffoldDistToCart() ids=@ids<br/>\n";
    if ( $#ids < 0 ) {
        webError("Please select some scaffolds to save.");
        return;
    }

    printStartWorkingDiv();
    print "<p>\n";

    my $t2 = 'assembled';

    my %h2;
    for my $id2 (@ids) {
        my ( $trunc, @lines );

        if ( $dist_type eq 'seq_length' ) {
            my ( $min_length, $max_length ) = split( /\:/, $id2 );
            print "Retrieving scaffolds with sequence length $min_length .. $max_length ...<br/>\n";
            webLog("$min_length, $max_length\n\n");
            my ( $trunc2, $lines_ref, $scafs_ref ) =
              MetaUtil::getScaffoldStatsInLengthRange( $taxon_oid, $t2, $min_length, $max_length );
            $trunc = $trunc2;
            @lines = @$lines_ref;

        } elsif ( $dist_type eq 'gene_count' ) {
            my $i2 = sanitizeInt($id2);
            print "Retrieving scaffolds with gene count = $i2 ...<br/>\n";
            webLog("$i2\n\n");
            my ( $trunc2, $lines_ref, $scafs_ref ) = MetaUtil::getScaffoldStatsWithFixedGeneCnt( $taxon_oid, $t2, $i2 );
            $trunc = $trunc2;
            @lines = @$lines_ref;

        } else {
            webError("Cannot find dist type.");
            return;
        }

        for my $line (@lines) {
            my ( $scaf_oid, $seq_len, $gc_percent, $gene_cnt )
		= split( /\t/, $line );

            my $workspace_id = "$taxon_oid $t2 $scaf_oid";
            if ( $h2{$workspace_id} ) {
                # already in
                next;
            }
            $h2{$workspace_id} = 1;
        }

    }

    printEndWorkingDiv();

    my @scaffold_oids = keys %h2;
    addToScaffoldCart(\@scaffold_oids);
}


###########################################################################
# printValidationJS - Checks for scaffold selection and blank cart name
###########################################################################
sub printValidationJS {
    print qq{
        <script language='JavaScript' type='text/javascript'>
        function isBlankCartName(cart) {
            if (cart.value == "") {
                alert ("Please provide a name for your cart.");
                cart.focus();
                return false;
            } else {
                return validateSelection(1);
            }
        }

        function validateSelection(num) {
            //alert("inside validateSelection " + num);
            var els = document.getElementsByTagName('input');

            var count = 0;
            for (var i = 0; i < els.length; i++) {
                var e = els[i];

                if (e.type == "checkbox" &&
                    e.name == "scaffold_oid" &&
                    e.checked == true) {
                    count++;
                }
            }
            //alert("count " + count);

            if (count < num) {
                if (num == 1) {
                    alert("Please select some scaffolds");
                } else {
                    alert("Please select at least "+num+" scaffolds");
                }
                return false;
            }

            return true;
        }
        </script>
    };
}

###########################################################################
# printHistogramJS - Better usage of screen real estate with plots
###########################################################################
sub printHistogramJS {
    print <<END_JS;

    <script language="javascript" type="text/javascript">
	var objDiv = document.getElementById("content_other");
	if (objDiv) {
	    objDiv.style.width = "100%";
	}
    </script>
END_JS
}

1;

