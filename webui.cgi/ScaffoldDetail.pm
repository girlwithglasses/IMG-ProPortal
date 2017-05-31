############################################################################
# Utility subroutines for scaffold detail
# $Id: ScaffoldDetail.pm 36987 2017-04-24 20:40:20Z klchu $
############################################################################
package ScaffoldDetail;

my $section = "ScaffoldDetail";

use strict;
use CGI qw( :standard );
use Data::Dumper;
use DBI;
use WebConfig;
use WebUtil;
use OracleUtil;
use QueryUtil;
use MetaUtil;
use ScaffoldDataUtil;
use GeneDataUtil;

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
my $pfam_base_url = $env->{pfam_base_url};

my $preferences_url    = "$main_cgi?section=MyIMG&page=preferences";
my $maxGeneListResults = 1000;
if ( getSessionParam("maxGeneListResults") ne "" ) {
    $maxGeneListResults = getSessionParam("maxGeneListResults");
}

my $dDelim = "===";
my $fDelim = "<<>>";


sub getPageTitle {
    return 'Scaffold Detail';
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

    if ( $page eq "scaffoldDetail" ) {
        printScaffoldDetail();
    }
    elsif ( $page eq "geneWithFunc" ) {
        scaffoldGenesWithFunc();
    }
    elsif ( $page eq "scaffoldGenes" ) {
        scaffoldGenesWithFunc();
    }
    elsif ( $page eq "scaffoldGenesInRange" ) {
        scaffoldGenesInRange();
    }
    elsif ( $page eq "scaffoldBins" ) {
        scaffoldBins();
    }
    elsif ( $page eq 'selectedScaffolds' ) {
        printSelectedScaffolds();
    }
}

############################################################################
# printScaffoldDetail
############################################################################
sub printScaffoldDetail {

    my $contact_oid = getContactOid();
    if ( blankStr($contact_oid) ) {

        WebUtil::webErrorHeader("Your login has expired.");
        return;
    }

    my $scaffold_oid = param('scaffold_oid');
    if ( !$scaffold_oid ) {

        WebUtil::webErrorHeader("No scaffold has been selected.");
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
        WebUtil::webError("Scaffold does not exist.");
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
    my $url2 = "$main_cgi?section=$section"
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
           from gold_sequencing_project g, taxon t
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
           from gold_sp_habitat g, taxon t
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

    if ( $virus ) {
        require Viral;
	Viral::printViralScafInfo($dbh, $taxon_oid, $scaffold_oid);
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

    printScaffoldCrisprDetail( $dbh, $scaffold_oid );

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
# printScaffoldCrisprDetail
############################################################################
sub printScaffoldCrisprDetail {
    my ( $dbh, $scaffold_oid, $scf_start_coord, $scf_end_coord ) = @_;

    if ( !$scaffold_oid ) {
        return "";
    }
    
    my @recs = ScaffoldDataUtil::getScaffoldCrisprDetail( $dbh, $scaffold_oid, $scf_start_coord, $scf_end_coord );
    if ( scalar(@recs) <= 0 ) {
        return "";
    }
   
    ScaffoldDataUtil::printScaffoldCrisprDetailTable(@recs);   
}


############################################################################
# printSelectedScaffolds
############################################################################
sub printSelectedScaffolds {

    my $scaffold_str = param('scaffold_oids');
    my @scaffold_oids = split( /\,/, $scaffold_str );

    my $cnt = scalar(@scaffold_oids);
    print "<h1>Selected Scaffolds (Count: $cnt)</h1>\n";

    printMainForm();

    print "<p>\n";    # paragraph section puts text in proper font.

    my ( $dbOids_ref, $metaOids_ref ) =
      MerFsUtil::splitDbAndMetaOids(@scaffold_oids);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;

    if ( scalar(@dbOids) > 0 ) {
        my $dbh = dbLogin();
        my $sql = "select scaffold_name from scaffold where scaffold_oid = ?";
        my $cur = prepSql( $dbh, $sql, $verbose );
        for my $scaffold_oid (@dbOids) {
            execStmt( $cur, $scaffold_oid );
            my ($scaffold_name) = $cur->fetchrow();
            my $url2 =
                "$main_cgi?section=ScaffoldDetail"
              . "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
            print "<br/>\n";
            print alink( $url2, $scaffold_name );
        }
    }

    if ( scalar(@metaOids) > 0 ) {
        for my $scaffold_oid (@metaOids) {
            my ( $taxon_oid, $data_type, $s_oid ) = split( / /, $scaffold_oid );

            my $url2 =
                "$main_cgi?section=MetaScaffoldDetail"
              . "&page=metaScaffoldDetail&scaffold_oid=$s_oid"
              . "&taxon_oid=$taxon_oid&data_type=$data_type";
            print "<br/>\n";
            print alink( $url2, $s_oid );
        }
    }

    print "</p>\n";

    print end_form();
}


############################################################################
# scaffoldGenesWithFunc
############################################################################
sub scaffoldGenesWithFunc {

    my $scaffold_oid = param('scaffold_oid');
    if ( !$scaffold_oid ) {
        WebUtil::webError("No scaffold");
        return;
    }

    my $func_id = param('func_id');

    my $dbh = dbLogin();

    my %genes;
    my $g_cnt     = 0;
    my $last_gene = 0;

    my $scf_url;
    if ( isInt($scaffold_oid) ) {
        $scf_url = "$main_cgi?section=$section"
             . "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
        my @binds;
        my $sql = "";
        if ($func_id) {
            ($sql, @binds) = getScaffoldFuncGeneQuery($func_id, $scaffold_oid);
            #print "scaffoldGenesWithFunc() func_id: $func_id, sql: $sql<br/>\n";
            #print "scaffoldGenesWithFunc() bindList: @binds<br/>\n";
        }
        else {
            my $rclause   = WebUtil::urClause('g.taxon');
            my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
            $sql = qq{
                select g.gene_oid, g.gene_display_name
                from gene g
                where g.scaffold = ?
                and g.obsolete_flag = 'No'
                $rclause
                $imgClause
            };
            push( @binds, $scaffold_oid );
        }

        my $cur = execSql( $dbh, $sql, $verbose, @binds );
        for ( ; ; ) {
            my ( $g_oid, $g_name ) = $cur->fetchrow();
            last if !$g_oid;

            $g_cnt++;
            if ( $g_cnt > $maxGeneListResults ) {
                last;
            }
            if ( $g_cnt > 10000000 ) {
                last;
            }

            $genes{$g_oid} = $g_name;
            $last_gene = $g_oid;
        }
        $cur->finish();
    }
    else {
        my ( $taxon_oid, $data_type, $s_oid ) = split( / /, $scaffold_oid );
        $scf_url = "$main_cgi?section=MetaScaffoldDetail&page=metaScaffoldDetail"
             . "&scaffold_oid=$scaffold_oid&taxon_oid=$taxon_oid&data_type=$data_type";

        my @genes_on_s;
        if ($func_id) {
            @genes_on_s =
              MetaUtil::getScaffoldFuncGenes( $taxon_oid, $data_type, $s_oid,
                $func_id );
        }
        else {
            @genes_on_s =
              MetaUtil::getScaffoldGenes( $taxon_oid, $data_type, $s_oid );
        }
        for my $g (@genes_on_s) {
            my (
                $g_oid,             $locus_type,  $locus_tag,
                $gene_display_name, $start_coord, $end_coord,
                $strand,            $seq_id,      $source
              )
              = split( /\t/, $g );

            $g_cnt++;
            if ( $g_cnt > $maxGeneListResults ) {
                last;
            }
            if ( $g_cnt > 10000000 ) {
                last;
            }

            my $workspaceId = "$taxon_oid $data_type $g_oid";
            if ( blankStr($gene_display_name) ) {
                $gene_display_name = "hypothetical protein";
            }
            $genes{$workspaceId} = $gene_display_name;
            $last_gene = $workspaceId;
        }
    }

    if ( $g_cnt == 1 && $last_gene && isInt($last_gene) ) {
        require GeneDetail;
        GeneDetail::printGeneDetail($last_gene);
    }
    elsif ( $g_cnt >= 1 ) {    #$g_cnt == 1 for meta gene
        printMainForm();
        if ($func_id) {
            print "<h1>Genes in Scaffold with Function</h1>\n";
        }
        else {
            print "<h1>Genes in Scaffold</h1>\n";
        }

        if ( $g_cnt > $maxGeneListResults ) {
            my $s = "Results limited to $maxGeneListResults genes.\n";
            $s .= "( Go to "
              . alink( $preferences_url, "Preferences" )
              . " to change \"Max. Gene List Results\" limit. )\n";
            printStatusLine( $s, 2 );
            print "<br/>\n";
        }
        else {
            printStatusLine( "$g_cnt genes retrieved.", 2 );
        }

        print "<p>";
        print "Scaffold: ";
        my $scaffold_name = getScaffoldName( $dbh, $scaffold_oid );
        if ( $scaffold_name ) {
            print alink($scf_url, escapeHTML($scaffold_name));
        }
        print " ($scaffold_oid)";
        print "</p>";

        if ($func_id) {
            my @func_ids = ( $func_id );
            my %funcId2Name = QueryUtil::fetchFuncIdAndName($dbh, \@func_ids);
            my ($func_name) = $funcId2Name{$func_id};
            print "<p>";
            print "Function: ";
            if ( $func_name ) {
                print escapeHTML($func_name);
            }
            print " ($func_id)";
            print "</p>";
        }

        my $it = new InnerTable( 1, "genelist$$", "genelist", 1 );
        my $sd = $it->getSdDelim();    # sort delimiter
        $it->addColSpec( "Select" );
        $it->addColSpec( "Gene ID",           "number asc", "right" );
        $it->addColSpec( "Gene Product Name", "char asc",   "left" );

        my @gene_oids = sort( keys(%genes) );
        for my $workspace_id (@gene_oids) {
            my $r;
            $r .= $sd
              . "<input type='checkbox' name='gene_oid' "
              . "value='$workspace_id' />" . "\t";

            my $taxon_oid;
            my $data_type;
            my $gene_oid;
            if ( $workspace_id && isInt($workspace_id) ) {
                $gene_oid = $workspace_id;
                $data_type = 'database';
            }
            else {
                ( $taxon_oid, $data_type, $gene_oid ) =
                  split( / /, $workspace_id );
            }

            my $gene_url;
            if ( $data_type eq 'database' ) {
                $gene_url =
                    "$main_cgi?section=GeneDetail"
                  . "&page=geneDetail&gene_oid=$gene_oid";
            }
            else {
                $gene_url =
                    "$main_cgi?section=MetaGeneDetail"
                  . "&page=metaGeneDetail&data_type=$data_type"
                  . "&taxon_oid=$taxon_oid&gene_oid=$gene_oid";
            }
            $r .= $workspace_id . $sd . alink( $gene_url, $gene_oid ) . "\t";

            my $gene_display_name;
            if ( $data_type eq 'database' ) {
                $gene_display_name = $genes{$gene_oid};
            }
            else {
                $gene_display_name = $genes{$workspace_id};
            }
            $r .= $gene_display_name . $sd . $gene_display_name . "\t";

            $it->addRow($r);
        }

        if ( $g_cnt > 10 ) {
            WebUtil::printGeneCartFooterWithToggle();
        }
        $it->printOuterTable(1);
        WebUtil::printGeneCartFooterWithToggle();

        print end_form() if $g_cnt > 0;
    }

}

sub getScaffoldFuncGeneQuery {
    my ($id, $scaffold_oid) = @_;

    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');

    my $sql;
    my @bindList = ();

    if ( $id =~ /^GO/ ) {
    }
    elsif ( $id =~ /^COG/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_cog_groups gcg, gene g
            where gcg.cog = ?
            and gcg.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^KOG/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_kog_groups gcg, gene g
            where gcg.kog = ?
            and gcg.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^pfam/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_pfam_families gpf, gene g
            where gpf.pfam_family = ?
            and gpf.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^TIGR/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_tigrfams gtf, gene g
            where gtf.ext_accession = ?
            and gtf.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^IPR/ ) {
    }
    elsif ( $id =~ /^EC:/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_ko_enzymes ge, gene g
            where ge.enzymes = ?
            and ge.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^TC:/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_tc_families gt, gene g
            where gt.tc_family = ?
            and gt.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^KO:/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_ko_terms gt, gene g
            where g.ko_terms = ?
            and gt.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^BC:/ ) {
        $sql = qq{
            select distinct bcg.gene_oid, g.gene_display_name
            from bio_cluster_features_new bcg, gene g
            where bcg.cluster_id = ?
            and bcg.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        my $id_shortened = $id;
        $id_shortened =~ s/BC://;
        push( @bindList, $id_shortened );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^MetaCyc:/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from biocyc_reaction_in_pwys brp, biocyc_reaction br,
                gene_biocyc_rxns gb, gene g
            where gb.gene_oid = g.gene_oid
            and gb.ec_number = br.ec_number
            and gb.biocyc_rxn = br.unique_id
            and br.unique_id = brp.unique_id
            and brp.in_pwys = ?
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        my $id_shortened = $id;
        $id_shortened =~ s/MetaCyc://;
        push( @bindList, $id_shortened );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^IPWAY:/ ) {
        $sql = qq{
            select g.gene_oid, g.gene_display_name
            from gene_img_functions gf, img_reaction_catalysts irc,
                 img_pathway_reactions ipr, gene g
            where ipr.pathway_oid = ?
            and ipr.rxn = irc.rxn_oid
            and irc.catalysts = gf.function
            and gf.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
                union
            select g.gene_oid, g.gene_display_name
            from gene_img_functions gf, img_reaction_t_components itc,
                 img_pathway_reactions ipr, gene g
            where ipr.pathway_oid = ?
            and ipr.rxn = itc.rxn_oid
            and itc.term = gf.function
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        my $id_shortened = $id;
        $id_shortened =~ s/IPWAY://;
        push( @bindList, $id_shortened );
        push( @bindList, $scaffold_oid );
        push( @bindList, $id_shortened );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^PLIST:/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from img_parts_list_img_terms plt,
              gene_img_functions gf, gene g
            where plt.parts_list_oid = ?
            and plt.term = gf.function
            and gf.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        my $id_shortened = $id;
        $id_shortened =~ s/PLIST://;
        push( @bindList, $id_shortened );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^ITERM:/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_img_functions gf, gene g
            where gf.function = ?
            and gf.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        my $id_shortened = $id;
        $id_shortened =~ s/ITERM://;
        push( @bindList, $id_shortened );
        push( @bindList, $scaffold_oid );
    }
    elsif ( $id =~ /^EGGNOG/ ) {
        $sql = qq{
            select distinct g.gene_oid, g.gene_display_name
            from gene_eggnogs ge, gene g
            where ge.nog_id = ?
            and ge.gene_oid = g.gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
        };
        push( @bindList, $id );
        push( @bindList, $scaffold_oid );
    }
    #print "getScaffoldFuncGeneQuery() sql: $sql<br/\n>";
    #print "getScaffoldFuncGeneQuery() bindList: @bindList<br/\n>";

    return ($sql, @bindList);
}

############################################################################
# scaffoldGenesInRange
############################################################################
sub scaffoldGenesInRange {
    my ( $noTitle ) = @_;

    printMainForm();

    my $scaffold_oid = param('scaffold_oid');
    if ( !$scaffold_oid ) {

        WebUtil::webErrorHeader("No scaffold has been selected.");
        return;
    }

    my $dbh = dbLogin();    
    WebUtil::checkScaffoldPerm( $dbh, $scaffold_oid );
    my $seq_length = QueryUtil::fetchSingleScaffoldLength($dbh, $scaffold_oid);

    my $start_coord = param('start_coord');
    my $end_coord = param('end_coord');
    $start_coord =~ s/\s+//g;
    $end_coord   =~ s/\s+//g;
    if ( !isInt($start_coord) ) {
        WebUtil::webError("Expected integer for start coordinate.");
    }
    if ( !isInt($end_coord) ) {
        WebUtil::webError("Expected integer for end coordinate.");
    }
    if ( $start_coord < 1 ) {
        WebUtil::webError("Start coordinate should be greater or equal to 1.");
    }
    if ( $start_coord > $end_coord ) {
        WebUtil::webError("Start coordinate should be "
               . "less than or equal to the end coordinate.");
    }
    if ( $end_coord > $seq_length && $seq_length > 0 ) {
        WebUtil::webError("End coordinate should be "
               . "less than or equal to $seq_length.");
    }

    if ( !$noTitle ) {
        print "<h1>Scaffold Genes in Range</h1>\n";        
    }
    print "<p>";
    print "Scaffold: ";
    my $scf_url = "$main_cgi?section=$section" 
        . "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
    my $scaffold_name = getScaffoldName( $dbh, $scaffold_oid );
    if ( $scaffold_name ) {
        print alink($scf_url, escapeHTML($scaffold_name));
    }
    print " ($scaffold_oid)<br/>\n";
    print "coordinates: $start_coord - $end_coord<br/>\n";
    print "</p>";

    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');

    #use: "and ((g.end_coord > ? and g.end_coord <= ?) or (g.start_coord >= ? and g.start_coord < ?))"
    #instead of "and g.start_coord >= ? and g.end_coord <= ?"
    #to make sure that the genes that starts below the starting range but ends within the range, 
    #or starts below the ending range but ends beyond the ending range, get in
    my $sql = qq{
        select g.gene_oid, g.locus_tag, g.gene_display_name, g.start_coord, g.end_coord
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

    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid,
        $start_coord, $end_coord, $start_coord, $end_coord );

    my %genes;
    my %gene2locus;
    my %gene2start;
    my %gene2end;
    my $g_cnt     = 0;
    my $last_gene = 0;
    for ( ; ; ) {
        my ( $g_oid, $g_name, $locus_tag, $start_coord, $end_coord ) = $cur->fetchrow();
        last if !$g_oid;

        $g_cnt++;
        if ( $g_cnt > $maxGeneListResults ) {
            last;
        }
        if ( $g_cnt > 10000000 ) {
            last;
        }

        $genes{$g_oid} = $g_name;
        $gene2locus{$g_oid} = $locus_tag;
        $gene2start{$g_oid} = $start_coord;
        $gene2end{$g_oid} = $end_coord;
        $last_gene = $g_oid;
    }
    $cur->finish();

    my @gene_oids = sort( keys(%genes) );
    my $pfamQueryClause = ", pf.ext_accession, pf.name ";
    my $gidInClause = OracleUtil::getIdClause( $dbh, 'gtt_num_id', '', \@gene_oids );    
    my $gene2pfams_href = GeneDataUtil::getGene2Pfam
        ($dbh, \@gene_oids, $pfamQueryClause, $gidInClause);
    OracleUtil::truncTable( $dbh, "gtt_num_id" )
      if ( $gidInClause =~ /gtt_num_id/i );


    my $it = new InnerTable( 1, "genelist$$", "genelist", 1 );
    my $sd = $it->getSdDelim();    # sort delimiter
    $it->addColSpec( "Select" );
    $it->addColSpec( "Gene ID",           "number asc", "right" );
    $it->addColSpec( "Locus Tag",         "char asc", "left" );
    $it->addColSpec( "Gene Product Name", "char asc",   "left" );
    $it->addColSpec( "Start Coordinate", "number asc", "right" );
    $it->addColSpec( "End Coordinate", "number asc", "right" );
    $it->addColSpec( "Pfam", "char asc",   "left" );

    for my $workspace_id (@gene_oids) {
        my $r;
        $r .= $sd
          . "<input type='checkbox' name='gene_oid' "
          . "value='$workspace_id' />" . "\t";

        #leave meta code for future
        my $taxon_oid;
        my $data_type;
        my $gene_oid;
        if ( $workspace_id && isInt($workspace_id) ) {
            $gene_oid = $workspace_id;
            $data_type = 'database';
        }
        else {
            ( $taxon_oid, $data_type, $gene_oid ) =
              split( / /, $workspace_id );
        }

        my $gene_url;
        if ( $data_type eq 'database' ) {
            $gene_url =
                "$main_cgi?section=GeneDetail"
              . "&page=geneDetail&gene_oid=$gene_oid";
        }
        else {
            $gene_url =
                "$main_cgi?section=MetaGeneDetail"
              . "&page=metaGeneDetail&data_type=$data_type"
              . "&taxon_oid=$taxon_oid&gene_oid=$gene_oid";
        }
        $r .= $workspace_id . $sd . alink( $gene_url, $gene_oid ) . "\t";

        my $gene_display_name;
        my $locus_tag;
        my $start_coord;
        my $end_coord;
        if ( $data_type eq 'database' ) {
            $gene_display_name = $genes{$gene_oid};
            $locus_tag = $gene2locus{$gene_oid};
            $start_coord = $gene2start{$gene_oid};
            $end_coord = $gene2end{$gene_oid};
        }
        else {
            $gene_display_name = $genes{$workspace_id};
            $locus_tag = $gene2locus{$workspace_id};
            $start_coord = $gene2start{$workspace_id};
            $end_coord = $gene2end{$workspace_id};
        }
        $r .= $gene_display_name . $sd . $gene_display_name . "\t";
        $r .= $locus_tag . $sd . $locus_tag . "\t";
        $r .= $start_coord . $sd . $start_coord . "\t";
        $r .= $end_coord . $sd . $end_coord . "\t";

        my $colVal = $gene2pfams_href->{$gene_oid};
        my $pfam_all;
        my @pfamIdNameGroups = split($fDelim, $colVal);
        foreach my $pfamIdName (@pfamIdNameGroups) {
            my ($pfamId, $pfamName) = split($dDelim, $pfamIdName);
            my $pfam_id2 = $pfamId;
            $pfam_id2 =~ s/pfam/PF/i;
            my $pfamid_url = alink($pfam_base_url . $pfam_id2, $pfamId);
            $pfam_all .= $pfamid_url . " - " . $pfamName . "<br/><br/>";
        }
        $r .= $colVal . $sd . $pfam_all . "\t";
        #print "addCols2Row() col=$col colVal=$colVal pfam_all=$pfam_all<br/>\n";

        $it->addRow($r);
    }

    if ( $g_cnt > 10 ) {
        WebUtil::printGeneCartFooterWithToggle();
    }
    $it->printOuterTable(1);
    WebUtil::printGeneCartFooterWithToggle();

    print end_form();

    if ( $g_cnt > $maxGeneListResults ) {
        my $s = "Results limited to $maxGeneListResults genes.\n";
        $s .= "( Go to "
          . alink( $preferences_url, "Preferences" )
          . " to change \"Max. Gene List Results\" limit. )\n";
        printStatusLine( $s, 2 );
        print "<br/>\n";
    }
    else {
        printStatusLine( "$g_cnt genes retrieved.", 2 );
    }
    
}


############################################################################
# scaffoldBins
############################################################################
sub scaffoldBins {

    my $scaffold_oid = param('scaffold_oid');
    if ( !$scaffold_oid ) {
        WebUtil::webError("No scaffold");
        return;
    }

    printMainForm();
    my $dbh = dbLogin();

    my $scaffold_name = getScaffoldName( $dbh, $scaffold_oid );
    print "<h2>All Bins for Scaffold $scaffold_oid: $scaffold_name</h2>\n";

    my $rclause   = WebUtil::urClause('bs.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('bs.taxon');
    my $sql       = qq{
        select bs.bin_oid, b.display_name, b.description,
        bm.method_name, to_char(b.add_date, 'yyyy-mm-dd')
        from bin_scaffolds bs, bin b, bin_method bm
        where bs.scaffold = ?
        and bs.bin_oid = b.bin_oid
        and b.bin_method = bm.bin_method_oid (+)
        $rclause
        $imgClause
        order by 1
    };

    ### BEGIN static YUI table ###
    my $sit = new StaticInnerTable();
    $sit->addColSpec("Select", "", "center");
    $sit->addColSpec("Bin OID");
    $sit->addColSpec("Bin Name");
    $sit->addColSpec("Description");
    $sit->addColSpec("Bin Method");
    $sit->addColSpec("Add Date");
    $sit->addColSpec("Scaffold Count");

    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    for ( ; ; ) {
        my ( $bin_oid, $bin_name, $desc, $bin_method, $add_date ) =
          $cur->fetchrow();
        last if !$bin_oid;

        my $url3 =
            "$main_cgi?section=Metagenome"
          . "&page=binDetail"
          . "&bin_oid=$bin_oid";

        my $row =
          "<input type='checkbox' name='selected_bin' value='$bin_oid' />\t";
        $row .= alink( $url3, $bin_oid ) . "\t";
        $row .= "$bin_name\t";
        $row .= "$desc\t";
        $row .= "$bin_method\t";
        $row .= "$add_date\t";

        # taxon permission
        my $sql2 = qq{
            select count(*)
            from bin_scaffolds bs, scaffold s
            where bin_oid = ?
            and bs.scaffold = s.scaffold_oid
            $rclause
            $imgClause
    };
        my $cur2    = execSql( $dbh, $sql2, $verbose, $bin_oid );
        my $s_count = $cur2->fetchrow();

        $row .= "$s_count\t";
        $sit->addRow($row);
    }
    $sit->printTable();
    ### END static YUI table ###

    $cur->finish();
    #$dbh->disconnect();

    print "<h4>Add scaffolds from selected bin(s) to scaffold cart</h4>\n";
    print "<p>Select one or more bins from the above table, and click "
    . "'Add To Scaffold Cart' to add all scaffolds in the selected bin(s) to cart.</p>\n";

    print "<p>\n";
    my $name = "_section_ScaffoldCart_addBinScaffold";
    print submit(
        -name  => $name,
        -value => "Add To Scaffold Cart",
        -class => 'meddefbutton'
    );

    print end_form();
}

############################################################################
# getScaffoldName
############################################################################
sub getScaffoldName {
    my ( $dbh, $scaffold_oid ) = @_;

    if ( !$scaffold_oid ) {
        return "";
    }

    my ( $s_oid, $s_name, $ext_acc );

    if ( $scaffold_oid && isInt($scaffold_oid) ) {
        my $sql = QueryUtil::getSingleScaffoldNameSql();
        my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
        ( $s_oid, $s_name, $ext_acc ) = $cur->fetchrow();
        $cur->finish();
    }
    else {
        my ( $taxon_oid, $data_type, $oid ) = split( / /, $scaffold_oid );
        $s_name = $oid;
    }

    if ( !$s_oid ) {
        return "";
    }

    return $s_name;
}


1;
