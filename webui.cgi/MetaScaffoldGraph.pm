############################################################################
# MetaScaffoldGraph.pm - Show graph of a section of a scaffold used in
#   chromosomal viewers. (file version)
# $Id: MetaScaffoldGraph.pm 36954 2017-04-17 19:34:04Z klchu $
############################################################################
package MetaScaffoldGraph;
my $section = "MetaScaffoldGraph";

use strict;
use CGI qw( :standard );
use DBI;
use ScaffoldPanel;
use Data::Dumper;
use WebConfig;
use WebUtil;
use POSIX qw(ceil floor);
use GeneUtil;
use FindGenesBlast;
use HtmlUtil;
use MetaUtil;
use QueryUtil;
use GraphUtil;
use PhyloUtil;
use ScaffoldDataUtil;
use MyIMG;

my $env                  = getEnv();
my $img_internal         = $env->{img_internal};
my $include_metagenomes  = $env->{include_metagenomes};
my $img_er               = $env->{img_er};
my $main_cgi             = $env->{main_cgi};
my $section_cgi          = "$main_cgi?section=$section";
my $tmp_url              = $env->{tmp_url};
my $tmp_dir              = $env->{tmp_dir};
my $cgi_tmp_url          = $env->{cgi_tmp_url};
my $base_url             = $env->{base_url};
my $crispr_png           = "$base_url/images/crispr.png";
my $verbose              = $env->{verbose};
my $scaffold_page_size   = $env->{scaffold_page_size};
my $pageSize             = $scaffold_page_size;
my $user_restricted_site = $env->{user_restricted_site};
my $YUI                  = $env->{yui_dir_28};
my $top_base_url = $env->{top_base_url};
my $mer_data_dir = $env->{mer_data_dir};
my $virus = $env->{virus};

# No. bp's for whole page.
my $blockSize = 30000;

# No aa's for one Scaffold Panel line.

my %cogFuncFilter;

sub getPageTitle {
    return 'Chromosome Viewer';
}

sub getAppHeaderData {
    my ($self) = @_;

    my @a = ('FindGenomes');
    return @a;
}

sub dispatch {
    my ( $self, $numTaxon ) = @_;
    my $page = param("page");

    if ( paramMatch("userScaffoldGraph") ne "" ) {
        my $scaffold_oid_len = param("scaffold_oid_len");
        my ( $scaffold_oid, $seq_length ) = split( /:/, $scaffold_oid_len );
        param( "scaffold_oid", $scaffold_oid );
        param( "seq_length",   $seq_length );
        param( "userEntered",  1 );
        printMetaScaffoldGraph();

    }
    elsif ( paramMatch("viewerScaffoldGraph") ne "" ) {
        my $scaffold_oid_len = param("scaffold_oid_len");
        my ( $scaffold_oid, $seq_length ) = split( /:/, $scaffold_oid_len );
        param( "scaffold_oid", $scaffold_oid );
        param( "seq_length",   $seq_length );

        # get the coordinates from the text fields
        my $start = param("start");
        my $end   = param("end");
        param( "start_coord", $start );
        param( "end_coord",   $end );
        param( "userEntered", 1 );
        printMetaScaffoldGraph();

    }
    elsif ( $page eq "metaScaffoldGraph"
        || paramMatch("setCogFunc") ne "" )
    {
        printMetaScaffoldGraph();
    }
    elsif ( $page eq "preScaffoldGraph" ) {
        printPreScaffoldGraph();
    }
    elsif ( $page eq "metaScaffoldDna" ) {
        printMetaScaffoldDna();
    }
    elsif ( $page eq "contigReads" ) {
        printContigReads();
    }
    else {
        printMetaScaffoldGraph();
    }
}

sub printPreScaffoldGraph {
    my $marker_gene  = param("marker_gene");
    my $scaffold_oid = param("scaffold_oid");

    my $sql = qq{
        select g.gene_oid, g.start_coord, g.end_coord, ss.seq_length
        from gene g, scaffold_stats ss
        where g.gene_oid = ?
        and g.scaffold = ?
        and g.scaffold = ss.scaffold_oid
    };

    my $dbh = dbLogin();
    my $cur = execSql( $dbh, $sql, $verbose, $marker_gene, $scaffold_oid );
    my ( $gene_oid, $start_coord, $end_coord, $scf_seq_length ) =
      $cur->fetchrow();
    $cur->finish();
    #$dbh->disconnect();

    my $large_flank_length = 200000;
    my $scf_start_coord    = $start_coord - $large_flank_length;
    my $scf_end_coord      = $end_coord + $large_flank_length;
    $scf_start_coord = $scf_start_coord > 1 ? $scf_start_coord : 1;
    $scf_end_coord =
      $scf_end_coord > $scf_seq_length ? $scf_seq_length : $scf_end_coord;
    param( -name => "page",        -value => "scaffoldGraph" );
    param( -name => "start_coord", -value => $scf_start_coord );
    param( -name => "end_coord",   -value => $scf_end_coord );
    param( -name => "seq_length",  -value => $scf_seq_length );

    printMetaScaffoldGraph();
}

############################################################################
# printMetaScaffoldGraph - Show one scaffold graphic.
#   Inputs:
#     scaffold_oid - scaffold object identifier
#     start_coord0 - start coordinate in scaffold
#     end_coord0 - end coordinate in scaffold
#     marker_gene - marker gene (in red) from gene page
#     seq_length - total scaffold sequence length
#     cog_func_filter_str - COG function filter string
#     userEntered - user entered coordinates
############################################################################
sub printMetaScaffoldGraph {    
    my $scaffold_oid = param("scaffold_oid");
    if ( $scaffold_oid eq "" ) {
        # from clicking on coordinate range:
        $scaffold_oid = param("link_scaffold_oid");
    }
    my $start_coord0        = param("start_coord");
    my $end_coord0          = param("end_coord");
    my $seq_length          = param("seq_length");
    my $marker_gene         = param("marker_gene");
    my $cog_func_filter_str = param("cog_func_filter_str");
    my $userEntered         = param("userEntered");
    my $phantom_start_coord = param("phantom_start_coord");
    my $phantom_end_coord   = param("phantom_end_coord");
    my $phantom_strand      = param("phantom_strand");

    my $mygene_oid = param("mygene_oid");
    my $taxon_oid  = param("taxon_oid");
    my $data_type  = param('data_type');
    if ( !$data_type ) {
        $data_type = 'assembled';
    }

    if (!isInt($scaffold_oid)) {
        my ($txid, $dt, $scfid) = split(/ /, $scaffold_oid);
        if ($scfid && $scfid ne "") {
            $taxon_oid = $txid;
            $scaffold_oid = $scfid;
            $data_type = $dt;
        } else {
            # in Kmer, spaces are not allowed, so the metascaffikd
            # is specified as txid-dt-scfid
            ($txid, $dt, $scfid) = split("-", $scaffold_oid);
            if ($scfid && $scfid ne "") {
                $taxon_oid = $txid;
                $scaffold_oid = $scfid;
                $data_type = $dt;
            }
        }
    	param("scaffold_oid", $scaffold_oid);
    	param("taxon_oid", $taxon_oid);
    	param("data_type", $data_type);
    }

    # if not blank and equal to gc, color by gc not cog
    my $color  = param("color");
    my $sample = param("sample");
    my $study  = param("study");

    if ( $sample eq '0' ) {
        my @samples = param("exp_samples");
        if ( scalar @samples > 0 ) {
            $sample = @samples[0];
        }
        else {
            $sample = "";
        }
    }
    if ( $sample ne "" && $color eq "" ) {
        $color = "expression";
    }

    my $taxon_gc_pc = -1;

    $start_coord0 =~ s/\s+//g;
    $end_coord0   =~ s/\s+//g;
    if ( !isInt($start_coord0) ) {
        WebUtil::webError("Expected integer for start coordinate.");
    }
    if ( !isInt($end_coord0) ) {
        WebUtil::webError("Expected integer for end coordinate.");
    }
    if ( $start_coord0 < 1 ) {
        WebUtil::webError("Start coordinate should be greater or equal to 1.");
    }
    if ( $end_coord0 > $seq_length && $seq_length > 0 ) {
        WebUtil::webError( "End coordinate should be "
              . "less than or equal to $seq_length." );
    }
    if ( $start_coord0 > $end_coord0 ) {
        WebUtil::webError( "Start coordinate should be "
              . "less than or equal to the end coordinate." );
    }
    if ( $phantom_start_coord ne "" && !isInt($phantom_start_coord) ) {
        WebUtil::webError("Please enter a valid integer for phantom start coordinate");
    }
    if ( $phantom_end_coord ne "" && !isInt($phantom_end_coord) ) {
        WebUtil::webError("Please enter a valid integer for phantom end coordinate");
    }
    if ( $scaffold_oid eq "" ) {
        WebUtil::webDie("printMetaScaffoldGraph: scaffold_oid not defined\n");
    }

    my $taxon_rescale = 1.0;
    $blockSize *= $taxon_rescale;

    my $dbh = dbLogin();

    my %cogFunction = QueryUtil::getCogFunction($dbh);

    my $scaffold_name = $scaffold_oid;
    if ( !$seq_length ) {
        $seq_length = $end_coord0 - $start_coord0 + 1;
    }

    # gc color
    my $read_depth =
    	MetaUtil::getScaffoldDepth($taxon_oid, $data_type, $scaffold_oid);

    my $gc_percent =
    	MetaUtil::getScaffoldGc( $taxon_oid, $data_type, $scaffold_oid );
    if ( $color eq "gc" ) {
        if ( $marker_gene eq "" || $mygene_oid ne "" ) {
            $taxon_gc_pc = $gc_percent;
        } else {
            $taxon_gc_pc = $gc_percent;    # FIXME LATER
        }
    } else {
        $taxon_gc_pc = -1;
    }

    my $tmp = uc($color);
    $tmp = "COG" if ( $color eq "" );
    $tmp = "Phylo Distribution" if ( $color eq "phylodist" );

    print "<h1>Chromosome Viewer - Colored by $tmp </h1>\n";
    if ( $color eq "phylodist" ) {
        my $phyloDist_date = PhyloUtil::getPhyloDistDate( $dbh, $taxon_oid );
        print "<p><b>Warning: Colored by phylo distribution is based on pre-computed result on <font color='red'>" . $phyloDist_date . "</font>.</b>\n";
    }
    
    my $taxon_name = WebUtil::taxonOid2Name( $dbh, $taxon_oid, 1 );
    HtmlUtil::printMetaTaxonName( $taxon_oid, $taxon_name, $data_type );
    
    print "<p style='width: 650px;'>";
    my $s_url = "$main_cgi?section=MetaScaffoldDetail" 
           . "&page=metaScaffoldDetail&taxon_oid=$taxon_oid" 
           . "&scaffold_oid=$scaffold_oid"
           . "&data_type=$data_type";
    print "Scaffold: " . alink( $s_url, $scaffold_name, "_blank" );
    print "<br/>\n";
    print "(";
    my $depth;
    $depth = "depth=$read_depth" if $read_depth > 0;
    print "${seq_length}bp gc=$gc_percent $depth";
    if ( $data_type eq 'assembled' ) {
        my ( $lineage, $lineage_percentage, $rank ) = 
        	MetaUtil::getScaffoldLineage($taxon_oid, $data_type, $scaffold_oid);
        if ( $lineage ) {
            print " lineage=$lineage lineage_percentage=$lineage_percentage"
        }
    }
    print ")<br/>\n";
    if ( $data_type eq 'assembled' && $virus ) {
	my $v_sql = qq{
                select domain, phylum, ir_class, ir_order,
                       family, subfamily, genus, species
                from dt_mvc_taxonomy
                where mvc = ?
                };

	my $mvc_id = $taxon_oid . "_____" . $scaffold_oid;
	my $v_cur = execSql( $dbh, $v_sql, $verbose, $mvc_id );
            my ($v_dom, $v_phy, $v_cla, $v_ord, $v_fam,
                $v_sub_fam, $v_gen, $v_spe) = $v_cur->fetchrow();
	$v_cur->finish();
	if ( $v_dom ) {
	    my $lineage = "$v_dom;$v_phy;$v_cla;$v_ord;$v_fam";
	    if ( $v_sub_fam && $v_sub_fam ne 'unclassified' ) {
		$lineage .= "(" . $v_sub_fam . ")";
	    }
	    $lineage .= ";$v_gen;";
	    if ( $v_spe =~ /^vc\_/ || $v_spe =~ /^sg\_/ ) {
		my $v_url = "$main_cgi?section=Viral"
    		    . "&page=viralClusterDetail&viral_cluster_id=$v_spe";
		$lineage .= alink($v_url, $v_spe);
	    }
	    else {
		$lineage .= $v_spe;
	    }
	    print "<b>Viral study shows lineage: $lineage</b><br/>\n";
	}
    }
    print "(coordinates <b>$start_coord0-$end_coord0</b>)\n";
    print "</p>\n";

    my $exp_profile;
    if ( $sample ne "" && $color eq "expression" ) {
        if ( $study eq "proteomics" ) {
            my $sql = qq{ 
                select s.description
            	from ms_sample s
            	where s.sample_oid = ?
    	    };
            my $cur = execSql( $dbh, $sql, $verbose, $sample );
            my ($sample_desc) = $cur->fetchrow();
            $cur->finish();

            print "<p>";
            my $url = "$main_cgi?section=IMGProteins"
    		    . "&page=sampledata&sample=$sample";
            print "Coloring is based on coverage of genes for sample: "
		. "$sample<br/>";
            print "<b>" . alink( $url, $sample_desc ) . "</b><br/>\n";
            print "</p>";

            $exp_profile = getExpressionProfile
		( $dbh, $sample, $study, $taxon_oid,
		  $data_type, $scaffold_oid, 1 );

        } elsif ( $study eq "rnaseq" ) {
            use RNAStudies;
            my $sample_desc = RNAStudies::getNameForSample($dbh, $sample);

            print "<p>";
            my $url = "$main_cgi?section=RNAStudies"
    		    . "&page=sampledata&sample=$sample";
            print "Coloring is based on coverage of genes for sample: "
		. "$sample<br/>";
            print "<b>" . alink( $url, $sample_desc ) . "</b><br/>\n";
            print "</p>";

            $exp_profile = getExpressionProfile
		( $dbh, $sample, $study, $taxon_oid,
		  $data_type, $scaffold_oid, 1 );
            if ( scalar keys %$exp_profile == 0 ) {
                print "<p><font color='red'>"
    		    . "Genes for this sample are <u>not found</u> "
    		    . "on the selected scaffold $scaffold_oid</font></p>";
            }
        }
    }

    # switch color
    printMainForm();

    my $url = "$main_cgi?section=MetaScaffoldGraph"
	    . "&page=metaScaffoldGraph&scaffold_oid=$scaffold_oid"
	    . "&taxon_oid=$taxon_oid&data_type=$data_type"
	    . "&start_coord=$start_coord0&end_coord=$end_coord0"
	    . "&seq_length=$seq_length";

    $url .= "&marker_gene=$marker_gene" if ( $marker_gene ne "" );
    $url .= "&mygene_oid=$mygene_oid" if ( $mygene_oid ne "" );
    $url .= "&sample=$sample&study=$study" if ( $sample ne "" );
    $url .= "&color=";

    print qq{
        <script language='javascript' type='text/javascript'>
        function chromoColor(myurl) {
            var e =  document.getElementById("chromoColorBy");
            if (e.value == 'label') {
                return;
            }
            window.open( myurl + e.value, '_self' );
        }
        </script>
    };

    # Chromosome Viewer colored by section
    print qq{
        <p>
        Switch coloring to: &nbsp;
        <select onchange="chromoColor('$url')" name="chromoColorBy" id="chromoColorBy">
        <option selected="true" value="label"> --- Select Function --- </option>
        <option value="cog"> COG </option>
        <option value="gc"> GC </option>
        <option value="kegg"> KEGG </option>
        <option value="pfam"> Pfam </option>
        <option value="tigrfam"> TIGRfam </option>
        <option value="phylodist"> Phylo Distribution </option>
    };
    if ( $sample ne "" ) {
        print "<option value='expression'> Expression </option>";
    }

    print "</select>\n";
    print "</p>\n";

    # end of switch color

    printStatusLine("Loading ...");

    if ( $color eq "gc" ) {
        my $seq_status;
        if ( $marker_gene ne "" ) {
            $seq_status = getSeqStatusViaGeneId( $dbh, $marker_gene );
        } else {
            # $seq_status = getSeqStatusViaScaffold( $dbh, $scaffold_oid );
            $seq_status = "Draft";    # FIXME LATER
        }

        if ( $seq_status eq "Draft" || $seq_status eq "Permanent Draft" ) {
            $seq_status = "($seq_status genome, scaffold avg GC% ) ";
        } else {
            $seq_status = "($seq_status genome avg GC% ) ";
        }

        my $tmp = $taxon_gc_pc * 100;
        print qq{
            <p>
            <b>Characteristic GC% - $tmp %</b>
             $seq_status
            </p>
        };
    }

    my %uniqueGenes;

    #getUniqueGenes( $dbh, $scaffold_oid, $start_coord0, $end_coord0,
    #  \%uniqueGenes );

    my @cogFuncs = param("cogFunc");
    %cogFuncFilter = ();
    my $cogFuncFilterStr = "";
    for my $i (@cogFuncs) {
        $cogFuncFilter{$i} = $i;
        $cogFuncFilterStr .= $i;
        webLog "cogFuncFilter:1: $i\n" if $verbose >= 3;
    }

    # By another means.
    my @cogFuncs2 = split( //, $cog_func_filter_str );
    for my $i (@cogFuncs2) {
        $cogFuncFilter{$i} = $i;
        $cogFuncFilterStr .= $i;
        webLog "cogFuncFilter:2: $i\n" if $verbose >= 3;
    }
    my $nCogFuncs              = scalar( keys(%cogFuncFilter) );
    my $cogFuncFilterStrSuffix = ".x$cogFuncFilterStr"
      if !blankStr($cogFuncFilterStr);

    # kegg color
    # data id => cat id ===  ko_oid => hash of kegg_oid => kegg_oid's name
    my $data_id_href;
    my $cat_id_href;    # cat_id => cat name
    my %ids_colored;    # ids used in the graph - so far for kegg = ken

    if ( $color eq "kegg" ) {
        ( $data_id_href, $cat_id_href ) = getKeggCat( $dbh, 0 );
    }
    elsif ( $color eq "pfam" ) {
        ( $data_id_href, $cat_id_href ) = getPfamCat($dbh);
    }
    elsif ( $color eq "tigrfam" ) {
        ( $data_id_href, $cat_id_href ) = getTigrfamCat( $dbh, 0 );
    }
    #elsif ( $color eq "phylodist" ) {
    #    ( $data_id_href, $cat_id_href ) = getPhyloDistCat( $dbh, $taxon_oid );
    #}

    # gc or kegg color params
    my @colorFuncs;
    my $colorFuncStr;
    if (   $color eq "gc"
        || $color eq "kegg"
        || $color eq "pfam"
        || $color eq "phylodist"
        || $color eq "tigrfam" )
    {
        @colorFuncs   = param("colorFunc");
        $colorFuncStr = param("colorFuncStr");

        if ( $#colorFuncs < 0 && $colorFuncStr ne "" ) {
            @colorFuncs = split( /x/, $colorFuncStr );
        }
        if ( $#colorFuncs >= 0 && $colorFuncStr eq "" ) {
            foreach my $i (@colorFuncs) {
                $colorFuncStr .= "$i" . "x";
            }
        }
    }

    webLog "Run sql " . currDateTime() . "\n" if $verbose >= 1;

    my $mid_coord0 = $end_coord0 - $start_coord0;


    my @recs;
    my $block_coord1 = $start_coord0;
    my $block_coord2 = $block_coord1 + $blockSize;
    my $block_count  = 0;
    my (
        $gene_oid,      $gene_symbol,    $gene_display_name,
        $locus_type,    $locus_tag,
        $start_coord,   $end_coord,      $strand,
        $aa_seq_length, $functions,      $scf_seq_length,
        $bit_score,     $is_pseudogene,  $img_orf_type,
        $gc_percent,    $cds_frag_coord, $ko_id,
        $ko_bit_score
    );
    my $seq_id;
    my $source;
    my $old_scf_seq_length;
    webLog "Add panels " . currDateTime() . "\n" if $verbose >= 1;
    my %done;    # distinct gene_oid
    my $count = 0;
    my $phantom_rec;
    my $phantom_done = 0;

    if (   $phantom_start_coord ne ""
        && $phantom_end_coord ne ""
        && $phantom_start_coord < $phantom_end_coord )
    {
        my $gene_display_name = "Alignment";
        my $gene_oid          = "phantom";
        my $gene_symbol       = "phantom";
        my ( $locus_type, $locus_tag );
        my $aa_seq_length =
          int( ( $phantom_end_coord - $phantom_start_coord + 1 ) / 3 );
        $phantom_rec = "$gene_oid\t";
        $phantom_rec .= "$gene_symbol\t";
        $phantom_rec .= "$gene_display_name\t";
        $phantom_rec .= "$locus_type\t";
        $phantom_rec .= "$locus_tag\t";
        $phantom_rec .= "$phantom_start_coord\t";
        $phantom_rec .= "$phantom_end_coord\t";
        $phantom_rec .= "$phantom_strand\t";
        $phantom_rec .= "$aa_seq_length\t";
        $phantom_rec .= "$functions\t";
        $phantom_rec .= "$is_pseudogene\t";
        $phantom_rec .= "$img_orf_type\t";
        $phantom_rec .= "$gc_percent\t";
        $phantom_rec .= "$cds_frag_coord\t";
        $phantom_rec .= "$ko_id\t";
        $phantom_rec .= "$ko_bit_score";
    }

    my $hint_part =
        "<img style='left: 0px;' src='$crispr_png' "
      . "width='25' height='10' alt='Crispr'>&nbsp;&nbsp;CRISPR array<br/>";
    if ( $phantom_rec ne "" ) {
        $hint_part .= "(Alignment is shown as a thin red line "
	            . "near the coordinate axis.)<br/>\n";
    }

    my @genes_on_s =
    	MetaUtil::getScaffoldGenes( $taxon_oid, $data_type, $scaffold_oid );

    # sort genes by start_coord
    my %len_h;
    for my $line (@genes_on_s) {
        (
            $gene_oid,          $locus_type,  $locus_tag,
            $gene_display_name, $start_coord, $end_coord,
            $strand,            $seq_id,      $source
          )
          = split( /\t/, $line );
        my ( $prod_name, $source2 ) =
	    MetaUtil::getGeneProdNameSource( $gene_oid, $taxon_oid, $data_type );
        if ( !$prod_name && $gene_display_name ) {
            $prod_name = $gene_display_name;
        }
        $line = "$gene_oid\t$locus_type\t$locus_tag\t$prod_name\t"
	      . "$start_coord\t$end_coord\t$strand\t$seq_id\t$source2";
        $len_h{$start_coord} = $line;
    }
    
    @genes_on_s = ();
    my @keys = sort { $a <=> $b } ( keys %len_h );
    for my $len (@keys) {
        my $line = $len_h{$len};
        push @genes_on_s, ($line);
    }
    #print "printMetaScaffoldGraph() genes_on_s: @genes_on_s<br/>\n";

    my $sessionId = getSessionId();
    #print "printMetaScaffoldGraph() session id: $sessionId<br/>\n";

    my %phylo_h;
    my $phylo_cnt = 11;
    my $crispr_cnt = 0;

    for my $g2 (@genes_on_s) {
        (
            $gene_oid,          $locus_type,  $locus_tag,
            $gene_display_name, $start_coord, $end_coord,
            $strand,            $seq_id,      $source
          )
          = split( /\t/, $g2 );

        if ( !$gene_oid ) {
            next;
        }

        #print "<p>$gene_oid: $start_coord to $end_coord\n";

        # check start
        if ( $start_coord < $start_coord0 ) {
            next;
        }

        # check end
        if ( $end_coord > $end_coord0 ) {
            last;
        }

        # $scf_seq_length = $end_coord0 - $start_coord0 + 1;
        $scf_seq_length = $seq_length;

        # get gene cog
        my @cogs = MetaUtil::getGeneCogId( $gene_oid, $taxon_oid, $data_type );
        if ( scalar(@cogs) > 0 ) {
            my $cog_id = $cogs[0];
            my $sql2 = "select functions from cog_functions where cog_id = ?";
            my $cur2 = execSql( $dbh, $sql2, $verbose, $cog_id );
            ($functions) = $cur2->fetchrow();
            $cur2->finish();
            # print "<p>*** $gene_oid has $cog_id, [$functions]\n";
        }
        else {
            $functions = "";
        }

        # get other gene functions
        $ko_id = "";
        if ( $color eq "pfam" ) {
            my ($pfams_ref, $sdbFileExist) 
                = MetaUtil::getGenePfamInfo( $gene_oid, $taxon_oid, $data_type );
            if ( scalar(@$pfams_ref) > 0 ) {
                my $score0 = 0;
                for my $pfam0 (@$pfams_ref) {
                    my (
                        $gid2,   $pfam_id, $percent_identity,
                        $start1, $end1,    $start2,
                        $end2,   $evalue,  $bit_score,
                        $t2
                      )
                      = split( /\t/, $pfam0 );
                    if ( $bit_score > $score0 ) {
                        $ko_id  = $pfam_id;
                        $score0 = $bit_score;
                    }
                }
            }
        }
        elsif ( $color eq "tigrfam" ) {
            my ($tigrfams_ref, $sdbFileExist) 
                = MetaUtil::getGeneTIGRfamInfo( $gene_oid, $taxon_oid, $data_type );
            if ( scalar(@$tigrfams_ref) > 0 ) {
                my $score0 = 0;
                for my $tigrfam0 (@$tigrfams_ref) {
                    my ( $gid2, $tigrfam_id, $bit_score, $percent_identity,
                        $evalue, $start1, $end1 )
                      = split( /\t/, $tigrfam0 );
                    if ( $bit_score > $score0 ) {
                        $ko_id  = $tigrfam_id;
                        $score0 = $bit_score;
                    }
                }
            }
        }
        elsif ( $color eq "kegg" ) {
            my @kos = MetaUtil::getGeneKoId( $gene_oid, $taxon_oid, $data_type );
            if ( scalar(@kos) > 0 ) {
                $ko_id = $kos[0];
            }
        }
        elsif ( $color eq "phylodist" ) {
            my $tid = getGeneHomoTaxon( $gene_oid, $taxon_oid, $data_type );
    	    if ( $tid ) {
		$phylo_h{$tid} = $tid;
		my $sql3 = "select taxon_oid, domain, phylum, ir_class from taxon " .
		    "where taxon_oid = ? ";
		my $cur3 = execSql( $dbh, $sql3, $verbose, $tid );
		my ($tid3, $domain3, $phylum3, $ir_class3) = $cur3->fetchrow();
		$cur3->finish();

		if ( $domain3 ) {
		    my $cat_name = "[" . substr($domain3, 0, 1) . "]" . $phylum3;

		    my $cat_id = 0;
		    if ( $phylo_h{$cat_name} ) {
			$cat_id = $phylo_h{$cat_name};
		    }
		    else {
			$phylo_cnt++;
			$phylo_h{$cat_name} = $phylo_cnt;
			$cat_id = $phylo_cnt;
			$cat_id_href->{$cat_id} = $cat_name;

			# $data_id_href->{$cat_name} = $cat_id;
			my $func_id = $cat_name;
			if(exists $data_id_href->{$func_id}) { 
			    my $href = $data_id_href->{$func_id};
			    $href->{$cat_id} = $cat_name;
			} else { 
			    my %tmp; 
			    $tmp{$cat_id} = $cat_name; 
			    $data_id_href->{$func_id} = \%tmp;
			}
		    }

		    $ko_id = $cat_id;
		}
    	    }
        }
        elsif ( $color eq "gc" ) {
            my $seq = MetaUtil::getScaffoldFna( $taxon_oid, $data_type, $scaffold_oid );
            my $gene_seq = "";
            if ( $strand eq '-' ) {
                $gene_seq = getSequence( $seq, $end_coord, $start_coord );
            }
            else {
                $gene_seq = getSequence( $seq, $start_coord, $end_coord );
            }
            my ( $a, $b, $c ) = gcContent($gene_seq);
            $gc_percent = sprintf( "%.2f", $c );
        }

    	if ( $color eq 'phylodist' && $ko_id ) {
    	    $gene_display_name .= " (hit: " . $cat_id_href->{$ko_id} . ")";
    	}

        $count++;
        $old_scf_seq_length = $scf_seq_length;
        ## --es 10/02/2005 Take first best cog bit score hit.
        next if $done{$gene_oid} ne "";

        if ( $end_coord > $block_coord2 && scalar(@recs) > 0 ) {
            $block_count++;
            if (
                   $phantom_rec ne ""
                && !$phantom_done
                && (   $phantom_start_coord >= $block_coord1
                    || $phantom_end_coord <= $block_coord2 )
              )
            {
                push( @recs, $phantom_rec );
                $phantom_done = 1;
            }

            my $tmp = "";
            if ( $img_er || $img_internal ) {
                $tmp = "My Gene in <u>cyan</u> or dashes<br/>\n";
            }

            if ( $color eq "gc" ) {
                printHint( "Mouse over a gene to see details.<br/>"
                      . "RNAs in <u>black</u>, "
                      . "Pseudo genes in <u>white</u><br/>"
                      . $tmp
                      . "Query gene is marked by a "
                      . "<font color='red'><u>red</u></font> bar<br/>"
                      . "Gene with protein is marked by a "
                      . "<font color='#CD96CD><u>purple</u></font> bar<br/>"
                      . "Gene in Gene Cart is marked by a "
                      . "<font color='blue'><u>blue</u></font> bar<br/>"
                      . $hint_part )
                  if $block_count == 1;

                #} elsif ( $color eq "kegg" ) {
                #} elsif ( $color eq "pfam") {
                #} elsif ( $color eq "tigrfam") {
            }
            elsif ( $sample ne "" && $color eq "expression" ) {
                printHint( "Mouse over a gene to see details.<br/>"
                      . "<img src='$base_url/images/colorstrip.100.png' "
                      . "width='200' style='left: 0px; top: 5px;' />"
                      . " &nbsp;&nbsp;red-high to green-low expression<br/>"
                      . "Query gene in <font color='red'><u>red</u></font>, "
                      . "RNAs in <u>black</u>, "
                      . "Pseudo genes in <u>white</u><br/>"
                      . $tmp
                      . "Query gene is marked by a "
                      . "<font color='red'><u>red</u></font> bar<br/>"
                      . "Gene with protein is marked by a "
		      . "<font color='#CD96CD'><u>purple</u></font> bar<br/>"
                      . "Gene in Gene Cart is marked by a "
                      . "<font color='blue'><u>blue</u></font> bar<br/>"
                      . $hint_part )
                  if $block_count == 1;
            }
            else {
                printHint( "Mouse over a gene to see details.<br/>"
                      . "Query gene in <font color='red'><u>red</u></font>, "
                      . "RNAs in <u>black</u>, "
                      . "Pseudo genes in <u>white</u><br/>"
                      . $tmp
                      . "Gene with protein is marked by a "
                      . "<font color='#CD96CD'><u>purple bar</u></font><br/>"
                      . "Gene in Gene Cart is marked by a "
                      . "<font color='blue'><u>blue</u></font> bar<br/>"
                      . $hint_part )
                  if $block_count == 1;
            }
    	    print "<br/>";

            my $id = "$scaffold_oid.$color.$block_coord1.x.$block_coord2";
            $id .= "$cogFuncFilterStrSuffix";
            if ($sessionId) {
                $id .= ".$sessionId";
            }
            #print "printMetaScaffoldGraph() id: $id<br/>\n";

            my ($crisprCount, @retain) = flushMetaRecs(
                $dbh, $data_type, $scaffold_oid, $id,
                $block_coord1,  $block_coord2, $scf_seq_length,
                \@recs,         \%uniqueGenes, \%cogFunction,
                $marker_gene,   $taxon_gc_pc,
                \@colorFuncs,   $color,        $data_id_href,
                $cat_id_href,   \%ids_colored, $exp_profile
            );
            #print "printMetaScaffoldGraph() crisprCount=$crisprCount, block_coord1=$block_coord1, block_coord2=$block_coord2<br/>\n";

            $block_coord1 = $block_coord2 + 1;
            $block_coord1 =
              $block_coord1 < $start_coord ? $block_coord1 : $start_coord;
            $block_coord2 += $blockSize;

            @recs = @retain;
            $crispr_cnt += $crisprCount;
        }

        my $faa = MetaUtil::getGeneFaa( $gene_oid, $taxon_oid, $data_type );
        $aa_seq_length = length($faa);

        my $rec = "$gene_oid\t";
        $rec .= "$gene_symbol\t";
        $rec .= "$gene_display_name\t";
        $rec .= "$locus_type\t";
        $rec .= "$locus_tag\t";
        $rec .= "$start_coord\t";
        $rec .= "$end_coord\t";
        $rec .= "$strand\t";
        $rec .= "$aa_seq_length\t";
        $rec .= "$functions\t";
        $rec .= "$is_pseudogene\t";
        $rec .= "$img_orf_type\t";
        $rec .= "$gc_percent\t";
        $rec .= "$cds_frag_coord\t";
        $rec .= "$ko_id\t";
        $rec .= "$ko_bit_score";

        push( @recs, $rec );
        $done{$gene_oid} = $gene_oid;
    }

    #if( $end_coord > $block_coord2 && scalar( @recs ) > 0 ) {
    if ( scalar(@recs) > 0 ) {
        $block_count++;
        if (
               $phantom_rec ne ""
            && !$phantom_done
            && (   $phantom_start_coord >= $block_coord1
                || $phantom_end_coord <= $block_coord2 )
          )
        {
            push( @recs, $phantom_rec );
            $phantom_done = 1;
        }

        if ( $sample ne "" && $color eq "expression" && $block_count == 1 ) {
            printHint( "Mouse over a gene to see details.<br/>"
		     . "<img src='$base_url/images/colorstrip.100.png' "
		     . "width='200' style='left: 0px; top: 5px;' />"
		     . " &nbsp;&nbsp;red-high to green-low expression"
                     . "<br/>$hint_part" );
            print "<br/>";
        }
        else {
            printHint("Mouse over a gene to see details.<br/>$hint_part")
              if $block_count == 1;
            print "<br/>";
        }

        my $id = "$scaffold_oid.$color.$block_coord1.x.$block_coord2";
        $id .= "$cogFuncFilterStrSuffix";
        if ($sessionId) {
            $id .= ".$sessionId";
        }
        #print "printMetaScaffoldGraph() id: $id<br/>\n";
        my ($crisprCount, @retain) = flushMetaRecs(
            $dbh, $data_type, $scaffold_oid, $id,
            $block_coord1,  $block_coord2, $old_scf_seq_length,
            \@recs,         \%uniqueGenes, \%cogFunction,
            $marker_gene,   $taxon_gc_pc,
            \@colorFuncs,   $color,        $data_id_href,
            $cat_id_href,   \%ids_colored, $exp_profile
        );
        #print "printMetaScaffoldGraph() crisprCount=$crisprCount, block_coord1=$block_coord1, block_coord2=$block_coord2<br/>\n";
        $crispr_cnt += $crisprCount;
    }

    if ( $count == 0 ) {
        print "<p>\n";
        print "No genes were found to display for this coordinate range.";
        print "<br/></p>\n";

        my $crisprCount = printNoGenePanel(
              $dbh,  $taxon_oid,  $data_type, $scaffold_oid,
              $start_coord0,      $end_coord0,
              $seq_length,        $phantom_start_coord,
              $phantom_end_coord, $phantom_strand
        );
        $crispr_cnt += $crisprCount;
    }
    webLog "Add panels " . currDateTime() . "\n" if $verbose >= 1;

    if ( $crispr_cnt > 0 ) {
        require MetaScaffoldDetail;
        MetaScaffoldDetail::printMetaScaffoldCrisprDetail( $taxon_oid, $data_type, $scaffold_oid, $start_coord0, $end_coord0 );            
        #print "printMetaScaffoldGraph() crispr_cnt=$crispr_cnt, start_coord0=$start_coord0, end_coord0=$end_coord0<br/>\n";
    }

    # Next and previous buttons.
    my $end_coord1   = $start_coord0 - 1;
    my $start_coord1 = $end_coord1 - $pageSize;
    $start_coord1 = 1 if $start_coord1 < 1;
    my $start_coord2 = $end_coord0 + 1;
    my $end_coord2   = $start_coord2 + $pageSize;
    $end_coord2 = $seq_length if $end_coord2 > $seq_length;

    my $prevUrl =
        "$section_cgi&page=metaScaffoldGraph"
      . "&scaffold_oid=$scaffold_oid"
      . "&taxon_oid=$taxon_oid&data_type=$data_type";
    $prevUrl .= "&start_coord=$start_coord1&end_coord=$end_coord1";
    $prevUrl .= "&seq_length=$seq_length";
    if ( $mygene_oid ne "" ) {
        $prevUrl .= "&mygene_oid=$mygene_oid";
    }
    if ( $sample ne "" ) {
        $prevUrl .= "&sample=$sample&study=$study";
    }
    $prevUrl .= "&color=$color";
    if (   $taxon_gc_pc > -1
        || $color eq "kegg"
        || $color eq "pfam"
        || $color eq "phylodist"
        || $color eq "tigrfam" )
    {

        #$prevUrl .= "&color=$color";
        if ( $colorFuncStr ne "" ) {
            $prevUrl .= "&colorFuncStr=$colorFuncStr";
        }
    }
    $prevUrl .= "&cog_func_filter_str=$cogFuncFilterStr"
      if ( $cogFuncFilterStr ne "" );

    my $nextUrl =
        "$section_cgi&page=metaScaffoldGraph"
      . "&scaffold_oid=$scaffold_oid"
      . "&taxon_oid=$taxon_oid&data_type=$data_type";
    $nextUrl .= "&start_coord=$start_coord2&end_coord=$end_coord2";
    $nextUrl .= "&seq_length=$seq_length";
    if ( $mygene_oid ne "" ) {
        $nextUrl .= "&mygene_oid=$mygene_oid";
    }
    if ( $sample ne "" ) {
        $nextUrl .= "&sample=$sample&study=$study";
    }
    $nextUrl .= "&color=$color";
    if (   $taxon_gc_pc > -1
        || $color eq "kegg"
        || $color eq "pfam"
        || $color eq "phylodist"
        || $color eq "tigrfam" )
    {

        #$nextUrl .= "&color=$color";
        if ( $colorFuncStr ne "" ) {
            $nextUrl .= "&colorFuncStr=$colorFuncStr";
        }
    }
    $nextUrl .= "&cog_func_filter_str=$cogFuncFilterStr"
      if ( $cogFuncFilterStr ne "" );

    print "<br/>\n";

    if ( $start_coord0 > 1 && $marker_gene eq "" && !$userEntered ) {
        print buttonUrl( $prevUrl, "&lt; Previous Range", "smbutton" );
    }
    if (   $end_coord0 < $seq_length
        && $seq_length > 0
        && $marker_gene eq ""
        && !$userEntered )
    {
        print buttonUrl( $nextUrl, "Next Range &gt;", "smbutton" );
    }

    my @color_array = GraphUtil::loadColorArrayFile( $env->{small_color_array_file} );
    my @keys        = sort( keys(%cogFunction) );

    print "<p>\n";
    my $url =
        "$section_cgi&page=metaScaffoldDna&scaffold_oid=$scaffold_oid"
      . "&taxon_oid=$taxon_oid&data_type=$data_type";
    $url .= "&start_coord=$start_coord0&end_coord=$end_coord0";
    print alink( $url, "Get Nucleotide Sequence For Range" ) . "<br/>\n";

    #    my $nReads = countReads( $dbh, $scaffold_oid );
    my $nReads = 0;    # FIXME LATER

    if ( $nReads > 0 ) {
        my $url = "$section_cgi&page=contigReads&scaffold_oid=$scaffold_oid";
        print alink( $url, "Show Read ID's For This Contig" ) . "<br/>\n";
    }

    #    my $nExtLinks = countExtLinks( $dbh, $scaffold_oid );
    my $nExtLinks = 0;    # FIXME LATER
    if ( $nExtLinks > 0 ) {
        printExtLinks( $dbh, $scaffold_oid );
    }

    #    my $nNotes = countNotes( $dbh, $scaffold_oid );
    my $nNotes = 0;       # FIXME LATER
    if ( $nNotes > 0 ) {
        printNotes( $dbh, $scaffold_oid );
    }
    print "</p>\n";

    if ( $sample ne "" && $color eq "expression" ) {
        #print toolTipCode();
        print "<script src='$top_base_url/js/overlib.js'></script>\n";
        printStatusLine( "Loaded.", 2 );
        print end_form();
        #$dbh->disconnect();
        return;
    }

    if ( $color eq "gc" ) {
        # HTML CODES
        my $colors_href = getHTMLColorList();

        # hash tables to check the table
        my $colorKeys_href;
        if ( $#colorFuncs < 0 ) {
            $colorKeys_href = getGCColorHashKeys();
        }
        else {
            foreach my $i (@colorFuncs) {
                $colorKeys_href->{$i} = "";
            }
        }

        # print gc color table
        print "<h2>GC Coloring</h2>\n";

	printYUITableHeader();

        my $idx = 0;
        my $classStr;

        foreach my $key ( sort { $b <=> $a } keys %$colors_href ) {
	    $classStr = !$idx ? "yui-dt-first " : "";
	    $classStr .= ( $idx % 2 == 0 ) ? "yui-dt-even" : "yui-dt-odd";

            my $kcolor = $colors_href->{$key};
            my $ck;
            $ck = "checked='checked'" if ( exists( $colorKeys_href->{$key} ) );

            # Checkbox
            print "<tr class='$classStr'>\n";
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner' style='text-align: center;'>";
            print "<input type='checkbox' name='colorFunc' value='$key' $ck>";
            print "</div>\n";
            print "</td>\n";

            # color column
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print "<span style='border-left:1em solid $kcolor;"
              . "padding-left:0.5em; margin-left:0.5em'>[";

            if ( $key > 0 ) {
                print " +";
            }
            elsif ( $key == 0 ) {
                print " +2 -2";
            }
            else {
                print " ";
            }

            print $key if $key;    # don't print if key = 0
            print "% ]</span>";
            print "</div>\n";
            print "</td>\n";

            # decription col.
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";

            if ( $key == 0 ) {
                my $tmp = $taxon_gc_pc * 100;
                print "$tmp% characteristic GC% (cgc) &plusmn;2";
            }
            else {
                if ( $key > 0 ) {
                    print "cgc +$key";
                }
                else {
                    print "cgc $key";
                }
            }
            print "%";
            print "</div>\n";
            print "</td>\n";
            print "</tr>\n";

            $idx++;
        }
        print "</table>\n";
        print "</div>\n";

    }
    elsif ( $color eq "kegg" ) {
        # TODO kegg color
        print "<h2>KEGG Categories Coloring</h2>\n";

	printYUITableHeader();

        my $args = {
            id               => "scf.abc-color",
            start_coord      => 1,
            end_coord        => 10,
            coord_incr       => 1,
            strand           => "+",
            has_frame        => 0,
            color_array_file => $env->{large_color_array_file},
            tmp_dir          => $tmp_dir,
            tmp_url          => $tmp_url,
        };
        my $sp = new ScaffoldPanel($args);
        my $im = $sp->getIm();

        # hash tables to check the table
        my %colorKeys_hash;
        my $all_boolean = 0;
        if ( $#colorFuncs < 0 ) {
            $all_boolean = 1;
        }
        else {
            foreach my $i (@colorFuncs) {
                $colorKeys_hash{$i} = "";
            }
        }

        my $idx = 0;
        my $classStr;

        foreach my $id (
            sort { $cat_id_href->{$a} cmp $cat_id_href->{$b} }
            keys %$cat_id_href
          )
        {
	    $classStr = !$idx ? "yui-dt-first " : "";
	    $classStr .= ( $idx % 2 == 0 ) ? "yui-dt-even" : "yui-dt-odd";

            my $ck;
            $ck = "checked='checked'"
              if ( $all_boolean || exists( $colorKeys_hash{$id} ) );

            my ( $r, $g, $b );
            if ( exists $ids_colored{$id} ) {
                ( $r, $g, $b ) = $im->rgb( $ids_colored{$id} );
            }
            else {
                my $color = HtmlUtil::getKeggColor( $sp, $id );
                ( $r, $g, $b ) = $im->rgb($color);
            }

            print "<tr class='$classStr'>\n";

            # Checkbox
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner' style='text-align: center;'>";
            print "<input type='checkbox' name='colorFunc' value='$id' $ck>";
            print "</div>\n";
            print "</td>\n";

            # color column
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print "<span style='border-left:1em solid rgb($r, $g, $b);"
              . "padding-left:0.5em; margin-left:0.5em'>[$id]</span>";

            print "</div>\n";
            print "</td>\n";

            # decription col.
            my $desc = $cat_id_href->{$id};
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print $desc;
            print "</div>\n";
            print "</td>\n";

            print "</tr>\n";

            $idx++;
        }
        print "</table>\n";
        print "</div>\n";

    }
    elsif ( $color eq "pfam" ) {
        print "<h2>Pfam Categories Coloring</h2>\n";

	printYUITableHeader();

        my $args = {
            id               => "scf.abc-color",
            start_coord      => 1,
            end_coord        => 10,
            coord_incr       => 1,
            strand           => "+",
            has_frame        => 0,
            color_array_file => $env->{large_color_array_file},
            tmp_dir          => $tmp_dir,
            tmp_url          => $tmp_url,
        };
        my $sp = new ScaffoldPanel($args);
        my $im = $sp->getIm();

        # hash tables to check the table
        my %colorKeys_hash;
        my $all_boolean = 0;
        if ( $#colorFuncs < 0 ) {
            $all_boolean = 1;
        }
        else {
            foreach my $i (@colorFuncs) {
                $colorKeys_hash{$i} = "";
            }
        }

        my $idx = 0;
        my $classStr;

        foreach my $id (
            sort { $cat_id_href->{$a} cmp $cat_id_href->{$b} }
            keys %$cat_id_href
          )
        {
	    $classStr = !$idx ? "yui-dt-first " : "";
	    $classStr .= ( $idx % 2 == 0 ) ? "yui-dt-even" : "yui-dt-odd";

            my $ck;
            $ck = "checked='checked'"
              if ( $all_boolean || exists( $colorKeys_hash{$id} ) );

            my ( $r, $g, $b );
            if ( exists $ids_colored{$id} ) {
                ( $r, $g, $b ) = $im->rgb( $ids_colored{$id} );
            }
            else {
                my $color = HtmlUtil::getPfamCatColor( $sp, $id );
                ( $r, $g, $b ) = $im->rgb($color);
            }

            print "<tr class='$classStr'>\n";

            # Checkbox
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner' style='text-align: center;'>";
            print "<input type='checkbox' name='colorFunc' value='$id' $ck>";
            print "</div>\n";
            print "</td>\n";

            # color column
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print "<span style='border-left:1em solid rgb($r, $g, $b);"
              . "padding-left:0.5em; margin-left:0.5em'>[$id]</span>";

            print "</div>\n";
            print "</td>\n";

            # decription col.
            my $desc = $cat_id_href->{$id};
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print $desc;
            print "</div>\n";
            print "</td>\n";

            print "</tr>\n";

            $idx++;
        }
        print "</table>\n";
        print "</div>\n";

    }
    elsif ( $color eq "tigrfam" ) {
        print "<h2>TIGRfam Categories Coloring</h2>\n";

	printYUITableHeader();

        my $args = {
            id               => "scf.abc-color",
            start_coord      => 1,
            end_coord        => 10,
            coord_incr       => 1,
            strand           => "+",
            has_frame        => 0,
            color_array_file => $env->{large_color_array_file},
            tmp_dir          => $tmp_dir,
            tmp_url          => $tmp_url,
        };
        my $sp = new ScaffoldPanel($args);
        my $im = $sp->getIm();

        # hash tables to check the table
        my %colorKeys_hash;
        my $all_boolean = 0;
        if ( $#colorFuncs < 0 ) {
            $all_boolean = 1;
        }
        else {
            foreach my $i (@colorFuncs) {
                $colorKeys_hash{$i} = "";
            }
        }

        my $idx = 0;
        my $classStr;

        foreach my $id (
            sort { $cat_id_href->{$a} cmp $cat_id_href->{$b} }
            keys %$cat_id_href
          )
        {
	    $classStr = !$idx ? "yui-dt-first " : "";
	    $classStr .= ( $idx % 2 == 0 ) ? "yui-dt-even" : "yui-dt-odd";

            my $ck;
            $ck = "checked='checked'"
              if ( $all_boolean || exists( $colorKeys_hash{$id} ) );

            my ( $r, $g, $b );
            if ( exists $ids_colored{$id} ) {
                ( $r, $g, $b ) = $im->rgb( $ids_colored{$id} );
            }
            else {
                my $color = HtmlUtil::getTigrfamCatColor( $sp, $id );
                ( $r, $g, $b ) = $im->rgb($color);
            }

            print "<tr class='$classStr'>\n";

            # Checkbox
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner' style='text-align: center;'>";
            print "<input type='checkbox' name='colorFunc' value='$id' $ck>";
            print "</div>\n";
            print "</td>\n";

            # color column
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print "<span style='border-left:1em solid rgb($r, $g, $b);"
              . "padding-left:0.5em; margin-left:0.5em'>[$id]</span>";

            print "</div>\n";
            print "</td>\n";

            # decription col.
            my $desc = $cat_id_href->{$id};
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print $desc;
            print "</div>\n";
            print "</td>\n";

            print "</tr>\n";

            $idx++;
        }
        print "</table>\n";
        print "</div>\n";

    }
    elsif ( $color eq "phylodist" ) {
        print "<h2>Phylo Distribution Coloring</h2>\n";

	printYUITableHeader();

        my $args = {
            id               => "scf.abc-color",
            start_coord      => 1,
            end_coord        => 10,
            coord_incr       => 1,
            strand           => "+",
            has_frame        => 0,
            color_array_file => $env->{large_color_array_file},
            tmp_dir          => $tmp_dir,
            tmp_url          => $tmp_url,
        };
        my $sp = new ScaffoldPanel($args);
        my $im = $sp->getIm();

        # hash tables to check the table
        my %colorKeys_hash;
        my $all_boolean = 0;
        if ( $#colorFuncs < 0 ) {
            $all_boolean = 1;
        }
        else {
            foreach my $i (@colorFuncs) {
                $colorKeys_hash{$i} = "";
            }
        }

        my $idx = 0;
        my $classStr;

        foreach my $id (
            sort { $cat_id_href->{$a} cmp $cat_id_href->{$b} }
            keys %$cat_id_href
          )
        {
	    $classStr = !$idx ? "yui-dt-first " : "";
	    $classStr .= ( $idx % 2 == 0 ) ? "yui-dt-even" : "yui-dt-odd";

            my $ck;
            $ck = "checked='checked'"
              if ( $all_boolean || exists( $colorKeys_hash{$id} ) );

            my ( $r, $g, $b );
            if ( exists $ids_colored{$id} ) {
                ( $r, $g, $b ) = $im->rgb( $ids_colored{$id} );
            }
            else {
		my $color = $id;
                ( $r, $g, $b ) = $im->rgb($color);
            }

            print "<tr class='$classStr'>\n";

            # Checkbox
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner' style='text-align: center;'>";
            print "<input type='checkbox' name='colorFunc' value='$id' $ck>";
            print "</div>\n";
            print "</td>\n";

            # color column
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print "<span style='border-left:1em solid rgb($r, $g, $b);"
              . "padding-left:0.5em; margin-left:0.5em'>[$id]</span>";

            print "</div>\n";
            print "</td>\n";

            # decription col.
            my $desc = $cat_id_href->{$id};
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print $desc;
            print "</div>\n";
            print "</td>\n";

            print "</tr>\n";

            $idx++;
        }
        print "</table>\n";
        print "</div>\n";

    }
    else {
        print "<h2>COG Coloring Selection</h2>\n";
        print "<p>\n";
        print "Color code of function category for top COG hit ";
        print "is shown below.<br/>\n";
        print "You may select a subset to view specific categories.<br/>\n";
        print "</p>\n";

	printYUITableHeader();

        my $idx = 0;
        my $classStr;

        for my $k (@keys) {
            last if !$k;

	    $classStr = !$idx ? "yui-dt-first " : "";
	    $classStr .= ( $idx % 2 == 0 ) ? "yui-dt-even" : "yui-dt-odd";

            my ( $definition, $count ) = split( /\t/, $cogFunction{$k} );
            my $ck;
            $ck = "checked='checked'"
              if $nCogFuncs == 0
              || ( $nCogFuncs > 0 && $cogFuncFilter{$k} ne "" );

            # Checkbox
            print "<tr class='$classStr'>\n";
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner' style='text-align: center;'>";
            print "<input type='checkbox' name='cogFunc' value='$k' $ck>";
            print "</div>\n";
            print "</td>\n";

            my $cogRec = $cogFunction{$k};
            my ( $definition, $function_idx ) = split( /\t/, $cogRec );
            my $color = $color_array[$function_idx];
            my ( $r, $g, $b ) = split( /,/, $color );
            my $kcolor = sprintf( "#%02x%02x%02x", $r, $g, $b );

            # COG Code
            print "<td class='$classStr'\n";
            print "<div class='yui-dt-liner'>";
            print "<span style='border-left:1em solid $kcolor;"
              . "padding-left:0.5em; margin-left:0.5em'>[$k]</span>";
            print "</div>\n";
            print "</td>\n";

            # COG Function Definition
            print "<td class='$classStr'>\n";
            print "<div class='yui-dt-liner'>";
            print escHtml($definition);
            print "</div>\n";
            print "</td>\n";
            print "</tr>\n";

            $idx++;
        }
        print "</table>\n";
        print "</div>\n";
    }    # end if for cog color selection

    print "<p>\n";
    print hiddenVar( "taxon_oid",    $taxon_oid );
    print hiddenVar( "data_type",    $data_type );
    print hiddenVar( "scaffold_oid", $scaffold_oid );
    print hiddenVar( "start_coord",  $start_coord0 );
    print hiddenVar( "end_coord",    $end_coord0 );
    print hiddenVar( "marker_gene",  $marker_gene );
    print hiddenVar( "seq_length",   $seq_length );
    print hiddenVar( "userEntered",  $userEntered );
    print hiddenVar( "color",        $color );
    if ( $sample ne "" ) {
        print hiddenVar( "sample", $sample );
        print hiddenVar( "study",  $study );
    }

    if ( $mygene_oid ne "" ) {
        print hiddenVar( "mmgene_oid", $mygene_oid );
    }

    my $name = "_section_${section}_setCogFunc";
    print submit(
        -name  => $name,
        -value => "Save Selections",
        -class => 'meddefbutton'
    );
    print nbsp(1);
    print "<input type='button' name='selectAll' value='Select All' "
      . "onClick='selectAllCheckBoxes(1)' class='smbutton' />\n";
    print nbsp(1);
    print "<input type='button' name='clearAll' value='Clear All' "
      . "onClick='selectAllCheckBoxes(0)' class='smbutton' />\n";
    print nbsp(1);

    webLog "End Graph " . currDateTime() . "\n" if $verbose >= 1;

    printHint("Saving with no selections defaults to show all colors.");
    #print toolTipCode();
    print "<script src='$top_base_url/js/overlib.js'></script>\n";

    printStatusLine( "Loaded.", 2 );
    print end_form();
}

sub printYUITableHeader {
    print <<YUI;

    <link rel="stylesheet" type="text/css"
        href="$YUI/build/datatable/assets/skins/sam/datatable.css" />

        <style type="text/css">
        .yui-skin-sam .yui-dt th .yui-dt-liner {
            white-space:normal;
    }
        </style>

        <div class='yui-dt'>
        <table style='font-size:12px'>
        <th>
        <div class='yui-dt-liner'>
        <span>Show Color</span>
        </div>
        </th>
        <th>
        <div class='yui-dt-liner'>
        <span>Color</span>
        </div>
        </th>
        <th>
        <div class='yui-dt-liner'>
        <span>Description</span>
        </div>
        </th>
YUI
}

############################################################################
# flushMetaRecs - Flush the records for a bunch of genes in a scaffold
#                 (file version)
#  region.
#  Inputs:
#     dbh - database handle
#     scaffold_oid - scaffold object identifier
#     id - ID used in temp file
#     scf_start_coord - scaffold start coordinate
#     scf_end_coord - scaffold end coordinate
#     scf_seq_length - scaffold sequence length
#     recs_ref - gene records
#     uniqueGene_ref - unique genes list
#     cogFunc_ref - cog functions
#     marker_gene - marker gene (shown in red from gene page)
#
#     $taxon_gc_pc
#     $colorFuncs_aref
#
#     $color_view - color cgi param values: gc, kegg
#     $data_id_href - data id => cat id ===  ko_oid => hash of kegg_oid => kegg_oid's name
#     $cat_id_href - cat_id => cat name
#     $ids_colored_href - set of ids that where color
############################################################################
sub flushMetaRecs {
    my (
        $dbh, $data_type,  $scaffold_oid,     $id,
        $scf_start_coord,  $scf_end_coord,    $scf_seq_length,
        $recs_ref,         $uniqueGenes_ref,  $cogFunction_ref,
        $marker_gene,      $taxon_gc_pc,
        $colorFuncs_aref,  $color_view,       $data_id_href,
        $cat_id_href,      $ids_colored_href, $exp_profile
      )
      = @_;
    webLog ">>> Panel id='$id' $scf_start_coord $scf_end_coord\n"
      if $verbose >= 5;
    printStatusLine("Loading ...");
    my @cogFuncs  = keys(%cogFuncFilter);
    my $nCogFuncs = @cogFuncs;

    my $coord_incr = 3000;
    ## Rescale for large Euks
    #    my $taxon_oid     = QueryUtil::scaffoldOid2TaxonOid( $dbh, $scaffold_oid );
    #    my $taxon_rescale = WebUtil::getTaxonRescale( $dbh, $taxon_oid );

    my $taxon_oid     = param("taxon_oid");
    my $taxon_rescale = 1;

    $coord_incr *= $taxon_rescale;

    # get protein data for these genes
    # my $protein_href = getProtein($dbh, $taxon_oid, $scf_start_coord, $scf_end_coord);
    my $protein_href;

    # get gene in gene cart
    require GeneCartStor;
    my $gcart     = new GeneCartStor();
    my $gene_href = $gcart->getGeneOids();

    my %colorKeys_hash;    # kegg color for user selected kegg
    my $all_boolean = 0;   # color all kegg
    my $arrayofcolors;

    if (   $color_view eq "kegg"
        || $color_view eq "pfam"
        || $color_view eq "phylodist"
        || $color_view eq "tigrfam" )
    {
	$arrayofcolors = $env->{large_color_array_file};
        if ( $#$colorFuncs_aref < 0 ) {
            $all_boolean = 1;
        }
        else {
            foreach my $i (@$colorFuncs_aref) {
                $colorKeys_hash{$i} = "";
            }
        }

    } elsif ( $color_view eq "expression" ) {
    	$arrayofcolors = $env->{green2red_array_file};
    } else {
    	$arrayofcolors = $env->{small_color_array_file};
    }

    my $args = {
    	id                   => "scf.$id",
    	start_coord          => $scf_start_coord,
    	end_coord            => $scf_end_coord,
    	coord_incr           => $coord_incr,
    	strand               => "+",
    	has_frame            => 0,
    	gene_page_base_url   =>
    	    "$main_cgi?section=MetaGeneDetail&page=metaGeneDetail"
    	  . "&taxon_oid=$taxon_oid&data_type=$data_type",
            mygene_page_base_url =>
    	"$main_cgi?section=MyGeneDetail&page=geneDetail",
    	color_array_file     => $arrayofcolors,
    	tmp_dir              => $tmp_dir,
    	tmp_url              => $tmp_url,
    };
    
    $args->{meta_gene_page_base_url} =
	$args->{gene_page_base_url} . "&taxon_oid=$taxon_oid&data_type=$data_type";

    my $sp = new ScaffoldPanel($args);
    my $color_array = $sp->{color_array};
    my @retain;
    my (
        $mymaker_gene_oid, $mymaker_start_coord, $mymaker_end_coord,
        $mymaker_strand,   $mymaker_color,       $mymaker_label
    );

    for my $r (@$recs_ref) {
        my (
            $gene_oid,      $gene_symbol, $gene_display_name,
            $locus_type,    $locus_tag,
            $start_coord,   $end_coord,   $strand,
            $aa_seq_length, $functions,   $is_pseudogene,
            $img_orf_type,  $gc_percent,  $cds_frag_coord,
            $ko_id,         $ko_bit_score
          )
          = split( /\t/, $r );
        if ( $start_coord < $scf_start_coord ) {
            webLog( "flushMetaRecs: start_coord=$start_coord < "
                  . "scf_start_coord=$scf_start_coord\n" );
        }
        if ( $end_coord > $scf_end_coord ) {
            webLog( "flushMetaRecs: end_coord=$start_coord > "
                  . "scf_end_coord=$scf_end_coord\n" );
        }
        if ( $end_coord > $scf_end_coord ) {
            push( @retain, $r );
        }

        my $cogRec = $cogFunction_ref->{$functions};
        my ( $definition, $function_idx ) = split( /\t/, $cogRec );
        my $cogStr;
        if ( $nCogFuncs > 0 && $cogFuncFilter{$functions} eq "" ) {
            $cogRec = "";    # nullify if not found.
        }

        my $color = $sp->{color_yellow};
        if ( $cogRec ne "" ) {
            $color  = @$color_array[$function_idx];
            $cogStr = " [$functions]";
        }

        $color = $sp->{color_red} if $gene_oid eq $marker_gene;
        $color = $sp->{color_red} if $gene_oid eq "phantom";

        if (   $taxon_gc_pc > -1
            || $color_view eq "kegg"
            || $color_view eq "pfam"
            || $color_view eq "phylodist"
            || $color_view eq "tigrfam"
            || $color_view eq "expression" )
        {

            # gc color
            if ( $taxon_gc_pc > -1 ) {
                $color =
                  getGCColor( $sp, $gc_percent, $taxon_gc_pc,
                    $colorFuncs_aref );
            }
            elsif ( $color_view eq "kegg" ) {
                # TODO kegg color
                # do not use $color here
                # but find another param for color
                # I need to get genes kegg id
                my $href = $data_id_href->{$ko_id};
                my $kegg_id;
                foreach my $key ( keys %$href ) {
                    # TODO - what to do with multiple ko ids
                    $kegg_id = $key;
                    last;
                }
                $color = HtmlUtil::getKeggColor( $sp, $kegg_id );
                if ( $kegg_id ne "" ) {
                    # for color selection table
                    $ids_colored_href->{$kegg_id} = $color;
                }
                elsif ( $ko_id ne "" ) {
                    #webLog("===== $ko_id \n");
                    # unclassified pfam id
                    $ids_colored_href->{"z"} = $sp->{color_cyan};
                    $color                   = $sp->{color_cyan};
                    $kegg_id                 = "z";
                }

                # color based on user selection - if any default is all colors
                if ( $all_boolean || exists $colorKeys_hash{$kegg_id} ) {
                    # do nothing for now
                }
                else {
                    $color = $sp->{color_yellow};
                }
            }
            elsif ( $color_view eq "pfam" ) {
                my $href = $data_id_href->{$ko_id};
                my $cat_id;
                foreach my $key ( keys %$href ) {
                    #  what to do with multiple ids
                    $cat_id = $key;
                    last;
                }
                $color = HtmlUtil::getPfamCatColor( $sp, $cat_id );

                if ( $cat_id ne "" ) {
                    # for color selection table
                    $ids_colored_href->{$cat_id} = $color;
                }
                elsif ( $ko_id ne "" ) {
                    #webLog("===== $ko_id \n");
                    # unclassified pfam id
                    $ids_colored_href->{"z"} = $sp->{color_cyan};
                    $color                   = $sp->{color_cyan};
                    $cat_id                  = "z";
                }

                # color based on user selection - if any default is all colors
                if ( $all_boolean || exists $colorKeys_hash{$cat_id} ) {
                    # do nothing for now
                }
                else {
                    $color = $sp->{color_yellow};
                }

            }
            elsif ( $color_view eq "tigrfam" ) {
                my $href = $data_id_href->{$ko_id};
                my $cat_id;
                foreach my $key ( keys %$href ) {
                    #  what to do with multiple ids
                    $cat_id = $key;
                    last;
                }
                $color = HtmlUtil::getTigrfamCatColor( $sp, $cat_id );

                if ( $cat_id ne "" ) {
                    # for color selection table
                    $ids_colored_href->{$cat_id} = $color;
                }
                elsif ( $ko_id ne "" ) {
                    #webLog("===== $ko_id \n");
                    # unclassified tigrfam id
                    $ids_colored_href->{"z"} = $sp->{color_cyan};
                    $color                   = $sp->{color_cyan};
                    $cat_id                  = "z";
                }

                # color based on user selection - if any default is all colors
                if ( $all_boolean || exists $colorKeys_hash{$cat_id} ) {
                    # do nothing for now
                }
                else {
                    $color = $sp->{color_yellow};
                }
            }
            elsif ( $color_view eq "phylodist" ) {
                my $href = $data_id_href->{$ko_id};
                my $cat_id = $ko_id;
        		$color = $cat_id;

                if ( $cat_id ne "" ) {
                    # for color selection table
                    $ids_colored_href->{$cat_id} = $color;
                }
                elsif ( $ko_id ne "" ) {
                    #webLog("===== $ko_id \n");
                    # unclassified tigrfam id
                    $ids_colored_href->{"z"} = $sp->{color_cyan};
                    $color                   = $sp->{color_cyan};
                    $cat_id                  = "z";
                }

                # color based on user selection - if any default is all colors
                if ( $all_boolean || exists $colorKeys_hash{$cat_id} ) {
                    # do nothing for now
                }
                else {
                    $color = $sp->{color_yellow};
                }
            }
            elsif ( $color_view eq "expression" ) {
                $color = getExpressionColor( $sp, $gene_oid, $exp_profile );
            }

            if ( $gene_oid eq $marker_gene ) {
                my @coordLines = GeneUtil::getMultFragCoords( $dbh, $gene_oid, $cds_frag_coord );
                if ( scalar(@coordLines) > 1 ) {
                    foreach my $line (@coordLines) {
                        my ( $frag_start, $frag_end ) = split( /\.\./, $line );
                        $sp->addBox(
                            $frag_start, $frag_end,    $sp->{color_red},
                            $strand,     "$gene_oid ", $gene_oid
                        );
                    }

                }
                else {
                    # red bar marker gene
                    my $label = "Marker gene: $gene_oid ";
                    if ( exists $gene_href->{$gene_oid} ) {
                        # its in gene cart too
                        $label = "Gene Cart and Marker gene: $gene_oid ";
                    }
                    $sp->addBox( $start_coord, $end_coord, $sp->{color_red},
                        $strand, $label, $gene_oid );
                }
            }
        }

        # original way of coloring
        $color = $sp->{color_black} if $locus_type eq "tRNA";
        $color = $sp->{color_black} if $locus_type eq "rRNA";

        # All pseudo gene should be white - 2008-04-09 ken
        $color = $sp->{color_white}
          if (
               ( $gene_oid ne $marker_gene )
            && ( $gene_oid ne "phantom" )
            && ( uc($is_pseudogene) eq "YES"
                || $img_orf_type eq "pseudo" )
          );

        my $label = $gene_symbol;
        $label = $locus_tag           if $label eq "";
        $label = "gene_oid $gene_oid" if $label eq "";
        $label .= " : $gene_display_name$cogStr";
        $label .= " $start_coord..$end_coord";

        if ( $locus_type eq "CDS" ) {
            $label .= "(${aa_seq_length}aa)";
        }
        else {
            my $len = $end_coord - $start_coord + 1;
            $label .= "(${len}bp)";
        }

        if ( $taxon_gc_pc > -1 ) {
            # add genes' gc
            $gc_percent = $gc_percent * 100;
            $label .= " GC: $gc_percent%";
        }
        if (   $color_view eq "expression"
            && $color ne $sp->{color_yellow}
            && $color ne $sp->{color_black} )
        {
            $label .=
              " <br/>coverage: " . $exp_profile->{ "orig" . "$gene_oid" };
        }

        webLog "gene: $gene_oid $start_coord $end_coord $strand\n"
          if $verbose >= 5;
        if ( $gene_oid eq "phantom" ) {
            $sp->addPhantomGene( $gene_oid, $start_coord, $end_coord, $strand );

        }
        else {
            my @coordLines = GeneUtil::getMultFragCoords( $dbh, $gene_oid, $cds_frag_coord );
            if ( scalar(@coordLines) > 1 ) {
                foreach my $line (@coordLines) {
                    my ( $frag_start, $frag_end ) = split( /\.\./, $line );
                    my $tmplabel = $label . " $frag_start..$frag_end";
                    $sp->addGene(
                        $gene_oid, $frag_start, $frag_end,
                        $strand,   $color,      $tmplabel
                    );
                }

            }
            else {
                # marker gene
                if ( $gene_oid eq $marker_gene ) {
                    (
                        $mymaker_gene_oid,  $mymaker_start_coord,
                        $mymaker_end_coord, $mymaker_strand,
                        $mymaker_color,     $mymaker_label
                      )
                      = (
                        $gene_oid, $start_coord, $end_coord, $strand, $color,
                        $label
                      );
                }

                $sp->addGene( $gene_oid, $start_coord, $end_coord, $strand,
                    $color, $label );
            }
        }

        # gene cart genes
        if ( exists $gene_href->{$gene_oid} && $gene_oid ne $marker_gene ) {
            $sp->addBox( $start_coord, $end_coord, $sp->{color_blue}, $strand,
                "Gene in Gene Cart $label", $gene_oid, );
        }
        elsif ( exists $protein_href->{$gene_oid}
            && $gene_oid ne $marker_gene )
        {
            # protein gene
            $sp->addBox( $start_coord, $end_coord, $sp->{color_light_purple},
                $strand, "Gene with Protein Info $label", $gene_oid, );
        }

    }    # end for loop

    # draw marker gene again - ken
    if ( $mymaker_gene_oid ne "" && $taxon_gc_pc < 0 ) {
        $sp->addGene(
            $mymaker_gene_oid, $mymaker_start_coord, $mymaker_end_coord,
            $mymaker_strand,   $sp->{color_red},     $mymaker_label
        );
    }

    if (   $scf_start_coord <= $scf_seq_length
        && $scf_seq_length <= $scf_end_coord )
    {
        $sp->addBracket( $scf_seq_length, "right" );
    }

    my $crisprCount = ScaffoldDataUtil::addMetaCrisprRepeats( $taxon_oid, $data_type, $scaffold_oid, 
        $sp, "+", $scf_start_coord, $scf_end_coord );

    my $s = $sp->getMapHtml("overlib");
    print "$s\n";

    return ($crisprCount, @retain);
}

# missing gene???
# look for missing gene if any - only for img er system
# $marker_gene_oid is the one to color red
sub addMyGene {
    my ( $dbh, $sp, $scaffold_oid, $scf_start_coord, $scf_end_coord, 
	 $taxon_oid, $marker_gene_oid ) = @_;
    return if !$user_restricted_site;

    #print "$marker_gene_oid <br/>";

    my $contact_oid = getContactOid();
    return if ( $contact_oid == 0 || $contact_oid eq "" );
    my $super_user = getSuperUser();

    my $group = MyIMG::getUserGroup( $dbh, $contact_oid );

    my $user_clause = urClause("mg.taxon");

    #webLog("contact_oid $contact_oid ============ \n");

    # now get users group info

    my $sql = qq{
      select mg.mygene_oid, mg.gene_symbol, mg.gene_display_name, 
      mg.product_name, mg.ec_number ,mg.locus_type, mg.locus_tag, 
      mg.start_coord, mg.end_coord, mg.strand,
      mg.aa_seq_length, mg.is_pseudogene, mg.modified_by, c.img_group      
      from mygene mg, contact c
      where mg.scaffold = ?
      and mg.taxon = ?
      and mg.modified_by = c.contact_oid
      and (   (mg.start_coord >= ? and mg.start_coord <= ?) 
           or (mg.end_coord   <= ? and mg.end_coord   >= ?))
      $user_clause
    };

    my @a = (
        $scaffold_oid,  $taxon_oid,     $scf_start_coord,
        $scf_end_coord, $scf_end_coord, $scf_start_coord
    );

    my $color = $sp->{color_cyan};
    my $cur = WebUtil::execSqlBind( $dbh, $sql, \@a, $verbose );
    for ( ; ; ) {
        my (
            $mygene_oid,   $gene_symbol,   $gene_display_name,
            $product_name, $ec_number,     $locus_type,
            $locus_tag,    $start_coord,   $end_coord,
            $strand,       $aa_seq_length, $is_pseudogene,
            $modified_by,  $img_group
          )
          = $cur->fetchrow();
        last if ( !$mygene_oid );

        if ( $super_user ne "Yes" ) {
            if ( $modified_by ne $contact_oid ) {
                if ( $img_group ne $group ) {

                    # user does not have access to this my gene
                    next;
                }
                if ( $img_group eq "" && $group eq "" ) {
                    next;
                }
            }
        }

       # for plots -ve strans are stored start < end. see gene table for example
       # but in mygene table -ve have start > end
        if ( $start_coord > $end_coord ) {

            # this is -ve stran
            my $tmp = $start_coord;
            $start_coord = $end_coord;
            $end_coord   = $tmp;
        }

        #print "$mygene_oid eq $marker_gene_oid <br/>";
        # it will be cyan is more than one in database
        if ( $mygene_oid eq $marker_gene_oid ) {
            $color = $sp->{color_red};
        }

        # what is the label
        my $label = "My Gene $mygene_oid, $start_coord..$end_coord, $strand";
        $label .= " $gene_symbol $product_name $ec_number";
        $label .= " $locus_type $locus_tag";
        $sp->addMyGene( $mygene_oid, $start_coord, $end_coord, $strand, $color,
            $label );

        $color = $sp->{color_cyan};    # reset color
    }
    $cur->finish();

}

############################################################################
# getUniqueGenes - Show unique genes.  (Not used.)
############################################################################
sub getUniqueGenes {
    my ( $dbh, $scaffold_oid, $start_coord0, $end_coord0, $uniqueGenes_ref ) =
      @_;

    ## Get orthologs
    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
    my $sql       = qq{
      select g.gene_oid
      from gene g, scaffold s, gene_orthologs go
      where g.scaffold = s.scaffold_oid
      and s.scaffold_oid = ?
      and g.start_coord >= ?
      and g.end_coord <= ?
      and g.gene_oid = go.gene_oid
      $rclause
      $imgClause
   };
    my %orthologs;
    my $cur =
      execSql( $dbh, $sql, $verbose, $scaffold_oid, $start_coord0,
        $end_coord0 );
    for ( ; ; ) {
        my ($gene_oid) = $cur->fetchrow();
        last if !$gene_oid;
        $orthologs{$gene_oid} = 1;
    }
    $cur->finish();

    ## Get paralogs
    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
    my $sql       = qq{
      select g.gene_oid
      from gene g, scaffold s, gene_paralogs gp
      where g.scaffold = s.scaffold_oid
      and s.scaffold_oid = ?
      and g.start_coord >= ?
      and g.end_coord <= ?
      and g.gene_oid = gp.gene_oid
      $rclause
      $imgClause
   };
    my %paralogs;
    my $cur =
      execSql( $dbh, $sql, $verbose, $scaffold_oid, $start_coord0,
        $end_coord0 );
    for ( ; ; ) {
        my ($gene_oid) = $cur->fetchrow();
        last if !$gene_oid;
        $paralogs{$gene_oid} = 1;
    }
    $cur->finish();

    ## Unique genes.
    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
    my $sql       = qq{
      select g.gene_oid
      from gene g, scaffold s
      where g.scaffold = s.scaffold_oid
      and s.scaffold_oid = ?
      and g.start_coord >= ?
      and g.end_coord <= ?
      $rclause
      $imgClause
   };
    my $cur =
      execSql( $dbh, $sql, $verbose, $scaffold_oid, $start_coord0,
        $end_coord0 );
    for ( ; ; ) {
        my ($gene_oid) = $cur->fetchrow();
        last if !$gene_oid;
        next if $orthologs{$gene_oid} ne "";
        next if $paralogs{$gene_oid}  ne "";
        $uniqueGenes_ref->{$gene_oid} = 1;
    }
    $cur->finish();
    webLog "Unique Genes " . Dumper $uniqueGenes_ref
      if $verbose >= 3;
}

############################################################################
# getScaffoldName - Get scaffold_name from scaffold_oid
############################################################################
sub getScaffoldName {
    my ( $dbh, $scaffold_oid ) = @_;
    my $rclause   = WebUtil::urClause('s.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('s.taxon');
    my $sql       = qq{
      select s.scaffold_name
      from scaffold s
      where s.scaffold_oid = ?
      $rclause
      $imgClause
   };
    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my $scaffold_name = $cur->fetchrow();
    $cur->finish();
    return $scaffold_name;
}

############################################################################
# getScaffoldRec - Get record from scaffold_oid
############################################################################
sub getScaffoldRec {
    my ( $dbh, $scaffold_oid ) = @_;
    my $rclause   = WebUtil::urClause('scf.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('scf.taxon');
    my $sql       = qq{
      select scf.scaffold_name, ss.seq_length, ss.gc_percent, scf.read_depth
      from scaffold scf, scaffold_stats ss
      where scf.scaffold_oid = ?
      and scf.scaffold_oid = ss.scaffold_oid
      $rclause
      $imgClause
   };
    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my ( $scaffold_name, $seq_length, $gc_percent, $read_depth ) =
      $cur->fetchrow();
    $cur->finish();
    $gc_percent = sprintf( "%.2f", $gc_percent );
    $read_depth = sprintf( "%.2f", $read_depth );
    $read_depth = "" if $read_depth == 0;
    return ( $scaffold_name, $seq_length, $gc_percent, $read_depth );
}

#
# get all kegg cat colors
# Note not all ko id have a cat.
#    data id => cat id ===  func id => hash of cat id => cat name
#    my $data_id_href;
#    my $cat_id_href;   # cat_id => cat name
sub getKeggCat {
    my ( $dbh, $taxon_oid ) = @_;

    my $sql;
    my $cur;

    if ($taxon_oid) {
        $sql = qq{
	    select irk.ko_terms, pw.kegg_id, pw.category
		from kegg_pathway pw, image_roi iroi, image_roi_ko_terms irk, 
		gene_ko_terms gk, gene g
		where pw.pathway_oid = iroi.pathway
		and iroi.roi_id = irk.roi_id 
		and irk.ko_terms   = gk.ko_terms
		and gk.gene_oid = g.gene_oid
		and g.taxon = ?
		order by pw.category       
	    };

        $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    }
    else {
        $sql = qq{
	    select irk.ko_terms, pw.kegg_id, pw.category
		from kegg_pathway pw, image_roi iroi, image_roi_ko_terms irk
		where pw.pathway_oid = iroi.pathway
		and iroi.roi_id = irk.roi_id 
		order by pw.category       
	    };

        $cur = execSql( $dbh, $sql, $verbose );
    }

    my %data_id_hash;
    my %cat_id_hash;

    my $count         = 0;
    my $last_cat_name = "";
    for ( ; ; ) {
        my ( $func_id, $cat_id, $cat_name ) = $cur->fetchrow();
        last if !$func_id;

        if ( $cat_name ne $last_cat_name ) {
            $count++;
        }
        $cat_id = $count;

        $cat_id_hash{$cat_id} = $cat_name;

        # Set KEGG pathway to "Unknown" if empty
        $cat_id_hash{$cat_id} = "Unknown" if !$cat_name;
        if ( exists $data_id_hash{$func_id} ) {
            my $href = $data_id_hash{$func_id};
            $href->{$cat_id} = $cat_name;
        }
        else {
            my %tmp;
            $tmp{$cat_id}           = $cat_name;
            $data_id_hash{$func_id} = \%tmp;
        }
        $last_cat_name = $cat_name;
    }
    $cur->finish();

    $cat_id_hash{"z"} = "_Unclassified";    # to sort at the end

    return ( \%data_id_hash, \%cat_id_hash );
}

#
# get all pfam cat colors
# Note not all pfam have a cat.
#    data id => cat id ===  func id => hash of cat id => cat name
#    my $data_id_href;
#    my $cat_id_href;   # cat_id => cat name
sub getPfamCat {
    my ($dbh) = @_;
    my $sql = qq{
      select pfc.ext_accession, pfc.functions, cf.definition
      from pfam_family_cogs pfc, cog_function cf
      where pfc.functions = cf.function_code
      order by cf.definition        
    };

    my %data_id_hash;
    my %cat_id_hash;
    my $cur = execSql( $dbh, $sql, $verbose );
    for ( ; ; ) {
        my ( $func_id, $cat_id, $cat_name ) = $cur->fetchrow();
        last if !$func_id;

        $cat_id_hash{$cat_id} = $cat_name;
        if ( exists $data_id_hash{$func_id} ) {
            my $href = $data_id_hash{$func_id};
            $href->{$cat_id} = $cat_name;
        }
        else {
            my %tmp;
            $tmp{$cat_id}           = $cat_name;
            $data_id_hash{$func_id} = \%tmp;
        }
    }
    $cur->finish();

    $cat_id_hash{"z"} = "Unclassified";

    return ( \%data_id_hash, \%cat_id_hash );
}

#
# get all tigrfam cat colors
# Note not all tigrfam have a cat.
#    data id => cat id ===  func id => hash of cat id => cat name
#    my $data_id_href;
#    my $cat_id_href;   # cat_id => cat name
sub getTigrfamCat {
    my ( $dbh, $taxon_oid ) = @_;

    my $sql;
    my $cur;

    if ($taxon_oid) {
        $sql = qq{
            select distinct tfr.ext_accession, 'id', tr.main_role
                from gene_tigrfams gt, tigrfam_roles tfr, tigr_role tr
                where gt.taxon = ?
                and gt.ext_accession = tfr.ext_accession
                and tfr.roles = tr.role_id
	    };
        $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    }
    else {
        $sql = qq{
	    select distinct tr.ext_accession, 'id', t.main_role
		from tigrfam_roles tr, tigr_role t 
		where tr.roles = t.role_id 
		order by t.main_role
	    };
        $cur = execSql( $dbh, $sql, $verbose );
    }

    my %data_id_hash;
    my %cat_id_hash;

    my $count         = 0;
    my $last_cat_name = "";
    for ( ; ; ) {
        my ( $func_id, $cat_id, $cat_name ) = $cur->fetchrow();
        last if !$func_id;

        if ( $cat_name ne $last_cat_name ) {
            $count++;
        }
        $cat_id = $count;

        #webLog("==== $cat_id  === >${cat_name}<\n");

        $cat_id_hash{$cat_id} = $cat_name;
        if ( exists $data_id_hash{$func_id} ) {
            my $href = $data_id_hash{$func_id};
            $href->{$cat_id} = $cat_name;
        }
        else {
            my %tmp;
            $tmp{$cat_id}           = $cat_name;
            $data_id_hash{$func_id} = \%tmp;
        }

        $last_cat_name = $cat_name;
    }
    $cur->finish();

    $cat_id_hash{"z"} = "Unclassified";

    return ( \%data_id_hash, \%cat_id_hash );
}

#
# get all phylo dist colors
# Note not all phylo dist
#    data id => cat id ===  func id => hash of cat id => cat name
#    my $data_id_href;
#    my $cat_id_href;   # cat_id => cat name
sub getPhyloDistCat {
    my ( $dbh, $taxon_oid ) = @_;

    my $sql;
    my $cur;

    if ($taxon_oid) {
        $sql = qq{
            select t.domain, t.phylum
                from dt_phylo_taxon_stats dt, taxon t
                where dt.taxon_oid = ?
                and dt.homolog_taxon = t.taxon_oid
            union
            select dt2.domain, dt2.phylum
                from dt_phylum_dist_genes dt2
                where dt2.taxon_oid = ?
            order by 1, 2
	    };
        $cur = execSql( $dbh, $sql, $verbose, $taxon_oid, $taxon_oid );
    }
    else {
        $sql = qq{
	    select distinct t.domain, t.phylum
		from taxon t
                where t.genome_type = 'isolate'
		order by 1, 2
	    };
        $cur = execSql( $dbh, $sql, $verbose );
    }

    my %data_id_hash;
    my %cat_id_hash;

    my $count         = 0;
    my $last_cat_name = "";
    for ( ; ; ) {
        my ( $domain, $phylum ) = $cur->fetchrow();
        last if !$domain;

	my $cat_id = "[" . substr($domain, 0, 1) . "]" . $phylum;
	my $cat_name = $cat_id;
	my $func_id = $cat_id;

        if ( $cat_name ne $last_cat_name ) {
            $count++;
        }
        $cat_id = $count;

        #webLog("==== $cat_id  === >${cat_name}<\n");

        $cat_id_hash{$cat_id} = $cat_name;
        if ( exists $data_id_hash{$func_id} ) {
            my $href = $data_id_hash{$func_id};
            $href->{$cat_id} = $cat_name;
        }
        else {
            my %tmp;
            $tmp{$cat_id}           = $cat_name;
            $data_id_hash{$func_id} = \%tmp;
        }

        $last_cat_name = $cat_name;
    }
    $cur->finish();

    $cat_id_hash{"z"} = "Unclassified";

    return ( \%data_id_hash, \%cat_id_hash );
}

############################################################################
# printMetaScaffoldDna - Print scaffold DNA in FASTA format.
############################################################################
sub printMetaScaffoldDna {
    my $scaffold_oid = param("scaffold_oid");
    my $start_coord  = param("start_coord");
    my $end_coord    = param("end_coord");

    my $taxon_oid = param("taxon_oid");
    my $data_type = param("data_type");
    if ( !$data_type ) {
        $data_type = 'assembled';
    }

    printStatusLine( "Loading ...", 1 );
    my $seq;
    $seq = MetaUtil::getScaffoldFna( $taxon_oid, $data_type, $scaffold_oid );

    my $d1 = $start_coord - 1;
    my $d2 = $end_coord + 1 - $start_coord;
    $seq = substr( $seq, $d1, $d2 );

    my $seq2 = wrapSeq($seq);

    print "<h1>Scaffold Nucleotide Sequence for Range</h1>\n";

    my $rows = length($seq) / 50 + 2;

    #if ($img_internal) {
    print qq{    
        <form method="post" action="main.cgi" name="findGeneBlast">
        };
    #}

    print "<pre>\n";
    print "<font color='blue'>\n";
    print ">$scaffold_oid $start_coord..$end_coord";
    print "</font>\n";

    # readonly='yes'
    print " <textarea name='fasta' rows='$rows' cols='70' style='background-color: #FFFFFF'  >\n";
    print "$seq2\n";
    print "</textarea>\n";
    print "</pre>\n";

    # missing gene form to run blastx
    #if ($img_internal) {

    print qq{
    <input type="hidden" name='section' value='FindGenesBlast' />
    <input type="hidden" name='page' value='geneSearchBlastForm' />
    
    <input type="hidden" name='blast_program' value='blastx' />
    <input type="hidden" name='ffgGeneSearchBlast' value='ffgGeneSearchBlast' />
    <input type="hidden" name='scaffold_oid' value='$scaffold_oid' />
    <input type="hidden" name='from' value='ScaffoldGraphDNA' />
    <input type="hidden" name='query_orig_start_coord' value='$start_coord' />
    <input type="hidden" name='query_orig_end_coord' value='$end_coord' />
    
    <br/>
};

    print qq{
<table class='img' border="0">
<tr>
<th class="subhead">E-value:</th>
<td >
<select name="blast_evalue">
<option value="10e-0">10e-0</option>
<option value="5e-0">5e-0</option>
<option value="2e-0">2e-0</option>
<option value="1e-0">1e-0</option>
<option value="1e-2">1e-2</option>
<option selected="selected" value="1e-5">1e-5</option>
<option value="1e-8">1e-8</option>
<option value="1e-10">1e-10</option>
<option value="1e-20">1e-20</option>
<option value="1e-50">1e-50</option>
</select></td>
</tr>    

<tr>
<th class="subhead">Databases:</th>
<td>
    <select name="imgBlastDb" size=10 multiple>
<option value="All IMG Genes - One large Database" selected>All IMG Genes - One large Database&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
<option value="currently selected">
  Currently selected genomes from Genome Browser</option>
};

    #    FindGenesBlast::printTaxonBlastOptions($dbh);

    print qq{
    </select>
</td>
</tr>
</table>    
<br/>

    <input class="smdefbutton" type="submit" name="ffgGeneSearchBlast" value="Missing Gene?" />
    </form>
};

    #}
    printStatusLine( "Loaded.", 2 );
}

############################################################################
# countReads - Count reads in contig.
############################################################################
sub countReads {
    my ( $dbh, $scaffold_oid ) = @_;

    #    my $sql = qq{
    #      select count(*)
    #      from read_sequence
    #      where scaffold = ?
    #   };
    #    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    #    my ($cnt) = $cur->fetchrow();
    #    $cur->finish();
    #    return $cnt;
    return 0;
}

############################################################################
# countExtLinks - Count external links.
############################################################################
sub countExtLinks {
    my ( $dbh, $scaffold_oid ) = @_;
    my $sql = qq{
      select count(*)
      from scaffold_ext_links
      where scaffold_oid = ?
   };
    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my ($cnt) = $cur->fetchrow();
    $cur->finish();
    return $cnt;
}

############################################################################
# countNotes - Count scaffold_notes
############################################################################
sub countNotes {
    my ( $dbh, $scaffold_oid ) = @_;
    my $sql = qq{
      select count(*)
      from scaffold_notes
      where scaffold_oid = ?
   };
    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my ($cnt) = $cur->fetchrow();
    $cur->finish();
    return $cnt;
}

############################################################################
# printExtLinks - Show external links for scaffold.
############################################################################
sub printExtLinks {
    my ( $dbh, $scaffold_oid ) = @_;

    my $sql = qq{
      select scaffold_oid, db_name, id
      from scaffold_ext_links
      where scaffold_oid = ?
   };
    print "<br/>\n";
    print "<font color='darkblue'>External Links</font>:<br/>\n";
    print "- ";
    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my $s;
    for ( ; ; ) {
        my ( $scaffold_oid, $db_name, $id ) = $cur->fetchrow();
        last if !$scaffold_oid;
        $s .= "$db_name:$id; ";
    }
    chop $s;
    chop $s;
    print "$s\n";
    $cur->finish();
    print "<br/>\n";
    print "<br/>\n";
}

############################################################################
# printNotes - Show notes
############################################################################
sub printNotes {
    my ( $dbh, $scaffold_oid ) = @_;

    my $sql = qq{
      select scaffold_oid, notes
      from scaffold_notes
      where scaffold_oid = ?
   };
    print "<font color='darkblue'>Notes</font>:<br/>\n";
    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    for ( ; ; ) {
        my ( $scaffold_oid, $notes ) = $cur->fetchrow();
        last if !$scaffold_oid;
        print "- ";
        print escHtml($notes);
        print "<br/>\n";
    }
    $cur->finish();
    print "<br/>\n";
}

############################################################################
# printContigReads - Show contig read ID's.
############################################################################
sub printContigReads {
    my $scaffold_oid = param("scaffold_oid");

    #    my $dbh = dbLogin();
    #    my $extAccession = QueryUtil::scaffoldOid2ExtAccession( $dbh, $scaffold_oid );
    #    print "<h1>Reads for $extAccession</h1>\n";
    #    my $sql = qq{
    #      select distinct ext_accession
    #      from read_sequence
    #      where scaffold = ?
    #      order by ext_accession
    #   };
    #    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    #    print "<p>\n";
    #    for ( ; ; ) {
    #        my ($ext_accession) = $cur->fetchrow();
    #        last if !$ext_accession;
    #        print escHtml($ext_accession) . "<br/>\n";
    #    }
    #    print "</p>\n";
    #    $cur->finish();
    #    #$dbh->disconnect();
}

############################################################################
#  printNoGenePanel - Print one panel with no genes (mainly because
#   there aren't any).
############################################################################
sub printNoGenePanel {
    my ( $dbh, $taxon_oid, $data_type, $scaffold_oid, 
        $scf_start_coord, $scf_end_coord, $scf_seq_length,
        $phantom_start_coord, $phantom_end_coord, $phantom_strand )
      = @_;

    my $id         = "$scaffold_oid.$scf_start_coord.x.$scf_end_coord.noGenes";
    my $coord_incr = int( ( $scf_end_coord - $scf_start_coord + 1 ) / 2 );
    my $args       = {
        id                 => "scf.$id",
        start_coord        => $scf_start_coord,
        end_coord          => $scf_end_coord,
        coord_incr         => $coord_incr,
        strand             => "+",
        has_frame          => 0,
        gene_page_base_url => "$main_cgi?section=GeneDetail&page=geneDetail",
        color_array_file   => $env->{small_color_array_file},
        tmp_dir            => $tmp_dir,
        tmp_url            => $tmp_url,
    };
    my $sp = new ScaffoldPanel($args);
    if (
           $phantom_start_coord ne ""
        && $phantom_end_coord   ne ""
        && $phantom_start_coord <= $phantom_end_coord
        && (   $phantom_end_coord >= $scf_start_coord
            && $phantom_start_coord <= $scf_end_coord )
      )
    {
        my $gene_oid = "phantom";
        my $strand   = "+";
        $strand = "-" if ( $phantom_strand eq "neg" );
        $sp->addPhantomGene( $gene_oid, $phantom_start_coord,
            $phantom_end_coord, $phantom_strand );
    }
    ScaffoldDataUtil::addNxFeatures( $dbh, $scaffold_oid, $sp, "+", $scf_start_coord,
			    $scf_end_coord );
    my $crisprCount = ScaffoldDataUtil::addMetaCrisprRepeats( $taxon_oid, $data_type, $scaffold_oid, 
        $sp, "+", $scf_start_coord, $scf_end_coord );
    my $s = $sp->getMapHtml("overlib");
    print "$s\n";
    
    return $crisprCount;    
}

#
# gets html color codes hash
sub getHTMLColorList {
    my %colors = (
        20  => "#0000FF",
        10  => "#3366FF",
        5   => "#6699FF",
        2   => "#CCCCFF",
        0   => "#CCCCCC",
        -2  => "#FFCCCC",
        -5  => "#CC6699",
        -10 => "#CC0033",
        -20 => "#FF0000"
    );

    return \%colors;
}

# gets rgb color codes hash using the html color code hash
sub getRGBColor {
    my $color_href = getHTMLColorList();
    return HtmlUtil::getRGBColor($color_href);
}

# gets only hash of the color keys
sub getGCColorHashKeys {
    my %colorHash;

    my $href = getHTMLColorList();
    foreach my $key ( keys %$href ) {
        $colorHash{$key} = "";
    }

    return \%colorHash;
}

# $sp - gd panel
# $gc - gene's gc
# $avg - genome's avg gc / characteristic gc
# $colorFuncs_aref  - user selected colors
sub getGCColor {
    my ( $sp, $gc, $avg, $colorFuncs_aref ) = @_;
    my $im = $sp->{im};

    $gc  = $gc * 100;
    $avg = $avg * 100;

    # keys 20, 10, 5, 2, 0, -2, -5, -10, -20
    # which ones to color, if null ignore
    my $color_href;
    if ( $colorFuncs_aref eq "" || $#$colorFuncs_aref < 0 ) {
        $color_href = getGCColorHashKeys();
    }
    else {
        foreach my $i (@$colorFuncs_aref) {
            $color_href->{$i} = "";
        }
    }

    my $diff = $gc - $avg;

    my $rgb_href = getRGBColor();

    # future get routine to convert the html color codes to
    # rgb color codes

    if ( $diff >= 2 && $diff < 5 && exists( $color_href->{2} ) ) {
        my $str = $rgb_href->{2};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff >= 5 && $diff < 10 && exists( $color_href->{5} ) ) {
        my $str = $rgb_href->{5};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff >= 10 && $diff < 20 && exists( $color_href->{10} ) ) {
        my $str = $rgb_href->{10};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff >= 20 && exists( $color_href->{20} ) ) {
        my $str = $rgb_href->{20};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff <= -2 && $diff > -5 && exists( $color_href->{-2} ) ) {
        my $str = $rgb_href->{-2};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff <= -5 && $diff > -10 && exists( $color_href->{-5} ) ) {
        my $str = $rgb_href->{-5};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff <= -10 && $diff > -20 && exists( $color_href->{-10} ) ) {
        my $str = $rgb_href->{-10};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff <= -20 && exists( $color_href->{-20} ) ) {
        my $str = $rgb_href->{-20};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    elsif ( $diff > -2 && $diff < 2 && exists( $color_href->{0} ) ) {
        my $str = $rgb_href->{0};
        my @rgb = split( ',', $str );
        return $im->colorAllocate( $rgb[0], $rgb[1], $rgb[2] );
    }
    else {
        return $sp->{color_yellow};
    }
}

# gets taxon gc percen, values 0 to 1.0
#
# but if draft get the scaffold gc avg not the taxon gc avg
sub getTaxonGCPercent {
    my ( $dbh, $marker_gene ) = @_;

    # Finished or Draft
    my $status = getSeqStatusViaGeneId( $dbh, $marker_gene );

    my $sql;

    if ( $status eq "Draft" ) {
        $sql = qq{
        select t.gc_percent
        from gene g, scaffold_stats t
        where g.taxon = t.taxon
        and g.scaffold = t.scaffold_oid
        and g.gene_oid = ?
        };
    }
    else {
        $sql = qq{
        select t.gc_percent
        from gene g, taxon_stats t
        where g.taxon = t.taxon_oid
        and g.gene_oid = ?
        };
    }
    my $cur = execSql( $dbh, $sql, $verbose, $marker_gene );
    my $pc = $cur->fetchrow();
    $cur->finish();
    return $pc;
}

# gets taxon gc avg via scaffold oid
#
# but if draft get the scaffold gc avg not the taxon gc avg
sub getTaxonGCPercentByScaffold {
    my ( $dbh, $scaffold_oid ) = @_;

    my $status = getSeqStatusViaScaffold( $dbh, $scaffold_oid );

    my $sql;

    if ( $status eq "Draft" ) {
        $sql = qq{
        select t.gc_percent
        from scaffold_stats t
        where t.scaffold_oid = ?
        };
    }
    else {
        my $rclause   = WebUtil::urClause('s.taxon');
        my $imgClause = WebUtil::imgClauseNoTaxon('s.taxon');
        $sql = qq{
        select t.gc_percent
        from scaffold s, taxon_stats t
        where s.taxon = t.taxon_oid
        and s.scaffold_oid = ?
        $rclause
        $imgClause
        };
    }

    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my $pc = $cur->fetchrow();
    $cur->finish();
    return $pc;
}

sub getSeqStatusViaGeneId {
    my ( $dbh, $gene_oid ) = @_;

    return "Draft";    # FIXME LATER

    my $sql = qq{
    select t.seq_status
    from taxon t, gene g
    where t.taxon_oid = g.taxon
    and g.gene_oid = ?        
    };

    my $cur = execSql( $dbh, $sql, $verbose, $gene_oid );
    my $pc = $cur->fetchrow();
    $cur->finish();
    return $pc;
}

sub getSeqStatusViaScaffold {
    my ( $dbh, $scaffold_oid ) = @_;

    return "Draft";    # FIXME LATER

    my $rclause   = WebUtil::urClause('s.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('s.taxon');
    my $sql       = qq{
    select t.seq_status
    from taxon t, scaffold s
    where t.taxon_oid = s.taxon
    and s.scaffold_oid = ?
    $rclause
    $imgClause
    };

    my $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );
    my $pc = $cur->fetchrow();
    $cur->finish();
    return $pc;
}

# returns list (hash set) of genes with a protein
sub getProtein {
    my ( $dbh, $taxon_oid, $start, $end ) = @_;

    my @binds = ($taxon_oid);
    my $clause;
    if ( $start ne "" ) {
        $clause .= " and g.start_coord >= ? ";
        push( @binds, $start );
    }
    if ( $end ne "" ) {
        $clause .= " and g.end_coord <= ? ";
        push( @binds, $end );
    }

    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
    my $sql       = qq{
        select distinct m.gene
        from ms_protein_img_genes m, gene g
        where m.genome = ?
        and m.gene = g.gene_oid
        and m.genome = g.taxon
        $clause
        $rclause
        $imgClause
    };

    my %list;
    my $cur = execSql( $dbh, $sql, $verbose, @binds );
    for ( ; ; ) {
        my ($gene_oid) = $cur->fetchrow();
        last if !$gene_oid;
        $list{$gene_oid} = "";
    }

    $cur->finish();
    return \%list;
}

sub getExpressionColor {
    my ( $sp, $gene_oid, $profile_href ) = @_;
    my $im  = $sp->{im};
    my $val = 10 * $profile_href->{$gene_oid};

    if ( $val && $val ne "" ) {
        my $ff0;
        if ( $val < 0.00 ) {
            $ff0 = -1 * $val;
        }
        else {
            $ff0 = $val;
        }
        if ( $ff0 > 1.0000000 ) {
            $ff0 = 1.0;
        }

        my ( $r, $g, $b );
        if ( $val < 0.00 ) {
            $r = 0;
            $g = int( 205 * $ff0 + 50 );
            $b = 0;
        }
        else {
            $r = int( 205 * $ff0 + 50 );
            $g = 0;
            $b = 0;
        }

        my $idx = $im->colorClosest( $r, $g, $b );
        if ( $idx == -1 ) {
            if ( $val < 0.00 ) {
                $g = $g + 1;
            }
            else {
                $r = $r + 1;
            }
            $idx = $im->colorClosest( $r, $g, $b );
        }

        #my ($r1,$g1,$b1) = $im->rgb($idx);
        #print "<br/>R: $r  G: $g  B: $b";
        #print "   > idx: ($idx) $r1 $g1 $b1";
        return $idx;
    }
    return $sp->{color_yellow};
}

############################################################################
# getExpressionProfile - queries for the coverage values for each gene in
#        the specified proteomic sample
############################################################################
sub getExpressionProfile {
    my ( $dbh, $sample_oid, $study, $taxon_oid, $data_type,
	 $scaffold_oid, $in_file ) = @_;

    my $rclause   = WebUtil::urClause('g.taxon');
    my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
    my $sql       = qq{ 
        select distinct dt.gene_oid, round(sum(dt.coverage), 7) 
        from dt_img_gene_prot_pep_sample dt, gene g 
	where dt.sample_oid = ? 
	and dt.gene_oid = g.gene_oid 
        and g.scaffold = ?
        $rclause
        $imgClause
	group by dt.gene_oid
    };
    if ( $study eq "rnaseq" ) {
        $sql = qq{
	    select distinct es.IMG_gene_oid,
		   round(es.reads_cnt/g.DNA_seq_length, 5)
	    from rnaseq_expression es, gene g
	    where es.dataset_oid = ?
	    and g.gene_oid = es.IMG_gene_oid
            and g.scaffold = ?
            $rclause
            $imgClause
	};
    }

    my @genes;
    my @values;

    my %scfgene2info;
    if ($study eq "rnaseq") {
	%scfgene2info = MetaUtil::getGenesForRNASeqSampleInScaffold
	    ( $sample_oid, $taxon_oid, $scaffold_oid);
    }

    if (scalar keys %scfgene2info < 1) {
        my %gene2info;
	if ($study eq "rnaseq") {
	    %gene2info = MetaUtil::getGenesForRNASeqSample
		( $sample_oid, $taxon_oid );
	}
	if (scalar keys %gene2info > 0) {
	    my %genes4scaffold = MetaUtil::getScaffoldGenes
		( $taxon_oid, $data_type, $scaffold_oid );
	    my @genes_on_s = keys %genes4scaffold;

	    foreach my $item (@genes_on_s) {
		my ( $gene, @rest ) = split( /\t/, $item );
		
		my $line = $gene2info{$gene};
		my ( $geneid, $locus_type, $locus_tag, $strand, $scaffold_oid0,
		     $dna_seq_length, $reads_cnt, @rest )
		    = split( "\t", $line );

		next if ( $reads_cnt == 0 );
		next if ( $dna_seq_length == 0 );
		
		my $coverage = $reads_cnt / $dna_seq_length;
		if ( $coverage > 0.00000 ) {
		    push @genes, $gene;
		    push @values, sprintf( "%.5f", $coverage );
		}
	    }
	    
	} 

	if ($study eq "proteomics") {
	    my $cur = execSql
		( $dbh, $sql, $verbose, $sample_oid, $scaffold_oid );
	    for ( ;; ) {
		my ( $gid, $coverage ) = $cur->fetchrow();
		last if !$gid;
		next if $coverage == 0;
		push @genes, $gid;
		push @values, sprintf( "%.5f", $coverage );
	    }
	    $cur->finish();
	}

    } else {
	foreach my $gene (keys %scfgene2info) {
	    my $line = $scfgene2info{$gene};
	    my ( $geneid, $locus_type, $locus_tag, $strand, $scaffold_oid0,
		 $dna_seq_length, $reads_cnt, @rest )
		= split( "\t", $line );
	    next if ( $reads_cnt == 0 );
	    next if ( $dna_seq_length == 0 );

	    my $coverage = $reads_cnt / $dna_seq_length;
	    if ( $coverage > 0.00000 ) {
		push @genes, $gene;
		push @values, sprintf( "%.5f", $coverage );
	    }
	}
    }

    my %profile;
    return \%profile if ( scalar @genes == 0 );
    if ( scalar @genes == 1 ) {
        $profile{ $genes[0] } = $values[0];
        $profile{ "orig" . "$genes[0]" } = $values[0];
        return \%profile;
    }

    my $tvalues     = logTransform( \@values );
    my $cvalues     = center($tvalues);
    my $nvalues_ref = normalize($cvalues);
    my @nvalues     = @$nvalues_ref;

    my $idx = 0;
    foreach my $gene (@genes) {
        $profile{$gene} = $nvalues[$idx];
        $profile{ "orig" . "$gene" } = $values[$idx];
        $idx++;
    }
    return \%profile;
}

# replace all values x by log base 2 of (x)
sub logTransform {
    my ($values) = @_;
    my @tvalues;
    foreach my $v (@$values) {
        my $t = log($v) / log(2);
        push @tvalues, $t;
    }
    return \@tvalues;
}

sub center {
    my ($values) = @_;

    my $cnt = scalar @$values;
    my $sum = 0;
    foreach my $v (@$values) {
        $sum += $v;
    }
    my $mean = $sum / $cnt;
    my @cvalues;
    foreach my $v (@$values) {
        my $c = $v - $mean;
        push @cvalues, $c;
    }
    return \@cvalues;
}

#############################################################################
# normalize: multiply all values by a scale factor S so that
# the sum of the squares of the values in each row is 1.0
#############################################################################
sub normalize {
    my ($values) = @_;

    my $sum = 0;
    foreach my $v (@$values) {
        $sum += $v * $v;
    }

    my $sval = sqrt( 1 / $sum );

    my @nvalues;
    foreach my $v (@$values) {
        my $n = $sval * $v;
        push @nvalues, sprintf( "%.3f", $n );
    }
    return \@nvalues;
}


#############################################################################
# getMetaScaffoldAttributes - Get scaffold attributes from MERFs
#   Inputs:
#     r_ref - records reference.
#############################################################################
sub getMetaScaffoldAttributes {
    my ( $dbh, $r_ref ) = @_;
    my @recs;
    my %taxons;

    my %gene_oids_hash;
    for my $r (@$r_ref) {
        my ( $scf_id_full, undef ) = split( /\t/, $r, 2 );
#print "scf_id_full $scf_id_full <br>\n";
        #my ( $goid, $dtype, $toid ) = MetaUtil::parseMetaGeneOid($scf_id_full);
        my ( $goid, $dtype, $toid ) = MetaUtil::parseMetaScaffoldOid($scf_id_full);
        unless ( $taxons{$toid} ) {
            $taxons{$toid} = 1;
        }
        my $hash_key = "$toid.$dtype";
        if ( exists( $gene_oids_hash{$hash_key} ) ) {
            push( @{$gene_oids_hash{$hash_key}}, $goid );
        } else {
            $gene_oids_hash{$hash_key} = [ $goid ];
        }
    }

    my $taxon_oids_str = join( ",", keys %taxons ); 

    my $sql = qq{
        select taxon_oid, domain, seq_status, taxon_display_name
        from taxon
        where taxon_oid in ($taxon_oids_str)
    };
    my $cur = WebUtil::execSql( $dbh, $sql, $verbose );
    for ( ; ; ) {
        my ( $taxon_oid, $domain, $seq_status, 
            $taxon_display_name ) = $cur->fetchrow();
        last if !$taxon_oid;
        $taxons{$taxon_oid} = join( "\t", $domain, $seq_status, $taxon_display_name );
        # single quotes do not work for joinning with tab
    }

    my %stats_hash;
    for my $key ( keys %gene_oids_hash ) {
        my ( $toid, $dtype ) = split( /\./, $key, 2 );
        my $href = MetaUtil::getScaffoldStatsForTaxonScaffolds2(
            $toid, $dtype, $gene_oids_hash{$key} );
        for my $goid ( keys %$href ) {
            my $goid_full = MetaUtil::getMetaGeneOid( $goid, $dtype, $toid );
            $stats_hash{$goid_full} = $href->{$goid};
        }
    }




    for my $r (@$r_ref) {        
        my ( $scf_id_full, $percIdent, $evalue, $bitScore, 
             $query_start, $query_end, $subj_start, $subj_end, $alen
        ) = split( /\t/, $r );
        #my ( $goid, $dtype, $taxon ) = MetaUtil::parseMetaGeneOid($scf_id_full);
        my ( $goid, $dtype, $taxon ) = MetaUtil::parseMetaScaffoldOid($scf_id_full);
        my $gene_oid_full = MetaUtil::getMetaGeneOid( $goid, $dtype, $taxon );
        my ( $goid2, $scf_seq_length, $scf_gc_percent, $gene_count ) 
                = split( /\t/, $stats_hash{$scf_id_full} );
        my ( $domain, $seq_status, $taxon_display_name ) = split( /\t/, $taxons{$taxon} );

        my $r = "-\t"; # ext_accession not applicable or not available for MERFS scaffolds
        $r .= "$gene_oid_full\t";
        $r .= "-\t";# scaffold_name not applicable or not available for MERFS scaffolds
        $r .= "$taxon\t";
        $r .= "$percIdent\t";
        $r .= "$evalue\t";
        $r .= "$bitScore\t";
        $r .= "$query_start\t";
        $r .= "$query_end\t";
        $r .= "$subj_start\t";
        $r .= "$subj_end\t";
        $r .= "$alen\t";
        $r .= "-\t"; # opType not applicable or not available for MERFS scaffolds
        $r .= "$domain\t";
        $r .= "$seq_status\t";
        $r .= "$taxon_display_name\t";
        $r .= "$scf_seq_length\t";
        $r .= "$scf_gc_percent\t";
        $r .= "-\t"; # scf_read_depth not applicable or not available for MERFS scaffolds
        push( @recs, $r );
    }
    return @recs;
}



1;

