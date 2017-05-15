############################################################################
# Help.pm - site map for all documents in IMG
#
# $Id: Help.pm 37064 2017-05-08 21:14:00Z imachen $
############################################################################
package Help;
use strict;
use CGI qw( :standard );
use DBI;
use Data::Dumper;
use JSON;
use WebConfig;
use WebUtil;

$| = 1;

my $section                 = "Help";
my $env                     = getEnv();
my $cgi_dir                 = $env->{cgi_dir};
my $cgi_url                 = $env->{cgi_url};
my $cgi_tmp_dir             = $env->{cgi_tmp_dir};
my $main_cgi                = $env->{main_cgi};
my $base_url                = $env->{base_url};
my $base_dir                = $env->{base_dir};
my $tmp_url                 = $env->{tmp_url};
my $tmp_dir                 = $env->{tmp_dir};
my $verbose                 = $env->{verbose};
my $no_phyloProfiler        = $env->{no_phyloProfiler};
my $full_phylo_profiler     = $env->{full_phylo_profiler};
my $phyloProfiler_sets_file = $env->{phyloProfiler_sets_file};
my $scaffold_cart           = $env->{scaffold_cart};
my $img_pheno_rule          = $env->{img_pheno_rule};
my $img_pheno_rule          = $env->{img_pheno_rule};
my $include_metagenomes     = $env->{include_metagenomes};
my $include_tigrfams        = $env->{include_tigrfams};
my $include_img_terms       = $env->{include_img_terms};
my $img_edu                 = $env->{img_edu};
my $img_er                  = $env->{img_er};
my $img_lite                = $env->{img_lite};
my $img_internal            = $env->{img_internal};
my $user_restricted_site    = $env->{user_restricted_site};
my $public_nologin_site     = $env->{public_nologin_site};
my $show_myimg_login        = $env->{show_myimg_login};
my $enable_interpro         = $env->{enable_interpro};

sub getPageTitle {
    return 'Help';
}

sub getAppHeaderData {
    my ($self) = @_;
    my @a = ('about');
    return @a;
}


############################################################################
# dispatch - Dispatch loop.
############################################################################
sub dispatch {
    my ( $self, $numTaxon ) = @_;
    my $page = param('page');

    if ( $page eq "sitemap" ) {
        #printSiteMap();
        printSiteMap2();
        
    } elsif ( $page eq "ftppolicy" ) {
        printFtpPolicy();
    } elsif ( $page eq "ftpreadme" ) {
        printFtpReadMe();
    } elsif ( $page eq "policypage" ) {
        printFtpPolicyPage();
    } elsif ( $page eq 'cite' ) {
        printCite();

    } elsif ( $page eq 'docs' ) {
        printDocs();

    } elsif ( $page eq 'news' ) {
        printNews();

    } elsif($page eq 'about_index') {
        my $text = WebUtil::file2Str("$base_dir/about_index.html");
        print $text;
    } elsif($page eq 'using_index') {
        my $text = WebUtil::file2Str("$base_dir/using_index.html");
        print $text;        

    } elsif($page eq 'education') {
        my $text = WebUtil::file2Str("$base_dir/education.html");
        print $text;        

    } elsif($page eq 'imgterms') {
        my $text = WebUtil::file2Str("$base_dir/imgterms.html");
        print $text;        

    } elsif($page eq 'analysis') {
        my $text = WebUtil::file2Str("$base_dir/analysis.html");
        print $text;        

    } else {
        printSiteMap();
    }
}

sub printNews {
    print qq{
<h1>News Releases</h1>
<div id='newsReleases'>
    };


    # read news  file
    my $file = '/webfs/scratch/img/news.html';
    if ( -e $file ) {
        my $line;
        my $rfh = newReadFileHandle($file);
        my $count = 1;
        while ( $line = $rfh->getline() ) {
            if($line =~ /^<b id='subject'>/) {
                
                $line =~ s/<br>//;
                $line =~ s/<\/br>//;
                
                print "<h2>" . $line . "<a name='$count' href='#'><font size='1'>top</font></a></h2> ";
                
                $count++;
                
#            } elsif ($line =~ /^<p>/) {
#                $line =~ s/^<p>/<p style='font-size: 14px;'>/;
#                print $line;
            } else {
                print $line;
            }
        }
        close $rfh;
    }
    
    print "</div>\n";
}


sub printDocs {
    print qq{
<h1>IMG Document Archive</h1>
         <p>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#userguide">User Guide</a><br/>         
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#new">What's New in IMG</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#archive">Archive of past What's New</a><br/>
        </p>
        
    };

    print qq{
    <a name='userguide' href='#'><h2> User Guide </h2></a>
        <p>
        <a href="$base_url/../docs/userGuide.pdf" onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'user guide']);">
            <img src="$base_url/images/icon_pdf_medium.png" border="0" />
        </a>
        </p>
    };

    # SingleCellDataDecontamination.pdf

    printWhatsNew();
    printWhatsNewArchive();
}

sub printCite {
#    my $file = "$base_dir/cite.html";
#    my $s    = file2Str($file);
#    print "$s\n";
}

sub printFtpReadMe {
    printFtpDepreciated();

#    my $file = "$base_dir/ftp-readme.html";
#    my $s    = file2Str($file);
#    print "$s\n";
}

# the page without ok button to ftp site
sub printFtpPolicyPage {
    my $file = "$base_dir/ftp-policy.html";
    my $s    = file2Str($file);
    print "$s\n";
}

sub printFtpDepreciated {
    print qq{
<h3>IMG FTP Depreciated</h3>
<p>
<b>The IMG FTP site is being replaced with the <a href="http://genome.jgi.doe.gov/">JGI Genome Portal</a></b>
See <a href="https://groups.google.com/a/lbl.gov/forum/?hl=en#!searchin/img-user-forum/ftp/img-user-forum/Ivbo4ivK4j0/ufoMkiLTtzgJ"> our forum</a>
</p>
    };

}


# ok button before going to ftp sites
sub printFtpPolicy {
    printFtpDepreciated();

    printFtpPolicyPage();

    print qq{
<br/>
<div>
<input type="button" value="OK" onclick="javascript:window.open('ftp://ftp.jgi-psf.org/pub/IMG/','_self');" />
</div>        
    };
}


sub printSiteMap2 {
    
    # menu file json data
    my $menuFile = "menu.json";
    
    # read file
    my $content = WebUtil::file2Str("$base_dir/$menuFile");
    
    my $aref = decode_json($content);
    
    print qq{
      <table class='img'>
      <tr class='img'>
      <th class='img'>Name</th>
      <th class='img'>Description</th>
      <th class='img'>Not available<br>in Data Mart</th>
      </tr>  
    };
    
    printMenuRow($aref);
    
    print "</table>\n";
    
    
     printComponentPages();
}

sub printMenuRow {
    my($aref) = @_;
    return if ($aref eq '');

    my $subarrowRight = "<img class='subarrow' src='../../images/ArrowNav.gif'/>";
    my $subarrowLeft = "<img class='subarrow_left' src='../../images/ArrowNav_left.gif'/>";

    foreach my $menutop_href (@$aref) {
        
        print "<tr class='img'>";
        
        my $name = $menutop_href->{'name'};
        my $level = $menutop_href->{'level'};
        my $title = $menutop_href->{'title'};
        my $url = $menutop_href->{'url'};
        my $icon = $menutop_href->{'icon'};
        my $arrow = $menutop_href->{'arrow'};
        my $not_avaiable_href = $menutop_href->{'not avaiable'};
        my $submenu_aref = $menutop_href->{'submenu'};
        my $onClick = $menutop_href->{'onClick'};

        if($onClick) {
            $onClick = "onClick=\"$onClick\"";
        }

        if($icon) {
            $icon = "<img class='menuimg' src='../../images/$icon'/>";
        }

        if($url) {
            if($arrow eq 'right') {
                $name = "<a href='$url' $onClick>$icon $name $subarrowRight</a>";                
            } elsif($arrow eq 'left') {
                #$name = "<a href='$url' $onClick>$subarrowLeft $icon $name</a>";
                $name = "<a href='$url' $onClick>$icon $name</a>";
            } else {
                $name = "<a href='$url' $onClick>$icon $name</a>";
            }
        }

        
        # indent
        my $x = 4 * ($level) + 1;
        my $nbsp = WebUtil::nbsp($x);
        
        if($level == 0) {
            print "<td class='img'>$nbsp<b>$name</b></td><td class='img'>$title</td>";
        } else {
            print "<td class='img'>$nbsp $name</td><td class='img'>$title</td>";    
        }
        
        
        print "<td class='img'>";
        my $size = keys %$not_avaiable_href;
        if($size > 0) {
            foreach my $key (sort keys %$not_avaiable_href) {
                print "$key -- ";
            }
        
        }
        print "</td>";
        if($submenu_aref ne '') {
            print "</tr>\n";
            printMenuRow($submenu_aref);
        } else {
            print "</tr>\n";        
        }
    }
    
}



sub printSiteMap {
    print qq{
	<h1>Site Map</h1>
	    
	<p>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#menu">Navigation Menus</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#anacart">Analysis Carts</a><br/>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#comp">sub-Pages and Components</a><br/>
        </p>
    };

    printNavigationMenus();
    printAnalysisCartMap();
    printComponentPages();
}

sub printWhatsNew {

    print qq{
        <a name='new' href='#'><h2>What's New in IMG</h2></a>
        <table boder='0'>
        <tr>
        <td align="left" style="padding-right: 25px;">
        
        <a href="$base_url/../docs/releaseNotes.pdf" onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'release notes']);">
            <img src="$base_url/images/icon_pdf_medium.png" border="0" />
        </a> <br/>
        &nbsp;
        </td>
    };

    if ($img_er) {

        # https://img-stage.jgi-psf.org/er/../docs/userGuideER.pdf
        print qq{
            <td align="left" style="padding-right: 25px;">
        
        <a href="$base_url/../docs/userGuideER.pdf" onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'user guide er']);">
            <img src="$base_url/images/icon_pdf_medium.png" border="0" /> 
        </a> <br/>
        IMG/ER Tutorial
            </td>
        };
    }

    # http://localhost/~ken/web25m.htd/../docs/userGuide_m.pdf
    if ($include_metagenomes) {
        print qq{
            <td align="left" style="padding-right: 25px;">
        
        <a href="$base_url/../docs/userGuide_m.pdf" onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'user guide m']);">
            <img src="$base_url/images/icon_pdf_medium.png" border="0" />  
        </a> <br/>
        IMG/M Addendum
        </td>

        };
    }

    print qq{
        </tr>
        </table>
    };
}

sub printNavigationMenus {
    my $contact_oid = getContactOid();
    my $isEditor    = 0;
    if ($user_restricted_site) {
        my $dbh = dbLogin();
        $isEditor = isImgEditor( $dbh, $contact_oid );
    }

    print qq{
	<a name='menu' href='#'><h2>Navigation Menus</h2> </a>
        <table class='img'>
	    <th class='img'> Menu </th>
	    <th class='img'> Description </th>
	    <th class='img'> Document </th>
	      <tr class='highlight' valign='top'>
	      <td class='img'> <a href="$main_cgi"> <b>IMG Home</b> </a> </td>
	      <td class='img'> IMG home page </td>
	      <td class='img'></td>
	    </tr>
    };

    printFindGenomesMap();
    printFindGenesMap();
    printFindFunctionsMap();
    printCompareGenomesMap();
    printOmicsMap();
    printWorkspaceMap();
##    printAnalysisCartMap($isEditor);
    printMyImgMap($contact_oid);

    printCompanionSystem();

    printUsingMap();

    print "</table>\n";
}

sub printFindGenomesMap {
    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="$main_cgi?section=FindGenomes&page=findGenomes">
	    <b>Find Genomes</b> </a>
	    </td>
	    <td class='img'>
            Find genomes/metagenomes of interest.
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=TaxonList&page=taxonListAlpha">
		Genome Browser </a>

	    </td>
	    <td class='img'>
            Browse all public genomes and your own private genomes <br/>
            (private genomes are in MER only) in table display or tree display. 
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/GenomeBrowser.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'genome browser']);">
	    <img width="20" height="14" border="0"
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/binocular.png">
	    <a href="$main_cgi?section=FindGenomes&page=genomeSearch"> 
	    Genome Search </a>
	    </td>
	    <td class='img'>
            Search genomes of interest in the IMG database. <br/>
            Search can be based on keywords or on metadata categories. <br/>
            Metadata is from GOLD. 
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/GenomeSearch.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'genome search']);">
	    <img width="20" height="14" border="0" 
	    style="margin-top: 10px;margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>

	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/binocular.png">
	    <a href="$main_cgi?section=ScaffoldSearch"> 
	    Scaffold Search </a>
	    </td>
	    <td class='img'>
            Search scaffolds/contigs based on scaffold IDs, names, or statistics. 
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/ScaffoldSearch.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'scaffold search']);">
	    <img width="20" height="14" border="0" 
	    style="margin-top: 10px;margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>

	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=TaxonDeleted"> 
	    Deleted Genomes </a>
	    </td>
	    <td class='img'>
            View older genomes/metagenomes that have been deleted from IMG.
	    </td>
	    <td class='img'>
	    </a>
	    </td>
	</tr>
    };

    if ($img_internal) {
        print qq{

            <tr class='img' valign="top">
                <td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=TaxonList&page=categoryBrowser">
		    Category Browser </a>
                </td>
                <td class='img'>
		View genomes organized by genome categories e.g. Oxygen Requirement, Ecosystem, etc.
		</td>
                <td class='img'></td>
            </tr>
        };
    }
}

sub printFindGenesMap {
    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="$main_cgi?section=FindGenes&page=findGenes">
	    <b>Find Genes</b> </a>
	    </td>
	    <td class='img'>
            Find genes of interest.
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/binocular.png">
	    <a href="$main_cgi?section=FindGenes&page=geneSearch">
	    Gene Search </a>

	    </td>
	    <td class='img'>
            Search genes of interest based on IDs, names, locus tags, etc. 
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/GeneSearch.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'gene search']);">
	    <img width="20" height="14" border="0"
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>
    };

    print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=GeneCassetteSearch&page=form">
		    Cassette Search </a>
		</td>
		<td class='img'>
                 Search gene cassette.
	        </td>
  	    <td class='img'>
	    <a href='$base_url/../docs/CassetteSearch.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'cassette search']);">
	    <img width="20" height="14" border="0"
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	    </tr>
	};

    print qq{
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/blast.ico">
	    <a href="$main_cgi?section=FindGenesBlast&page=geneSearchBlast">
	    BLAST </a>
	    </td>
	    <td class='img'>
	    Find sequence similarity in IMG database using LAST.<br/>
            (This option is only available in IMG/MER). 
	    </td>
            <td class='img'>
	    <a href='$base_url/../docs/Blast.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'blast']);">
	    <img width="20" height="14" border="0" 
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
            </td>
	</tr>
    };

    print qq{
		<tr class='img' valign='top'>
		    <td class='img'> 
		    &nbsp; &nbsp; &nbsp; &nbsp;
		    <a href="$main_cgi?section=GeneCassetteProfiler&page=genetools">
			<b>Phylogenetic Profilers</b></a>
		    </td>
		    <td class='img'>
		    &nbsp;
		    </td>
    	            <td class='img' rowspan='3'>
                       <a href='$base_url/../docs/PhylogeneticProfilers.pdf' target='_help'>
                       <img width="20" height="14" border="0" 
		       style="margin-left: 20px; vertical-align:middle" 
		       src="$base_url/images/help_book.gif"> 
                    </a>
                    </td>
		</tr>
		    
		<tr class='img' valign='top'>
		    <td class='img'> 
		    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
		    <a href="$main_cgi?section=PhylogenProfiler&page=phyloProfileForm"> Single Genes </a>
		    </td>
		    <td class='img'>
                    Search genes in a selected genome with and/or without <br/>
                    homologs in other genomes. 
		    </td>
		</tr>
		    
		<tr class='img' valign='top'>
		    <td class='img'> 
		    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
		    <a href="$main_cgi?section=GeneCassetteProfiler&page=geneContextPhyloProfiler2"> Genes Cassettes </a>
		    </td>
		    <td class='img'>
                    Find genes in a query genome, that are collocated in the <br/>
                    query genome as well as across other genomes of interest, <br/>
                    based on their inclusion in cassettes. <br/>
                    <b>Limitation:</b> Currently you can only select up to 
                    <b>50 Collocated In</b> Genomes.
		    </td>
		</tr>
            };

    if ($img_internal) {
        print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=ProteinCluster">
		    Protein Clusters </a>
		</td>
		<td class='img'>
		&nbsp;
	        </td>
		<td class='img'></td>
	    </tr>
        };
    }
}

sub printFindFunctionsMap {
    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="$main_cgi?section=FindFunctions&page=findFunctions">
	    <b>Find Functions</b> </a>
	    </td>
	    <td class='img'>
            Find functions of interest.
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/binocular.png">
	    <a href="$main_cgi?section=FindFunctions&page=findFunctions">
		Function Search </a>
	    </td>
	    <td class='img'>
	    Find functions in selected genomes based on keyword.
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/FunctionSearch.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'function search']);">
	    <img width="20" height="14" border="0"  
	    style="margin-left: 20px; vertical-align:middle" 
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>
	
    };

     print qq{
       <tr class='img' valign='top'>
           <td class='img'>
               &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/binocular.png">
                  <a href="$main_cgi?section=AllPwayBrowser&page=allPwayBrowser"> Search Pathways </a>
           </td>
           <td class='img'>
           Search IMG, KEGG, MetaCyc and/or MPW pathways based on enzyme EC or keyword.
           </td>
           <td class='img'></td>
       </tr>
    };

     print qq{
       <tr class='img' valign='top'>
           <td class='img'>
               &nbsp; &nbsp; &nbsp; &nbsp;
             <a href="https://img.jgi.doe.gov/abc/">Secondary Metabolism</a>
           </td>
           <td class='img'>
           Re-direct to IMG/ABC for biosynthetic gene cluster and secondary metabolite search. 
           </td>
           <td class='img'></td>
       </tr>
    };

    # <img width="25" height="14" border="0" style="margin-left: 5px;" src="$base_url/images/new.gif">

    print qq{
    <tr class='img' valign='top'>
	<td class='img'> 
	&nbsp; &nbsp; &nbsp; &nbsp;
        <img class="menuimg" src="$base_url/images/cog.png">
        <a href="$main_cgi?section=FindFunctions&page=ffoAllCogCategories"> COG </a>
	</td>
	<td class='img'>
        Browse and find COG functions
	</td>
	<td class='img'></td>
    </tr>

            <tr class='img' valign='top'>
                <td class='img' nowrap='nowrap'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=ffoAllCogCategories"> COG Browser </a>
                </td>
                <td class='img'>
                Browse all COG functions in IMG. 
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=cogList"> COG List </a>
                </td>
                <td class='img'>
                Browse all COG functions in a table display.
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=cogList&stats=1"> COG List w/ Stats </a>
                </td>
                <td class='img'>
                Browse COG function list with associated isolate genome and metagenome counts<br/>
                in IMG.
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=cogid2cat"> COG Id to Categories </a>
                </td>
                <td class='img'>
                Browse COG functions and associated COG categories. 
                </td>
                <td class='img'></td>
            </tr>

    <tr class='img' valign='top'>
        <td class='img'> 
        &nbsp; &nbsp; &nbsp; &nbsp;
        <img class="menuimg" src="$base_url/images/kog.png">
        <a href="$main_cgi?section=FindFunctions&page=ffoAllKogCategories"> KOG </a>
                
        </td>
        <td class='img'> 
        Browse and find KOG functions
        </td>
        <td class='img'> </td>
    </tr>

            <tr class='img' valign='top'>
                <td class='img' nowrap='nowrap'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=ffoAllKogCategories"> KOG Browser </a>
                </td>
                <td class='img'>
                Browse all KOG functions in IMG. 
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=kogList"> KOG List </a>
                </td>
                <td class='img'>
                Browse all KOG functions in a table display.
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=kogList&stats=1"> KOG List w/ Stats </a>
                </td>
                <td class='img'>
                Browse KOG function list with associated isolate genome and metagenome counts<br/>
                in IMG.
                </td>
                <td class='img'></td>
            </tr>
	
    <tr class='img' valign='top'>
        <td class='img'>
	&nbsp; &nbsp; &nbsp; &nbsp;
        <img class="menuimg" src="$base_url/images/pfam.png">
	<a href="$main_cgi?section=FindFunctions&page=pfamCategories">
	Pfam </a>
	</td>
	<td class='img'>
        Browse and find Pfam functions
	</td>
	<td class='img'></td>
    </tr>

            <tr class='img' valign='top'>
                <td class='img' nowrap='nowrap'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=pfamCategories"> Pfam Browser </a>
                </td>
                <td class='img'>
                Browse all Pfam functions in IMG. 
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=pfamList"> Pfam List </a>
                </td>
                <td class='img'>
                Browse all Pfam functions in a table display.
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=pfamList&stats=1"> Pfam List w/ Stats </a>
                </td>
                <td class='img'>
                Browse Pfam function list with associated isolate genome and metagenome counts<br/>
                in IMG.
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=pfamListClans"> Pfam Clans </a>
                </td>
                <td class='img'>
                Browse Pfam functions organized into corresponding clans. 
                </td>
                <td class='img'></td>
            </tr>
    };

    if ($include_tigrfams) {
        print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
                <img class="menuimg" src="$base_url/images/tigrfam.png">
	        <a href="$main_cgi?section=TigrBrowser&page=tigrBrowser">
		    TIGRfam </a>
		</td>
		<td class='img'>
		Browse and find TIGRfam roles and list.
		</td>
		<td class='img'></td>
	    </tr>

            <tr class='img' valign='top'>
                <td class='img' nowrap='nowrap'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=TigrBrowser&page=tigrBrowser"> TIGRfam Roles </a>
                </td>
                <td class='img'>
                Browse all TIGRfam functions in IMG. 
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=TigrBrowser&page=tigrfamList"> TIGRfam List </a>
                </td>
                <td class='img'>
                Browse all TIGRfam functions in a table display.
                </td>
                <td class='img'></td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=TigrBrowser&page=tigrfamList&stats=1"> TIGRfam List w/ Stats </a>
                </td>
                <td class='img'>
                Browse TIGRfam function list with associated isolate genome and metagenome<br/>
                counts in IMG.
                </td>
                <td class='img'></td>
            </tr>
        };
    }

  #    print qq{
  #
  #    <tr class='img' valign='top'>
  #        <td class='img'>
  #        &nbsp; &nbsp; &nbsp; &nbsp;
  #        <a href="$main_cgi?section=FindFunctions&page=ffoAllSeed">
  #        SEED </a>
  #        </td>
  #        <td class='img'>
  #        List of SEED product names and subsystems.
  #        </td>
  #            <td class='img'>
  #        <a href='$base_url/../docs/SEED.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'seed']);">
  #        <img width="20" height="14" border="0"
  #        style="margin-left: 20px; vertical-align:middle"
  #        src="$base_url/images/help_book.gif">
  #        </a>
  #            </td>
  #    </tr>
  #    };


#	<tr class='img' valign='top'>
#	    <td class='img' NOWRAP> 
#	    &nbsp; &nbsp; &nbsp; &nbsp;
#	    <a href="$main_cgi?section=FindFunctions&page=ffoAllTc">
#		Transporter Classification </a>
#	    </td>
#	    <td class='img'>
#	    List of Transporter Classification families
#	    </td>
#            <td class='img'>
#	    <a href='$base_url/../docs/TransporterClassification.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'transporter class']);">
#	    <img width="20" height="14" border="0" 
#	    style="margin-left: 20px; vertical-align:middle" 
#	    src="$base_url/images/help_book.gif"> 
#	    </a>
#            </td>
#	</tr>
    print qq{	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
            <img class="menuimg" src="$base_url/images/kegg.png">
	    <a href="$main_cgi?section=FindFunctions&page=ffoAllKeggPathways&view=brite"> KEGG </a>
	    </td>
	    <td class='img'>
            Browse and find KO terms, KEGG pathways or modules. 
	    </td>
	    <td class='img' rowspan='7'>
                <a href='$base_url/../docs/KEGG.pdf' target='_help'>
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
	</tr>

            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=KeggPathwayDetail&page=koList"> KO List </a>
                </td>
                <td class='img'>
                Browse all KO terms in a table display.
                </td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=KeggPathwayDetail&page=koList&stats=1"> KO List w/ Stats </a>
                </td>
                <td class='img'>
                Browse KO term list with associated isolate genome and metagenome<br/>
                counts in IMG.
                </td>
            </tr>

            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=KeggPathwayDetail&page=keggmodulelist"> KEGG Module List </a>
                </td>
                <td class='img'>
                Browse all KEGG modules in a table display.
                </td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=KeggPathwayDetail&page=keggmodulelist&stats=1"> KEGG Module List w/ Stats </a>
                </td>
                <td class='img'>
                Browse KEGG module list with associated isolate genome and metagenome<br/>
                counts in IMG.
                </td>
            </tr>

            <tr class='img' valign='top'>
                <td class='img' nowrap='nowrap'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=ffoAllKeggPathways&view=brite"> Orthology KO terms </a>
                </td>
                <td class='img'>
                Browse KEGG Orthology (KO) terms and Pathways. 
                </td>
            </tr>

            <tr class='img' valign='top'>
                <td class='img' nowrap='nowrap'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=FindFunctions&page=ffoAllKeggPathways&view=ko"> Pathway via KO terms </a>
                </td>
                <td class='img'>
                Browse KEGG pathways via KO terms. 
                </td>
            </tr>
    };

    if ($include_img_terms) {
        print qq{
        <tr class='img' valign='top'>
        <td class='img' nowrap='nowrap'> 
        &nbsp; &nbsp; &nbsp; &nbsp;
            <img class="menuimg" src="$base_url/images/favicon.ico">
        <a href="$main_cgi?section=ImgNetworkBrowser&page=imgNetworkBrowser"> <b>IMG Network</b> </a>
        </td>
        <td class='img'>
        Find IMG terms, pathways or parts list. 
        </td>
        <td class='img' rowspan='5'>
             <a href='$base_url/../docs/IMGNetwork.pdf' target='_help'>
             <img width="20" height="14" border="0" 
             style="margin-left: 20px; vertical-align:middle" 
             src="$base_url/images/help_book.gif"> 
             </a>
             </td>
        </tr>
            
            <tr class='img' valign='top'>
                <td class='img' nowrap='nowrap'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <img class="menuimg" src="$base_url/images/favicon.ico">
                    <a href="main.cgi?section=ImgNetworkBrowser&page=imgNetworkBrowser"> IMG Network Browser </a>
                </td>
                <td class='img'>
                Browse IMG networks and associated pathways. 
                </td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <img class="menuimg" src="$base_url/images/favicon.ico">
                    <a href="main.cgi?section=ImgPartsListBrowser&page=browse"> IMG Parts List </a>
                </td>
                <td class='img'>
                Browse IMG parts list. 
                </td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <img class="menuimg" src="$base_url/images/favicon.ico">
                    <a href="main.cgi?section=ImgPwayBrowser&page=imgPwayBrowser"> IMG Pathways </a>
                </td>
                <td class='img'>
                Browse IMG pathways in a table display. 
                </td>
            </tr>
                
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <img class="menuimg" src="$base_url/images/favicon.ico">
                    <a href="main.cgi?section=ImgTermBrowser&page=imgTermBrowser"> IMG Terms </a>
                </td>
                <td class='img'>
                Browse IMG terms. 
                </td>
            </tr>
        };
    }

    print qq{
    <tr class='img' valign='top'>
        <td class='img'> 
        &nbsp; &nbsp; &nbsp; &nbsp;
        <a href="$main_cgi?section=FindFunctions&page=enzymeList">
        Enzyme </a>
        </td>
        <td class='img'>
        Browse all enzymes with corresponding isolate genome and metagenome counts <br/>
        in a table display. 
        </td>
   	        <td class='img'>
                <a href='$base_url/../docs/Enzyme.pdf' target='_help'>
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
                </td>
    </tr>    
};

    print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=MetaCyc"> MetaCyc </a>
		</td>
		<td class='img'>
		Browse MetaCyc pathways in tree display.
		</td>
   	        <td class='img'>
                <a href='$base_url/../docs/MetaCyc.pdf' target='_help'>
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
                </td>
	    </tr>
        };

    if ($img_pheno_rule) {
        print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=ImgPwayBrowser&page=phenoRules">
		    Phenotypes </a>
	        </td>
		<td class='img'>
                Browse IMG predicted phenotypes in a table display. <br/>
                All genomes predicted with a selected phenotype can be viewed <br/>
                in a table or tree display. 
                </td>
		<td class='img'></td>
	    </tr>
        };
    }

    if ($enable_interpro) {
        print qq{
        <tr class='img' valign='top'>
            <td class='img'> 
                &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="$main_cgi?section=Interpro"> InterPro List </a>
            </td>
            <td class='img'>
            Browse all InterPro proteins with corresponding isolate genome <br/>
            and gene counts in a table display. 
            </td>
	    <td class='img'>
	    <a href='$base_url/../docs/InterProGuide.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'interpro']);">
	    <img width="20" height="14" border="0" 
	    style="margin-top: 10px;margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
        </tr>
       };
    }

    print qq{
        <tr class='img' valign='top'>
            <td class='img' nowrap> 
                &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="$main_cgi?section=ImgTermStats&page=functionCompare"> Protein Family Comparison </a>
            </td>
            <td class='img'>
            Check protein family comparisons.
            </td>
            <td class='img'></td>
        </tr>
    };
}

sub printCompareGenomesMap {
    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="$main_cgi?section=CompareGenomes&page=compareGenomes">
	    <b>Compare Genomes</b> </a>
	    </td>
	    <td class='img'>
	    &nbsp;
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=CompareGenomes&page=compareGenomes">
		Genome Statistics </a>
	    </td>
	    <td class='img'>
            IMG Genome Summary Statistics.
	    </td>
	    <td class='img'>
                <a href='$base_url/../docs/GenomeStatistics.pdf' target='_help'>
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=Vista&page=toppage">
		<b>Synteny Viewers</b> </a>
	    </td>
	    <td class='img'>
	    &nbsp;
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/vista.ico">
	    <a href="$main_cgi?section=Vista&page=vista"> VISTA </a>
	    </td>
	    <td class='img'>
	    VISTA is used for alignemt of full scaffolds between multiple genomes.
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=DotPlot&page=plot"> Dotplot </a>
	    <!-- <img width="45" height="14" border="0" style="margin-left: 5px;" src="$base_url/images/updated.bmp">
	    -->
	    </td>
	    <td class='img'>
	    Dot Plot employs Mummer to generate dotplot diagrams between two genomes.  
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/Dotplot.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'dot plot']);">
	    <img width="20" height="14" border="0" 
	    style="margin-left: 20px; vertical-align:middle" 
	    src="$base_url/images/help_book.gif">
	    </a>
	    </td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/sanger-ico.png">
	    <a href="$main_cgi?section=Artemis&page=ACTForm"> Artemis ACT </a>
	    </td>
	    <td class='img'>
	    ACT (Artemis Comparison Tool) is a viewer based on Artemis for 
	    pair-wise <br/> genome DNA sequence comparisons,
            whereby comparisons <br/>
	    are usually the result of running Mega BLAST search. 
	    </td>
	    <td class='img'>
                <a href='$base_url/../docs/ArtemisACT.pdf' target='_help'>
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
	</tr>
     };

    print qq{
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=AbundanceProfiles&page=topPage">
		<b>Abundance Profiles</b> </a>
	    </td>
	    <td class='img'>
	    The following tools operate on functional profiles of multiple genomes.
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=AbundanceProfiles&page=mergedForm">
		Overview (All Functions) </a>
	    </td>
	    <td class='img'>
	    View abundance for all functions across selected genomes.
	    </td>
	    <td class='img'> 
	};

    if ($include_metagenomes) {
        print
qq{<a href='$base_url/../docs/userGuide_m.pdf#page=18' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'user guide m']);">};
    } else {
        print
qq{<a href='$base_url/../docs/userGuide.pdf#page=49' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'user guide']);">};
    }

    print qq{
	    <img width="20" height="14" border="0"
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif">
	    </a> 
	    </td> 
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=AbundanceProfileSearch"> Search </a>
	    </td>
	    <td class='img'>
	    Search for functions based on over or under abundance in other genomes.
	    </td>
	    <td class='img'> 
	};

    if ($include_metagenomes) {
        print
qq{<a href='$base_url/../docs/userGuide_m.pdf#page=19' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'user guide m']);">};
    } else {
        print
qq{<a href='$base_url/../docs/userGuide.pdf#page=51' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'user guide']);">};
    }

    print qq{
	    <img width="20" height="14" border="0"
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif">
	    </a> 
	    </td> 
	</tr>
    };

    if ($include_metagenomes) {
        print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=AbundanceComparisons">
		    Function Comparisons </a>
	        </td>
		<td class='img'>
		Compare metagenomes in terms of relative abundance of COGs, Pfams, <br/> TIGRFams, and Enzymes.
		</td>
                <td class='img'>
                <a href='$base_url/../docs/userGuide_m.pdf#page=20' target='_help'>
                <img width="20" height="14" border="0"
                style="margin-left: 20px; vertical-align:middle"
                src="$base_url/images/help_book.gif"> 
                </a> 
                </td>
	    </tr>

            <tr class='img' valign='top'>
                <td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;
  	        <a href="$main_cgi?section=AbundanceComparisonsSub">
		    Function Category Comparisons </a>
                </td>
                <td class='img'>
		Compare metagenomes in terms of relative abundance of genes assigned to <br/>
                different functional categories.
		</td>
		<td class='img'> 
                <a href='$base_url/../docs/userGuide_m.pdf#page=23' target='_help'>
                <img width="20" height="14" border="0"
                style="margin-left: 20px; vertical-align:middle"
                src="$base_url/images/help_book.gif">
                </a>
		</td>
            </tr>
        };
    }

    print qq{
	    <tr class='img' valign="top">
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=MetagPhyloDist&page=top">
		    <b>Phylogenetic Distribution</b> </a>
	        </td>
		<td class='img'></td>
		<td class='img'></td>
	    </tr>
	    
	    <tr class='img' valign="top">
	        <td class='img' nowrap="nowrap"> 
		&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="main.cgi?section=MetagPhyloDist&page=form">
		    Metagenomes vs. Genomes </a>
	        </td>
		<td class='img'>Phylogenetic Distribution of Metagenomes</td>
		<td class='img'></td>
	    </tr>

            <tr class='img' valign="top">
                <td class='img' nowrap="nowrap"> 
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    <a href="main.cgi?section=GenomeHits"> Genome vs Metagenomes </a>
                </td>
                <td class='img'>Single Genome vs. Metagenomes Analysis</td>
                <td class='img'></td>
            </tr>

	<tr class='img' valign="top">
            <td class='img' nowrap='nowrap'> 
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            <a href="$main_cgi?section=RadialPhyloTree"> Radial Tree </a>
                    
	    </td>
	    <td class='img'> Radial Phylogenetic Tree </td>
	    <td class='img'> </td>
	</tr>
    };

    print qq{
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=ANI">
		<b>Avg Nucleotide Identity</b> </a>
	    </td>
	    <td class='img'>
            Average Nucleotide Identity (ANI) is a measure of nucleotide-level genomic <br/>similarity between the coding regions of two genomes.
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=ANI&page=pairwise">
		Pairwise ANI </a>
	    </td>
	    <td class='img'>
            BBHs between a genome pair are computed as pairwise bidirectional best <br/>
            SimScan hits of genes having 70% or more identity and at least 70% coverage <br/>of the shorter gene.
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/ANI.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'ani']);"> 
	    <img width="20" height="14" border="0" 
	    style="margin-left: 20px; vertical-align:middle" 
	    src="$base_url/images/help_book.gif"> 
	    </td>
        </tr>

	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=ANI&page=doSameSpeciesPlot">
		Same Species Plot </a>
	    </td>
	    <td class='img'>
            ANI Same Species Pairwise Analysis.
	    </td>
	    <td class='img'> </td>
        </tr>

	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=ANI&page=overview">
		ANI Cliques</a>
	    </td>
	    <td class='img'>
            ANI Cliques List.
	    </td>
	    <td class='img'> </td>
        </tr>
	};

    print qq{
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=DistanceTree&page=tree">
		Distance Tree </a>
        <!-- <img width="45" height="14" border="0" style="margin-left: 5px;" src="$base_url/images/updated.bmp">
        -->
	    </td>
	    <td class='img'>
	    Circular phylogenetic tree for selected genomes.
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/DistanceTree.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'distance tree']);"> 
	    <img width="20" height="14" border="0" 
	    style="margin-left: 20px; vertical-align:middle" 
	    src="$base_url/images/help_book.gif"> 
	    </td>
	</tr>
    };

    print qq{
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=FunctionProfiler&page=profiler">
		Function Profile </a>
	    </td>
	    <td class='img'>
	    Display the count (abundance) of genes associated with <br/>
	    a given function and a given genome.
	    </td>
	    <td class='img'>
                <a href='$base_url/../docs/releaseNotes2-7.pdf#page=6' target='_help'> 
                <img width="20" height="14" border="0" 
                style="margin-left: 20px; vertical-align:middle" 
                src="$base_url/images/help_book.gif">
                </a> 
	    </td>
	</tr>
	    
	<tr class='img' valign='top'>
	    <td class='img'>
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=EgtCluster&page=topPage">
		Genome Clustering </a>
	    </td>
	    <td class='img'>
	    Cluster samples (genomes) based on similar COG, Pfam, or enzyme profiles.
	    </td>
	    <td class='img'></td>
	</tr>
    };

    #    if ($img_edu) {
    #        print qq{
    #            <tr class='img' valign='top'>
    #                <td class='img'>
    #		&nbsp; &nbsp; &nbsp; &nbsp;
    #	        <a href="$main_cgi?section=CompareGeneModels&page=topPage">
    #		    Compare Gene Models </a>
    #                </td>
    #                <td class='img'></td>
    #                <td class='img'></td>
    #            </tr>
    #        };
    #    }

    print qq{
        <tr class='img' valign='top'>
            <td class='img'> 
                &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="$main_cgi?section=GenomeGeneOrtholog"> Genome Gene Best Homologs </a>
            </td>
            <td class='img'>Find best gene homologs among selected genomes.</td>
            <td class='img'></td>
        </tr>
    };

    if ($include_metagenomes) {
        print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=PhyloCogs&page=phyloCogTaxonsForm">
		    Phylogenetic Marker COGs </a>
		</td>
		<td class='img'>
		Show genome alignment against phylogenetic marker COGs.
		</td>
		<td class='img'></td>
	    </tr>
        };
    }
}

sub printOmicsMap {
    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="$main_cgi?section=ImgStatsOverview#tabview=tab3">
	    <b>OMICS</b> </a>
	    </td>
	    <td class='img'>
            Browse and analyze "omics" data in IMG.
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=IMGProteins&page=proteomics">
		Protein </a>

	    </td>
	    <td class='img'>
            Browse protein expression study data. 
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/Proteomics.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'proteomics']);">
	    <img width="20" height="14" border="0"
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=RNAStudies&page=rnastudies"> 
	    RNASeq </a>
	    </td>
	    <td class='img'>
            Browse RNASeq expression study data, including both <br/>
            transcriptome and metatranscriptome. 
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/RNAStudies.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'rna study']);">
	    <img width="20" height="14" border="0" 
	    style="margin-top: 10px;margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>

	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=Methylomics&page=methylomics"> 
	    Methylation </a>
	    </td>
	    <td class='img'>
            Browse Mythylomics experiement data.
	    </td>
	    <td class='img'>
	    <a href='$base_url/../docs/Methylomics.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'methylomics']);">
	    <img width="20" height="14" border="0" 
	    style="margin-top: 10px;margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>
     };
}

sub printWorkspaceMap {
    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="$main_cgi?section=Workspace">
	    <b>Workspace</b> </a>
	    </td>
	    <td class='img'>
            Users can store their datasets in workspace to load into analysis carts or for future analysis.
	    </td>
	    <td class='img' rowspan='6'>
	    <a href='$base_url/../docs/IMGWorkspaceUserGuide.pdf' target='_help' onClick="_gaq.push(['_trackEvent', 'Document', 'help', 'workspace']);">
	    <img width="20" height="14" border="0"
	    style="margin-left: 20px; vertical-align:middle"
	    src="$base_url/images/help_book.gif"> 
	    </a>
	    </td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=WorkspaceGenomeSet&page=home">
		Genome Sets </a>
	    </td>
	    <td class='img'>
            Workspace Genome Sets.
	    </td>
	</tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=WorkspaceScafSet&page=home">
		Scaffold Sets </a>
	    </td>
	    <td class='img'>
            Workspace Scaffold Sets.
	    </td>
	</tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=WorkspaceFuncSet&page=home">
		Function Sets </a>
	    </td>
	    <td class='img'>
            Workspace Function Sets.
	    </td>
	</tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=WorkspaceGeneSet&page=home">
		Gene Sets </a>
	    </td>
	    <td class='img'>
            Workspace Gene Sets.
	    </td>
	</tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=Workspace">
		Export Workspace </a>
	    </td>
	    <td class='img'>
            Export all workspace datasets into files.
	    </td>
	</tr>
     };
}

sub printAnalysisCartMap {
    my ($isEditor) = @_;

    my $contact_oid = getContactOid();
    if ($user_restricted_site && ! $isEditor) {
        my $dbh = dbLogin();
        $isEditor = isImgEditor( $dbh, $contact_oid );
    }

    print qq{
	<a name='anacart' href='#'><h2>Analysis Carts</h2> </a>
        <p>Analysis carts are shown at the top of the screen.<br/>
        <table class='img'>
	    <th class='img'> My Analysis Carts </th>
	    <th class='img'> Description </th>
	    <th class='img'> Document </th>
    };

    print qq{
        <tr class='img' valign='top'>
            <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=MyIMG&page=taxonUploadForm">
		Genomes </a>
            </td>
            <td class='img'>
		Genome List <br/>
		Export and Import Genome Data <br/>
            </td>
            <td class='img'></td>
        </tr>
    };

    if ($scaffold_cart) {
        print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=ScaffoldCart&page=index">
		    Scaffolds </a>
		</td>
		<td class='img'>
		Scaffold List <br/>
		Export and Import Scaffold Data <br/>
		Function Profile <br/>
		Histogram <br/>
		Kmer Analysis <br/> 
		</td>
		<td class='img'></td>
	    </tr>
        };
    }

    print qq{
	    <tr class='img' valign='top'>
	        <td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=FuncCartStor&page=funcCart">
		    Functions </a>
	        </td>
	        <td class='img'>
	            Function List  <br/>
  		    Export and Import Function Data <br/>
	            Function Profile  <br/>
	            Occurrence Profiles  <br/>
	            Function Alignment <br/>
                    Analysis
	        </td>
            <td class='img'>
                <a href='$base_url/../docs/FunctionCart.pdf' target='_help'>
                <img width="20" height="14" border="0"
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
	    </tr>

    };

    print qq{
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=GeneCartStor&page=geneCart"> Genes </a>
	    </td>
	    <td class='img'>
	        Gene List <br/>
		Add to Function Cart <br/>
                View KEGG Pathways <br/>
		Export and Import Gene Data <br/>
		Chromosome Map <br/>
		Sequence Alignments <br/>
		Gene Neighborhoods <br/>
		Gene Profile <br/>
		Occurrence Profile <br/>
		Function Alignment <br/>
	    </td>
            <td class='img'>
                <a href='$base_url/../docs/GeneCart.pdf' target='_help'>
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
	    </tr>
    };

    if ($isEditor) {
        print qq{
            <tr class='img' valign='top'>
                <td class='img'> 
                    &nbsp; &nbsp; &nbsp; &nbsp;
	            <a href="$main_cgi?section=CuraCartStor&page=curaCart">
			Curation </a>
                </td>
                <td class='img'></td>
                <td class='img'></td>
            </tr>
        };
    }

    print "</table>\n";
}

sub printMyImgMap {
    my ($contact_oid) = @_;

    my $rowspan_cnt = 2;
    if ( $show_myimg_login ) {
	$rowspan_cnt = 4;
    }

    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="$main_cgi?section=MyIMG"> <b>MyIMG</b> </a>
	    </td>
	    <td class='img'>
	    &nbsp;
	    </td>
	    <td class='img' rowspan='$rowspan_cnt'>
                <a href='$base_url/../docs/MyIMG4.pdf' target='_help'>
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
	</tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=MyIMG&page=home"> MyIMG Home </a>
	    </td>
	    <td class='img'>
            MyIMG Home page, which includes IMG Group information <br/>
            (in MER only). 
	    </td>
	</tr>
    };

##    if ( $contact_oid > 0 && $show_myimg_login && !$public_nologin_site ) {
    if ( $show_myimg_login ) {
        print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=MyIMG&page=myAnnotationsForm">
		    Annotations </a>
	        </td>
		<td class='img'>
                MyIMG gene annotations. (This is available in MER only.) 
	        </td>
	    </tr>
        };
 
       print qq{
	    <tr class='img' valign='top'>
		<td class='img'> 
		&nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="$main_cgi?section=MyIMG&page=myJobForm">
		    MyJob </a>
	        </td>
		<td class='img'>
                View user's computation on demand jobs. <br/>
                (This is available in MER only.)
	        </td>
	    </tr>
        };
    }

    print qq{
	<tr class='img' valign='top'>
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=MyIMG&page=preferences">
		Preferences </a>
	    </td>
	    <td class='img'>
            Set web browser preferences. 
	    </td>
	    <td class='img'></td>
	</tr>
    };

#    if ($user_restricted_site) {
#        print qq{
#            <tr class='img' valign='top'>
#                <td class='img'> 
#                    &nbsp; &nbsp; &nbsp; &nbsp;
#                    <a href="$main_cgi?section=Workspace"> Workspace </a>
#                </td>
#                <td class='img'>
#                    My saved data Genes, Functions, Scaffolds, Genomes
#                </td>
#                <td class='img'></td>
#            </tr>
#        };
#    }
}

sub printCompanionSystem {
    print qq{
    <tr class='highlight' valign='top'>
        <td class='img'> 
        <a href="https://img.jgi.doe.gov/"> <b>Data Marts</b> </a>
        </td>
        <td class='img'>
        There's the list of all IMG data marts or companion systems.
        </td>
        <td class='img'></td>
    </tr>
    
    <tr class='img' valign="top">
        <td class='img'> 
            &nbsp; &nbsp; &nbsp; &nbsp;
        <a href="https://img.jgi.doe.gov/m/"> <b>IMG/M</b> </a>
        </td>
        <td class='img'>
        IMG/M provides free access to public genome &
        microbiome datasets. 
        </td>
        <td class='img'> &nbsp; </td>
    </tr>    

    <tr class='img' valign="top">
        <td class='img'> 
            &nbsp; &nbsp; &nbsp; &nbsp; 
        <a href="https://img.jgi.doe.gov/mer"> IMG/M ER </a>
        </td>
        <td class='img'>
        IMG/M ER provides login access to private and public genome and microbiome <br/>datatsets, with support for data curation, dataset downloads
        and workspace <br/>analysis and data exports. 
        </td>
        <td class='img'> &nbsp; </td>
    </tr> 

    <tr class='img' valign="top">
        <td class='img'> 
            &nbsp; &nbsp; &nbsp; &nbsp;
        <a href="https://img.jgi.doe.gov/abc/"> IMG ABC </a>
        </td>
        <td class='img'>
        IMG/ABC a knowledge base to fuel the discovery of biosynthetic gene clusters<br/>
        and novel secondary metabolites in IMG .
        </td>
        <td class='img'> &nbsp; </td>
    </tr> 

    <tr class='img' valign="top">
        <td class='img'> 
            &nbsp; &nbsp; &nbsp; &nbsp;
        <a href="https://img.jgi.doe.gov/vr/"> IMG VR </a>
        </td>
        <td class='img'>
        IMG/VR serves as a starting point for the sequence analysis of viral fragments<br/>
        derived from metagenomic samples. 
        </td>
        <td class='img'> &nbsp; </td>
    </tr> 

    <tr class='img' valign="top">
        <td class='img'> 
            &nbsp; &nbsp; &nbsp; &nbsp;
        <a href="https://img-proportal-dev.jgi.doe.gov/"> IMG ProPortal BETA </a>
        </td>
        <td class='img'>
        IMG ProPortal is a beta site for Prochlorococcus genome study.
        </td>
        <td class='img'> &nbsp; </td>
    </tr> 

    <tr class='img' valign="top">
        <td class='img'> 
            &nbsp; &nbsp; &nbsp; &nbsp;
        <a href="https://img.jgi.doe.gov/imgm_hmp/"> IMG HMP </a>
        </td>
        <td class='img'>
        IMG HMP provides users with tools for analyzing HMP specific microbial<br/>
        genomes and metagenome samples in the context of all public genomes and<br/>
        metagenome samples in IMG.
        </td>
        <td class='img'> &nbsp; </td>
    </tr> 

    <tr class='img' valign="top">
        <td class='img'> 
            &nbsp; &nbsp; &nbsp; &nbsp;
        <a href="https://img.jgi.doe.gov/submit/"> Submit Data Set </a>
        </td>
        <td class='img'>
        IMG Submission Site allows users to submit their data sets to IMG for<br/>
        functional annotation and analysis.
        </td>
        <td class='img'> &nbsp; </td>
    </tr>     
    };
}

sub printUsingMap {
    print qq{
	<tr class='highlight' valign='top'>
	    <td class='img'> 
	    <a href="about_index.html"> <b>Using IMG</b> </a>
	    </td>
	    <td class='img'>
	    &nbsp;
	    </td>
	    <td class='img'></td>
	</tr>
	 
	<tr class='img' valign="top">
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <img class="menuimg" src="$base_url/images/information.png">
		<a href="about_index.html"> <b>About IMG</b> </a>
	    </td>
	    <td class='img'>
	    Information about IMG
	    </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$base_url/../docs/mission.html"> IMG Mission </a>
	    </td>
	    <td class='img'>What is the mission of IMG</td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$base_url/../docs/faq.html"> FAQ </a>
	    </td>
	    <td class='img'>Frequently Asked Questions</td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$base_url/../docs/related.html"> Related Links </a>
	    </td>
	    <td class='img'>List of other genome systems.</td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$base_url/../docs/credits.html"> Credits </a>
	    </td>
	    <td class='img'>List of teams and people who made IMG possible.</td>
	    <td class='img'></td>
	</tr>

	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$base_url/../docs"> IMG Document Archive </a>
	    </td>
	    <td class='img'>
            The archive of all existing IMG documents.
            </td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img'> 
	    &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/question.png">
	    <a href="using_index.html"> User Guide </a>
	    </td>
	    <td class='img'></td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$base_url/../docs/systemreqs.html"> System Requirements </a>
	    </td>
	    <td class='img'></td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <a href="$main_cgi?section=Help"> Site Map </a>
            <img width="45" height="14" border="0" 
	    style="margin-left: 5px;" src="$base_url/images/updated.bmp">
	    </td>
	    <td class='img'>
	    Contains links to all tools and documents, including an archive of past <br/> What's New documents
	    </td>
            <td class='img'>
                <a href='$base_url/../docs/SiteMap.pdf' target='_help'>
                <img width="20" height="14" border="0" 
                style="margin-left: 20px; vertical-align:middle"
                src="$base_url/images/help_book.gif"> 
                </a>
            </td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/icon_pdf.gif">
	    <a href="https://sites.google.com/a/lbl.gov/img-form/using-img/tutorial"> Tutorial</a>
	    </td>
	    <td class='img'>Links to MGM Workshop Videos.</td>
	    <td class='img'></td>
	</tr>
	
	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/icon_pdf.gif">
	    <a href="$base_url/../docs/uiMap.pdf"> User Interface Map</a>
	    </td>
	    <td class='img'>IMG User Interface Guide Map</td>
	    <td class='img'></td>
	</tr>

	<tr class='img' valign="top">
	    <td class='img' nowrap="nowrap"> 
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
	    <img class="menuimg" src="$base_url/images/icon_pdf.gif">
	    <a href="$base_url/../docs/SingleCellDataDecontamination.pdf"> Single Cell Data</a>
	    </td>
	    <td class='img'>Documentatation about single cells in IMG.</td>
	    <td class='img'></td>
	</tr>
    };

    print qq{
    <tr class='img' valign="top">
        <td class='img' nowrap="nowrap"> 
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            <img class="menuimg" src="$base_url/images/icon_pdf.gif">
            <a href="$base_url/../docs/userGuideER.pdf">
                IMG ER Tutorial</a>
        </td>
        <td class='img'>IMG User Guide</td>
        <td class='img'></td>
    </tr>
        };

    print qq{
    <tr class='img' valign="top">
        <td class='img' nowrap="nowrap"> 
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            <img class="menuimg" src="$base_url/images/icon_pdf.gif">
            <a href="$base_url/../docs/userGuide_m.pdf">
                IMG/M Addendum</a>
        </td>
        <td class='img'>IMG Metagenome Addendum</td>
        <td class='img'></td>
    </tr>
        };

    print qq{
    <tr class='img' valign="top">
        <td class='img' nowrap="nowrap"> 
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            <img class="menuimg" src="$base_url/images/icon_pdf.gif">
            <a href="$base_url/../docs/IMG_virus_Help.pdf">
                IMG Virus Help</a>
        </td>
        <td class='img'>IMG Virus System Documentation.</td>
        <td class='img'></td>
    </tr>
        };

    print qq{
        <tr class='img' valign='top'>
            <td class='img' nowrap> 
                &nbsp; &nbsp; &nbsp; &nbsp;
                <img src="$base_url/images/download_icon.png"/>
                <a href="$main_cgi?section=Help&page=policypage"> <b> Downloads </b> </a>
                <!--
                <img width="25" height="14" border="0" 
                style="margin-left: 5px;" src="$base_url/images/new.gif">
                -->
            </td>
            <td class='img'>
                Download public genome sequence files used in 
                <a href='http://img.jgi.doe.gov/'> IMG/W </a>
            </td>
            <td class='img'></td>
        </tr>
        <tr class='img' valign='top'>
            <td class='img' nowrap> 
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="$main_cgi?section=Help&page=policypage"> Data Usage Policy </a>
            </td>
            <td class='img'>IMG Data Usage Policy</td>
            <td class='img'></td>
        </tr>
        <tr class='img' valign='top'>
            <td class='img' nowrap> 
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="http://jgi.doe.gov/data-and-tools/data-management-policy-practices-resources/"> Data Management Policy </a>
            </td>
            <td class='img'>DOE Data Management Policy, Practices & Resources</td>
            <td class='img'></td>
        </tr>
        <tr class='img' valign='top'>
            <td class='img' nowrap> 
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="http://jgi.doe.gov/user-program-info/pmo-overview/policies/"> Collaborate with JGI </a>
            </td>
            <td class='img'>JGI Policies re. data release and publications</td>
            <td class='img'></td>
        </tr>
        <tr class='img' valign='top'>
            <td class='img' nowrap> 
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="https://groups.google.com/a/lbl.gov/d/msg/img-user-forum/o4Pjc_GV1js/EazHPcCk1hoJ"> How to Download </a>
            </td>
            <td class='img'>Information re. downloading data from IMG</td>
            <td class='img'></td>
        </tr>
        <tr class='img' valign='top'>
            <td class='img' nowrap> 
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <a href="http://genome.jgi-psf.org/"> JGI Genome Portal </a>
            </td>
            <td class='img'>Link to JGI Genome Portal</td>
            <td class='img'></td>
        </tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="https://sites.google.com/a/lbl.gov/img-form/using-img/citation"> Citation </a>
	    </td>
	    <td class='img'>
            How to cite IMG
	    </td>
	    <td class='img'></td>
        </tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="http://www.standardsingenomics.com/content/10/1/86"> Genome Annotation SOP </a>
	    </td>
	    <td class='img'>
            Article describing IMG isolate genome annotation SOP.
	    </td>
	    <td class='img'></td>
        </tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="http://standardsingenomics.biomedcentral.com/articles/10.1186/s40793-016-0138-x"> Metagenome SOP </a>
	    </td>
	    <td class='img'>
            Article describing IMG metagenome annotation SOP.
	    </td>
	    <td class='img'></td>
        </tr>
	
	<tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="education.html"> Education </a>
	    </td>
	    <td class='img'>
            IMG EDU Documentation
	    </td>
	    <td class='img'></td>
        </tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="http://mgm.jgi.doe.gov/"> MGM Workshop </a>
	    </td>
	    <td class='img'>
            Link to JGI MGM Workshop.
	    </td>
	    <td class='img'></td>
        </tr>

	<tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="https://sites.google.com/a/lbl.gov/img-form/questions"> IMG User Forum </a>
	    </td>
	    <td class='img'>
            Link to IMG User Forum.
	    </td>
	    <td class='img'></td>
        </tr>
	
        <tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
                <img class="menuimg" src="$base_url/images/mail.png">
	        <a href="$main_cgi?section=Questions"> Report Bugs / Issues </a>
            </td>
	    <td class='img'>
            Report any bugs or issues you have encountered when using IMG.
            </td>
	    <td class='img'></td>
	</tr> 

        <tr class='img' valign='top'>
	    <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp;
	        <a href="https://sites.google.com/a/lbl.gov/img-form/contact-us"> Contact Us </a>
            </td>
	    <td class='img'>
            How to contact the IMG Group.
            </td>
	    <td class='img'></td>
	</tr> 
    };

    if ($user_restricted_site) {
        print qq{
	    <tr class='img' valign='top'>
	        <td class='img'> 
	            &nbsp; &nbsp; &nbsp; &nbsp;
	            <a href="http://img.jgi.doe.gov/submit">Submit Genome</a>
	        </td>
	        <td class='img'>
	        &nbsp;
	        </td>
	        <td class='img'></td>
	    </tr>
        };
    }
}

sub printComponentPages {
    print qq{

	<a name='comp' href='#'><h2>sub-Pages and Components</h2> </a>
	<p>
	List of important sub-pages and components that are not covered by navigation menus.
	</p>
	<table class='img'>
	    <th class='img'> Page </th>
	    <th class='img'> Description </th>
	    <th class='img'> Document </th>
    };

    printGenomeDetailMap();
    printGeneDetailMap();
    printOtherTools();

    print "</table>\n";

}

sub printGenomeDetailMap {
    print qq{
        <tr class='highlight' valign='top'>
            <td class='img'> 
                 <b>Genome Detail Page</b> 
            </td>
            <td class='img'>
                &nbsp;
            </td>
            <td class='img'></td>
        </tr>
    
        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Organism Information 
            </td>
	    <td class='img'>
	    [ <a href="$main_cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=643348509">see example</a> ]
            </td>
	    <td class='img'></td>
        </tr>

	<tr class='img' valign='top'>
	    <td class='img'>
	    &nbsp; &nbsp; &nbsp; &nbsp; Genome Statistics 
	    </td>
	    <td class='img'>
	    [ <a href="$main_cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=643348509#statistics">see example</a> ]
            </td>
	    <td class='img'></td>
	</tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Phylogenetic Distribution of Genes 
            </td>
            <td class='img'>
                [ <a href="$main_cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=643348509#bin">
                see example</a> ]
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img' NOWRAP>
	    &nbsp; &nbsp; &nbsp; &nbsp; Putative Horizontally Transferred Genes 
            </td>
            <td class='img'>
                [ <a href="$main_cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=643348509#hort">
                see example</a> ] 
             </td>
            <td class='img'></td>
        </tr>
    
        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; <b>Genome Viewers</b> 
            </td>
            <td class='img'> &nbsp; </td>
            <td class='img'></td>
        </tr>
    
        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Scaffolds and Contigs 
            </td>
            <td class='img'>
                [ <a href="$main_cgi?section=TaxonDetail&page=scaffolds&taxon_oid=643348509">
                see example</a> ]
             </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Chromosome Maps 
            </td>
            <td class='img'>
                [ <a href="$main_cgi?section=TaxonCircMaps&page=circMaps&taxon_oid=643348509">
                see example</a> ] 
             </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Web Artemis 
            </td>
            <td class='img'>
                [ <a href="$main_cgi?section=Artemis&page=form&taxon_oid=643348509">
                see example</a> ] 
             </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Compare Gene Annotations 
            </td>
            <td class='img'> &nbsp; </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Download Gene Information 
            </td>
            <td class='img'> &nbsp; </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; <b>Export Genome Data</b> 
            </td>
            <td class='img'> &nbsp; </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; FASTA 
            </td>
        <td class='img' valign='top'>
            FASTA nucleic acid file for all scaffolds <br/>
            FASTA amino acid file for all proteins <br/>
            FASTA nucleic acid file for all genes <br/>
            FASTA intergenic sequences
        </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Tab Delimited 
            </td>
            <td class='img'> &nbsp; </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Genbank 
            </td>
            <td class='img'> &nbsp; </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Generate GenBank File 
            </td>
            <td class='img'> &nbsp; </td>
            <td class='img'>
                <a href='$base_url/../docs/GenerateGenBankFile.pdf' target='_help'>
                <img width="20" height="14" border="0"
		style="margin-left: 20px; vertical-align:middle"
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
        </tr>
    };
}

sub printGeneDetailMap {
    print qq{
        <tr class='highlight' valign='top'>
            <td class='img'> 
	    <b>Gene Detail Page</b> 
            </td>
            <td class='img'>
	    &nbsp;
            </td>
            <td class='img'></td>
        </tr>
    
        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Gene Information 
            </td>
            <td class='img'>
                [ <a href="$main_cgi?section=GeneDetail&page=geneDetail&gene_oid=643580707#information">
                see example</a> ]
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Add to Gene Cart 
            </td>
            <td class='img'>
	    Click on \"Add To Gene Cart\" button under Gene Information section to add this gene to the gene cart 
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Find Candidate Enzymes 
            </td>
            <td class='img'>
	    Click on \"Find Candidate Enzymes\" button under Gene Information section to find candidate enzymes for this gene
            </td>
            <td class='img'></td>
        </tr>
    
        <tr class='img' valign='top'>
            <td class='img' NOWRAP>
                &nbsp; &nbsp; &nbsp; &nbsp; Find Candidate Product Name 
            </td>
            <td class='img'>
                Find candidate product name for this gene. 
                [ <a href="$main_cgi?section=GeneDetail&page=geneDetail&gene_oid=643580707#candidate">
                see example</a> ] 
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
	    &nbsp; &nbsp; &nbsp; &nbsp; <b>Evidence For Function Predictions</b> 
            </td>
            <td class='img'>
	    [ <a href="$main_cgi?section=GeneDetail&page=geneDetail&gene_oid=643580707#evidence">
	      see example</a> ] 
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
	    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Neighborhood 
            </td>
	    <td class='img'>
	    Sequence Viewer For Alternate ORF Search 
	    [ <a href="$main_cgi?section=Sequence&page=queryForm&genePageGeneOid=643580707">see example</a> ]<br/>
	    Chromosome Viewer (colored by COG, GC, KEGG, Pfam TIGRfam, Expression) 
	    [ <a href="$main_cgi?section=ScaffoldGraph&page=scaffoldGraph&scaffold_oid=643348665&start_coord=1&end_coord=158475&marker_gene=643580707&seq_length=158475">see example</a> ] 
	    </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Conserved Neighborhood 
            </td>
            <td class='img'>
	    Ortholog Neighborhood Viewer <br/>
	    Chromosomal Cassette Viewer (COG, IMG Ortholog Cluster, Pfam)
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; External Sequence Search 
            </td>
	    <td class='img'>
	    [ <a href="$main_cgi?section=GeneDetail&page=geneDetail&gene_oid=643580707#tools1.1">see example</a> ]<br/>
	    NCBI BLAST <br/>
	    EBI InterPro Scan <br/>
	    Protein Data Bank BLAST
	    </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; IMG Sequence Search
            </td>
	    <td class='img'>
	    [ <a href="$main_cgi?section=GeneDetail&page=geneDetail&gene_oid=643580707#tools1.1">see example</a> ]<br/>
	    IMG Genome BLAST <br/>
	    Phylogenetic Profile Similarity Search
	    </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Homolog Display 
            </td>
	    <td class='img'>
	    [ <a href="$main_cgi?section=GeneDetail&page=geneDetail&gene_oid=643580707#homolog">see example</a> ] <br/>
	    Customized Homolog Display <br/>
	    Homolog Selection (Paralogs / Orthologs, Top IMG Homolog Hits) 
	    [ <a href="$main_cgi?section=GeneDetail&page=homolog&gene_oid=643580707&homologs=otfBlast">see example</a> ] 
	    </td>
            <td class='img'></td>
        </tr>
    };
}

sub printOtherTools {
    print qq{
        <tr class='highlight' valign='top'>
            <td class='img'> 
                 <b>Missing?</b> 
            </td>
            <td class='img'>
                &nbsp;
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
	    &nbsp; &nbsp; &nbsp; &nbsp; Missing Gene 
            </td>
	    <td class='img'>
	    Gene Details Page -> Neighborhood Viewer or <br/>
	    Chromosome Viewer -> Click intergenic region or <br/>
	    Find Genes -> Phylogenetic Profilers -> Single Genes see <a href="$base_url/../docs/releaseNotes2-7.pdf">IMG 2.7 release notes</a> 
	    </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'>
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Missing Enzymes 
            </td>
	    <td class='img'>
	    See <a href="$base_url/../docs/releaseNotes2-7.pdf">IMG 2.7 release notes</a> 
	    </td>
            <td class='img'></td>
        </tr>

        <tr class='highlight' valign='top'> 
            <td class='img'> 
                <b>Miscellaneous</b> 
            <td class='img'>
                &nbsp;
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'> 
            <td class='img'>
                &nbsp; &nbsp; &nbsp; &nbsp; Protein Expression Studies 
                <img width="45" height="14" border="0" 
		style="margin-left: 5px;" src="$base_url/images/updated.bmp"> 
            <td class='img'> 
                Example: 
                <a href="$main_cgi?section=IMGProteins&page=genomeexperiments&exp_oid=1&taxon_oid=643348509">Arthrobacter Study</a> 
            </td> 
            <td class='img'> 
                <a href='$base_url/../docs/Proteomics.pdf' target='_help'> 
                <img width="20" height="14" border="0" 
		style="margin-left: 20px; vertical-align:middle" 
		src="$base_url/images/help_book.gif"> 
            </td> 
        </tr>
    };

    my $rnaseq = $env->{rnaseq};
    if ($rnaseq) {
        print qq{
        <tr class='img' valign='top'> 
            <td class='img'> 
	        &nbsp; &nbsp; &nbsp; &nbsp; RNASeq Expression Studies
                <img width="45" height="14" border="0" 
                style="margin-left: 5px;" src="$base_url/images/updated.bmp">
            <td class='img'>
	        Example: 
                <a href="$main_cgi?section=RNAStudies&page=experiments&exp_oid=3&taxon_oid=641522654">Synechococcus sp. Study</a> 
            </td> 
            <td class='img'> 
                <a href='$base_url/../docs/RNAStudies.pdf' target='_help'> 
                <img width="20" height="14" border="0"
                style="margin-left: 20px; vertical-align:middle"
                src="$base_url/images/help_book.gif">
            </td>
        </tr> 
    };
    }

    print qq{
        <tr class='highlight' valign='top'> 
            <td class='img'> 
                <b>Component</b> 
            <td class='img'>
                &nbsp;
            </td>
            <td class='img'></td>
        </tr>

        <tr class='img' valign='top'> 
            <td class='img'> 
                &nbsp; &nbsp; &nbsp; &nbsp; Genome Filter 
            <td class='img'> 
                Residing in pages of Gene Search, Blast, Find Functions --> Keyword Search, Function Alignment Search, and many other area.
            </td> 
            <td class='img'>
                <a href='$base_url/../docs/GenomeFilter.pdf' target='_help'>
                <img width="20" height="14" border="0"
		style="margin-left: 20px; vertical-align:middle"
		src="$base_url/images/help_book.gif"> 
                </a>
            </td>
        </tr>

    };
}

sub printWhatsNewArchive {
    print qq{
	<a name='archive' href='#'><h2> Archive of past What's New </h2></a>
        <p>
        <div class="pdflink">
        <ul>
    <li> <a href="$base_url/../docs/releaseNotes4-0-0.pdf">IMG 4.0.0</a></li>        
    <li> <a href="$base_url/../docs/releaseNotes3-5.pdf">IMG 3.5</a></li>
    <li> <a href="$base_url/../docs/releaseNotes3-4.pdf">IMG 3.4</a></li>
    <li> <a href="$base_url/../docs/releaseNotes3-3.pdf">IMG 3.3</a></li>
    <li> <a href="$base_url/../docs/releaseNotes3-2.pdf">IMG 3.2</a></li>
    <li> <a href="$base_url/../docs/releaseNotes3-1.pdf">IMG 3.1</a></li>
    <li> <a href="$base_url/../docs/releaseNotes3-0.pdf">IMG 3.0</a></li>
    <li> <a href="$base_url/../docs/releaseNotes2-9.pdf">IMG 2.9</a></li>
    <li> <a href="$base_url/../docs/releaseNotes2-8.pdf">IMG 2.8</a></li>
    <li> <a href="$base_url/../docs/releaseNotes2-7.pdf">IMG 2.7</a></li>
    <li> <a href="$base_url/../docs/releaseNotes2-6.pdf">IMG 2.6</a></li>
        </ul>
        </div>
        </p>
    };
}

1;
