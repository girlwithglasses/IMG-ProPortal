############################################################################
# Viral IMG
############################################################################
package Viral;

use strict;
use CGI qw( :standard );
use DBI;
use POSIX qw(ceil floor);
use HTML::Template;
use WebConfig;
use WebUtil;
use Data::Dumper;
use GenomeList;
use LwpHandle;
use Command;
use FindGenesBlast;

my $section        = 'Viral';
my $env            = getEnv();
my $main_cgi       = $env->{main_cgi};
my $section_cgi    = "$main_cgi?section=$section";
my $verbose        = $env->{verbose};
my $base_url       = $env->{base_url};
my $base_dir       = $env->{base_dir};
my $top_base_url   = $env->{top_base_url};
my $common_tmp_dir = $env->{common_tmp_dir};
my $cgi_tmp_dir    = $env->{cgi_tmp_dir};
my $cgi_url        = $env->{cgi_url};
my $cgi_dir        = $env->{cgi_dir};

my $blast_a_flag = $env->{blast_a_flag};
$blast_a_flag = "-a 16" if $blast_a_flag eq "";
my $blastallm0_server_url = $env->{blastallm0_server_url};
my $default_timeout_mins = $env->{default_timeout_mins};

my $img_lid_blastdb = $env->{img_lid_blastdb};
my $vpf_models_url  = $env->{base_url} . "/../virus/doc/final_list.hmms.gz";

my $viral_table_name = "dt_viral_clusters\@core_v400_musk";    # table 1
my $host_assignment_table_name = "dt_viral_host_assignment\@core_v400_musk";
my $spacer_table_name = "dt_viral_spacer\@core_v400_musk";
my $crispr_table_name = "taxon_crispr_details\@core_v400_musk";
my $mvc_taxonomy_table = "dt_mvc_taxonomy\@core_v400_musk";    # table 4

my $YUI = $env->{yui_dir_28};


sub getPageTitle {
    my $page = param('page');
    if ( $page =~ /^kentest/ ) {
        return "Find Genomes";
    } 
    else {
        return "Home";
    }
}

sub getAppHeaderData {
    my ($self) = @_;
    
    my @a = ();
    if (WebUtil::paramMatch("noHeader") ne "") {
        return @a;
    } else {
        my $page = param('page');
        if ( $page =~ /^kentest/ ) {
            @a = ("Find Genomes");
        } 
        else {
            @a = ("Home");
        }
    }
    return @a;
}

sub getDatamartEnv {
    my $e = {};

    $e->{name}       = 'IMG ProPortal';
    $e->{main_label} = 'Marine Cyanobacterium';

    my @members = ( 'prochlorococcus', 'synechococcus', 'cyanophage' );
    $e->{members} = \@members;

    my %labels;
    $labels{'prochlorococcus'} = 'Prochlorococcus';
    $labels{'synechococcus'}   = 'Synechococcus';
    $labels{'cyanophage'}      = 'Cyanophage';
    $e->{member_labels}        = \%labels;

    my %conds;
    $conds{'prochlorococcus'} =
"lower(t.GENUS) like '%prochlorococcus%' and t.sequencing_gold_id in (select gold_id from gold_sequencing_project where ecosystem_type = 'Marine')";
    $conds{'synechococcus'} =
"lower(t.GENUS) like '%synechococcus%' and t.sequencing_gold_id in (select gold_id from gold_sequencing_project where ecosystem_type = 'Marine')";
    $conds{'cyanophage'} =
"lower(t.taxon_display_name) like '%cyanophage%' or lower(t.taxon_display_name) like '%prochlorococcus phage%' or lower(t.taxon_display_name) like '%synechococcus phage%'";
    $e->{member_conds} = \%conds;

    $e->{img_group_id} = 26;

    return $e;
}

sub dispatch {
    my ( $self, $numTaxon ) = @_;    

    my $page  = param('page');
    #print "page=$page<br/>\n";
    #my $cgi   = WebUtil::getCgi();
    #my @all_params = $cgi->param;
    #print "all_params=@all_params";

    if ( $page eq "googlemap" ) {
    	## map will display from main
    }

    if ( $page eq "exportScaffoldTable" 
        || paramMatch("exportScaffoldTable") ne "" ) {
        exportScaffoldTable();
        return;
    }

    print qq{
    	<div id="content_other">
    };

    if ( $page eq 'genomeList' ) {
        printGenomes();
    } elsif ( $page eq "bodySiteDetail" ) {
	   printInfoForBodySite();
    } elsif ( $page eq "viralStudyList" ) {
	   printViralStudyList();
    } elsif ( $page eq "viralClusterList" ) {
	   printViralClusterList();
    } elsif ( $page eq "viralClusterDetail" ) {
	   printClusterDetail();
    } elsif ( $page eq "spacerDetail" ) {
	   printSpacerDetail();
    } elsif ( $page eq "viralClusterGenome" ) {
	   printClusterGenome();
    } elsif ( $page eq "viralClusterStudy" ) {
	   printClusterStudy();
    } elsif ( $page eq "viralHostList" ) {
	   printViralHostList();
    } elsif ( $page eq "viralHostBySpacerList" ) {
	   printViralHostBySpacerList();
    } elsif ( $page eq "viralHostDetail" ) {
	   printViralHostDetail();
    } elsif ( $page eq "isoHostDetail" 
        || paramMatch("isoHostDetail") ne "" ) {
    	printViralHostDetail('isolate');
    } elsif ( $page eq "metaHostDetail" 
        || paramMatch("metaHostDetail") ne "" ) {
	   printViralHostDetail('metagenome');
    } elsif ( $page eq "bothHostDetail" 
        || paramMatch("bothHostDetail") ne "" ) {
	   printViralHostDetail('');
    } elsif ( $page eq "viralMvcHostList" ) {
	   printViralMvcHostList();
    } elsif ( $page eq "mvcHostDetail" 
        || paramMatch("mvcHostDetail") ne "" ) {
	   printViralMvcHostDetail('metagenome');
    } elsif ( $page eq "viralScaffoldList" ) {
	   printViralScaffoldList();
    } elsif ( $page eq "printViralMethod" ) {
	   printViralMethodForm();
    } elsif ( $page eq "printClusterMethod" ) {
	   printClusterMethodForm();
    } elsif ( $page eq "printSingletonMethod" ) {
	   printSingletonMethodForm();
    } elsif ( $page eq "printHostMethod" ) {
	   printHostMethodForm();
    } elsif ( $page eq "findViralGenesBlast" ) {
	   printViralBlastForm();
    } elsif ( $page eq "viralBlastResults" 
        || paramMatch("viralBlastResults") ne "") {
	   FindGenesBlast::printGeneSearchBlastResults();
    } 

    print "</div>"; # end of content_other
}

##############################################################
# getDatamartStats: stats data
##############################################################
sub getDatamartStats {
    my $dbh = dbLogin();

    my @color = ( "#66ccff", "#ff99aa", "#ffdd99", "#bbbbbb" );

    my $ivg = "Isolate Viruses (iVGs)";
    my $mvg = "Metagenomic Viral Contigs (mVCs)";
    my @list = ( $ivg, $mvg );
    my %counts;
    my $total = 0;
    for my $x (@list) {
        $counts{$x} = 0;
    }

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    my $sql = qq{
        select count(*) from taxon t 
        where t.genome_type = 'isolate'
        and t.domain = 'Viruses'
        $rclause
        $imgClause
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    my ($count) = $cur->fetchrow();
    $counts{$ivg} = $count;
    $total += $count;
    $cur->finish();

    ## Amy: we want to show all counts for mvc
    $rclause = "";
    $imgClause = "";

    $sql = qq{
          select count(distinct v.scaffold_id) 
          from $viral_table_name v, taxon t
          where v.ecosystem not like 'ref\%'
          and v.taxon_oid = t.taxon_oid
          and t.genome_type = 'metagenome'
          and t.obsolete_flag = 'No'
          $rclause
          $imgClause
          };
    $cur = execSql( $dbh, $sql, $verbose );
    ($count) = $cur->fetchrow();
    $counts{$mvg} = $count;
    $total += $count;
    $cur->finish();

    my $str;
    my $i = 0;
    foreach my $x (@list) {
        my $cnt  = $counts{$x};
        my $name = $x;
        my $tmp  = $i % 4; # for 4 possible colors

	my $url = $section_cgi . "&page=viralStudyList";
	if ( $x eq $mvg ) {
	    $url .= "&genome_type=metagenome";
	}
	else {
	    $url .= "&genome_type=isolate";
	}
        $url = alink( $url, $cnt );
        $str .= qq{<tr bgcolor=$color[$tmp]><td colspan='2'>$name</td><td align='right'>$url</td></tr> };
        $i++;
    }

    my $url = $section_cgi . "&page=viralStudyList";
    my $total_url = alink($url, $total);
    $str .= qq{<tr><td colspan='2'>Total Viral Datasets</td><td align='right'>$total_url</td></tr> };

    return $str;
}


##############################################################
# getViralClusterStats: stats data
##############################################################
sub getViralClusterStats {
    my $dbh = dbLogin();

    my @color = ( "#66ccff", "#ff99aa", "#ffdd99", "#bbbbbb" );

    my $vc = "Viral Clusters";
    my $vs = "Viral Singletons";
    my @list = ( $vc, $vs );
    my %counts;
    for my $x (@list) {
        $counts{$x} = 0;
    }

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all counts
    $rclause = "";
    $imgClause = "";

    my $sql = qq{
         select count(distinct v.viral_clusters)
         from $viral_table_name v, taxon t
         where v.taxon_oid = t.taxon_oid
         and t.obsolete_flag = 'No'
         $rclause
         $imgClause
         };
    my $cur = execSql( $dbh, $sql, $verbose );
    my ($total) = $cur->fetchrow();
    $cur->finish();

    $sql = qq{
         select count(distinct v.viral_clusters)
         from $viral_table_name v, taxon t
         where v.taxon_oid = t.taxon_oid
         and v.viral_clusters like 'sg%'
         and t.obsolete_flag = 'No'
         $rclause
         $imgClause
         };
    $cur = execSql( $dbh, $sql, $verbose );
    my ($sg_cnt) = $cur->fetchrow();
    $cur->finish();

    $counts{$vs} = $sg_cnt;
    $counts{$vc} = $total - $sg_cnt;

    my $str;
    my $i = 0;
    foreach my $x (@list) {
        my $cnt  = $counts{$x};
        my $name = $x;
        my $tmp  = ($i % 4) + 2;               # for 4 possible colors

	my $url = $section_cgi . "&page=viralClusterList";
	if ( $x eq $vs ) {
	    $url .= "&cluster_type=singleton";
	}
	else {
	    $url .= "&cluster_type=cluster";
	}
        $url = alink( $url, $cnt );
##	$url = $cnt;
        $str .= qq{<tr bgcolor=$color[$tmp]><td colspan='2'>$name</td><td align='right'>$url</td></tr> };
        $i++;
    }

    return $str;
}

##############################################################
# getViralHostStats: stats data
##############################################################
sub getViralHostStats {
    my $dbh = dbLogin();

    my @color = ( "#66cc66", "#aa99ff", "#99ddff", "#bababa" );

    my $ivg = "Isolate Viruses (iVGs)";
    my $mvg = "Metagenomic Viral Contigs (mVCs): spacer hit";
    my @list = ( $ivg, $mvg );
    my %counts;
    my $total = 0;
    for my $x (@list) {
        $counts{$x} = 0;
    }

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all counts
    $rclause = "";
    $imgClause = "";

    my $sql = qq{
          select count(*) from taxon t 
          where genome_type = 'isolate' and domain = 'Viruses' 
          and sequencing_gold_id is not null
          and sequencing_gold_id in
              (select gold_id from gold_sequencing_project
               where host_name is not null)
          $rclause $imgClause
          };
    my $cur = execSql( $dbh, $sql, $verbose );
    my ($count) = $cur->fetchrow();
    $counts{$ivg} = $count;
    $total          += $count;
    $cur->finish();

##    $sql = "select count(*) from $viral_table_name where host is not null";
    $sql = qq{
        select count(distinct scaffold_id) 
        from $host_assignment_table_name
        where taxon_oid in
        (select taxon_oid from taxon where genome_type = 'metagenome')
    };
    $cur = execSql( $dbh, $sql, $verbose );
    ($count) = $cur->fetchrow();
    $counts{$mvg} = $count;
    $total          += $count;
    $cur->finish();

    my $str;
    my $i = 0;
    foreach my $x (@list) {
        my $cnt  = $counts{$x};
        my $name = $x;
        my $tmp  = $i % 4;                 # for 4 possible colors

	my $url = $section_cgi . "&page=viralHostList";
	if ( $x eq $mvg ) {
	    $url = $section_cgi . "&page=viralHostBySpacerList";
	    $url .= "&genome_type=metagenome";
	}
	else {
	    $url .= "&genome_type=isolate";
	}
        $url = alink( $url, $cnt );
        $str .= qq{<tr bgcolor=$color[$tmp]><td colspan='2'>$name</td><td align='right'>$url</td></tr> };
        $i++;
    }

    my $sql = qq{
         select count(distinct v.scaffold_id)
         from $viral_table_name v, taxon t
         where v.taxon_oid = t.taxon_oid
         and v.host is not null
         and t.obsolete_flag = 'No'
         and t.genome_type = 'metagenome'
         $rclause
         $imgClause
         };
    my $cur = execSql( $dbh, $sql, $verbose );
    my ($mvc_total) = $cur->fetchrow();
    $cur->finish();
    my $url = $section_cgi . "&page=viralMvcHostList";
    my $total_url = alink($url, $mvc_total);
    $str .= qq{<tr bgcolor=$color[2]><td colspan='2'>Metagenomic Viral Contigs (mVCs): total</td><td align='right'>$total_url</td></tr> };

# hide this one
#    my $url = $section_cgi . "&page=viralHostList";
#    my $total_url = alink($url, $total);
#    $str .= qq{<tr><td colspan='2'>Total Viral Datasets</td><td align='right'>$total_url</td></tr> };

    return $str;
}


#################################################################
# printViralHome
#################################################################
sub printViralHome {
    print qq{<div style="width: 1500px;">}; 
    printViralStatsDiv();
    print qq{
        <div id="content" class="content" 
         style="font-size: 16px; border: none; width: 1000px; margin-left: 0;">
    };

## print "<p>*** page: " . param('page') . "\n";
#  my $new_url = $main_cgi . "?section=Viral";

    #HtmlUtil::cgiCacheInitialize("homepage_viral");
    #HtmlUtil::cgiCacheStart() or return; 

    print qq{
        <script language='JavaScript' type='text/javascript'>
        function showView(type) {
        if (type == 'env') {
            document.getElementById('bodyView').style.display = 'none';
            document.getElementById('envView').style.display = 'block';
        } else {
            document.getElementById('bodyView').style.display = 'block';
            document.getElementById('envView').style.display = 'none';
        }
        }
        </script>
    };
    print "<div id='envView' style='display: block; line-height: 11px;'>";
    writeDiv("env");
    print "</div>";

    print "<div id='bodyView' style='display: none;'>";
    writeDiv("body");
    print "</div>";

    #HtmlUtil::cgiCacheStop();
}

sub writeDiv {
    my ($which) = @_;

    my $paper_link = alink("http://rdcu.be/kdrd", "\"Uncovering Earth's virome\"");
    my $nar_url = "http://nar.oxfordjournals.org/content/early/2016/10/30/nar.gkw1030";
    my $info = "<p style='width: 680px;'>The <b>IMG/VR</b> system (" .
	alink($nar_url, $nar_url) .
	") serves as a starting point for the sequence analysis of viral fragments derived from metagenomic samples. Virus detection methods and host assignment approaches in IMG/VR are fully described in Paez-Espino et al. <b><i>Nature</i></b>, 2016 $paper_link.</p>";

    print "<table><tr bgcolor='lightblue'><td>\n";
    print $info;
    print "</td></tr></table>";
    print "</p>\n";

    if ($which eq "env") {
	my $info = "<p style='width: 680px;'> All metagenome datasets with geo-location are organized in three main ecosystem types: <i>engineered</i>, <i>environmental</i>, and <i>host-associated</i>. All ecosystem types shown together by default. Customizable by selecting the <i>Ecosystem</i> tab.</p>";
	my $info = "All metagenome datasets with geo-location are organized in three main ecosystem types: engineered, environmental, and host-associated. All ecosystem types shown together by default. Customizable by selecting the Ecosystem tab.";

##	print "<h1>Ecosystems</h1>\n";

	print qq{
           <h1>Ecosystems
               <a href="" onClick="alert('$info'); return false;">
               <span id="ecosystems" title="$info">
               <image src="$base_url/images/question.png"></span></a></h1>
        };

        print "<input type='button' class='medbutton' name='view'"
            . " value='Show Human Body Sites'"
            . " onclick='showView(\"body\")' />";
        print "<br/>";

	require ImgStatsOverview;
	ImgStatsOverview::googleMap_new("virus");
	printEcosystemCount();

    } elsif ($which eq "body") {
##        print "<h1>Human Body Sites</h1>";
	my $info = "<p style='width: 680px;'> All viral contigs identified in samples from the human body for each of the 5 main human body sites (nose, mouth, skin, intestine, and vagina). Viral contigs data can be retrieved either from the body illustration or from the <i>Human Body Sites</i> summary table. Total samples or individual metagenomes can be also accessed from the summary table.</p>\n";
	my $info = "All viral contigs identified in samples from the human body for each of the 5 main human body sites (nose, mouth, skin, intestine, and vagina). Viral contigs data can be retrieved either from the body illustration or from the Human Body Sites summary table. Total samples or individual metagenomes can be also accessed from the summary table.";

	print qq{
           <h1>Human Body Sites
               <a href="" onClick="alert('$info'); return false;">
               <span id="ecosystems" title="$info">
               <image src="$base_url/images/question.png"></span></a></h1>
        };

        print "<input type='button' class='medbutton' name='view'"
            . " value='Show Ecosystems'"
            . " onclick='showView(\"env\")' />";
        print "<br/>";

	#style="border:2px #99CCFF solid;" 
	my $bs_url = "$section_cgi&page=bodySiteDetail&body_site=";
	my $air_url = "$section_cgi&page=bodySiteDetail&body_site=airway";
	my $gi_url = "$section_cgi&page=bodySiteDetail&body_site=gi";
	my $skin_url = "$section_cgi&page=bodySiteDetail&body_site=skin";
	my $oral_url = "$section_cgi&page=bodySiteDetail&body_site=oral";
	my $ug_url = "$section_cgi&page=bodySiteDetail&body_site=ug";
	print qq{
            <table><tr><td valign='top'>
            <img usemap="#image-map" src="$base_url/images/hmp_imgn.jpg" border="0"
             alt="Human Body Sites"/>

            <map name="image-map">
            <area shape="rect" coords="178,375,204,350" target="_blank" 
             href="$gi_url" title="Gastro-Intestinal">
            <area shape="rect" coords="188,397,214,421" target="_blank" 
             href="$ug_url" title="Urogenital">
            <area shape="rect" coords="240,122,211,97,235,61,237,83" target="_blank" 
             href="$oral_url" title="Oral">
            <area shape="rect" coords="130,265,157,292" target="_blank"  
             href="$skin_url" title="Skin">
            <area shape="rect" coords="189,75,212,98" target="_blank" 
             href="$air_url" title="Airway">
            </map>
            </td>

            <td valign='top'>
        };

	printBodySiteCounts();

	print qq{
            </td></tr>
            </table>
            };

	printHint("Click on a body site in the figure* to see the data for that body site.");
	my $credit = "<p style='width: 680px;'>*This illustration shows the body sites that were sampled from volunteers for the Human Microbiome Project, part of the National Institutes of Health's Roadmap for Medical Research. <i>Credit: NIH Medical Arts and Printing</i></p>";
	print $credit;
    } 
}

sub printBodySiteCounts {
    my $dbh = dbLogin();

    my %bs2vc;
    my $sql = qq{
        select v.body_site, count(distinct v.viral_clusters)
        from $viral_table_name v, taxon tx
        where v.body_site is not null
        and viral_clusters like 'vc%'
        and v.taxon_oid = tx.taxon_oid
        and tx.obsolete_flag = 'No'
        group by v.body_site
        order by v.body_site
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    for ( ;; ) {
	my ($body_site, $count) = $cur->fetchrow();
	last if !$body_site;
	$bs2vc{ $body_site } = $count;
    }
    $cur->finish();

    my %bs2sg;
    my $sql = qq{
        select v.body_site, count(distinct v.viral_clusters)
        from $viral_table_name v, taxon tx
        where v.body_site is not null
        and v.viral_clusters like 'sg%'
        and v.taxon_oid = tx.taxon_oid
        and tx.obsolete_flag = 'No'
        group by v.body_site
        order by v.body_site
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    for ( ;; ) {
	my ($body_site, $count) = $cur->fetchrow();
	last if !$body_site;
	$bs2sg{ $body_site } = $count;
    }
    $cur->finish();

    my %bs2scfs_wh;
    my $sql = qq{
        select v.body_site, count(distinct v.scaffold_id)
        from $viral_table_name v, taxon tx
        where v.body_site is not null
        and v.host is not null
        and v.taxon_oid = tx.taxon_oid
        and tx.obsolete_flag = 'No'
        group by v.body_site
        order by v.body_site
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    for ( ;; ) {
	my ($body_site, $count) = $cur->fetchrow();
	last if !$body_site;
	$bs2scfs_wh{ $body_site } = $count;
    }
    $cur->finish();

    my %bs2scfs;
    my $sql = qq{
        select v.body_site, count(distinct v.scaffold_id)
        from $viral_table_name v, taxon tx
        where v.body_site is not null
        and v.taxon_oid = tx.taxon_oid
        and tx.obsolete_flag = 'No'
        group by v.body_site
        order by v.body_site
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    for ( ;; ) {
	my ($body_site, $count) = $cur->fetchrow();
	last if !$body_site;
	$bs2scfs{ $body_site } = $count;
    }
    $cur->finish();

    my %bs2txs;
    my $sql = qq{
        select v.body_site, count(distinct v.taxon_oid)
        from $viral_table_name v, taxon tx
        where v.body_site is not null
        and v.taxon_oid = tx.taxon_oid
        and tx.obsolete_flag = 'No'
        group by v.body_site
        order by v.body_site
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    for ( ;; ) {
	my ($body_site, $count) = $cur->fetchrow();
	last if !$body_site;
	$bs2txs{ $body_site } = $count;
    }
    $cur->finish();

    my @headers = sort keys %bs2scfs;

    print "<link rel='stylesheet' type='text/css' "
	. "href='$YUI/build/datatable/assets/skins/sam/datatable.css' />";

    print "<div class='yui-dt'>";
    print "<table class='img'>";
    print "<tr>";
    print "<th></th>";
    foreach my $col (@headers) {
	print "<th><div class='yui-dt-liner'><b>".ucfirst($col)."</b></div></th>";
    }
    print "</tr>";

    print "<tr class='yui-dt-odd'>";
    print "<td class='yui-dt-odd' style='text-align:right;'>";
    print "<div class='yui-dt-liner'><b>Total mVCs</b></div>";
    print "</td>";
    my $bs_url = "$section_cgi&page=bodySiteDetail&body_site=";
    foreach my $col (@headers) {
	my $col2 = $col;
	$col2 = "gi" if $col eq "gastrointestinal tract";
	$col2 = "ug" if $col eq "urogenital tract/vagina";

	print "<td class='yui-dt-odd' style='text-align:right;'>";
	print "<div class='yui-dt-liner'>";
	my $link = alink($bs_url.$col2, $bs2scfs{ $col }, "_blank");
	print $link;
	print "</div>";
	print "</td>";
    }
    print "</tr>";

    print "<tr class='yui-dt-even'>";
    print "<td style='text-align:right;'>";
    print "<div class='yui-dt-liner'><b>mVCs with Host</b></div>";
    print "</td>";
    foreach my $col (@headers) {
	my $col2 = $col;
	$col2 = "gi" if $col eq "gastrointestinal tract";
	$col2 = "ug" if $col eq "urogenital tract/vagina";

	print "<td class='yui-dt-even' style='text-align:right;'>";
	print "<div class='yui-dt-liner'>";
	my $link = alink($bs_url.$col2."&host=1", $bs2scfs_wh{ $col }, "_blank");
	print $link;
	print "</div>";
	print "</td>";
    }
    print "</tr>";

    print "<tr class='yui-dt-even'>";
    print "<td style='text-align:right;'>";
    print "<div class='yui-dt-liner'><b>Unique Viral Clusters</b></div>";
    print "</td>";
    foreach my $col (@headers) {
	my $col2 = $col;
	$col2 = "gi" if $col eq "gastrointestinal tract";
	$col2 = "ug" if $col eq "urogenital tract/vagina";

	print "<td class='yui-dt-even' style='text-align:right;'>";
	print "<div class='yui-dt-liner'>";
	my $link = alink($bs_url.$col2."&vc=1", $bs2vc{ $col }, "_blank");
	print $link;
	print "</div>";
	print "</td>";
    }
    print "</tr>";

    print "<tr class='yui-dt-odd'>";
    print "<td class='yui-dt-odd' style='text-align:right;'>";
    print "<div class='yui-dt-liner'><b>Viral Singletons</b></div>";
    print "</td>";
    foreach my $col (@headers) {
	my $col2 = $col;
	$col2 = "gi" if $col eq "gastrointestinal tract";
	$col2 = "ug" if $col eq "urogenital tract/vagina";

	print "<td class='yui-dt-odd' style='text-align:right;'>";
	print "<div class='yui-dt-liner'>";
	my $link = alink($bs_url.$col2."&sg=1", $bs2sg{ $col }, "_blank");
	print $link;
	print "</div>";
	print "</td>";
    }
    print "</tr>";

    print "<tr class='yui-dt-odd'>";
    print "<td class='yui-dt-odd' style='text-align:right;'>";
    print "<div class='yui-dt-liner'><b>Total Samples</b></div>";
    print "</td>";
    my $bs_url = "$section_cgi&page=bodySiteDetail&body_site=";
    foreach my $col (@headers) {
	my $col2 = $col;
	$col2 = "gi" if $col eq "gastrointestinal tract";
	$col2 = "ug" if $col eq "urogenital tract/vagina";

	print "<td class='yui-dt-odd' style='text-align:right;'>";
	print "<div class='yui-dt-liner'>";
	my $link = alink($bs_url.$col2."&txs=1", $bs2txs{ $col }, "_blank");
	print $link;
	print "</div>";
	print "</td>";
    }
    print "</tr>";

    print "</table>";
    print "</div>";
}

sub printInfoForBodySite {
    my $body_site = param("body_site");
    my $with_host = param("host");
    my $vc = param("vc");
    my $sg = param("sg");
    my $txs = param("txs");

    my $site2 = $body_site;
    $site2 = "gastrointestinal tract" if $body_site eq "gi";
    $site2 = "urogenital tract/vagina" if $body_site eq "ug";

    my $dbh = dbLogin();

    if ($txs) {
    	my $sql = qq{
            select distinct v.taxon_oid
            from $viral_table_name v, taxon tx
            where v.body_site = ?
            and v.taxon_oid = tx.taxon_oid
            and tx.obsolete_flag = 'No'
        };
    	my $cur = execSql( $dbh, $sql, $verbose, $site2 );
    	my @taxons;
    	for ( ;; ) {
    	    my ($taxon_oid) = $cur->fetchrow();
    	    last if !$taxon_oid;
    	    push @taxons, $taxon_oid;
    	}
    	$cur->finish();
    	
    	use HtmlUtil;
    	HtmlUtil::printGenomeListHtmlTable
    	    ("Genomes for Body Site: ".ucfirst($site2), "", $dbh, \@taxons);
    	return;
    }

    print "<h1>Body Site: ".ucfirst($site2)."</h1>";

    my $hostClause = "";
    $hostClause = " and v.host is not null " if $with_host;
    my $vcClause = "";
    $vcClause = " and viral_clusters like 'vc%' " if $vc;
    my $sgClause = "";
    $sgClause = " and viral_clusters like 'sg%' " if $sg;

    my $text;
    $text = "with Host only" if $with_host;
    $text = "Viral Clusters only" if $vc;
    $text = "Viral Singletons only" if $sg;
    print "<p>$text</p>" if $text ne "";

    #v.ecosystem, v.ecosystem_category,
    #v.ecosystem_type, v.ecosystem_subtype,
    my $sql = qq{
        select distinct v.scaffold_id, v.body_site, v.habitat, 
               v.perc_vpfs, v.viral_clusters, v.host,
               tx.taxon_oid, tx.genome_type, tx.in_file
        from $viral_table_name v, taxon tx
        where v.body_site = ?
        and v.taxon_oid = tx.taxon_oid
        and tx.obsolete_flag = 'No'
        $hostClause
        $vcClause
        $sgClause
    };
    my $cur = execSql( $dbh, $sql, $verbose, $site2 );
    my @recs;
    for ( ;; ) {
    	my ($scafid, $body_site, $habitat, #$eco, $eco_cat, $eco_type, $eco_sub,
    	    $perc_vpfs, $clusters, $host, $txid, $genome_type, $in_file)
    	    = $cur->fetchrow();
    	last if ! $scafid;
    	$host = " " if !$host;
    	my $item = "$scafid\t$perc_vpfs\t$clusters\t$host\t$txid\t$genome_type\t$in_file";
    	push @recs, $item;
    }
    $cur->finish();

    my @headers = ("Scaffold ID", "Percent VPFs", "Viral Clusters", "Host");
    my $it = new InnerTable(1, "$body_site", "$body_site", 0);
    $it->addColSpec( "Select" );

    my $sd = $it->getSdDelim();
    my $i = 0;
    foreach my $col (@headers) {
    	if ($i == 1) {
    	    $it->addColSpec($col, "asc", "right");
    	} else {
    	    $it->addColSpec($col, "asc", "left");
    	}
    	$i++;
    }
    
    foreach my $row (@recs) {
    	my $r;
    	my ($scafid, $perc_vpfs, $clusters, $host, $txid, $genome_type, $in_file) = split(/\t/, $row);
    	if ( $genome_type eq 'metagenome' && $in_file eq 'Yes' ) {
                my $workspace_id = "$txid assembled $scafid";
                $r = $sd . "<input type='checkbox' name='scaffold_oid' value='$workspace_id'/>\t";
    
                my $url = "$main_cgi?section=MetaDetail&page=metaScaffoldDetail"
                    . "&taxon_oid=$txid&scaffold_oid=$scafid&data_type=assembled";
                $r .= $scafid.$sd.alink($url, $scafid)."\t";
    	} else {
                $r = $sd . "<input type='checkbox' name='scaffold_oid' value='$scafid'/>\t";
    	    my $url = "$main_cgi?section=ScaffoldCart"
    		. "&page=scaffoldDetail&scaffold_oid=$scafid";
                $r .= $scafid.$sd.alink($url, $scafid)."\t";
    	}
    
    	$r .= $perc_vpfs.$sd.$perc_vpfs."\t";
    	$r .= $clusters.$sd.$clusters."\t";
    	$r .= $host.$sd.$host."\t";
    
    	$it->addRow($r);
    }

    WebUtil::printMainForm();
    printValidationJS();

    if ( scalar @recs > 10 ) {
    	WebUtil::printScaffoldCartFooterInLineWithToggle($body_site); 
        print nbsp(1);
        printExportButton();
    } 
    $it->printOuterTable(1);
    WebUtil::printScaffoldCartFooterInLineWithToggle($body_site); 
    print nbsp(1);
    printExportButton();

    print end_form();
}

###########################################################################
# printValidationJS - Checks for scaffold selection and blank cart name
###########################################################################
sub printValidationJS {
    print qq{
        <script language='JavaScript' type='text/javascript'>
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

############################################################################
# printExportButton
############################################################################
sub printExportButton {

    my $name = "_section_${section}_exportScaffoldTable_noHeader";

    print submit(
        -name  => $name,
        -value => 'Download Selected in Excel',
        -class => 'meddefbutton',
        -onClick => "return validateSelection(1);"
    );

}


############################################################################
# exportScaffoldTable
############################################################################
sub exportScaffoldTable {

    my @scaffold_oids = param('scaffold_oid');
    #WebUtil::webLog("exportScaffoldTable() scaffolds=@scaffold_oids.\n");
    if ( scalar(@scaffold_oids) == 0 ) {
        WebUtil::webErrorHeader("No scaffolds have been selected.");
        return;
    }

    # print note Header
    #print "Content-type: text/plain\n";
    #print "Content-Disposition: inline; filename=scaffold_table.xls\n";
    #print "\n";

    # print Excel Header
    WebUtil::printExcelHeader("scaffold_table$$.xls");
    printScaffoldDataFile( \@scaffold_oids );
    WebUtil::webExit(0);
}

############################################################################
# printScaffoldDataFile
############################################################################
sub printScaffoldDataFile {
    my ( $scaffold_oids_aref, $outFile ) = @_;

    my $idDict_href = dictionaryOids($scaffold_oids_aref);
    my @ids = keys %$idDict_href;
    #WebUtil::webLog("printScaffoldDataFile() ids=@ids\n");

    my $dbh = dbLogin();
    my $scaf_ids_str = OracleUtil::getFuncIdsInClause( $dbh, @ids );

    my $sql = qq{
        select distinct v.scaffold_id, v.perc_vpfs, v.viral_clusters, v.host
        from $viral_table_name v
        where v.scaffold_id in ($scaf_ids_str)
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    my @recs;
    for ( ;; ) {
        my ($scafid, $perc_vpfs, $clusters, $host) = $cur->fetchrow();
        last if ! $scafid;
        $host = " " if !$host;
        my $item = "$scafid\t$perc_vpfs\t$clusters\t$host";
        push @recs, $item;
    }
    $cur->finish();
    #WebUtil::webLog("printScaffoldDataFile() recs=@recs\n");

    my $wfh;
    if ( $outFile ) {
        $wfh = newAppendFileHandle( $outFile, "writeScaffoldFastaFile" );
    }

    my @headers = ("Scaffold ID", "Percent VPFs", "Viral Clusters", "Host");

    if ( $wfh ) {
        # print header
        print $wfh "Scaffold ID\t";
        print $wfh "Percent VPFs\t";
        print $wfh "Viral Clusters\t";
        print $wfh "Host\t";
        print $wfh "\r\n";
    }
    else {
        # print header
        print "Scaffold ID\t";
        print "Percent VPFs\t";
        print "Viral Clusters\t";
        print "Host\t";
        print "\r\n";
    }

    foreach my $row (@recs) {
        my ($id, $perc_vpfs, $clusters, $host) = split(/\t/, $row);
        my $s_oid = $idDict_href->{$id}; 
        if ( $wfh ) {
            print $wfh "$s_oid\t$perc_vpfs\t$clusters\t$host\t";
            print $wfh "\r\n";
        }
        else {
            print "$s_oid\t$perc_vpfs\t$clusters\t$host\t";
            print "\r\n";
        }
    }

    if ( $wfh ) {
        close $wfh;
    }

}

sub dictionaryOids {
    my ($oids_ref) = @_;

    my %oidDict;
    if ( scalar(@$oids_ref) > 0 ) {
        for my $oid (@$oids_ref) {
            $oid = WebUtil::strTrim($oid);
            if ( WebUtil::isInt($oid) ) {
                $oidDict{$oid} = $oid;
            }
            else {
                my ( $toid, $dtype, $id ) = split( / /, $oid );
                $oidDict{$id} = $oid;
            }
        }        
    }

    return (\%oidDict);
}



########################################################################
# printEcosystemCount - summary table per ecosystem
########################################################################
sub printEcosystemCount {
    my $ecosystem = param('ecosystem');

    my $dbh = dbLogin();
    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    $rclause = "";
    $imgClause = "";

    print "<p>\n";
    my @all_eco = ( $ecosystem );
    if ( ! $ecosystem || $ecosystem eq 'All' ) {
	@all_eco = ('Engineered', 'Environmental', 'Host-associated');
    }
    my %eco_h;
    my %eco_count;
    foreach my $eco ( @all_eco ) {
        my %h;
	my $count = 0;
	my $sql = qq{
           select g.ecosystem_category, count(distinct s.scaffold_oid)
           from taxon t, scaffold s,
                gold_sequencing_project g
           where t.domain = 'Viruses'
           and t.obsolete_flag = 'No'
           and t.is_public = 'Yes' 
           and s.taxon = t.taxon_oid
           and t.sequencing_gold_id = g.gold_id
           and g.ecosystem = ?
           and g.ecosystem_category is not null
           $rclause
           $imgClause
           group by g.ecosystem_category
           };
	my $cur = execSql( $dbh, $sql, $verbose, $eco );
	for (;;) {
	    my ($cat, $cnt) = $cur->fetchrow();
	    last if ! $cat;

	    $count += $cnt;
	    if ( $h{$cat} ) {
		$h{$cat} += $cnt;
	    }
	    else {
		$h{$cat} = $cnt;
	    }
	}
	$cur->finish();

	$sql = qq{
           select g.ecosystem_category, count(distinct s.scaffold_id)
           from taxon t,
                $viral_table_name s,
                gold_sequencing_project g
           where s.taxon_oid = t.taxon_oid
           and t.obsolete_flag = 'No'
           and t.genome_type = 'metagenome'
           and t.sequencing_gold_id = g.gold_id
           and g.ecosystem = ?
           and g.ecosystem_category is not null
           $rclause
           $imgClause
           group by g.ecosystem_category
           };

	$cur = execSql( $dbh, $sql, $verbose, $eco );
	for (;;) {
	    my ($cat, $cnt) = $cur->fetchrow();
	    last if ! $cat;

	    $count += $cnt;
	    if ( $h{$cat} ) {
		$h{$cat} += $cnt;
	    }
	    else {
		$h{$cat} = $cnt;
	    }
	}
	$cur->finish();

	$eco_h{$eco} = \%h;
	$eco_count{$eco} = $count;
    }

    ## print table
    print "<table>\n";
    print "<tr>\n";
    foreach my $eco ( @all_eco ) {
	print "<td valign='top'>\n";
	print "<table class='img'>\n";
	my $url2 = "$section_cgi&page=viralStudyList&ecosystem=$eco";
	print "<th align='left'>$eco</th><th align='right'>" . 
	    alink($url2, $eco_count{$eco}, '_blank') . "</th>\n";
	my $href = $eco_h{$eco};
	if ( $href ) {
	    for my $k (sort (keys %$href)) {
		my $cnt = $href->{$k};
		my $url3 = $url2 . "&ecosystem_category=$k";
		print "<tr><td align='left'>$k</td><td align='right'>" .
		    alink($url3, $cnt, '_blank') . "</td></tr>\n";
	    }
	}
	print "</table>";
	print "</td>";
    }

    print "<td valign='top'>";
    printHabitatTypeCount($ecosystem);
    print "</td>\n";

    ## add space
    print "<td width=20>\n";
    print "</td>\n";

    ## show info
    print "<td valign='top' border=1>\n";
    my $info = "Two distinct curated environmental classifications are displayed: Ecosystem (based on three main types: engineered, environmental, and host-associated with a further ecosystem category sub-tier division) previously described and Habitat Type (based on 11 distinct manually curated habitat terms that allows the selection of mVCs from samples that belong to a single category from Paez-Espino et al. Nature, 2016).";
#    print "<p style='width: 300px;'>" . $info . "</p>\n";
    print qq{
           <a href="" onClick="alert('$info'); return false;">
           <span id="ecosystems" title="$info">
           <image src="$base_url/images/question.png"></span></a>
        };

    print "</td>\n";
    print "</tr>\n";
    print "</table>\n";
}

########################################################################
# printHabitatCount
########################################################################
sub printHabitatCount {
    my ( $ecosystem ) = @_;
    if ( ! $ecosystem ) {
	$ecosystem = param('ecosystem');
    }

    my $dbh = dbLogin();
    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all counts
    $rclause = "";
    $imgClause = "";

    print "<p>\n";
    my @all_eco = ( $ecosystem );
    my $eco_cond = " and g.ecosystem in ( '" . $ecosystem . "') ";

    if ( ! $ecosystem || $ecosystem eq 'All' ) {
	@all_eco = ('Engineered', 'Environmental', 'Host-associated');
#	$eco_cond = " and g.ecosystem in ('" .
#	    join("', '", @all_eco) . "') ";
	$eco_cond = " ";
    }

    my %habitat_h; 
    my $sql = qq{
           select h.habitat, count(distinct s.scaffold_oid)
           from taxon t, scaffold s,
                gold_sequencing_project g,
                gold_sp_habitat h
           where t.domain = 'Viruses'
           and s.taxon = t.taxon_oid
           and t.sequencing_gold_id = g.gold_id
           and t.sequencing_gold_id = h.gold_id
           and h.habitat is not null
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           group by h.habitat
           };
    my $sql = qq{
           select h.habitat, count(distinct s.scaffold_oid)
           from taxon t, scaffold s,
                gold_sp_habitat h
           where t.domain = 'Viruses'
           and s.taxon = t.taxon_oid
           and t.sequencing_gold_id = h.gold_id
           and h.habitat is not null
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           group by h.habitat
           };
    my $cur = execSql( $dbh, $sql, $verbose );
    for (;;) {
	my ($hab, $cnt) = $cur->fetchrow();
	last if ! $hab;

	if ( $habitat_h{$hab} ) {
	    $habitat_h{$hab} += $cnt;
	}
	else {
	    $habitat_h{$hab} = $cnt;
	}
    }
    $cur->finish();

    $sql = qq{
           select count(distinct s.scaffold_oid)
           from taxon t, scaffold s,
                gold_sequencing_project g,
                gold_sp_habitat h
           where t.domain = 'Viruses'
           and s.taxon = t.taxon_oid
           and t.sequencing_gold_id = g.gold_id
           and t.sequencing_gold_id = h.gold_id
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           and h.habitat is not null
           };
    $sql = qq{
           select count(distinct s.scaffold_oid)
           from taxon t, scaffold s,
                gold_sp_habitat h
           where t.domain = 'Viruses'
           and s.taxon = t.taxon_oid
           and t.sequencing_gold_id = h.gold_id
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           and h.habitat is not null
           };
    $cur = execSql( $dbh, $sql, $verbose );
    my ($count) = $cur->fetchrow();
    $cur->finish();

    $sql = qq{
           select h.habitat, count(distinct s.scaffold_id)
           from taxon t,
                $viral_table_name s,
                gold_sequencing_project g,
                gold_sp_habitat h
           where s.taxon_oid = t.taxon_oid
           and t.sequencing_gold_id = g.gold_id
           and t.sequencing_gold_id = h.gold_id
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           group by h.habitat
           }; 
    $sql = qq{
           select h.habitat, count(distinct s.scaffold_id)
           from taxon t,
                $viral_table_name s,
                gold_sp_habitat h
           where s.taxon_oid = t.taxon_oid
           and t.sequencing_gold_id = h.gold_id
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           group by h.habitat
           };

    $cur = execSql( $dbh, $sql, $verbose );
    for (;;) {
	my ($hab, $cnt) = $cur->fetchrow();
	last if ! $hab;

	if ( $habitat_h{$hab} ) {
	    $habitat_h{$hab} += $cnt;
	}
	else {
	    $habitat_h{$hab} = $cnt;
	}
    }
    $cur->finish();

    $sql = qq{
           select count(distinct s.scaffold_id)
           from taxon t,
                $viral_table_name s,
                gold_sequencing_project g,
                gold_sp_habitat h
           where s.taxon_oid = t.taxon_oid
           and t.sequencing_gold_id = g.gold_id
           and t.sequencing_gold_id = h.gold_id
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           and h.habitat is not null
           }; 
    $sql = qq{
           select count(distinct s.scaffold_id)
           from taxon t,
                $viral_table_name s,
                gold_sp_habitat h
           where s.taxon_oid = t.taxon_oid
           and t.sequencing_gold_id = h.gold_id
           and t.obsolete_flag = 'No'
           $eco_cond
           $rclause
           $imgClause
           and h.habitat is not null
           };
    $cur = execSql( $dbh, $sql, $verbose );
    my ($count2) = $cur->fetchrow();
    $cur->finish();
    $count += $count2;

    ## print table
    print "<table class='img' style='width:180px'>\n";
    my $url2 = "$section_cgi&page=viralStudyList&ecosystem=$ecosystem";
    print "<th>Habitat</th><th align='right'>";
    if ( $count) {
	print alink($url2 . "&habitat=All", $count, '_blank') . "</th>\n";
    }
    else {
	print "0</th>\n";
    }
    for my $k (sort (keys %habitat_h)) {
	my $cnt = $habitat_h{$k};
	my $url3 = $url2 . "&habitat=$k";
	print "<tr><td>$k</td><td align='right'>" .
		alink($url3, $cnt, '_blank') . "</td></tr>\n";
    }
    print "</table>\n";
}

########################################################################
# printHabitatTypeCount
########################################################################
sub printHabitatTypeCount {
    my ( $ecosystem ) = @_;
    if ( ! $ecosystem ) {
	$ecosystem = param('ecosystem');
    }

    my $dbh = dbLogin();
    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all counts
    $rclause = "";
    $imgClause = "";

    my @all_eco = ( $ecosystem );
    my $eco_cond = " and s.ecosystem in ( '" . $ecosystem . "') ";
    my $eco_cond = " and s.ecosystem = '$ecosystem'";

    if ( ! $ecosystem || $ecosystem eq 'All' ) {
	@all_eco = ('Engineered', 'Environmental', 'Host-associated');
#	$eco_cond = " and g.ecosystem in ('" .
#	    join("', '", @all_eco) . "') ";
	$eco_cond = " ";
    }

    my %habitat_h; 
    my $count = 0;
    my $sql = qq{
           select s.habitat, count(distinct t.taxon_oid)
           from $viral_table_name s, taxon t
           where t.obsolete_flag = 'No'
           and t.genome_type = 'metagenome'
           and s.taxon_oid = t.taxon_oid
           $eco_cond
           $rclause
           $imgClause
           group by s.habitat
           };
    my $cur = execSql( $dbh, $sql, $verbose );
    for (;;) {
	my ($hab, $cnt) = $cur->fetchrow();
	last if ! $hab;

	if ( $habitat_h{$hab} ) {
	    $habitat_h{$hab} += $cnt;
	}
	else {
	    $habitat_h{$hab} = $cnt;
	}

	$count += $cnt;
    }
    $cur->finish();

    ## print table
    print "<table class='img' style='width:180px'>\n";
    my $url2 = "$section_cgi&page=viralStudyList&ecosystem=$ecosystem";
    print "<th align='left'>Habitat Type</th><th align='right'>";
    if ( $count) {
	print alink($url2 . "&habitat_type=All", $count, '_blank') . "</th>\n";
    }
    else {
	print "0</th>\n";
    }
    for my $k (sort (keys %habitat_h)) {
	my $cnt = $habitat_h{$k};
	my $url3 = $url2 . "&habitat_type=$k";
	print "<tr><td align='left'>$k</td><td align='right'>" .
		alink($url3, $cnt, '_blank') . "</td></tr>\n";
    }
    print "</table>\n";
}

####################################################################
# printViralStatsDiv
####################################################################
sub printViralStatsDiv {
    require MainPageStats;
#    my ( $s, $hmp ) = MainPageStats::replaceStatTableRows();
    my $s = "";
    my $hmp = "";

    print qq{
        <div id="left" class="shadow">
    }; 

    my $str = getDatamartStats();

    print qq{
         <h2>IMG Viral Content</h2>
         <table cellspacing="0" cellpadding="0">
         <tr>
	 <th align="right" colspan="2" > &nbsp; </th>
             <th align="right">Viral Datasets</th>
         </tr>
    }; 
    print $str;
    print qq{
        </table>
    }; 

    my $str2 = getViralClusterStats();
    print qq{
         <p>
         <table cellspacing="0" cellpadding="0">
	 <th align="right" colspan="2" > &nbsp; </th>
             <th align="right">Viral Clusters</th>
         </tr>
    }; 
    print $str2;
    print qq{
        </table>
    }; 

    my $str3 = getViralHostStats();

    print qq{
         <p>
         <table cellspacing="0" cellpadding="0">
         <tr>
	 <th align="right" colspan="2" > &nbsp; </th>
             <th align="right">With Host</th>
         </tr>
    }; 
    print $str3;
    print qq{
        </table>
    }; 

##    print "<h6>*GFM: Genome extracted from Metagenome</h6>\n";

    my $contact_oid = WebUtil::getContactOid();

    print "<p>\n";
    my $blast_url =
	"$main_cgi?section=Viral"
	. "&page=findViralGenesBlast";
    print nbsp(2);
    print WebUtil::buttonUrlNewWindow($blast_url, 
				      "Viral/Spacer BLAST",
				      "smdefbutton");
#    print "<h6>" . alink( $blast_url, "BLAST against Viral Database" ) .
#	"</h6>\n";

    print "<p>\n";
    print nbsp(2);
    print "<a href='$vpf_models_url' download>Download VPF Models</a>\n";

    ## Nikos said to hide this
#    print qq{
#         <table cellspacing="0" cellpadding="0">
#         <tr>
#	 <th align="right" colspan="2" > &nbsp; </th>
#             <th align="right">Datasets</th>
#         </tr>
#    }; 
#    print $s; 
#    print qq{
#        </table>
#    }; 

    print "</div>\n";
}


###############################################################
# printAboutNews
###############################################################
sub printAboutNews {
    print "<p>\n";
    print "<fieldset class='aboutPortal' id='about_proportal'>\n";
    print qq{
        <legend class='aboutLegend'>About IMG/ProPortal</legend>
        The marine cyanobacterium <b><i>Prochlorococcus</i></b>, 
        which is abundant in the oceans, is a key model system in 
        microbial ecology. 
        <b>IMG/ProMod</b> provides <i>Prochlorococcus</i> and its closely
        related <i>Synechococcus</i> and <i>Cyanophage</i> genomes 
        integrated with a comprehensive set of  publicly 
        available isolate and single cell genomes, and a rich set 
        of publicly available metagenome samples. 
        <b>IMG/ProMod</b>  includes genomic, transcriptomic, 

        metagenomic and population data from both 
        cultivated strains and wild populations of cyanobacteria 
        and phage.<br> 
        <b>IMG/ProPortal</b> relies on IMG's data warehouse 
        and comparative analysis tools 
       (<a href='http://nar.oxfordjournals.org/content/42/D1/D560'>Nucleic Acids Research, Volume 42 Issue D1</a>) 
       and  is a descendant of <b>ProPortal</b>  
       (<a href='http://nar.oxfordjournals.org/content/40/D1/D632'>Nucleic Acids Research Volume 40 Issue D1</a>).
       </fieldset> 
    };

    #    print qq{
    #    <fieldset class='newsPortal'>
    #    <legend class='aboutLegend'>News</legend>
    #    <div id='news_proportal'> </div>
    #    </fieldset>
    #    };

    my $news = getNewsContents();
    print qq{
    <fieldset class='newsPortal'>
    <legend class='aboutLegend'>News</legend>
    <div id='news'> $news </div>
    </fieldset>
    };
}

############################################################
# getNewsContents
############################################################
sub getNewsContents {
    my $dbh = dbLogin();

    my $e        = getDatamartEnv();
    my $group_id = $e->{img_group_id};
    if ( !$group_id ) {
        $group_id = 0;
    }

    my $contact_oid = WebUtil::getContactOid();
    if ( !$contact_oid ) {
        return "No News.";
    }

    my $super_user_flag = WebUtil::getSuperUser();
    my $sql             = "select role from contact_img_groups where contact_oid = ? and img_group = ? ";

    my $cur = execSql( $dbh, $sql, $verbose, $contact_oid, $group_id );
    my ($role) = $cur->fetchrow();
    $cur->finish();

    my $cond = "and n.is_public = 'Yes'";
    if ( $super_user_flag eq 'Yes' || $role ) {

        # no condition
        $cond = "";
    }

    my $str = "";
    $sql =
        "select n.news_id, n.title, n.add_date "
      . "from img_group_news n "
      . "where n.group_id = ? "
      . $cond
      . " order by 3 desc ";
    $cur = execSql( $dbh, $sql, $verbose, $group_id );
    for ( ; ; ) {
        my ( $news_id, $title, $add_date ) = $cur->fetchrow();
        last if !$news_id;

        my $url2 = "main.cgi?section=ImgGroup&page=showNewsDetail"
	    . "&group_id=$group_id&news_id=$news_id";
        if ( !$str ) {
            $str = "<ul>";
        }
        $str .= "<li>" . alink( $url2, $title, '_blank' ) . " ($add_date) </li>\n";
    }
    $cur->finish();

    if ($str) {
        $str .= "</ul>";
    } else {
        $str = "No News.";
    }

    return $str;
}

###############################################################
# printGenomes: print genome list based on 'class'
###############################################################
sub printGenomes {
    my $class = param('class');

    my $additional_cond   = ' ';
    my $include_min_depth = 0;
    my $include_max_depth = 1;

    my $genome_type = param('genome_type');
    if ($genome_type) {
        $genome_type =~ s/'/''/g;    # replace ' with ''
        $additional_cond .= " and t.genome_type = '$genome_type' ";
    }

    my $depth = param('depth');
    if ( length($depth) > 0 && isNumber($depth) ) {
        $depth =~ s/'/''/g;          # replace ' with ''
        my $depth_set = "('" . $depth . "m', '" . $depth . " m', '" . $depth . " meters', '" . $depth . " meter'" . ")";
        $additional_cond .=
" and t.sequencing_gold_id in (select p.gold_id from gold_sequencing_project p where p.depth in $depth_set ) ";
    }
    my $min_depth = param('min_depth');
    my $max_depth = param('max_depth');
    my $ecotype   = param('ecotype');
    if ( $ecotype eq 'H' ) {
        $ecotype = 'High light adapted (HL)';
    } elsif ( $ecotype eq 'L' ) {
        $ecotype = 'Low light adapted (LL)';
    } elsif ( $ecotype eq 'U' ) {
        $ecotype = 'Unknown';
    }
    my $clade = param('clade');

    WebUtil::printMainForm();
    if ( length($min_depth) > 0 || $max_depth ) {
        if ( $max_depth && !$min_depth ) {
            $min_depth = 0;
        }
        print "<h3>Depth: $min_depth";
        if ( !$include_min_depth && $min_depth > 0 ) {
            print "+";
        }
        if ($max_depth) {
            if ($include_max_depth) {
                print " to " . $max_depth;
            } else {
                print " to <" . $max_depth;
            }
        }
        print " m</h3>\n";
    }
    if ( length($depth) > 0 ) {
        print "<h3>Depth: $depth m</h3>\n";
    }
    if ($ecotype) {
        print "<h3>Ecotype: $ecotype</h3>\n";
    }
    if ($clade) {
        if ( $clade eq 'NA' ) {
            print "<h3>Clade: NA (Not Available)</h3>\n";
        } else {
            print "<h3>Clade: $clade</h3>\n";
        }
    }

    my $sql;
    my $e             = getDatamartEnv();
    my $title         = "";
    my $member_labels = $e->{member_labels};

    my @list = ();
    if ( $class eq 'datamart' ) {
        $title = "All " . $e->{main_label} . " Genome List";
        my $members = $e->{members};
        for my $x (@$members) {
            push @list, ($x);
        }
    } elsif ( $class eq 'marine_metagenome' ) {
        print "<h3>Marine Metagenome</h3>\n";
        $additional_cond .= " and t.genome_type = 'metagenome' and t.ir_order = 'Marine'";
    } elsif ( $class eq 'marine_other' ) {
        print "<h3>Other</h3>\n";
        $additional_cond .=
" and t.genome_type = 'isolate' and t.sequencing_gold_id in (select gold_id from gold_sequencing_project where ecosystem_type = 'Marine')";
    } elsif ( $class eq 'marine_all' ) {
        print "<h3>Marine Genomes and Metagenomes</h3>\n";
        $additional_cond .=
" and t.sequencing_gold_id in (select gold_id from gold_sequencing_project where ecosystem_type = 'Marine')";
    } else {
        print "<h3>" . $member_labels->{$class} . "</h3>\n";
        $title = $member_labels->{$class} . " Genome List";
        push @list, ($class);
    }

    ## ecosystem subtype?
    my $ecosystem_subtype = param('ecosystem_subtype');
    if ($ecosystem_subtype) {
        print "<h3>Ecosystem Subtype: $ecosystem_subtype</h3>\n";
        my $db_subtype = $ecosystem_subtype;
        $db_subtype =~ s/'/''/g;    # replace ' with ''
        if ( lc($ecosystem_subtype) eq 'unclassified' ) {
            $additional_cond .=
" and t.sequencing_gold_id in (select p.gold_id from gold_sequencing_project p where p.ecosystem_subtype is null or lower(p.ecosystem_subtype) = '"
              . lc($db_subtype) . "')";
        } else {
            $additional_cond .=
" and t.sequencing_gold_id in (select p.gold_id from gold_sequencing_project p where p.ecosystem_subtype = '"
              . $db_subtype . "')";
        }
    }

    my $sql1 =
        "select t.taxon_oid, t.taxon_display_name, t.genus from taxon t "
      . "where t.obsolete_flag = 'No' and t.is_public = 'Yes' ";
    if ( length($min_depth) > 0 || $max_depth || $ecotype || $clade ) {
        $sql1 =
            "select t.taxon_oid, t.taxon_display_name, t.genus, "
          . "p.ecotype, p.depth, p.clade "
          . "from taxon t, gold_sequencing_project p "
          . "where t.obsolete_flag = 'No' and t.is_public = 'Yes' "
          . "and t.sequencing_gold_id = p.gold_id ";
    }

    my $member_conds = $e->{member_conds};
    for my $x (@list) {
        if ($sql) {
            $sql .= " union ";
        }
        if ( $member_conds->{$x} ) {
            $sql .= $sql1 . "and (" . $member_conds->{$x} . ") " . $additional_cond;
        } else {
            $sql .= $sql1 . $additional_cond;
        }
    }

    if (
        scalar(@list) == 0
        && (   $class eq 'marine_metagenome'
            || $class eq 'marine_other'
            || $class eq 'marine_all' )
      )
    {
        $sql = $sql1 . $additional_cond;
    }

##    print "<p>SQL: $sql\n";
    if ( !$sql ) {
        return;
    }

    printStatusLine( "Loading ...", 1 );

    my $dbh = dbLogin();
    my $cur = execSql( $dbh, $sql, $verbose );

    my @taxon_list = ();
    my $cnt2       = 0;
    for ( ; ; ) {
        my ( $taxon_oid, $taxon_name, $genus, $eco_val, $depth_val, $clade_val ) = $cur->fetchrow();
        last if !$taxon_oid;

        ## check ecotype
        if ($ecotype) {
            if ( $ecotype eq 'Unknown' ) {
                if ($eco_val) {
                    next;
                }
            } else {
                if ( $eco_val ne $ecotype ) {
                    next;
                }
            }
        }

        ## check clade
        if ($clade) {
            if ( $clade eq 'Unknown' || $clade eq 'NA' ) {
                if ($clade_val) {
                    next;
                }
            } else {
                if ( $clade =~ /^5/ ) {
                    if ( !( $clade_val =~ /$clade/ ) ) {
                        next;
                    }
                } elsif ( $clade_val ne $clade ) {
                    next;
                }
            }
        }

        # check depth
        if ( $min_depth || $max_depth ) {
            if ( !defined($depth_val) || length($depth_val) == 0 ) {
                next;
            }
            my $depth2 = convertDepth($depth_val);
            if ( length($depth2) == 0 ) {
                next;
            }
            if ($min_depth) {
                if ( $depth2 < $min_depth ) {
                    next;
                }
                if ( !$include_min_depth && $depth2 <= $min_depth ) {
                    next;
                }
            }
            if ($max_depth) {
                if ( $depth2 > $max_depth ) {
                    next;
                }
                if ( !$include_max_depth && $depth2 >= $max_depth ) {
                    next;
                }
            }
        }

        ## check for others
        if ( $class eq 'marine_other' ) {
            if ( lc($genus) =~ /prochlorococcus/ ) {
                next;
            }
            if ( lc($genus) =~ /synechococcus/ ) {
                next;
            }
            if ( lc($taxon_name) =~ /cyanophage/ ) {
                next;
            }
            if ( lc($taxon_name) =~ /prochlorococcus phage/ ) {
                next;
            }
            if ( lc($taxon_name) =~ /synechococcus phage/ ) {
                next;
            }
        }

        push @taxon_list, ($taxon_oid);
        $cnt2++;
    }
    $cur->finish();

    GenomeList::printGenomesViaList( \@taxon_list, '', '' );
    printStatusLine( "$cnt2 Loaded", 2 );
}


###############################################################
# printViralStudyList
###############################################################
sub printViralStudyList {
    my $genome_type = param('genome_type');
    WebUtil::printMainForm();

    if ( $genome_type eq 'isolate' ) {
##	print "<h1>Isolate Viruses</h1>\n";
##	print "<p style='width: 680px;'>Unique taxon identifiers (<i>Taxon OID</i>) and <i>Viral Contig Counts</i> of " .
##	    alink("https://www.ncbi.nlm.nih.gov/genome/viruses/", 
##		  "isolate viral genomes (iVGs) from NCBI", "_blank") . 
##		  " can be selected for further analyses. Host tab displays virus host. <br/>Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).</p>\n";

	my $info = "Unique taxon identifiers (Taxon OID) and Viral Contig Counts of isolate viral genomes (iVGs) from NCBI (https://www.ncbi.nlm.nih.gov/genome/viruses/) can be selected for further analyses. Host tab displays virus host. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
	print qq{
           <h1>Isolate Viruses
           <a href="" onClick="alert('$info'); return false;">
           <span id="ecosystems" title="$info">
           <image src="$base_url/images/question.png"></span></a></h1>
        };
    }
    elsif ( $genome_type eq 'metagenome' ) {
##	print "<h1>Metagenomic Viral Contigs</h1>\n";
##	print "<p style='width: 680px;'>mVCs from geographically and ecologically diverse metagenomic samples identified using a computational approach described in Paez-Espino et al (2016). Unique sample identifiers (<i>Taxon OID</i>) and total number of identified <i>Viral Contig Counts</i> annotated via IMG standard annotation pipeline can be selected for further analyses. <i>Habitat type</i> tab displays distinct manually curated habitat terms according to the sample information, while <i>Habitat (from GOLD)</i> refers to a more granular classification of the sample according to the Genomes OnLine Database. <br/>Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).</p>\n";

	my $info = "mVCs from geographically and ecologically diverse metagenomic samples identified using a computational approach described in Paez-Espino et al (2016). Unique sample identifiers (Taxon OID) and total number of identified Viral Contig Counts annotated via IMG standard annotation pipeline can be selected for further analyses. Habitat type tab displays distinct manually curated habitat terms according to the sample information, while Habitat (from GOLD) refers to a more granular classification of the sample according to the Genomes OnLine Database. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";

	print qq{
           <h1>Metagenomic Viral Contigs
           <a href="" onClick="alert('$info'); return false;">
           <span id="ecosystems" title="$info">
           <image src="$base_url/images/question.png"></span></a>
        };

	my $method_url =
	    "$main_cgi?section=Viral"
	    . "&page=printViralMethod";
	print nbsp(1);
	print WebUtil::buttonUrlNewWindow($method_url, 
					  "Method",
					  "tinybutton");
	print "</h1>\n";
    }
    else {
##	print "<h1>Total Viral Datasets</h1>\n";
##	print "<p style='width: 680px;'>Combination of " .
##	    alink("https://www.ncbi.nlm.nih.gov/genome/viruses/",
##		  "isolate viral genomes (iVGs) from NCBI", "_blank") .
##		  " and mVCs from metagenomic samples identified using a computational approach described in Paez-Espino et al (2016).<br/>Unique taxon/sample identifiers (<i>Taxon OID</i>) and total number of identified <i>Viral Contig Counts</i> can be selected for further analyses. <i>Habitat type</i> tab displays manually curated habitat terms according to the nature of the sample. <i>Habitat (from GOLD)</i> refers to a more granular classification of the sample according to the Genomes OnLine Database. <br/>Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).</p>\n";

	my $info = "Combination of isolate viral genomes (iVGs) from NCBI (https://www.ncbi.nlm.nih.gov/genome/viruses/) and mVCs from metagenomic samples identified using a computational approach described in Paez-Espino et al (2016). Unique taxon/sample identifiers (Taxon OID) and total number of identified Viral Contig Counts can be selected for further analyses. Habitat type tab displays manually curated habitat terms according to the nature of the sample. Habitat (from GOLD) refers to a more granular classification of the sample according to the Genomes OnLine Database. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
	print qq{
           <h1>Total Viral Datasets
           <a href="" onClick="alert('$info'); return false;">
           <span id="ecosystems" title="$info">
           <image src="$base_url/images/question.png"></span></a>
        };

	my $method_url =
	    "$main_cgi?section=Viral"
	    . "&page=printViralMethod";
	print nbsp(1);
	print WebUtil::buttonUrlNewWindow($method_url, 
					  "Method",
					  "tinybutton");
	print "</h1>\n";
    }

    print "<p><font color='red'><u>Note</u>: Private genomes are not displayed here</font></p>\n";

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    my $dbh = dbLogin();

    ## ecosystem
    my $ecosystem = param('ecosystem');
    my $ecosystem_category = param('ecosystem_category');
    my %eco_h;
    my %depth_h;
    if ( $ecosystem || $ecosystem_category ) {
	print "<h2>$ecosystem $ecosystem_category</h2>\n";
	my $sql = qq{
           select t.taxon_oid, g.ecosystem, g.ecosystem_category,
                  g.ecosystem_type, g.ecosystem_subtype,
                  g.specific_ecosystem, g.depth
           from taxon t, gold_sequencing_project g
           where t.obsolete_flag = 'No'
           and t.sequencing_gold_id = g.gold_id
           };
	if ( $ecosystem ) {
	    my $db_val = $ecosystem;
	    $db_val =~ s/'/''/g;   # replace ' with ''
	    $sql .= " and g.ecosystem = '" . $db_val . "'";
	}
	if ( $ecosystem_category ) {
	    my $db_val = $ecosystem_category;
	    $db_val =~ s/'/''/g;   # replace ' with ''
	    $sql .= " and g.ecosystem_category = '" . $db_val . "'";
	}

	## print "<p>SQL: $sql\n";

	my $cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($tid, @rest) = $cur->fetchrow();
	    last if ! $tid;
	    $eco_h{$tid} = join("\t", @rest);
	    $depth_h{$tid} = $rest[-1];
	}
    }

    my %habitat_h;
    my %taxon_w_habitat;
    my %habitat_type_h;
    my %taxon_w_habitat_type;

    ## habitat type
    my $habitat_type = param('habitat_type');
    if ( $habitat_type ) {
	print "<h2>Habitat Type: $habitat_type</h2>\n";
    }

    ## habitat
    my $habitat = param('habitat');
    if ( ! $habitat ) {
	$habitat = 'All';
    }
    else {
	print "<h2>Habitat: $habitat</h2>\n";
    }

    if ( $habitat || $habitat_type ) {
	my $sql = qq{
           select t.taxon_oid, g.habitat, sp.depth
           from taxon t, gold_sp_habitat g,
                gold_sequencing_project sp
           where t.obsolete_flag = 'No'
           and sp.gold_id = g.gold_id
           and t.sequencing_gold_id = g.gold_id
           and g.habitat is not null
           };
	if ( $habitat_type ) {
	    $sql .= " and t.genome_type = 'metagenome' ";
	}
	my $cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($tid, $hab, $depth) = $cur->fetchrow();
	    last if ! $tid;

	    if ( $habitat eq 'All' ) {
		$taxon_w_habitat{$tid} = 1;
	    }
	    elsif ( $hab eq $habitat ) {
		$taxon_w_habitat{$tid} = 1;
	    }

	    if ( $habitat_h{$tid} ) {
		$habitat_h{$tid} .= ", " . $hab;
	    }
	    else {
		$habitat_h{$tid} = $hab;
	    }

	    $depth_h{$tid} = $depth;
	}
	$cur->finish();

	$sql = qq{
            select distinct v.taxon_oid, v.habitat
            from $viral_table_name v
            where v.habitat is not null
            order by 1, 2
        };
	$cur = execSql( $dbh, $sql, $verbose );
	for ( ;; ) {
	    my ($tid, $hab) = $cur->fetchrow();
	    last if ! $tid;

	    if ( $habitat_type && $hab eq $habitat_type ) {
		$taxon_w_habitat_type{$tid} = 1;
	    }
	    if ( $habitat_type_h{$tid} ) {
		$habitat_type_h{$tid} .= ", " . $hab;
	    }
	    else {
		$habitat_type_h{$tid} = $hab;
	    }
	}
	$cur->finish();
    }

    my %viral_cnt;
    my $sql;
    my $cur;
    if ( ! $genome_type || $genome_type eq 'isolate' ) {
	$sql = qq{
            select s.taxon, count(*)               
            from scaffold s
            where s.taxon in (
                  select t.taxon_oid from taxon t
                  where t.domain = 'Viruses'
                  $rclause
                  $imgClause )
            group by s.taxon
            };
	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($tid, $cnt) = $cur->fetchrow();
	    last if ! $tid;
	    $viral_cnt{$tid} = $cnt;
	}
	$cur->finish();
    }
    if ( ! $genome_type || $genome_type eq 'metagenome' ) {
       $sql = qq{
             select v.taxon_oid, count(distinct v.scaffold_id) 
             from $viral_table_name v, taxon t
             where v.ecosystem not like 'ref\%'
             and v.taxon_oid = t.taxon_oid
             and t.genome_type = 'metagenome'
             $rclause
             $imgClause
             group by v.taxon_oid
             };
	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($tid, $cnt) = $cur->fetchrow();
	    last if ! $tid;
	    $viral_cnt{$tid} = $cnt;
	}
	$cur->finish();
    }

    my %taxon_info;
    if ( $habitat_type ) {
	## don't show isolate
    }
    elsif ( ! $genome_type || $genome_type eq 'isolate' ) {
	$sql = qq{
            select t.taxon_oid, t.genome_type, t.domain, t.seq_status,
                   t.taxon_display_name, t.proposal_name
            from taxon t
            where t.domain = 'Viruses'
            $rclause
            $imgClause
            };
	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ( $taxon_oid, $type, $domain, $seq_status,
		 $taxon_name, $study ) = $cur->fetchrow();
	    last if !$taxon_oid;

	    $taxon_info{$taxon_oid} = 
		"$taxon_oid\t$type\t$domain\t$seq_status" .
		"\t$taxon_name\t$study";
	}
	$cur->finish();
    }
    if ( ! $genome_type || $genome_type eq 'metagenome' ) {
	$sql = qq{
            select t.taxon_oid, t.genome_type, t.domain, t.seq_status,
                   t.taxon_display_name, t.proposal_name
            from taxon t
            where t.taxon_oid in
               (select v.taxon_oid from $viral_table_name v
                where v.ecosystem not like 'ref\%')
            and t.genome_type = 'metagenome'
            $rclause
            $imgClause
            };

	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ( $taxon_oid, $type, $domain, $seq_status,
		 $taxon_name, $study ) = $cur->fetchrow();
	    last if !$taxon_oid;

	    $taxon_info{$taxon_oid} = 
		"$taxon_oid\t$type\t$domain\t$seq_status" .
		"\t$taxon_name\t$study";
	}
	$cur->finish();
    }

    printStatusLine( "Loading ...", 1 );

    my $it = new InnerTable( 1, "genomeSet$$", "genomeSet", 1 );
    $it->addColSpec("Select");
    $it->addColSpec( "Domain", "char asc", "center", "", 
		     "*=Microbiome, B=Bacteria, A=Archaea, E=Eukarya, P=Plasmids, G=GFragment, V=Viruses"
	); 
    $it->addColSpec( "Status", "char asc", "center", "",
		     "Sequencing Status: F=Finished, P=Permanent Draft, D=Draft" );
    $it->addColSpec( "Study Name", "char asc", "left" );
    $it->addColSpec( "Taxon OID", "number asc", "right" );
    $it->addColSpec( "Genome Name", "char asc", "left" );
    my $eco_field_cnt = 6;
    my $show_eco = 0;
    if ( $ecosystem || $ecosystem_category ) {
	$it->addColSpec( "Ecosystem", "char asc", "left" );
	$it->addColSpec( "Ecosystem Category", "char asc", "left" );
	$it->addColSpec( "Ecosystem Type", "char asc", "left" );
	$it->addColSpec( "Ecosystem Subtype", "char asc", "left" );
	$it->addColSpec( "Specific Ecosystem", "char asc", "left" );
	$it->addColSpec( "Depth", "char asc", "left" );
	$show_eco = 1;
    }
    if ( $habitat || $habitat_type ) {
	$it->addColSpec( "Habitat Type", "char asc", "left" );
	$it->addColSpec( "Habitat (from GOLD)", "char asc", "left" );
	if ( ! $show_eco ) {
	    $it->addColSpec( "Depth", "char asc", "left" );
	}
    }
    $it->addColSpec( "Viral Contig Count", "number asc", "right" );
    my $sd = $it->getSdDelim();

    $cur = execSql( $dbh, $sql, $verbose );

    my @taxon_list = ();
    my $cnt2       = 0;
    for my $t1 ( keys %taxon_info ) {
        my ( $taxon_oid, $type, $domain, $seq_status,
	     $taxon_name, $study ) = split(/\t/, $taxon_info{$t1});

	## check ecosystem
	if ( $ecosystem || $ecosystem_category ) {
	    if ( ! $eco_h{$taxon_oid} ) {
		next;
	    }
	}

	## check habitat type
	if ( $habitat_type && $habitat_type ne 'All' ) {
	    if ( ! $taxon_w_habitat_type{$taxon_oid} ) {
		next;
	    }
	}

	## check habitat
	if ( $habitat && $habitat ne 'All' ) {
	    if ( ! $taxon_w_habitat{$taxon_oid} ) {
		next;
	    }
	}

	$domain = substr($domain, 0, 1);
	$seq_status = substr($seq_status, 0, 1);

	my $r = $sd 
	    . "<input type='checkbox' name='taxon_oid' value='$taxon_oid'/>"
	    . "\t";

	$r .= $domain . $sd . $domain
	    . "\t" . $seq_status . $sd . $seq_status . "\t";

	$r .= $study . $sd . $study . "\t";
	my $url =
	    "$main_cgi?section=TaxonDetail"
	    . "&page=taxonDetail&taxon_oid=$taxon_oid";
	$r .= $taxon_oid . $sd . alink( $url, $taxon_oid ) . "\t";
	$r .= $taxon_name . $sd . $taxon_name . "\t";

	if ( $ecosystem || $ecosystem_category ) {
	    my @eco_val = split(/\t/, $eco_h{$taxon_oid});
	    for my $eco1 ( @eco_val ) {
		$r .= $eco1 . $sd . $eco1 . "\t";
	    }

	    if ( scalar(@eco_val) < $eco_field_cnt ) {
		my $j = scalar(@eco_val);
		while ( $j < $eco_field_cnt ) {
		    $r .= "-" . $sd . "-" . "\t";
		    $j++;
		}
	    }
	}

	if ( $habitat || $habitat_type ) {
	    $r .= $habitat_type_h{$taxon_oid} . $sd . 
		$habitat_type_h{$taxon_oid} . "\t";
	    $r .= $habitat_h{$taxon_oid} . $sd . 
		$habitat_h{$taxon_oid} . "\t";
	}

	if ( ! $show_eco ) {
	    # show depth
	    $r .= $depth_h{$taxon_oid} . $sd . $depth_h{$taxon_oid} . "\t";
	}

	my $scf_cnt = $viral_cnt{$taxon_oid};
	if ( $scf_cnt ) {
	    my $url2 = $section_cgi . "&page=viralScaffoldList" .
		"&taxon_oid=$taxon_oid";
	    $r .= $scf_cnt . $sd . alink($url2, $scf_cnt, '_blank') . "\t";
	}
	else {
	    $r .= "0" . $sd . "0\t";
	}

	$it->addRow($r);

        $cnt2++;
    }
    $cur->finish();

    if ( $cnt2 > 10 ) {
	WebUtil::printGenomeCartFooter();
    } 
 
    $it->printOuterTable(1);

    WebUtil::printGenomeCartFooter();
 
    WorkspaceUtil::printSaveGenomeToWorkspace("taxon_oid");

    printStatusLine( "$cnt2 Loaded", 2 );
}

###############################################################
# printViralScaffoldList
###############################################################
sub printViralScaffoldList {
    WebUtil::printMainForm();

    my $taxon_oid = param('taxon_oid');
    my $cluster_id = param('cluster_id');
    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    my $dbh = dbLogin();
    my $sql = qq{
        select t.taxon_oid, t.taxon_display_name,
               t.genome_type, t.in_file
        from taxon t
        where t.taxon_oid = ?
        $rclause
        $imgClause
        };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my ($tid, $taxon_name, $genome_type, $in_file) = $cur->fetchrow();
    $cur->finish();
    if ( ! $tid ) {
	WebUtil::webError("Genome not found");
	return;
    }

    my $url =
	"$main_cgi?section=TaxonDetail"
	. "&page=taxonDetail&taxon_oid=$taxon_oid";
    if ( $genome_type eq 'metagenome' ) {
	print "<h1>Metagenome Viral Contigs</h1>\n";
	print "<h2>Metagenome: " . alink($url, $taxon_name) .
	    "</h2>\n";
	$sql = qq{
            select v.scaffold_id, 0, 0, 0,
                   v.perc_vpfs, v.viral_clusters,
                   v.host, v.host_detection,
                   v.putative_retrovirus,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus
            from $viral_table_name v
            where v.taxon_oid = ?
            };

	if ( $cluster_id ) {
	    $sql .= " and v.viral_clusters = ? ";
	}
    }
    else {
	print "<h1>Isolate Viral Contigs</h1>\n";
	print "<h2>Virus: " . alink($url, $taxon_name) .
	    "</h2>\n";
	$sql = qq{
            select s.scaffold_oid, st.seq_length,
                   st.gc_percent, st.count_total_gene
            from scaffold s, scaffold_stats st
            where s.taxon = ?
            and s.scaffold_oid = st.scaffold_oid
            };
    }

    if ( $cluster_id ) {
	if ( $cluster_id =~ /sg/ ) {
	    print "<h3>Singleton: $cluster_id </h3>\n";
	}
	else {
	    print "<h3>Cluster: $cluster_id </h3>\n";
	}
    }

    printStatusLine( "Loading ...", 1 );

    my $tblname = "scaffoldSet$$";
    my $it = new InnerTable( 1, $tblname, $tblname, 1 );
    $it->hideExportButtons();

    $it->addColSpec( "Select" );
    $it->addColSpec( "Scaffold ID", "char asc", "left" );
    $it->addColSpec( "Gene Count", "asc", "right" );
    $it->addColSpec( "Sequence Length<br/>(bp)", "asc", "right" );
    $it->addColSpec( "GC Content", "asc", "right" ); 

    if ( $genome_type eq 'metagenome' ) {
	$it->addColSpec( "Perc VPFs", "asc", "right" );
	$it->addColSpec( "Viral Cluster", "char asc", "left" );
	$it->addColSpec( "Host Detection", "char asc", "left" );
	$it->addColSpec( "POGs Order", "char asc", "left" );
	$it->addColSpec( "POGs Family", "char asc", "left" );
	$it->addColSpec( "POGs Subfamily", "char asc", "left" );
	$it->addColSpec( "POGs Genus", "char asc", "left" );
	$it->addColSpec( "Putative Retrovirus", "char asc", "left" );
    }

    my $sd = $it->getSdDelim();

    if ( $genome_type eq 'metagenome' && $cluster_id ) {
	$cur = execSql( $dbh, $sql, $verbose, $taxon_oid, $cluster_id );
    }
    else {
	$cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    }

    my @taxon_list = ();
    my $cnt2       = 0;
    for ( ;; ) {
	my ($scaffold_oid, $seq_length, $gc, $n_genes,
	    $perc_vpfs, $cluster_id, $host, $detect_method,
	    $putative_retrovirus, @pogs) =
	    $cur->fetchrow();
        last if !$scaffold_oid;

	my $r;
	if ( $genome_type eq 'metagenome' && $in_file eq 'Yes' ) {
	    my $workspace_id = "$taxon_oid assembled $scaffold_oid";
	    $r = $sd 
		. "<input type='checkbox' name='scaffold_oid' value='$workspace_id'/>"
		. "\t";

	    my $url = "$main_cgi?section=MetaDetail&page=metaScaffoldDetail"
		. "&taxon_oid=$taxon_oid&scaffold_oid=$scaffold_oid&data_type=assembled";
	    $r .= $scaffold_oid . $sd . alink( $url, $scaffold_oid ) . "\t";

	    ($seq_length, $gc, $n_genes) = 
		MetaUtil::getScaffoldStats($taxon_oid, 'assembled', $scaffold_oid);

	    my $url3 = 
		"$main_cgi?section=MetaDetail"
		. "&page=metaScaffoldGenes&scaffold_oid=$scaffold_oid"
		. "&taxon_oid=$taxon_oid";
	    $r .= $n_genes . $sd . alink($url3, $n_genes, '_blank') . "\t";

	    my $url4 =
		"$main_cgi?section=MetaScaffoldGraph" .
		"&page=metaScaffoldGraph&scaffold_oid=$scaffold_oid" .
		"&taxon_oid=$taxon_oid" . 
		"&start_coord=1&end_coord=$seq_length" .
		"&seq_length=$seq_length";
	    $r .= $seq_length . $sd . alink($url4, $seq_length, '_blank') . "\t";
	    $r .= $gc . $sd . $gc . "\t";
	}
	else {
	    $r = $sd 
		. "<input type='checkbox' name='scaffold_oid' value='$scaffold_oid'/>"
		. "\t";

	    my $url = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
	    $r .= $scaffold_oid . $sd . alink( $url, $scaffold_oid ) . "\t";

	    my $url3 = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldGenes"
		. "&scaffold_oid=$scaffold_oid";
	    $r .= $n_genes . $sd . alink($url3, $n_genes, '_blank') . "\t";

	    my $url4 = "$main_cgi?section=ScaffoldGraph" .
                    "&page=scaffoldGraph&scaffold_oid=$scaffold_oid" .
                    "&taxon_oid=$taxon_oid" . 
                    "&start_coord=1&end_coord=$seq_length" .
                    "&seq_length=$seq_length";
	    $r .= $seq_length . $sd . alink($url4, $seq_length, '_blank') . "\t";
	    $r .= $gc . $sd . $gc . "\t";
	}

	if ( $genome_type eq 'metagenome' ) {
	    $r .= $perc_vpfs . $sd . $perc_vpfs . "\t";
	    my $url5 = $section_cgi . "&page=viralClusterDetail" .
		"&viral_cluster_id=$cluster_id";
	    if ( $cluster_id ) {
		$r .= $cluster_id . $sd . 
		    alink($url5, $cluster_id, '_blank') . "\t";
	    }
	    else {
		$r .= "-" . $sd . "-" . "\t";
	    }

	    my $method_detail = getDetectMethod($taxon_oid, $scaffold_oid);
	    $r .= '' . $sd . $method_detail . "\t";
	    for my $v2 ( @pogs ) {
		if ( ! $v2 ) {
		    $v2 = "-";
		}
		$r .= $v2 . $sd . $v2 . "\t";
	    }
	    $r .= $putative_retrovirus . $sd . $putative_retrovirus . "\t";
	}

	$it->addRow($r);

        $cnt2++;
    }
    $cur->finish();

    if ( $cnt2 > 10 ) {
	WebUtil::printScaffoldCartFooterInLineWithToggle($tblname); 
    } 
 
    $it->printOuterTable(1);

    WebUtil::printScaffoldCartFooterInLineWithToggle($tblname); 
    WorkspaceUtil::printSaveScaffoldToWorkspace("scaffold_oid");

    printStatusLine( "$cnt2 Loaded", 2 );
    print end_form();
}


sub getDetectMethod {
    my ($taxon_oid, $scaffold_id) = @_;
    my $method_detail = "";

    ## get host assignment from the new table
    my $dbh = dbLogin();
    my $sql = qq{
        select h.scaffold_id, h.host_detection_method,
               h.spacer_id, h.spacer_seq,
               h.host_taxon_id, h.host_scaffold_id,
               h.crispr_no, h.spacer_host,
               h.host_genome_type, h.host_domain,
               h.host_phylum, h.host_class, h.host_order,
               h.host_family, h.host_genus, h.host_species
        from $host_assignment_table_name h
        where h.taxon_oid = ?
        and h.scaffold_id = ?
    };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid, $scaffold_id );
    for ( ;; ) {
	my ($sid, $method, $sid, $seq, $host_tid, $host_sid, $crispr_no,
	    $host, @rest) = $cur->fetchrow();
	last if ! $sid;

	$method_detail .= "<tr class='img'>";
	$method_detail .= "<td class='img'>$method</td>";
	my $url2 = "$section_cgi&page=spacerDetail&spacer_id=$sid";
	$method_detail .= "<td class='img'>" .
	    alink($url2, $sid) . "</td>";
	$method_detail .= "<td class='img'>$seq</td>";
	my $host = join(' ', @rest);
	$method_detail .= "<td class='img'>$host</td>";
	$method_detail .= "</tr>";
    }
    $cur->finish();

    if ( $method_detail ) {
	$method_detail = "<table class='table-in-cell'>" .
	    "<th>Method</th>" . 
	    "<th>Spacer ID</th>" .
	    "<th>Spacer Sequence</th>" .
	    "<th>Host</th>" .
	    $method_detail .
	    "</table>";
    }

    return $method_detail;
}

###############################################################
# printViralClusterList
#
# so far we only have metagenome viral clusters
# therefore genome_type is set to 'metagenome'
###############################################################
sub printViralClusterList {
    my $genome_type = param('genome_type');
    my $cluster_type = param('cluster_type');
    $genome_type = 'metagenome';
    WebUtil::printMainForm();

    if ( $genome_type eq 'isolate' ) {
	print "<h1>Isolate Viral Clusters</h1>\n";
    }
    elsif ( $genome_type eq 'metagenome' ) {
	print "<h1>Viral Clusters</h1>\n";
    }
    else {
	print "<h1>All Viral Clusters</h1>\n";
    }

    if ( $cluster_type ) {
##	print "<h2>Cluster Type: $cluster_type</h2>\n";

	if ( $cluster_type eq 'cluster' ) {
	    my $info = "Unique cluster identifiers (Viral Cluster ID) and total number of Viral Contig Counts per cluster can be selected for further analyses as well as the samples (Sample Count) or the distinct studies (Study Count) they are derived from. Viral Host information is shown per viral cluster when detected as well as the manually curated Habitat type(s) information of the sample(s). Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
	    print qq{
               <h2>Cluster Type: $cluster_type
               <a href="" onClick="alert('$info'); return false;">
               <span id="ecosystems" title="$info">
               <image src="$base_url/images/question.png"></span></a>
            };

	    my $method_url =
		"$main_cgi?section=Viral"
		. "&page=printClusterMethod";
	    print nbsp(1);
	    print WebUtil::buttonUrlNewWindow($method_url, 
					      "Method",
					      "tinybutton");
	    print "</h2>\n";
	}
	elsif ( $cluster_type eq 'singleton' ) {
	    my $info = "Unique cluster identifiers (Viral Cluster ID) and the corresponding Viral Contig Count can be selected for further analyses as well as the sample (Sample Count) or the study (Study Count) they are derived from. Host information is shown per singleton when detected as well as the manually curated Habitat type information of the sample. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
	    print qq{
               <h2>Cluster Type: $cluster_type
               <a href="" onClick="alert('$info'); return false;">
               <span id="ecosystems" title="$info">
               <image src="$base_url/images/question.png"></span></a>
            };

	    my $method_url =
		"$main_cgi?section=Viral"
		. "&page=printSingletonMethod";
	    print nbsp(1);
	    print WebUtil::buttonUrlNewWindow($method_url, 
					      "Method",
					      "tinybutton");
	    print "</h2>\n";
	}
    }

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## don't hide any
    $rclause = "";
    $imgClause = "";

    my $dbh = dbLogin();

    printStartWorkingDiv();

    print "<p>Processing host information ...\n";
    my %host_h;
    my $sql = "select distinct viral_clusters, host from $viral_table_name where host is not null";
    if ( $cluster_type eq 'cluster' ) {
	$sql .= " and viral_clusters like 'vc%'";
    }
    elsif ( $cluster_type eq 'singleton' ) {
	$sql .= " and viral_clusters like 'sg%'";
    }
    $sql .= " order by 1, 2";
    my $cur = execSql( $dbh, $sql, $verbose );
    for (;;) {
	my ($cid, $host) = $cur->fetchrow();
	last if ! $cid;

	if ( $host_h{$cid} ) {
	    $host_h{$cid} .= ", " . $host;
	}
	else {
	    $host_h{$cid} = $host;
	}
    }
    $cur->finish();

    print "<p>Processing habitat type information ...\n";
    my %habitat_h;
    $sql = "select distinct viral_clusters, habitat from $viral_table_name where habitat is not null";
    if ( $cluster_type eq 'cluster' ) {
	$sql .= " and viral_clusters like 'vc%'";
    }
    elsif ( $cluster_type eq 'singleton' ) {
	$sql .= " and viral_clusters like 'sg%'";
    }
    $sql .= " order by 1, 2";
    $cur = execSql( $dbh, $sql, $verbose );
    for (;;) {
	my ($cid, $hab) = $cur->fetchrow();
	last if ! $cid;

	if ( $habitat_h{$cid} ) {
	    $habitat_h{$cid} .= ", " . $hab;
	}
	else {
	    $habitat_h{$cid} = $hab;
	}
    }
    $cur->finish();

    print "<p>Processing study information ...\n";
    my %viral_cnt;
    my %genome_cnt;
    my %study_cnt;
    if ( ! $genome_type || $genome_type eq 'isolate' ) {
	$sql = qq{
            select s.taxon, count(*)               
            from scaffold s
            where s.taxon in (
                  select t.taxon_oid from taxon t
                  where t.domain = 'Viruses'
                  $rclause
                  $imgClause )
            group by s.taxon
            };
	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($tid, $cnt) = $cur->fetchrow();
	    last if ! $tid;
	    $viral_cnt{$tid} = $cnt;
	}
	$cur->finish();
    }
    if ( ! $genome_type || $genome_type eq 'metagenome' ) {
	$sql = qq{
            select v.viral_clusters, count(*), count(distinct taxon_oid)
            from $viral_table_name v
            where v.viral_clusters is not null
            and v.taxon_oid in
                (select t.taxon_oid from taxon t
                  where 1 = 1
                  $rclause
                  $imgClause )
            group by v.viral_clusters
            };

	$sql = qq{
            select v.viral_clusters, count(*), count(distinct v.taxon_oid),
                   count(distinct t.proposal_name)
            from $viral_table_name v, taxon t
            where v.viral_clusters is not null
            and v.taxon_oid = t.taxon_oid
            $rclause
            $imgClause 
            group by v.viral_clusters
            };

	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($cid, $cnt, $g_cnt, $st_cnt) = $cur->fetchrow();
	    last if ! $cid;

	    if ( $cluster_type eq 'singleton' ) {
		if ( $cid =~ /sg/ ) {
		    # singleton, ok
		}
		else {
		    next;
		}
	    }
	    else {
		if ( $cid =~ /sg/ ) {
		    # singleton
		    next;
		}
	    }
	    $viral_cnt{$cid} = $cnt;
	    $genome_cnt{$cid} = $g_cnt;
	    $study_cnt{$cid} = $st_cnt;
	}
	$cur->finish();
    }

    printEndWorkingDiv();

    printStatusLine( "Loading ...", 1 );

    my $it = new InnerTable( 1, "genomeSet$$", "genomeSet", 1 );
    $it->addColSpec("Select");
    $it->addColSpec( "Viral Cluster ID", "char asc", "left" );
    $it->addColSpec( "Viral Contig Count", "number asc", "right" );
    $it->addColSpec( "Sample Count", "number asc", "right" );
    $it->addColSpec( "Study Count", "number asc", "right" );
    $it->addColSpec( "Host", "char asc", "left" );
    $it->addColSpec( "Habitat Type", "char asc", "left" );
    my $sd = $it->getSdDelim();

    my $cnt2 = 0;
    for my $key (keys %viral_cnt) {
	my $r = $sd 
	    . "<input type='checkbox' name='viral_cluster_id' value='$key'/>"
	    . "\t";

	my $url = $section_cgi . "&page=viralClusterDetail" .
	    "&viral_cluster_id=$key";
	$r .= $key . $sd . alink( $url, $key ) . "\t";

	my $scf_cnt = $viral_cnt{$key};
	if ( $scf_cnt ) {
	    my $url2 = $section_cgi . "&page=viralClusterDetail" .
		"&viral_cluster_id=$key";
	    $r .= $scf_cnt . $sd . alink($url2, $scf_cnt, '_blank') . "\t";
	}
	else {
	    $r .= "0" . $sd . "0\t";
	}

	my $g_cnt = $genome_cnt{$key};
	if ( $g_cnt ) {
	    my $url2 = $section_cgi . "&page=viralClusterGenome" .
		"&viral_cluster_id=$key";
	    $r .= $g_cnt . $sd . alink($url2, $g_cnt, '_blank') . "\t";
	}
	else {
	    $r .= "0" . $sd . "0\t";
	}

	my $st_cnt = $study_cnt{$key};
	if ( $st_cnt ) {
	    my $url2 = $section_cgi . "&page=viralClusterStudy" .
		"&viral_cluster_id=$key";
	    $r .= $st_cnt . $sd . alink($url2, $st_cnt, '_blank') . "\t";
	}
	else {
	    $r .= "0" . $sd . "0\t";
	}

	$r .= $host_h{$key} . $sd . $host_h{$key} . "\t";
	$r .= $habitat_h{$key} . $sd . $habitat_h{$key} . "\t";
	$it->addRow($r);

        $cnt2++;
    }
    $cur->finish();

    $it->printOuterTable(1);

    printStatusLine( "$cnt2 Loaded", 2 );
}

###############################################################
# printClusterDetail
###############################################################
sub printClusterDetail {
    WebUtil::printMainForm();

    my $cluster_id = param('viral_cluster_id');
    return if ! $cluster_id;

    my $genome_type = param('genome_type');
    if ( $genome_type eq 'isolate' ) {
	print "<h1>Isolate Viral Contigs</h1>\n";
    }
    elsif ( $genome_type eq 'metagenome' ) {
	print "<h1>Metagenome Viral Contigs</h1>\n";
    }
    else {
	print "<h1>Viral Contigs</h1>\n";
    }

    if ( $cluster_id =~ /sg/ ) {
	print "<h2>Singleton: $cluster_id </h2>\n";
    }
    else {
	print "<h2>Cluster: $cluster_id </h2>\n";
    }

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    $rclause = "";
    $imgClause = "";

    printStatusLine( "Loading ...", 1 );

    my $dbh = dbLogin();

    ## host
    my $v_host = "";
    my $sql = qq{
        select distinct viral_clusters, host from $viral_table_name 
        where viral_clusters = ?
        and host is not null
        order by 1, 2
    };
    my $cur = execSql( $dbh, $sql, $verbose, $cluster_id );
    for (;;) {
	my ($cid, $host) = $cur->fetchrow();
	last if ! $cid;

	if ( $v_host ) {
	    $v_host .= ", " . $host;
	}
	else {
	    $v_host = $host;
	}
    }
    $cur->finish();
    if ( $v_host ) {
	print "<h3>Host: $v_host</h3>\n";
    }

    my $v_habitat;
    $sql = qq{
        select distinct viral_clusters, habitat 
        from $viral_table_name
        where viral_clusters = ?
        and habitat is not null order by 1, 2
    };
    $cur = execSql( $dbh, $sql, $verbose, $cluster_id );
    for (;;) {
	my ($cid, $hab) = $cur->fetchrow();
	last if ! $cid;

	if ( $v_habitat ) {
	    $v_habitat .= ", " . $hab;
	}
	else {
	    $v_habitat = $hab;
	}
    }
    $cur->finish();
    if ( $v_habitat ) {
	print "<h3>Habitat Type: $v_habitat</h3>\n";
    }

    my @recs = ();

    if ( ! $genome_type || $genome_type eq 'isolate' ) {
	my $sql = qq{
            select st.scaffold_oid, t.genome_type,
                   v.taxon_oid, t.in_file,
                   t.taxon_display_name, 
                   st.seq_length,
                   st.gc_percent, st.count_total_gene,
                   v.perc_vpfs, v.viral_clusters,
                   v.host, v.host_detection,
                   v.putative_retrovirus,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus
            from $viral_table_name v, taxon t, scaffold_stats st
            where v.viral_clusters = ?
            and v.taxon_oid = t.taxon_oid
            and v.taxon_oid = st.taxon
            $rclause
            $imgClause
            };
	my $cur = execSql( $dbh, $sql, $verbose, $cluster_id );
	for ( ; ; ) {
	    my ($scaffold_oid, @rest) =
		$cur->fetchrow();
	    last if !$scaffold_oid;

	    push @recs, ( $scaffold_oid . "\t" . join("\t", @rest) );
	}
	$cur->finish();
    }

    if ( ! $genome_type || $genome_type eq 'metagenome' ) {
	my $sql = qq{
            select v.scaffold_id, t.genome_type,
                   v.taxon_oid, t.in_file,
                   t.taxon_display_name, 
                   0, 0, 0,
                   v.perc_vpfs, v.viral_clusters,
                   v.host, v.host_detection,
                   v.putative_retrovirus,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus
            from $viral_table_name v, taxon t
            where v.viral_clusters = ?
            and v.taxon_oid = t.taxon_oid
            $rclause
            $imgClause
            };
	my $cur = execSql( $dbh, $sql, $verbose, $cluster_id );
	for ( ; ; ) {
	    my ($scaffold_oid, @rest) =
		$cur->fetchrow();
	    last if !$scaffold_oid;

	    push @recs, ( $scaffold_oid . "\t" . join("\t", @rest) );
	}
	$cur->finish();
    }

    my %my_access_h;
    my $contact_oid = WebUtil::getContactOid();
    my $sql = qq{
      select taxon_oid
      from taxon
      where is_public = 'Yes'
      and obsolete_flag = 'No'
         union
      select taxon_permissions
      from contact_taxon_permissions
      where contact_oid = ?
    };
    my $cur = execSql( $dbh, $sql, $verbose, $contact_oid );
    for ( ;; ) {
	my ($tid) = $cur->fetchrow();
	last if ! $tid;
	$my_access_h{$tid} = 1;
    }
    $cur->finish();

    my $tblname = "scaffoldSet$$";
    my $it = new InnerTable( 1, $tblname, $tblname, 1 );
    $it->hideExportButtons();

    $it->addColSpec( "Select" );
    $it->addColSpec( "Scaffold ID", "char asc", "left" );
    $it->addColSpec( "Taxon OID", "number asc", "right" );
    $it->addColSpec( "Genome Name", "char asc", "left" );
    $it->addColSpec( "Gene Count", "asc", "right" );
    $it->addColSpec( "Sequence Length<br/>(bp)", "asc", "right" );
    $it->addColSpec( "GC Content", "asc", "right" ); 

    $it->addColSpec( "Perc VPFs", "asc", "right" );
    $it->addColSpec( "Viral Cluster", "char asc", "left" );
    $it->addColSpec( "Host Detection", "char asc", "left" );
    $it->addColSpec( "POGs Order", "char asc", "left" );
    $it->addColSpec( "POGs Family", "char asc", "left" );
    $it->addColSpec( "POGs Subfamily", "char asc", "left" );
    $it->addColSpec( "POGs Genus", "char asc", "left" );
    $it->addColSpec( "Putative Retrovirus", "char asc", "left" );

    my $sd = $it->getSdDelim();

    my $cnt2       = 0;
    my $no_permission = 0;
    for my $rec1 ( @recs ) {
	my ($scaffold_oid, $taxon_type, $taxon_oid, 
	    $in_file, $taxon_name,
	    $seq_length, $gc, $n_genes, 
	    $perc_vpfs, $viral_clusters, $host,
	    $host_detection, $putative_retrovirus,
	    @pogs) = split(/\t/, $rec1);

	my $r;
	if ( ! $my_access_h{$taxon_oid} ) {
	    $no_permission++;
	    $r .= "" . $sd . "" . "\t";
	    $r .= $scaffold_oid . $sd . $scaffold_oid . "\t";
	    $r .= $taxon_oid . $sd . $taxon_oid . "\t";
	    $r .= $taxon_name . $sd . $taxon_name . "\t";
	    $it->addRow($r);
	    next;
	}
	if ( $taxon_type eq 'metagenome' && $in_file eq 'Yes' ) {
	    ## metagenome
	    my $workspace_id = "$taxon_oid assembled $scaffold_oid";
	    $r = $sd 
		. "<input type='checkbox' name='scaffold_oid' value='$workspace_id'/>"
		. "\t";

	    my $url = "$main_cgi?section=MetaDetail&page=metaScaffoldDetail" .
		"&taxon_oid=$taxon_oid&scaffold_oid=$scaffold_oid" .
		"&data_type=assembled";
	    $r .= $scaffold_oid . $sd . alink( $url, $scaffold_oid ) . "\t";

	    my $url2 = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
		"&taxon_oid=$taxon_oid";
	    $r .= $taxon_oid . $sd . alink( $url2, $taxon_oid ) . "\t";
	    $r .= $taxon_name . $sd . $taxon_name . "\t";

	    ($seq_length, $gc, $n_genes) = 
		MetaUtil::getScaffoldStats($taxon_oid, 'assembled', $scaffold_oid);

	    my $url3 = 
		"$main_cgi?section=MetaDetail"
		. "&page=metaScaffoldGenes&scaffold_oid=$scaffold_oid"
		. "&taxon_oid=$taxon_oid";
	    $r .= $n_genes . $sd . alink($url3, $n_genes, '_blank') . "\t";

	    my $url4 =
		"$main_cgi?section=MetaScaffoldGraph" .
		"&page=metaScaffoldGraph&scaffold_oid=$scaffold_oid" .
		"&taxon_oid=$taxon_oid" . 
		"&start_coord=1&end_coord=$seq_length" .
		"&seq_length=$seq_length";
	    $r .= $seq_length . $sd . alink($url4, $seq_length, '_blank') . "\t";
	    $r .= $gc . $sd . $gc . "\t";
	}
	else {
	    ## isolate
	    $r = $sd 
		. "<input type='checkbox' name='scaffold_oid' value='$scaffold_oid'/>"
		. "\t";

	    my $url = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
	    $r .= $scaffold_oid . $sd . alink( $url, $scaffold_oid ) . "\t";

	    my $url2 = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
		"&taxon_oid=$taxon_oid";
	    $r .= $taxon_oid . $sd . alink( $url2, $taxon_oid ) . "\t";
	    $r .= $taxon_name . $sd . $taxon_name . "\t";

	    my $url3 = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldGenes"
		. "&scaffold_oid=$scaffold_oid";
	    $r .= $n_genes . $sd . alink($url3, $n_genes, '_blank') . "\t";

	    my $url4 = "$main_cgi?section=ScaffoldGraph" .
                    "&page=scaffoldGraph&scaffold_oid=$scaffold_oid" .
                    "&taxon_oid=$taxon_oid" . 
                    "&start_coord=1&end_coord=$seq_length" .
                    "&seq_length=$seq_length";
	    $r .= $seq_length . $sd . alink($url4, $seq_length, '_blank') . "\t";
	    $r .= $gc . $sd . $gc . "\t";
	}

	$r .= $perc_vpfs . $sd . $perc_vpfs . "\t";
	my $url3 = $section_cgi . "&page=viralClusterDetail" .
	    "&viral_cluster_id=$cluster_id";
	$r .= $cluster_id . $sd . alink($url3, $cluster_id) . "\t";

	my $method_detail = getDetectMethod($taxon_oid, $scaffold_oid);
	$r .= '' . $sd . $method_detail . "\t";

	for (my $j = 0; $j < 4; $j++ ) {
	    my $v2 = '-';
	    if ( scalar(@pogs) > $j ) {
		$v2 = $pogs[$j];
	    }
	    $r .= $v2 . $sd . $v2 . "\t";
	}

	$r .= $putative_retrovirus . $sd . $putative_retrovirus . "\t";
	$it->addRow($r);

        $cnt2++;
    }

    if ( $no_permission ) {
	if ( $cluster_id =~ /sg/ ) {
	    print "<p><font color='red'><u>Note</u>: This singleton contains some private contig(s)</font></p>\n";
	}
	else {
	    print "<p><font color='red'><u>Note</u>: This cluster contains some private contig(s)</font></p>\n";
	}
    }

    if ( $cnt2 > 10 && $cnt2 > $no_permission ) {
	WebUtil::printScaffoldCartFooterInLineWithToggle($tblname); 
    } 

    $it->printOuterTable(1);

    if ( $cnt2 > $no_permission ) {
	WebUtil::printScaffoldCartFooterInLineWithToggle($tblname);  
	WorkspaceUtil::printSaveScaffoldToWorkspace("scaffold_oid");
    }

    printStatusLine( "$cnt2 Loaded", 2 );
    print end_form();
}

###############################################################
# printSpacerDetail
###############################################################
sub printSpacerDetail {
    WebUtil::printMainForm();

    my $spacer_id = param('spacer_id');
    $spacer_id = strTrim($spacer_id);
    return if ! $spacer_id;

    my ($taxon_oid, $scaffold_id, $crispr_no, $pos) = split(/\:/, $spacer_id);
    my $rest = '';
    if ( ! $pos ) {
	## old format
	($taxon_oid, $scaffold_id, $crispr_no, $rest) = 
	    split(/_____/, $spacer_id);
    }

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    my $dbh = dbLogin();
    my $sql = qq{
         select t.taxon_oid, t.taxon_display_name, t.in_file
         from taxon t
         where taxon_oid = ?
         $rclause
         $imgClause
         };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my ($t2, $taxon_display_name, $in_file) = $cur->fetchrow();
    $cur->finish();

    print "<h1>Viral Spacer</h1>\n";

    print "<table class='img'>\n";
    printAttrRow("Spacer ID", $spacer_id);
    if ( $t2 ) {
	my $url2 = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
	    "&taxon_oid=$taxon_oid";
	printAttrRowRaw("Source Taxon", alink($url2, $taxon_display_name));
	if ( $in_file eq 'Yes' ) {
	    my $url = "$main_cgi?section=MetaDetail&page=metaScaffoldDetail" .
		"&taxon_oid=$taxon_oid&scaffold_oid=$scaffold_id" .
		"&data_type=assembled";
	    printAttrRowRaw("Source Scaffold", alink($url, $scaffold_id));
	}
	else {
	    my $sql2 = "select scaffold_oid from scaffold where taxon = ? and ext_accession = ?";
	    my $cur2 = execSql( $dbh, $sql2, $verbose, $taxon_oid,
		$scaffold_id);
	    my ($scaffold_oid) = $cur2->fetchrow();
	    $cur2->finish();
	    my $url = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
	    printAttrRowRaw("Source Scaffold", alink($url, $scaffold_id));
	}
    }

    if ( $crispr_no && isInt($crispr_no) ) {
	printAttrRowRaw("CRISPR No", $crispr_no);
    }
    else {
	$crispr_no = 1;
    }

    my $pos_cond = " ";
    if ( $pos && isInt($pos) ) {
	printAttrRowRaw("Position", $pos);
	$pos_cond = " and s.pos = $pos";
    }
    else {
	$pos = 0;
    }


    my $sql = qq{
           select s.spacer_seq from $crispr_table_name s 
           where s.taxon_oid = ?
           and s.contig_id = ?
           and s.crispr_no = ?
           $pos_cond
           };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid, 
		       $scaffold_id, $crispr_no );
    my ($seq) = $cur->fetchrow();
    $cur->finish();
    printAttrRow("Sequence", $seq);

    print "</table>\n";

    if ( ! $seq ) {
	return;
    }

    print "<h2>Metagenome Scaffolds with This Spacer</h2>\n";

    my $tblname = 'spacer_scaf';
    my $it = new InnerTable( 1, $tblname, $tblname, 1 );
    my $sd = $it->getSdDelim();
    $it->addColSpec( "Scaffold ID", "char asc", "left" );
    $it->addColSpec( "Taxon OID", "number asc", "right" );
    $it->addColSpec( "Genome Name", "char asc", "left" );
    $it->addColSpec( "Viral Cluster", "char asc", "left" );
    $it->addColSpec( "Host Domain", "char asc", "left" );
    $it->addColSpec( "Host Phylum", "char asc", "left" );
    $it->addColSpec( "Host Class", "char asc", "left" );
    $it->addColSpec( "Host Order", "char asc", "left" );
    $it->addColSpec( "Host Family", "char asc", "left" );
    $it->addColSpec( "Host Genus", "char asc", "left" );
    $it->addColSpec( "Host Species", "char asc", "left" );

#    $sql = qq{
#           select h.taxon_oid, t.taxon_display_name, t.in_file, 
#                  h.scaffold_id, h.viral_clusters,
#                  h.host_domain, h.host_phylum,
#                  h.host_class, h.host_order,
#                  h.host_family, h.host_genus, h.host_species
#           from $host_assignment_table_name h, taxon t
#           where h.taxon_oid = t.taxon_oid
#           and h.host_taxon_id = ?
#           and h.host_scaffold_id = ?
#           and h.crispr_no = ?
#           and h.spacer_seq = ?
#           $rclause
#           $imgClause
#           };
    $sql = qq{
           select distinct h.taxon_oid, t.taxon_display_name, t.in_file, 
                  h.scaffold_id, h.viral_clusters,
                  h.host_domain, h.host_phylum,
                  h.host_class, h.host_order,
                  h.host_family, h.host_genus, h.host_species
           from $host_assignment_table_name h, taxon t
           where h.taxon_oid = t.taxon_oid
           and h.spacer_seq = ?
           $rclause
           $imgClause
           };

#    $cur = execSql( $dbh, $sql, $verbose, $taxon_oid, $scaffold_id,
#		    $crispr_no, $seq );
    $cur = execSql( $dbh, $sql, $verbose, $seq );

    my $cnt2 = 0;
    for (;;) {
	my ($t_id, $taxon_name, $in_file, $s_id, $cluster_id,
	    @host_attr) =
	    $cur->fetchrow();
	last if ! $t_id;

	$cnt2++;
	my $r = "";
	if ( $in_file eq 'Yes' ) {
	    my $url = "$main_cgi?section=MetaDetail&page=metaScaffoldDetail" .
		"&taxon_oid=$t_id&scaffold_oid=$s_id" .
		"&data_type=assembled";
	    $r .= $s_id . $sd . alink( $url, $s_id ) . "\t";
	}
	else {
	    my $sql2 = "select scaffold_oid from scaffold where taxon = ? and ext_accession = ?";
	    my $cur2 = execSql( $dbh, $sql2, $verbose, $t_id, $s_id);
	    my ($scaffold_oid) = $cur2->fetchrow();
	    $cur2->finish();
	    my $url = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
	    $r .= $s_id . $sd . alink( $url, $s_id ) . "\t";
	}

	my $url2 = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
	    "&taxon_oid=$t_id";
	$r .= $t_id . $sd . alink( $url2, $t_id ) . "\t";
	$r .= $taxon_name . $sd . $taxon_name . "\t";

	my $url3 = $section_cgi . "&page=viralClusterDetail" .
	    "&viral_cluster_id=$cluster_id";
	if ( $cluster_id ) {
	    $r .= $cluster_id . $sd . alink($url3, $cluster_id) . "\t";
	}
	else {
	    $r .= "-" . $sd . "-" . "\t";
	}

	for my $str2 ( @host_attr ) {
	    if ( $str2 ) {
		$r .= $str2 . $sd . $str2 . "\t";
	    }
	    else {
		$r .= "-" . $sd . "-" . "\t";
	    }
	}
	$it->addRow($r);
    }
    $cur->finish();

    if ( $cnt2 ) {
	$it->printOuterTable(1);
    }
    else {
	print "<h4>No scaffolds found.</h4>\n";
    }

    print end_form();
}


###############################################################
# printClusterGenome
###############################################################
sub printClusterGenome {
    WebUtil::printMainForm();

    my $cluster_id = param('viral_cluster_id');
    return if ! $cluster_id;

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    my $dbh = dbLogin();
    my $sql;
    my $genome_type = 'metagenome';
    if ( $genome_type eq 'metagenome' ) {
	print "<h1>Metagenomes with Viral Contigs</h1>\n";
	if ( $cluster_id =~ /sg/ ) {
	    print "<h2>Singleton: $cluster_id </h2>\n";
	}
	else {
	    print "<h2>Cluster: $cluster_id </h2>\n";
	}
	$sql = qq{
            select v.taxon_oid, count(*)
            from $viral_table_name v, taxon t
            where v.viral_clusters = ?
            and v.taxon_oid = t.taxon_oid
            $rclause
            $imgClause
            group by v.taxon_oid
            };
    }
    else {
	print "<h1>Isolate Viral Genomes</h1>\n";
	print "<h2>Cluster: $cluster_id </h2>\n";
	## FIXME
	$sql = qq{
            select s.taxon, count(*)
            from scaffold s
            where s.taxon = ?
            group by s.taxon
            };
    }

    printStatusLine( "Loading ...", 1 );

    my $tblname = "genomeList$$";
    my $it = new InnerTable( 1, $tblname, $tblname, 1 );
    $it->addColSpec("Select");
    $it->addColSpec( "Taxon OID", "number asc", "right" );
    $it->addColSpec( "Genome Name", "char asc", "left" );
    $it->addColSpec( "Study Name", "char asc", "left" );
    $it->addColSpec( "Viral Contigs", "number asc", "right" );

    my $sd = $it->getSdDelim();

    my $cur = execSql( $dbh, $sql, $verbose, $cluster_id );

    my @taxon_list = ();
    my $cnt2       = 0;
    my $taxon_name_sql = "select taxon_display_name, proposal_name from taxon where taxon_oid = ?";
    for ( ; ; ) {
	my ($taxon_oid, $scf_cnt) =
	    $cur->fetchrow();
        last if !$taxon_oid;

	my $r;
	$r = $sd 
	    . "<input type='checkbox' name='taxon_oid' value='$taxon_oid'/>"
	    . "\t";

	my $url = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
	    "&taxon_oid=$taxon_oid";
	$r .= $taxon_oid . $sd . alink( $url, $taxon_oid ) . "\t";

	my $cur2 = execSql( $dbh, $taxon_name_sql, $verbose, $taxon_oid );
	my ($taxon_name, $study_name) = $cur2->fetchrow();
	$cur2->finish();
	$r .= $taxon_name . $sd . $taxon_name . "\t";
	$r .= $study_name . $sd . $study_name . "\t";

	my $url2 = $section_cgi . "&page=viralScaffoldList" .
	    "&taxon_oid=$taxon_oid&cluster_id=$cluster_id";
	$r .= $scf_cnt . $sd . alink($url2, $scf_cnt, '_blank') . "\t";

	$it->addRow($r);

        $cnt2++;
    }
    $cur->finish();

    if ( $cnt2 > 10 ) {
	WebUtil::printGenomeCartFooter($tblname); 
    } 
 
    $it->printOuterTable(1);

    WebUtil::printGenomeCartFooter($tblname); 
 
    WorkspaceUtil::printSaveGenomeToWorkspace("taxon_oid");

    printStatusLine( "$cnt2 Loaded", 2 );
}


###############################################################
# printClusterStudy
###############################################################
sub printClusterStudy {
    WebUtil::printMainForm();

    my $cluster_id = param('viral_cluster_id');
    return if ! $cluster_id;

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    my $dbh = dbLogin();
    my $sql;
    my $genome_type = 'metagenome';
    if ( $genome_type eq 'metagenome' ) {
	print "<h1>Metagenome Studies with Viral Contigs</h1>\n";
	if ( $cluster_id =~ /sg/ ) {
	    print "<h2>Singleton: $cluster_id </h2>\n";
	}
	else {
	    print "<h2>Cluster: $cluster_id </h2>\n";
	}
	$sql = qq{
            select t.proposal_name, v.taxon_oid, 
                   t.taxon_display_name, count(*)
            from $viral_table_name v, taxon t
            where v.viral_clusters = ?
            and v.taxon_oid = t.taxon_oid
            $rclause
            $imgClause
            group by t.proposal_name, v.taxon_oid, t.taxon_display_name
            order by 1, 2
            };
    }
    else {
	print "<h1>Isolate Viral Genome Studies</h1>\n";
	print "<h2>Cluster: $cluster_id </h2>\n";
	## FIXME
	$sql = qq{
            select t.proposal_name, s.taxon, 
                   t.taxon_display_name, count(*)
            from scaffold s, taxon t
            where s.taxon = ?
            and s.taxon = t.taxon_oid
            group by t.proposal_name, s.taxon, t.taxon_display_name
            order by 1, 2
            };
    }

    my $cur = execSql( $dbh, $sql, $verbose, $cluster_id );
    printStatusLine( "Loading ...", 1 );

    my $cnt2       = 0;
    my $name2 = "";
    for ( ; ; ) {
	my ($study_name, $taxon_oid, $taxon_name, $scf_cnt) =
	    $cur->fetchrow();
        last if !$taxon_oid;

	if ( $name2 ne $study_name ) {
	    print "<h4>Study: $study_name</h4>\n";
	    $name2 = $study_name;
	}

	print "<input type='checkbox' name='taxon_oid' value='$taxon_oid'/>";

	my $url = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
	    "&taxon_oid=$taxon_oid";
	print alink( $url, $taxon_oid ) . " ";
	print $taxon_name;

	my $url2 = $section_cgi . "&page=viralScaffoldList" .
	    "&taxon_oid=$taxon_oid&cluster_id=$cluster_id";
	print " (scaffold count: " . alink($url2, $scf_cnt, '_blank') . ")\n";
	print "<br/>\n";

        $cnt2++;
    }
    $cur->finish();

    print "<p>\n";
    WebUtil::printGenomeCartFooter();
 
    WorkspaceUtil::printSaveGenomeToWorkspace("taxon_oid");

    printStatusLine( "$cnt2 Loaded", 2 );
}


###############################################################
# printViralHostList
###############################################################
sub printViralHostList {
    my $genome_type = param('genome_type');
    WebUtil::printMainForm();

    if ( $genome_type eq 'isolate' ) {
##	print "<h1>Isolate Viruses with Host</h1>\n";
	my $info = "Total number of isolate viral genomes (Viral Contig Count) per viral host can be selected for further analyses. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
	print qq{
               <h1>Isolate Viruses with Host
               <a href="" onClick="alert('$info'); return false;">
               <span id="ecosystems" title="$info">
               <image src="$base_url/images/question.png"></span></a></h1>
            };
    }
    elsif ( $genome_type eq 'metagenome' ) {
##	print "<h1>Metagenomic Contigs with Host by Spacer Hit</h1>\n";
	my $info = "Virus-host direct association (at species level) of metagenomic viral contigs that bear a proto-spacer sequence -according to CRISPR spacer matches from a microbial isolate genome. mVCs grouped with their associated hosts at different taxonomic levels (from phylum to species) can be selected for further analyses. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
	print qq{
               <h1>Metagenomic Contigs with Host by Spacer Hit
               <a href="" onClick="alert('$info'); return false;">
               <span id="ecosystems" title="$info">
               <image src="$base_url/images/question.png"></span></a>
            };

	my $method_url =
	    "$main_cgi?section=Viral"
	    . "&page=printHostMethod";
	print nbsp(1);
	print WebUtil::buttonUrlNewWindow($method_url, 
					  "Method",
					  "tinybutton");
	print "</h1>\n";
    }
    else {
	print "<h1>All Viruses with Host</h1>\n";
	print "<h5>(Note: Only viral mVCs with <u>classified</u> host species assignment are included here.)</h5>\n";
    }

    printHint("Please limit the number of selections to avoid browser timeout.");

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all counts
    $rclause = "";
    $imgClause = "";

    my $dbh = dbLogin();
    my %viral_cnt;
    my $sql;
    my $cur;
    if ( ! $genome_type || $genome_type eq 'isolate' ) {
	$sql = qq{
            select g.host_name, count(*)
            from scaffold s, taxon t, gold_sequencing_project g
            where t.domain = 'Viruses'
                  and t.obsolete_flag = 'No'
                  $rclause
                  $imgClause
            and s.taxon = t.taxon_oid
            and t.sequencing_gold_id = g.gold_id
            and g.host_name is not null
            group by g.host_name
            };
	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($tid, $cnt) = $cur->fetchrow();
	    last if ! $tid;

	    if ( $viral_cnt{$tid} ) {
		$viral_cnt{$tid} += $cnt;
	    }
	    else {
		$viral_cnt{$tid} = $cnt;
	    }
	}
	$cur->finish();
    }
##    if ( ! $genome_type || $genome_type eq 'metagenome' ) {
    if ( ! $genome_type ) {
	my $host_field = 'host_species';
	$sql = qq{
            select v.$host_field, count(distinct scaffold_id)               
            from $host_assignment_table_name v
            where v.$host_field is not null
            and v.taxon_oid in
                (select t.taxon_oid from taxon t
                  where t.obsolete_flag = 'No'
                  $rclause
                  $imgClause )
            group by v.$host_field
            };

	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($cid, $cnt) = $cur->fetchrow();
	    last if ! $cid;

	    if ( $viral_cnt{$cid} ) {
		$viral_cnt{$cid} += $cnt;
	    }
	    else {
		$viral_cnt{$cid} = $cnt;
	    }
	}
	$cur->finish();
    }

    ## show 7 level host for metagenomes
    if ( $genome_type eq 'metagenome' ) {
	$sql = qq{
            select v.host_domain, v.host_phylum, v.host_class,
                   v.host_order, v.host_family, v.host_genus,
                   v.host_species, count(distinct scaffold_id)               
            from $host_assignment_table_name v
            where v.host_domain is not null
            and v.taxon_oid in
                (select t.taxon_oid from taxon t
                  where t.obsolete_flag = 'No'
                  $rclause
                  $imgClause )
            group by v.host_domain, v.host_phylum, v.host_class,
                  v.host_order, v.host_family, v.host_genus,
                  v.host_species
            };

	$cur = execSql( $dbh, $sql, $verbose );
	for (;;) {
	    my ($dom, $phy, $cla, $ord, $fam, $gen, $spe, $cnt) = $cur->fetchrow();
	    last if ! $dom;

	    $dom = strTrim($dom);
	    $dom =~ s/\t//;
	    $phy = strTrim($phy);
	    $phy =~ s/\t//;
	    if ( ! $phy ) {
		$phy = '-';
	    }
	    $cla = strTrim($cla);
	    $cla =~ s/\t//;
	    if ( ! $cla ) {
		$cla = '-';
	    }
	    $ord = strTrim($ord);
	    $ord =~ s/\t//;
	    if ( ! $ord ) {
		$ord = '-';
	    }
	    $fam = strTrim($fam);
	    $fam =~ s/\t//;
	    if ( ! $fam ) {
		$fam = '-';
	    }
	    $gen = strTrim($gen);
	    $gen =~ s/\t//;
	    if ( ! $gen ) {
		$gen = '-';
	    }
	    $spe = strTrim($spe);
	    $spe =~ s/\t//;
	    if ( ! $spe ) {
		$spe = '-';
	    }
##	    my $cid = "$dom\t$phy\t$cla\t$ord\t$fam\t$gen\t$spe";
	    my $cid = "$dom|$phy|$cla|$ord|$fam|$gen|$spe";
	    if ( $viral_cnt{$cid} ) {
		$viral_cnt{$cid} += $cnt;
	    }
	    else {
		$viral_cnt{$cid} = $cnt;
	    }
	}
	$cur->finish();
    }

    printStatusLine( "Loading ...", 1 );

    my $it = new InnerTable( 0, "scafSet$$", "scafSet", 0 );
    $it->addColSpec("Select");
    if ( $genome_type eq 'metagenome' ) {
	$it->addColSpec( "Host Domain", "char asc", "left" );
	$it->addColSpec( "Host Phylum", "char asc", "left" );
	$it->addColSpec( "Host Class", "char asc", "left" );
	$it->addColSpec( "Host Order", "char asc", "left" );
	$it->addColSpec( "Host Family", "char asc", "left" );
	$it->addColSpec( "Host Genus", "char asc", "left" );
	$it->addColSpec( "Host Species", "char asc", "left" );
    }
    else {
	$it->addColSpec( "Viral Host", "char asc", "left" );
    }
    $it->addColSpec( "Viral Contig Count", "number asc", "right" );
    my $sd = $it->getSdDelim();

    my $cnt2 = 0;
    for my $key (keys %viral_cnt) {
	my $r = $sd 
	    . "<input type='checkbox' name='viral_host' value='$key'/>"
	    . "\t";

	my $viral_host = $key;
	if ( $genome_type eq 'metagenome' ) {
	    ## metagenome
	    my @rec = split(/\|/, $key);
	    my $j = 0;
	    for my $r2 ( @rec ) {
		if ( $j < 7 ) {
		    $r .= $r2 . $sd . $r2. "\t";
		}
		else {
		    $viral_host = $r2;
		    if ( $r2 eq "-" ) {
			$r .= $r2 . $sd . $r2. "\t";
		    }
		    else {
			my $url = $section_cgi . "&page=viralHostDetail" .
			    "&genome_type=$genome_type" .
			    "&viral_host=$key";
			$r .= $r2 . $sd . alink( $url, $r2 ) . "\t";
		    }
		}
		$j++;
	    }
	}
	else {
	    my $url = $section_cgi . "&page=viralHostDetail" .
		"&genome_type=$genome_type" .
		"&viral_host=$key";
##	    $r .= $key . $sd . alink( $url, $key ) . "\t";
	    $r .= $key . $sd . $key . "\t";
	}

	my $scf_cnt = $viral_cnt{$key};

	if ( $scf_cnt ) {
	    if ( $viral_host eq "-" ) {
		$r .= $scf_cnt . $sd . $scf_cnt . "\t";
	    }
	    else {
		my $url2 = $section_cgi . "&page=viralHostDetail" .
		    "&genome_type=$genome_type" .
		    "&viral_host=$key";
		$r .= $scf_cnt . $sd . alink($url2, $scf_cnt, '_blank') . "\t";
	    }
	}
	else {
	    $r .= "0" . $sd . "0\t";
	}

	$it->addRow($r);

        $cnt2++;
    }
    $cur->finish();

    $it->printOuterTable(1);

    printHint("Please limit the number of selections to avoid browser timeout.");
    print "<p>\n";

    if ( $genome_type eq 'isolate' ) {
    	my $name = "_section_${section}_isoHostDetail";
    	print submit(
    	    -name  => $name,
    	    -value => "Show Detail",
    	    -class => 'smdefbutton'
    	    );
    	print nbsp(1);
    }
    elsif ( $genome_type eq 'metagenome' ) {
    	my $name = "_section_${section}_metaHostDetail";
    	print submit(
    	    -name  => $name,
    	    -value => "Show Detail",
    	    -class => 'smdefbutton'
    	    );
    	print nbsp(1);
    }
    else {
    	my $name = "_section_${section}_bothHostDetail";
    	print submit(
    	    -name  => $name,
    	    -value => "Show Detail",
    	    -class => 'smdefbutton'
    	    );
    	print nbsp(1);
    }

    print "<input type='button' name='selectAll' value='Select All' "
	. "onClick='selectAllCheckBoxes(1)', class='smbutton' />\n";
    print nbsp(1);
    print "<input type='button' name='clearAll' value='Clear All' "
	. "onClick='selectAllCheckBoxes(0)' class='smbutton' />\n";

    printStatusLine( "$cnt2 Loaded", 2 );
}

###############################################################
# printViralHostBySpacerList
###############################################################
sub printViralHostBySpacerList {
    my $genome_type = 'metagenome';   # for mvc only
    WebUtil::printMainForm();

##    print "<h1>Metagenomic Viral Contigs with Host by Spacer Hit</h1>\n";
    my $info = "Virus-host direct association (at species level) of metagenomic viral contigs that bear a proto-spacer sequence -according to CRISPR spacer matches from a microbial isolate genome. mVCs grouped with their associated hosts at different taxonomic levels (from phylum to species) can be selected for further analyses. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
    print qq{
        <h1>Metagenomic Viral Contigs with Host by Spacer Hit
               <a href="" onClick="alert('$info'); return false;">
               <span id="ecosystems" title="$info">
               <image src="$base_url/images/question.png"></span></a>
            };

    my $method_url =
	"$main_cgi?section=Viral"
	. "&page=printHostMethod";
    print nbsp(1);
    print WebUtil::buttonUrlNewWindow($method_url, 
				      "Method",
				      "tinybutton");
    print "</h1>\n";

    print hiddenVar('use_spacer', 1);

    my $viral_host = param('viral_host');
    my @host_arr = ();
    if ( $viral_host ) {
	@host_arr = split(/\|/, $viral_host);
    }
    my $host_arr_cnt = scalar(@host_arr);
    if ( $host_arr_cnt > 0 ) {
	print "<h3>Viral Host: " . join(';', @host_arr) . "</h3>\n";
    }

    my @host_fields = ('Host_Domain', 'Host_Phylum', 'Host_Class',
		       'Host_Order', 'Host_Family', 'Host_Genus',
		       'Host_Species');
    my $host_field = 'Host_Phylum';
    my $host_cond = "";
    my $i = 0;
    while ( $i < $host_arr_cnt && $i < 6 ) {
	$host_cond .= " and v." . $host_fields[$i] . " = ? ";
	$i++;
    }
    if ( $i >= 2 && $i <= 6 ) {
	$host_field = $host_fields[$i];
    }

    ##print "<p>*** $i, $host_field\n";
    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all counts
    $rclause = "";
    $imgClause = "";

    my $dbh = dbLogin();

    my $sql = qq{
            select v.host_domain, v.$host_field,
                   count(distinct scaffold_id)               
            from $host_assignment_table_name v
            where v.host_domain is not null
            $host_cond
            and v.taxon_oid in
                (select t.taxon_oid from taxon t
                  where t.obsolete_flag = 'No'
                  and t.genome_type = 'metagenome'
                  $rclause
                  $imgClause )
            group by v.host_domain, v.$host_field
            };

    ##print "<p>SQL: $sql\n";
    ##print "<p>" . join(';', @host_arr) . "\n";

    my $cur = execSql( $dbh, $sql, $verbose, @host_arr );
    my %viral_cnt;
    for (;;) {
	my ($dom, $p_fld, $cnt) = $cur->fetchrow();
	last if ! $dom;

	$dom = strTrim($dom);
	$dom =~ s/\t//;
	$p_fld = strTrim($p_fld);
	$p_fld =~ s/\t//;
	if ( ! $p_fld ) {
	    $p_fld = '-';
	}

	my $cid = "$dom|$p_fld";
	if ( $viral_cnt{$cid} ) {
	    $viral_cnt{$cid} += $cnt;
	}
	else {
	    $viral_cnt{$cid} = $cnt;
	}
    }
    $cur->finish();

    printStatusLine( "Loading ...", 1 );

    my $it = new InnerTable( 0, "scafSet$$", "scafSet", 0 );
    $it->addColSpec("Select");
    $it->addColSpec( "Host Domain", "char asc", "left" );
    my $disp_field = $host_field;
    $disp_field =~ s/\_/ /;
    $it->addColSpec( "$disp_field", "char asc", "left" );
    $it->addColSpec( "Viral Contig Count", "number asc", "right" );
    my $sd = $it->getSdDelim();

    my $cnt2 = 0;
    for my $key (keys %viral_cnt) {
	my ($dom, $p_fld) = split(/\|/, $key);
	my $new_host = $key;
	if ( $viral_host ) {
	    $new_host = $viral_host . "|" . $p_fld;
	}
	my $r = $sd 
	    . "<input type='checkbox' name='viral_host' value='$new_host'/>"
	    . "\t";
	$r .= $dom . $sd . $dom . "\t";
	my $url = $section_cgi . "&page=viralHostBySpacerList" .
	    "&viral_host=$new_host";
	if ( lc($host_field) eq 'host_species' ) {
	    $url = $section_cgi . "&page=viralHostDetail" .
		"&genome_type=$genome_type" .
		"&viral_host=$new_host";
	}

	$r .= $p_fld . $sd . alink( $url, $p_fld ) . "\t";

##	    $r .= $key . $sd . alink( $url, $key ) . "\t";
#	    $r .= $key . $sd . $key . "\t";

	my $scf_cnt = $viral_cnt{$key};

	if ( $scf_cnt ) {
	    $r .= $scf_cnt . $sd . alink( $url, $scf_cnt ) . "\t";
	}
	else {
	    $r .= "0" . $sd . "0\t";
	}

	$it->addRow($r);

        $cnt2++;
    }
    $cur->finish();

    $it->printOuterTable(1);

    printHint("Please limit the number of selections to avoid browser timeout.");

    print "<p><input type='checkbox' name='show_detect_method' value='1'/>" .
	"Show Detect Method? (Note: Showing detect method will slow down detail display.)\n";

    print "<p>\n";

    my $name = "_section_${section}_mvcHostDetail";

    print submit(
	-name  => $name,
	-value => "Show Detail",
	-class => 'smdefbutton'
	);
    print nbsp(1);

    print "<input type='button' name='selectAll' value='Select All' "
	. "onClick='selectAllCheckBoxes(1)', class='smbutton' />\n";
    print nbsp(1);
    print "<input type='button' name='clearAll' value='Clear All' "
	. "onClick='selectAllCheckBoxes(0)' class='smbutton' />\n";

    printStatusLine( "$cnt2 Loaded", 2 );
}

###############################################################
# printViralHostDetail
###############################################################
sub printViralHostDetail {
    my ($input_genome_type) = @_;
    WebUtil::printMainForm();

    my @all_hosts = param('viral_host');
    if ( scalar(@all_hosts) == 0 ) {
	WebUtil::webError("No hosts have been selected.");
	return;
    }

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all
    $rclause = "";
    $imgClause = "";

    my $dbh = dbLogin();
    my $genome_type = param('genome_type');
    if ( ! $genome_type && $input_genome_type ) {
	$genome_type = $input_genome_type;
    }
    if ( $genome_type eq 'isolate' ) {
	print "<h1>Isolate Viruses with Host</h1>\n";
    }
    elsif ( $genome_type eq 'metagenome' ) {
	print "<h1>Metagenome Viral Contigs with Host (Spacer Hit)</h1>\n";
    }
    else {
	print "<h1>All Viral Datasets with Host</h1>\n";
    }

    if ( scalar(@all_hosts) == 1 ) {
	my $host = $all_hosts[0];
	my ($host_domain, $host_phylum, $host_class, $host_order,
	    $host_family, $host_genus, $host_species) = split(/\|/, $host);
	if ( $host_species ) {
	    if ( $host_species eq 'unclassified' ) {
		print "<h2>Host: $host_domain; $host_phylum; $host_class; $host_order; $host_family; $host_genus; $host_species </h2>\n";
	    }
	    else {
		print "<h2>Host: $host_species</h2>\n";
	    }
	}
	else {
	    print "<h2>Host: $host </h2>\n";
	}
    }
    else {
	print "<h2>" . scalar(@all_hosts) . " hosts selected</h2>\n";
    }

    ## loop through all selected hosts
    printStatusLine( "Loading ...", 1 );

    printStartWorkingDiv();
    my %iso_vpfs_h;
    my %iso_cluster_id_h;
    if ( ! $genome_type || $genome_type eq 'isolate' ) {
	my $sql = qq{
                select v.taxon_oid, v.perc_vpfs, v.viral_clusters
                from $viral_table_name v
                where v.taxon_oid in
                    (select t.taxon_oid from taxon t
                     where genome_type = 'isolate')
                };
	my $cur = execSql( $dbh, $sql, $verbose );
	for ( ; ; ) {
	    my ($taxon_oid, $perc_vpfs, $cluster_id) =
		$cur->fetchrow();
	    last if !$taxon_oid;

	    $iso_vpfs_h{$taxon_oid} = $perc_vpfs;
	    $iso_cluster_id_h{$taxon_oid} = $cluster_id;
	}
	$cur->finish();
    }

    my @viral = ();
    my %added_h;
    for my $host ( @all_hosts ) {
	my ($host_domain, $host_phylum, $host_class, $host_order,
	    $host_family, $host_genus, $host_species) = split(/\|/, $host);

	print "<p>Processing host $host ...\n";

	## make sure there are no blanks
	if ( ! $host_domain ) {
	    $host_domain = 'unclassified';
	}
	if ( ! $host_phylum ) {
	    $host_phylum = 'unclassified';
	}
	if ( ! $host_class ) {
	    $host_class = 'unclassified';
	}
	if ( ! $host_order ) {
	    $host_order = 'unclassified';
	}
	if ( ! $host_family ) {
	    $host_family = 'unclassified';
	}
	if ( ! $host_genus ) {
	    $host_genus = 'unclassified';
	}
	if ( ! $host_species ) {
	    $host_species = $host;
	}

	if ( ! $genome_type || $genome_type eq 'isolate' ) {
	    my $sql = qq{
                select s.scaffold_oid, s.taxon, 'No', t.taxon_display_name,
                   st.seq_length,
                   st.gc_percent, st.count_total_gene,
                   0, '-', g.host_name
                from scaffold s, scaffold_stats st, taxon t,
                     gold_sequencing_project g
                where s.taxon = t.taxon_oid
                and s.scaffold_oid = st.scaffold_oid
                $rclause
                $imgClause
                and t.sequencing_gold_id = g.gold_id
                and g.host_name = ?
                };

	    my $cur = execSql( $dbh, $sql, $verbose, $host );

	    for ( ; ; ) {
		my ($scaffold_oid, @rest) =
		    $cur->fetchrow();
		last if !$scaffold_oid;

		my $str = $scaffold_oid . "\t" . join("\t", @rest);
		push @viral, ( $str );
	    }
	    $cur->finish();

	    if ( ! $genome_type && $host_species &&
		 $host_species ne 'unclassified' ) {
		my $sql = qq{
                    select v.scaffold_id, v.taxon_oid, t.in_file,
                       t.taxon_display_name, 
                       0, 0, 0,
                       v.perc_vpfs, v.viral_clusters,
                       v.host, v.host_detection,
                       v.pogs_order, v.pogs_family,
                       v.pogs_subfamily, v.pogs_genus,
                       v.putative_retrovirus
                    from $viral_table_name v, taxon t
                    where (v.taxon_oid, v.scaffold_id) in
                       (select h.taxon_oid, h.scaffold_id
                        from $host_assignment_table_name h
                        where h.host_species = ? )
                    and v.taxon_oid = t.taxon_oid
                    $rclause
                    $imgClause
                };

		my $cur = execSql( $dbh, $sql, $verbose, $host_species );

		for ( ; ; ) {
		    my ($scaffold_oid, $taxon_oid, @rest) =
			$cur->fetchrow();
		    last if !$scaffold_oid;

		    my $k2 = "$taxon_oid $scaffold_oid";
		    if ( $added_h{$k2} ) {
			next;
		    }
		    $added_h{$k2} = 1;
		    my $str = $scaffold_oid . "\t" . $taxon_oid .
			"\t" . join("\t", @rest);
		    push @viral, ( $str );
		}
		$cur->finish();
	    }
	}

	if ( $genome_type eq 'metagenome' ) {
	    my $sql = qq{
                select distinct v.scaffold_id, v.taxon_oid, t.in_file,
                   t.taxon_display_name, 
                   0, 0, 0,
                   v.perc_vpfs, v.viral_clusters,
                   v.host, v.host_detection,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus,
                   v.putative_retrovirus
                from $viral_table_name v, taxon t
                where (v.taxon_oid, v.scaffold_id) in
                   (select h.taxon_oid, h.scaffold_id
                    from $host_assignment_table_name h
                    where h.host_domain = ?
                    and h.host_phylum = ?
                    and h.host_class = ?
                    and h.host_order = ?
                    and h.host_family = ?
                    and h.host_genus = ?
                    and h.host_species = ?)
                and v.taxon_oid = t.taxon_oid
                $rclause
                $imgClause
                };

	    my $cur = execSql( $dbh, $sql, $verbose, $host_domain, 
			   $host_phylum, $host_class, $host_order,
	                   $host_family, $host_genus, $host_species);

	    for ( ; ; ) {
		my ($scaffold_oid, $taxon_oid, @rest) =
		    $cur->fetchrow();
		last if !$scaffold_oid;

		my $k2 = "$taxon_oid $scaffold_oid";
		if ( $added_h{$k2} ) {
		    next;
		}
		$added_h{$k2} = 1;

		my $str = $scaffold_oid . "\t" . $taxon_oid .
		    "\t" . join("\t", @rest);
		push @viral, ( $str );
	    }
	    $cur->finish();
	}
    }   # end for host

    my %my_access_h;
    my $contact_oid = WebUtil::getContactOid();
    my $sql = qq{
      select taxon_oid
      from taxon
      where is_public = 'Yes'
      and obsolete_flag = 'No'
         union
      select taxon_permissions
      from contact_taxon_permissions
      where contact_oid = ?
    };
    my $cur = execSql( $dbh, $sql, $verbose, $contact_oid );
    for ( ; ; ) {
	my ($tid) = $cur->fetchrow();
	last if ! $tid;
	$my_access_h{$tid} = 1;
    }
    $cur->finish();

    my $tblname = "scaffoldSet$$";
    my $it = new InnerTable( 1, $tblname, $tblname, 1 );
    $it->hideExportButtons();

    $it->addColSpec( "Select" );
    $it->addColSpec( "Scaffold ID", "char asc", "left" );
    $it->addColSpec( "Genome", "char asc", "left" );
    $it->addColSpec( "Gene Count", "asc", "right" );
    $it->addColSpec( "Sequence Length<br/>(bp)", "asc", "right" );
    $it->addColSpec( "GC Content", "asc", "right" ); 

    $it->addColSpec( "Perc VPFs", "asc", "right" );
    $it->addColSpec( "Viral Cluster", "char asc", "left" );
    $it->addColSpec( "Viral Host", "char asc", "left" );
    $it->addColSpec( "Host Detection", "char asc", "left" );
    $it->addColSpec( "POGs Order", "char asc", "left" );
    $it->addColSpec( "POGs Family", "char asc", "left" );
    $it->addColSpec( "POGs Subfamily", "char asc", "left" );
    $it->addColSpec( "POGs Genus", "char asc", "left" );
    $it->addColSpec( "Putative Retrovirus", "char asc", "left" );

    my $sd = $it->getSdDelim();

    my @taxon_list = ();
    my $cnt2       = 0;
    my $no_permission = 0;
    for my $str ( @viral ) {
	my ($scaffold_oid, $taxon_oid, $in_file, $taxon_name,
	    $seq_length, $gc, $n_genes, 
	    $perc_vpfs, $cluster_id, $host,
	    $host_detection, @rest) = 
		split(/\t/, $str);

	my $r;
	if ( ! $my_access_h{$taxon_oid} ) {
	    $no_permission++;
	    $r .= "" . $sd . "" . "\t";
	    $r .= $scaffold_oid . $sd . $scaffold_oid . "\t";
	    $r .= $taxon_name . $sd . $taxon_name . "\t";
	    $it->addRow($r);
	    next;
	}

	if ( $in_file eq 'Yes' ) {
	    ## metagenome
	    my $workspace_id = "$taxon_oid assembled $scaffold_oid";
	    $r = $sd 
		. "<input type='checkbox' name='scaffold_oid' value='$workspace_id'/>"
		. "\t";

	    my $url = "$main_cgi?section=MetaDetail&page=metaScaffoldDetail" .
		"&taxon_oid=$taxon_oid&scaffold_oid=$scaffold_oid" .
		"&data_type=assembled";
	    $r .= $scaffold_oid . $sd . alink( $url, $scaffold_oid ) . "\t";

	    my $url2 = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
		"&taxon_oid=$taxon_oid";
	    $r .= $taxon_name . $sd . alink( $url2, $taxon_name ) . "\t";

	    ($seq_length, $gc, $n_genes) = 
		MetaUtil::getScaffoldStats($taxon_oid, 'assembled', $scaffold_oid);

	    my $url3 = 
		"$main_cgi?section=MetaDetail"
		. "&page=metaScaffoldGenes&scaffold_oid=$scaffold_oid"
		. "&taxon_oid=$taxon_oid";
	    $r .= $n_genes . $sd . alink($url3, $n_genes, '_blank') . "\t";

	    my $url4 =
		"$main_cgi?section=MetaScaffoldGraph" .
		"&page=metaScaffoldGraph&scaffold_oid=$scaffold_oid" .
		"&taxon_oid=$taxon_oid" . 
		"&start_coord=1&end_coord=$seq_length" .
		"&seq_length=$seq_length";
	    $r .= $seq_length . $sd . alink($url4, $seq_length, '_blank') . "\t";
	    $r .= $gc . $sd . $gc . "\t";
	}
	else {
	    $r = $sd 
		. "<input type='checkbox' name='scaffold_oid' value='$scaffold_oid'/>"
		. "\t";

	    my $url = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
	    $r .= $scaffold_oid . $sd . alink( $url, $scaffold_oid ) . "\t";

	    my $url2 = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
		"&taxon_oid=$taxon_oid";
	    $r .= $taxon_name . $sd . alink( $url2, $taxon_name ) . "\t";

	    my $url3 = "$main_cgi?section=ScaffoldCart"
		. "&page=scaffoldGenes"
		. "&scaffold_oid=$scaffold_oid";
	    $r .= $n_genes . $sd . alink($url3, $n_genes, '_blank') . "\t";

	    my $url4 = "$main_cgi?section=ScaffoldGraph" .
                    "&page=scaffoldGraph&scaffold_oid=$scaffold_oid" .
                    "&taxon_oid=$taxon_oid" . 
                    "&start_coord=1&end_coord=$seq_length" .
                    "&seq_length=$seq_length";
	    $r .= $seq_length . $sd . alink($url4, $seq_length, '_blank') . "\t";
	    $r .= $gc . $sd . $gc . "\t";
	}

##	if ( $iso_vpfs_h{$taxon_oid} ) {
##	    $perc_vpfs = $iso_vpfs_h{$taxon_oid};
##	}
	$r .= $perc_vpfs . $sd . $perc_vpfs . "\t";

	if ( $iso_cluster_id_h{$taxon_oid} ) {
	    $cluster_id = $iso_cluster_id_h{$taxon_oid};
	}
        my $url4 = $section_cgi . "&page=viralClusterDetail" .
            "&viral_cluster_id=$cluster_id";
	if ( $cluster_id ) {
	    $r .= $cluster_id . $sd . alink($url4, $cluster_id) . "\t";
	}
	else {
	    $r .= "-" . $sd . "-" . "\t";
	}
	$r .= $host . $sd . $host . "\t";
	my $method_detail = getDetectMethod($taxon_oid, $scaffold_oid);
	$r .= '' . $sd . $method_detail . "\t";
	#ANNA here
	for my $v2 ( @rest ) {
	    if ( ! $v2 ) {
		$v2 = "-";
	    }
	    $r .= $v2 . $sd . $v2 . "\t";
	}

	$it->addRow($r);

        $cnt2++;
    }

    printEndWorkingDiv();

    if ( $no_permission ) {
	print "<p><font color='red'><u>Note</u>: This list contains some private contig(s)</font></p>\n";
    }

    if ( $cnt2 > 10 && $cnt2 > $no_permission ) {
	WebUtil::printScaffoldCartFooterInLineWithToggle($tblname); 
    } 
 
    $it->printOuterTable(1);

    if ( $cnt2 > $no_permission ) {
	WebUtil::printScaffoldCartFooterInLineWithToggle($tblname); 
	WorkspaceUtil::printSaveScaffoldToWorkspace("scaffold_oid");
    }

    print end_form();
    printStatusLine( "$cnt2 Loaded", 2 );
}


###############################################################
# printViralMvcHostList
###############################################################
sub printViralMvcHostList {
    my $genome_type = "metagenome";
    WebUtil::printMainForm();

##    print "<h1>Metagenomic Viral Contigs (mVCs): total</h1>\n";
    my $info = "Total number of metagenomic viral contigs assigned to a host (at the lowest possible taxonomic level) by projecting the host-virus information of an mVC onto a viral cluster (i.e. sequences that do not have direct association with a host are assigned to the one(s) of a member(s) of the same viral cluster) can be selected for further analyses. In the majority of the cases the virus-host link is at genus or species level. Tables can be filtered by using the filter column tab and exported in a tab-delimited text format (compatible with metagenomics analysis tools as well as R and Microsoft Excel).";
    print qq{
           <h1>Metagenomic Viral Contigs (mVCs): total
           <a href="" onClick="alert('$info'); return false;">
           <span id="ecosystems" title="$info">
           <image src="$base_url/images/question.png"></span></a></h1>
        };

    printHint("Please limit the number of selections to avoid browser timeout.");

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all counts
    $rclause = "";
    $imgClause = "";

    my $dbh = dbLogin();
    my %viral_cnt;
    my $sql;
    my $cur;

    $sql = qq{
            select v.host, count(distinct scaffold_id)               
            from $viral_table_name v
            where v.host is not null
            and v.taxon_oid in
                (select t.taxon_oid from taxon t
                  where t.obsolete_flag = 'No'
                  and t.genome_type = 'metagenome'
                  $rclause
                  $imgClause )
            group by v.host
            };

    $cur = execSql( $dbh, $sql, $verbose );
    for (;;) {
	my ($cid, $cnt) = $cur->fetchrow();
	last if ! $cid;

	if ( $viral_cnt{$cid} ) {
	    $viral_cnt{$cid} += $cnt;
	}
	else {
	    $viral_cnt{$cid} = $cnt;
	}
    }
    $cur->finish();

    printStatusLine( "Loading ...", 1 );

    my $it = new InnerTable( 0, "scafSet$$", "scafSet", 0 );
    $it->addColSpec("Select");
    $it->addColSpec( "Viral Host", "char asc", "left" );
    $it->addColSpec( "Viral Contig Count", "number asc", "right" );
    my $sd = $it->getSdDelim();

    my $cnt2 = 0;
    for my $key (keys %viral_cnt) {
	my $r = $sd 
	    . "<input type='checkbox' name='viral_host' value='$key'/>"
	    . "\t";
	$r .= $key . $sd . $key. "\t";
	my $viral_host = $key;

	my $scf_cnt = $viral_cnt{$key};

	if ( $scf_cnt ) {
	    if ( $viral_host eq "-" ) {
		$r .= $scf_cnt . $sd . $scf_cnt . "\t";
	    }
	    else {
		my $url2 = $section_cgi . "&page=mvcHostDetail" .
		    "&genome_type=$genome_type" .
		    "&viral_host=$key";
		$r .= $scf_cnt . $sd . alink($url2, $scf_cnt, '_blank') . "\t";
	    }
	}
	else {
	    $r .= "0" . $sd . "0\t";
	}

	$it->addRow($r);

        $cnt2++;
    }
    $cur->finish();

    $it->printOuterTable(1);

    printHint("Please limit the number of selections to avoid browser timeout.");

    print "<p><input type='checkbox' name='show_detect_method' value='1'/>" .
	"Show Detect Method? (Note: Showing detect method will slow down detail display.)\n";

    print "<p>\n";

    my $name = "_section_${section}_mvcHostDetail";

    print submit(
	-name  => $name,
	-value => "Show Detail",
	-class => 'smdefbutton'
	);
    print nbsp(1);

    print "<input type='button' name='selectAll' value='Select All' "
	. "onClick='selectAllCheckBoxes(1)', class='smbutton' />\n";
    print nbsp(1);
    print "<input type='button' name='clearAll' value='Clear All' "
	. "onClick='selectAllCheckBoxes(0)' class='smbutton' />\n";

    printStatusLine( "$cnt2 Loaded", 2 );
}


###############################################################
# printViralMvcHostDetail
###############################################################
sub printViralMvcHostDetail {
    WebUtil::printMainForm();

    my @all_hosts = param('viral_host');
    if ( scalar(@all_hosts) == 0 ) {
	WebUtil::webError("No hosts have been selected.");
	return;
    }

    my $use_spacer = param('use_spacer');

    my $rclause   = WebUtil::urClause('t.taxon_oid');
    my $imgClause = WebUtil::imgClauseNoTaxon('t.taxon_oid');

    ## show all
    $rclause = "";
    $imgClause = "";

    my $dbh = dbLogin();

    ## for mvc only
    my $genome_type = 'metagenome';
    print "<h1>Metagenome Viral Contigs with Host</h1>\n";
    my $host = '';
    if ( scalar(@all_hosts) == 1 ) {
	$host = $all_hosts[0];
	my $host_display = $host;
	if ( $use_spacer ) {
	    $host_display =~ s/\|/\;/g;
	}
	print "<h2>Host: $host_display </h2>\n";
    }
    else {
	print "<h2>" . scalar(@all_hosts) . " hosts selected</h2>\n";
    }

    ## loop through all selected hosts
    printStatusLine( "Loading ...", 1 );

    printStartWorkingDiv();

    my %added_h;
    my @viral = ();
    my $sql = "";
    my $cur;
    for my $host ( @all_hosts ) {
	print "<p>Processing $host ...\n";

	if ( $use_spacer ) {
	    ## use spacer
	    my @host_fields = ('Host_Domain', 'Host_Phylum', 'Host_Class',
			       'Host_Order', 'Host_Family', 'Host_Genus',
			       'Host_Species');
	    my $host_field = 'Host_Phylum';
	    my $host_cond = "";
	    my @host_arr = split(/\|/, $host);

	    my $host_arr_cnt = scalar(@host_arr);
	    my $i = 0;
	    while ( $i < $host_arr_cnt && $i < 6 ) {
		$host_cond .= " and h." . $host_fields[$i] . " = ? ";
		$i++;
	    }
	    if ( $i >= 2 && $i <= 6 ) {
		$host_field = $host_fields[$i];
	    }

	    $sql = qq{
                select distinct v.scaffold_id, v.taxon_oid, t.in_file,
                   t.taxon_display_name, 
                   0, 0, 0,
                   v.perc_vpfs, v.viral_clusters,
                   v.host, v.host_detection,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus,
                   v.putative_retrovirus
                from $host_assignment_table_name h,
                     $viral_table_name v, taxon t
                where t.genome_type = 'metagenome'
                and t.obsolete_flag = 'No'
                and v.taxon_oid = t.taxon_oid
                and v.taxon_oid = h.taxon_oid
                and v.scaffold_id = h.scaffold_id
                and h.host_domain is not null
                $host_cond
                $rclause
                $imgClause
                };

	    $cur = execSql( $dbh, $sql, $verbose, @host_arr );
	}
	else {
	    ## use host name
	    $sql = qq{
                select distinct v.scaffold_id, v.taxon_oid, t.in_file,
                   t.taxon_display_name, 
                   0, 0, 0,
                   v.perc_vpfs, v.viral_clusters,
                   v.host, v.host_detection,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus,
                   v.putative_retrovirus
                from $viral_table_name v, taxon t
                where t.genome_type = 'metagenome'
                and t.obsolete_flag = 'No'
                and v.taxon_oid = t.taxon_oid
                and v.host = ?
                $rclause
                $imgClause
                };

	    $cur = execSql( $dbh, $sql, $verbose, $host );
	}

	for ( ;; ) {
	    my ($scaffold_oid, $taxon_oid, @rest) =
		$cur->fetchrow();
	    last if !$scaffold_oid;

	    my $k2 = "$taxon_oid $scaffold_oid";
	    if ( $added_h{$k2} ) {
		next;
	    }
	    $added_h{$k2} = 1;

	    my $str = $scaffold_oid . "\t" . $taxon_oid .
		"\t" . join("\t", @rest);
	    push @viral, ( $str );
	}
	$cur->finish();
    }   # end for host

    my %my_access_h;
    my $contact_oid = WebUtil::getContactOid();
    my $sql = qq{
      select taxon_oid
      from taxon
      where is_public = 'Yes'
      and obsolete_flag = 'No'
         union
      select taxon_permissions
      from contact_taxon_permissions
      where contact_oid = ?
    };
    my $cur = execSql( $dbh, $sql, $verbose, $contact_oid );
    for ( ; ; ) {
	my ($tid) = $cur->fetchrow();
	last if ! $tid;
	$my_access_h{$tid} = 1;
    }
    $cur->finish();

    my $show_detect_method = param('show_detect_method');

    my $tblname = "scaffoldSet$$";
    my $it = new InnerTable( 1, $tblname, $tblname, 1 );
    $it->hideExportButtons();

    $it->addColSpec( "Select" );
    $it->addColSpec( "Scaffold ID", "char asc", "left" );
    $it->addColSpec( "Genome", "char asc", "left" );
    $it->addColSpec( "Gene Count", "asc", "right" );
    $it->addColSpec( "Sequence Length<br/>(bp)", "asc", "right" );
    $it->addColSpec( "GC Content", "asc", "right" ); 

    $it->addColSpec( "Perc VPFs", "asc", "right" );
    $it->addColSpec( "Viral Cluster", "char asc", "left" );
    $it->addColSpec( "Viral Host", "char asc", "left" );
    if ( $show_detect_method ) {
	$it->addColSpec( "Host Detection", "char asc", "left" );
	$it->addColSpec( "POGs Order", "char asc", "left" );
	$it->addColSpec( "POGs Family", "char asc", "left" );
	$it->addColSpec( "POGs Subfamily", "char asc", "left" );
	$it->addColSpec( "POGs Genus", "char asc", "left" );
	$it->addColSpec( "Putative Retrovirus", "char asc", "left" );
    }

    my $sd = $it->getSdDelim();

    my @taxon_list = ();
    my $cnt2       = 0;
    my $no_permission = 0;
    for my $str ( @viral ) {
	my ($scaffold_oid, $taxon_oid, $in_file, $taxon_name,
	    $seq_length, $gc, $n_genes, 
	    $perc_vpfs, $cluster_id, $host,
	    $host_detection, @rest) = 
		split(/\t/, $str);

	my $r;
	if ( ! $my_access_h{$taxon_oid} ) {
	    $no_permission++;
	    $r .= "" . $sd . "" . "\t";
	    $r .= $scaffold_oid . $sd . $scaffold_oid . "\t";
	    $r .= $taxon_name . $sd . $taxon_name . "\t";
	    $it->addRow($r);
	    next;
	}

	my $workspace_id = "$taxon_oid assembled $scaffold_oid";
	$r = $sd 
	    . "<input type='checkbox' name='scaffold_oid' value='$workspace_id'/>"
	    . "\t";

	my $url = "$main_cgi?section=MetaDetail&page=metaScaffoldDetail" .
	    "&taxon_oid=$taxon_oid&scaffold_oid=$scaffold_oid" .
	    "&data_type=assembled";
	$r .= $scaffold_oid . $sd . alink( $url, $scaffold_oid ) . "\t";

	my $url2 = "$main_cgi?section=TaxonDetail&page=taxonDetail" .
	    "&taxon_oid=$taxon_oid";
	$r .= $taxon_name . $sd . alink( $url2, $taxon_name ) . "\t";

	($seq_length, $gc, $n_genes) = 
	    MetaUtil::getScaffoldStats($taxon_oid, 'assembled', $scaffold_oid);

	my $url3 = 
	    "$main_cgi?section=MetaDetail"
	    . "&page=metaScaffoldGenes&scaffold_oid=$scaffold_oid"
	    . "&taxon_oid=$taxon_oid";
	$r .= $n_genes . $sd . alink($url3, $n_genes, '_blank') . "\t";

	my $url4 =
	    "$main_cgi?section=MetaScaffoldGraph" .
	    "&page=metaScaffoldGraph&scaffold_oid=$scaffold_oid" .
	    "&taxon_oid=$taxon_oid" . 
	    "&start_coord=1&end_coord=$seq_length" .
	    "&seq_length=$seq_length";
	$r .= $seq_length . $sd . alink($url4, $seq_length, '_blank') . "\t";
	$r .= $gc . $sd . $gc . "\t";

	$r .= $perc_vpfs . $sd . $perc_vpfs . "\t";

	my $url4 = $section_cgi . "&page=viralClusterDetail" .
	    "&viral_cluster_id=$cluster_id";
	if ( $cluster_id ) {
	    $r .= $cluster_id . $sd . alink($url4, $cluster_id) . "\t";
	}
	else {
	    $r .= "-" . $sd . "-" . "\t";
	}
	$r .= $host . $sd . $host . "\t";

	if ( $show_detect_method ) {
	    my $method_detail = getDetectMethod($taxon_oid, $scaffold_oid);
	    $r .= '' . $sd . $method_detail . "\t";

	    for my $v2 ( @rest ) {
		$r .= $v2 . $sd . $v2 . "\t";
	    }
	}

	$it->addRow($r);

	$cnt2++;
    }

    printEndWorkingDiv();

    if ( $no_permission ) {
	print "<p><font color='red'><u>Note</u>: This list contains some private contig(s)</font></p>\n";
    }

    if ( $cnt2 > 10 && $cnt2 > $no_permission ) {
	WebUtil::printScaffoldCartFooterInLineWithToggle($tblname); 
    } 
 
    $it->printOuterTable(1);

    if ( $cnt2 > $no_permission ) {
	WebUtil::printScaffoldCartFooterInLineWithToggle($tblname);  
	WorkspaceUtil::printSaveScaffoldToWorkspace("scaffold_oid");
    }

    printStatusLine( "$cnt2 Loaded", 2 );
    print end_form();
}

####################################################################
# printViralBlastForm
####################################################################
sub printViralBlastForm {
    WebUtil::printMainForm();

##    print "<h1>BLAST Against Viral Sequence or Spacer Database</h1>\n";
    my $info = "BLAST comparison tool against the sequence data integrated into IMG/VR. Users can select any of the Viral/Spacer Blast options from the Blast Database tab. BLAST searches are nucleotide-based with customizable e-value cutoffs. Recommended e-value cutoff for spacer matches is 1e-05.";
    print qq{
           <h1>BLAST Against Viral Sequence or Spacer Database
           <a href="" onClick="alert('$info'); return false;">
           <span id="ecosystems" title="$info">
           <image src="$base_url/images/question.png"></span></a></h1>
        };

    print qq{
        <table class='img' border='0'>
        <tr class='img'>
        <th class="subhead">Sequence:</th>
        <td>
        <textarea name='fasta' rows='10' cols='70'></textarea>
        </td>
        </tr>
        <tr class='img'>
        <th class="subhead">Program:</th>
        <td>blastn (DNA vs. DNA)</td>
        </tr>
        <tr class='img'>
        <tr class='img'>
        <th class="subhead">Blast Database:</th>
        <td >
        <select name="use_db">
        <option value="viruses">Viral Sequence Database</option>
	<option value="viral_spacers">Viral Spacer Database</option>
	<option value="meta_spacers">Metagenome Spacer Database</option>";
        </select>
        </td></tr>
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
        </table>
        };

    print hiddenVar('page', 'viralBlastResults');
    print hiddenVar('blast_program', 'blastn');
##    print hiddenVar('use_db', 'viruses');
    print "<p>\n";
    my $name = "_section_${section}_viralBlastResults";
    print submit(
	-name    => $name,
	-value   => "Run Blast",
	-class   => "meddefbutton"
	);

    print end_form();
}


####################################################################
# printViralMethodForm
####################################################################
sub printViralMethodForm {
    WebUtil::printMainForm();

    print qq{
<h2>Metagenomic Viral Contigs Identification Method</h2>
<ol style='width: 760px;'>
<li>
<b>Generation of viral protein families.</b> Protein coding genes were collected from iVGs (dsDNA viruses and retroviruses combined) from the NCBI server (http://www.ncbi.nlm.nih.gov/genomes/GenomesGroup.cgi?taxid=10239#). After dereplication using 70\% identity in usearch, protein sequences were obtained and then clustered into groups using the Markov Cluster (MCL) algorithm. Proteins within clusters were aligned using MAFFT and a set of viral protein families was created using hmmbuild. After manual curation of the viral families with high representation in prokaryotic genomes, viral protein families were compared against all of the metagenomic contigs longer than 5 kb. contigs with 5 or more viral protein families were collected, and these were reduced to putative viral contigs after removing contigs below 50kb. An additional filtering step was performed to exclude contigs with a high number of Kegg Orthology (KO) terms and Pfams (10\% and 25\% respectively); this further reduced the number of putative viral contigs to. These were complemented with sequences derived from diverse metagenomic contigs longer than 20kb that were binned with viruses or contained a viral RNA polymerase gene, respectively, and were not captured using the previous filter of bearing 5 or more viral protein families. Repeating the steps described above (i.e. usearch 70\% for de-replication, MCL clustering, MAFFT alignment and hmmbuild with a filter for viral families abundant in prokaryotes) the final list of 25k viral protein families was obtained and used for further exploration.</li>
 
<li> <b>Identification of metagenomic viral contigs for a training set via manual curation, binning and DNA-dependent RNA polymerase alignment.</b> In order to expand the training set of viral sequences, metagenome contigs identified as high-confidence viral sequences in the first iteration of our pipeline were complemented with additional metagenome contigs and scaffolds, not captured using viral protein families generated from isolate viruses. The first approach used kmer-based binning of 6 metagenome samples that contained the highest number of candidate viral sequences, which were not satisfy high-confidence threshold due to insufficient number of hits to protein models. These datasets were binned by Emergent Self Organizing Maps (ESOM; by Ultsch) as described previously and contig sets outside the bins corresponding to cellular organisms were manually checked. K-mer based binning identified 66 putative novel mVCs from diverse habitat types (freshwater, wastewater, thermal vents, and marine with IMG sample identifiers 3300000553, 3300001592, 3300001681, 3300000116, and 3300001450, respectively).
The second approach relied on identification of contigs containing RNA polymerase with domain composition reminiscent of RNA polymerase (RNAp) found in cellular life forms, which could not be placed into one of three domains on the tree of life based on their sequence similarity. First, 2,551 representative sequences of the genes encoding the three major subunits (&alpha;, &beta;, &beta;') of the RNAp gene from bacteria, as well as their eukaryotic and archaeal counterparts, were collected from IMG database. Next, the domains of these genes were extracted using Pfam models and aligned with MAFFT. Alignments were manually inspected and HMM models were built using hmmbuild. These models were used to scan metagenomic sequences longer than 5 kb and identified contigs with matches at least one core RNAp subunit. After filtering short matches and a dereplication step, we obtained metagenomic sequences that were combined with reference isolates to build a tree with RNAp sequences using FastTree with default parameters. The tree was visualized using Dendroscope and RNAp branch corresponding to large eukaryotic DNA viruses was identified based on reference sequences from isolate genomes. In addition to eukaryotic viruses, another set of metagenomic RNAp sequences branching separately from cellular references, turned out to comprise phage RNAp with domain composition similar to bacterial enzyme. Contigs longer than 20 kb containing viral and phage RNAp sequences were added to the training set.</li>
 
<li> <b>Assignment of metagenomic sequences to viruses.</b> The 25 k viral protein families were used to identify all DNA metagenomic viral contigs (mVCs) longer than 5 kb using 3 distinct filters. First, mVCs were identified from metagenomic contigs that had at least 5 hits to viral protein families, the total number of genes covered with KO terms on the contig was <=20\%; the total number of genes covered with Pfams <=40\%; and the number of genes covered with viral protein families >=10\%. Second, metagenomic sequences were selected as mVCs when the number of viral protein families on the contig were equal or higher than the number of Pfams. Finally, metagenomic contigs for which the number of viral protein families was equal or higher than 60% of the total of the genes were also assigned to mVCs. Benchmarking and modelling of this DNA viral discovery computational approach are detailed below demonstrating a specificity of 99.6\% for viral detection with a 37.5\% recall rate (sensitivity to identify all viral sequences).</li>
</ol>
    };

    print end_form();
}


####################################################################
# printClusterMethodForm
####################################################################
sub printClusterMethodForm {
    WebUtil::printMainForm();

    print qq{
<h2>Viral Cluster Identification Method</h2>
<p style='width: 760px;'>
<b>Viral genome clustering and designation of viral clusters.</b> A sequence-based classification framework was developed for systematically linking closely related viral genomes based on their overall nucleotide similarity. The framework relies on both nucleotide identity and total alignment fraction for pairwise comparisons of viral sequences and enables natural grouping of related iVGs and mVCs. mVCs were combined with iVGs for the generation of the viral cluster classification framework. We used BLASTn program in the Blast+ package to find hits of the total viral sequences to themselves with an e-value cutoff of 1e-50, at least 90% identity across &ge; 75\% of the shortest sequence length, and at least one hit over 1 kb in length. This filtering of BLAST results excluded matches against short highly conserved fragments of viral sequences, such as tRNAs, and other spurious hits. 
    };

    print end_form();
}


####################################################################
# printSingletonMethodForm
####################################################################
sub printSingletonMethodForm {
    WebUtil::printMainForm();

    print qq{
<h2>Viral Singleton Identification Method</h2>
<p style='width: 760px;'>
Viral sequences that belong to single member clusters or singletons (represented with a 'sg_' prefix and a numeric identifier) are shown according with the clustering method defined in Viral Clusters.
    };

    print end_form();
}

####################################################################
# printHostMethodForm
####################################################################
sub printHostMethodForm {
    WebUtil::printMainForm();

    print qq{
<h2>Viral Host Assignment Method</h2>
<p style='width: 760px;'>
<b>Viral host assignment using the CRISPR-Cas system.</b> A microbial CRISPR-Cas spacer database (using referenced genomes) was created using a modified version of the CRISPR Recognition Tool (CRT) detailed in Huntemann, et al. 2015 against iVGs and mVCs. 
First, all identified spacers were queried for exact sequence matches against all iVGs using the BLASTn-short function from the BLAST+ package with parameters: e-value threshold of 1.0e-10, percent identity of 95\%, and using 1 as a maximum target sequence. 98.5\% of the detected spacer hits were to a putative bacterial or archaeal host whose taxonomic assignment was in agreement at the species or genus level with the existing viral taxonomy (Supplementary Table 18). From the remaining matches, 1.2\% of the hits agreed at the family level and only 0.3\% of the spacers (2 cases where Pseudomonas spacers matched a Rhodothermus phage, and Methylomicrobium spacers that matched Pseudomonas and Burkholderia phage) were above family, validating our approach of host assignment based on CRISPR-Cas spacer matches. Second, all spacers were compared against the mVCs, requiring at least 95\% identity over the whole spacer length, and allowing only 1-2 SNPs at the 5' end of the sequence to assign host taxonomy.
    };

    print end_form();
}


####################################################################
# printViralScafInfo
####################################################################
sub printViralScafInfo {
    my ($dbh, $taxon_oid, $scaffold_oid) = @_;

    my $sql = "select genome_type from taxon where taxon_oid = ?";
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my ($taxon_type) = $cur->fetchrow();
    $cur->finish();
    my ($id2, $v_host, $habitat_type,
	$perc_vpfs, $viral_clusters, $pogs_order,
	$pogs_family, $pogs_subfamily, $pogs_genus,
	$putative_retrovirus);

    if ( $taxon_type eq 'isolate' ) {
	$sql = qq{
            select v.taxon_oid, v.host, v.habitat,
                   v.perc_vpfs, v.viral_clusters,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus,
                   v.putative_retrovirus
            from $viral_table_name v
            where v.taxon_oid = ?
            };
	$cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
	($id2, $v_host, $habitat_type,
	 $perc_vpfs, $viral_clusters, $pogs_order,
	 $pogs_family, $pogs_subfamily, $pogs_genus,
	 $putative_retrovirus) = $cur->fetchrow();
	$cur->finish();
    }
    else {
	$sql = qq{
            select v.scaffold_id, v.host, v.habitat,
                   v.perc_vpfs, v.viral_clusters,
                   v.pogs_order, v.pogs_family,
                   v.pogs_subfamily, v.pogs_genus,
                   v.putative_retrovirus
            from $viral_table_name v
            where v.taxon_oid = ?
            and v.scaffold_id = ?
            };
	$cur = execSql( $dbh, $sql, $verbose, $taxon_oid, $scaffold_oid );
	($id2, $v_host, $habitat_type,
	 $perc_vpfs, $viral_clusters, $pogs_order,
	 $pogs_family, $pogs_subfamily, $pogs_genus, 
	 $putative_retrovirus) = $cur->fetchrow();
	$cur->finish();
    }

    if ( ! $id2 ) {
	# not viral scaffold
	#print "<p>This is not a viral contig.\n";
	return;
    }

    if ( $habitat_type ) {
	printAttrRowRaw( "Habitat Type", $habitat_type );
    }
    if ( $v_host ){ 
	printAttrRowRaw( "Viral Host", $v_host );
    }

    if ( $perc_vpfs ) {
	printAttrRowRaw( "Perc VPFs", $perc_vpfs );
    }
    if ( $viral_clusters ) {
        my $url = $section_cgi . "&page=viralClusterDetail" .
            "&viral_cluster_id=$viral_clusters";
	printAttrRowRaw( "Viral Cluster", alink($url, $viral_clusters) );
    }
    if ( $pogs_order ) {
	printAttrRowRaw( "POGs Order", $pogs_order );
    }
    if ( $pogs_family ) {
	printAttrRowRaw( "POGs Family", $pogs_family );
    }
    if ( $pogs_subfamily ) {
	printAttrRowRaw( "POGs Subfamily", $pogs_subfamily );
    }
    if ( $pogs_genus ) {
	printAttrRowRaw( "POGs Genus", $pogs_genus );
    }

    if ( $putative_retrovirus ) {
	printAttrRowRaw( "Putative Retrovirus", $putative_retrovirus );
    }

    my $method = getDetectMethod($taxon_oid, $scaffold_oid);
    if ( $method ) {
	printAttrRowRaw( "Host Detection", $method );
    }
}


####################################################################
# getSpacerID (obsolete)
####################################################################
sub getSpacerID {
    my ($tid, $sid, $l, $s) = @_;

    my $dbh = dbLogin();
    my $new_id = $tid . '_____' . $sid . '_____' . '%' . $l . '_____Spacer_' . $s;
    $new_id = strTrim($new_id);
    my $sql = "select spacer_id from $spacer_table_name where spacer_id like ?";
    my $cur = execSql( $dbh, $sql, $verbose, $new_id );
    my ($spacer_id) = $cur->fetchrow();
    $cur->finish();

    return $spacer_id;
}

####################################################################
# getNewSpacerID
####################################################################
sub getNewSpacerID {
    my ($tid, $sid, $l, $seq) = @_;

    my $dbh = dbLogin();
    my $sql = "select pos from $crispr_table_name where taxon_oid = ? and contig_id = ? and crispr_no = ? and spacer_seq = ?";
    my $cur = execSql( $dbh, $sql, $verbose, $tid, $sid, $l, $seq );
    my ($pos) = $cur->fetchrow();
    $cur->finish();

    my $new_id = $tid . ':' . $sid . ':' . $l . ':' . $pos;
    return $new_id;
}


####################################################################
# getViralScafCount
####################################################################
sub getViralScafCount {
    my ($taxon_oid) = @_;

    if ( ! $taxon_oid ) {
	return 0;
    }

    my $dbh = dbLogin();
    my $sql = "select count(distinct scaffold_id) from $viral_table_name where taxon_oid = ?";
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    my ($cnt) = $cur->fetchrow();
    $cur->finish();

    return $cnt;
}

####################################################################
# getAllTaxonViralScafCount
####################################################################
sub getAllTaxonViralScafCount {
    my ($h) = @_;

    my $dbh = dbLogin();
    my $cnt = 0;
    my $sql = qq{
          select taxon_oid, count(distinct scaffold_id)
          from $viral_table_name 
          group by taxon_oid
          };
    my $cur = execSql( $dbh, $sql, $verbose );
    for (;;) {
	my ($taxon_oid, $s_cnt) = $cur->fetchrow();
	last if ! $taxon_oid;

	$h->{$taxon_oid} = $s_cnt;
	$cnt++;
    }
    $cur->finish();

    return $cnt;
}


####################################################################
# getViralScafInfo
#
# scaffold_oid -> perc_vpfs, viral_clusters, pogs fields
#                 (tab delimited)
####################################################################
sub getViralScafInfo {
    my ($taxon_oid, $scaf_h) = @_;

    if ( ! $taxon_oid ) {
	return 0;
    }

    my $dbh = dbLogin();
    my $cnt = 0;
    my $sql = qq{
          select scaffold_id, perc_vpfs, viral_clusters,
                 pogs_order, pogs_family,
                 pogs_subfamily, pogs_genus,
                 putative_retrovirus
          from $viral_table_name 
          where taxon_oid = ?
          };
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );
    for (;;) {
	my ($scaffold_id, @rest) = $cur->fetchrow();
	last if ! $scaffold_id;

	my $workspace_id = "$taxon_oid assembled $scaffold_id";
	$scaf_h->{$workspace_id} = join("\t", @rest);
	$cnt++;
    }
    $cur->finish();

    return $cnt;
}


#################################################################
# showDataSetSelectionSection
#################################################################
sub obsolete_showDataSetSelectionSection {
    my ( $graph_type, $class, $new_url ) = @_;

    my $e = getDatamartEnv();

    my $list          = $e->{members};
    my $member_labels = $e->{member_labels};

    print "<div class='mapSelection'>\n";

    $new_url = $section_cgi;
    print "<p>\n";
    print nbsp(2);
    print "<b>Graph:</b> \n";
    print nbsp(2);
    print qq{
      <select name='openselect'
          onchange="window.location='$new_url&page=' + this.value;"
          style="width:200px;">
    };

##    my @graphs = ('googlemap', 'depthecotypemap', 'depthclademap', 'cladegraph');
    my @graphs = ( 'datatypegraph', 'googlemap', 'depthgraph', 'cladegraph' );
    my %graph_name_h;
    $graph_name_h{'datatypegraph'}   = 'Data Type';
    $graph_name_h{'googlemap'}       = 'Location';
    $graph_name_h{'depthecotypemap'} = 'Depth & Ecotype';
    $graph_name_h{'depthclademap'}   = 'Depth & Clade';
    $graph_name_h{'depthgraph'}      = 'Depth';
    $graph_name_h{'cladegraph'}      = 'Clade';
    for my $x (@graphs) {
        print "    <option value='$x' ";
        if ( $x eq $graph_type ) {
            print " selected ";
        }

        print ">" . $graph_name_h{$x} . "</option>\n";
    }
    print "</select>\n";

    if (   $graph_type eq 'datatypegraph'
        || $graph_type eq 'depthgraph'
        || $graph_type eq 'cladegraph' )
    {
        print "</div>\n";
        return "";
    }

    print nbsp(5);
    print "<b>Genomes:</b> \n";
    print nbsp(2);
    print qq{                                                                  
      <select name='openselect'                                                
          onchange="window.location='$new_url&page=$graph_type&class=' + this.value;"        
          style="width:200px;">                                                
    };

    print "    <option value='all' ";
    if ( $class eq 'all' ) {
        print " selected ";
    }
    print ">All IMG Datasets</option>\n";
    print "    <option value='datamart' ";
    if ( !$class || $class eq 'datamart' ) {
        print " selected ";
    }
    print ">" . $e->{main_label} . "</option>\n";
    for my $x (@$list) {
        print "    <option value='$x' ";
        if ( $x eq $class ) {
            print " selected ";
        }

        print ">" . $member_labels->{$x} . "</option>\n";
    }
    print "</select>\n";

    print "</div>\n";

    return $class;
}


1;
