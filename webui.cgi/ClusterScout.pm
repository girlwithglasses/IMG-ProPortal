package ClusterScout;

use strict;
use CGI qw( :standard);
use Command;
use Data::Dumper;
use DBI;
use Capture::Tiny;
use File::Copy;
use File::Path;
use File::Path qw(make_path);
use File::ReadBackwards;
use FileHandle;
use InnerTable;
use HtmlUtil;
use MailUtil;
use WebConfig;
use WebUtil;
use Workspace;
use OracleUtil;
use QueryUtil;
use BcUtil;

$| = 1;

my $env               = getEnv();
my $verbose           = $env->{verbose};
my $main_cgi          = $env->{main_cgi};
my $cgi_dir           = $env->{cgi_dir};
my $cgi_tmp_dir       = $env->{cgi_tmp_dir};
my $cgi_url           = $env->{cgi_url};
my $tmp_dir           = $env->{tmp_dir};
my $tmp_url           = $env->{tmp_url}; # eg 'https://img.jgi.doe.gov/m/tmp'
my $top_base_url      = $env->{top_base_url};
my $base_url          = $env->{base_url};


sub getPageTitle {
    return 'ClusterScout';
}

sub getAppHeaderData {
    my($self) = @_;

    my @a = ( "getsme" );

    return @a;
}

#my $clusterScoutDir = '/global/dna/projectdirs/microbial/omics-biosynthetic/michalis/';
#my $clusterScoutScript = '/global/dna/projectdirs/microbial/omics-biosynthetic/michalis/clusterScout_IMG.py';
my $clusterScoutScript = "$cgi_dir/bin/clusterScout_IMG_v2.py";
#my $clusterScoutFileDir = "$cgi_tmp_dir";
my $clusterScoutFileDir = "$tmp_dir/public/clusterscout";

############################################################################
# dispatch - Dispatch loop.
############################################################################
sub dispatch {
    my ( $self, $numTaxon ) = @_;

    my $page = param('page');

    if ( $page eq 'clusterScoutResult' || paramMatch('clusterScoutResult') ne '' ) {
        processClusterScoutResult(); 
    }
    elsif ( $page eq 'displayClusterScoutResult' || paramMatch('displayClusterScoutResult') ne '' ) {
        displayClusterScoutResult(); 
    }
    else {
        printClusterScoutForm();
    }
}


############################################################################
# printClusterScoutForm
############################################################################
sub printClusterScoutForm {

   print "<h1>ClusterScout</h1>";

    my $dbh = dbLogin();
    my $contact_oid = getContactOid();
    my $myEmail = MailUtil::getMyEmail($dbh, $contact_oid);
    #print "printClusterScoutForm() myEmail=$myEmail<br/>\n";

    printMainForm();
    print table({-class => 'img'},
      Tr({-align=>'RIGHT',-valign=>'CENTER'},
        [
          td(['PFam Hooks (required):',              textfield(-name => 'pfam_hooks', -size => '80'),      div({-align=>'left',-style=>'color:grey;'},'((e.g.: pfam00405,pfam01254,pfam13219), min: 3, max: 10)')]),
          td(['Minimum Number of Hooks (required):', textfield(-name => 'min_pfam_hooks', -value => 3, -size => '80'),  div({-align=>'left',-style=>'color:grey;'},'(Number, default: 3)')]),
          td(['Essential PFams:',                    textfield(-name => 'essential_pfams', -size => '80'), div({-align=>'left',-style=>'color:grey;'},'(Must be included in hooks list)')]),
          td(['Maximum Distance between Hooks:',     textfield(-name => 'max_distance', -value => 5000, -size => '80'),    div({-align=>'left',-style=>'color:grey;'},'Nucleotides (default: 5000, max: 20000)')]),
          td(['Extend Boundaries by:',               textfield(-name => 'extend_by', -value => 5000, -size => '80'),       div({-align=>'left',-style=>'color:grey;'},'Nucleotides (default: 5000, max: 20000)')]),
          td(['Minimum distance from scaffold edge:',textfield(-name => 'min_scaf_edge', -value => 1000, -size => '80'),       div({-align=>'left',-style=>'color:grey;'},'Nucleotides (min: 1)')]),
          td(['Name Your Search',                    textfield(-name => 'name_of_search', -size => '80'),  div({-align=>'left',-style=>'color:grey;'},'(Up to 50 characters, no spaces)')]),
          td(['My Email',              textfield(-name => 'myEmail', -value => "$myEmail", -size => '80'), div({-align=>'left',-style=>'color:grey;'},'(Results will be mailed to you)')]),
          #td([submit(-value => 'Search', -class => 'smdefbutton', -name => '_section_ClusterScout_clusterScoutResult')])
        ])
    );

    print submit(
        -name    => "_section_ClusterScout_clusterScoutResult",
        -value   => "Search",
        -class   => 'smdefbutton',
    );
    print nbsp(2);
    print reset(
        -name    => "Reset",
        -value   => 'Reset',
        -class   => 'smdefbutton',
    );
    
    printPageHint();
    
    print end_form();

}

############################################################################
# printPageHint - Print this page's hint.
############################################################################
sub printPageHint {

    my $img = qq{
        Use the following illustration as a guideline for using ClusterScout. <br />
        <img width="880" height="150" src="$top_base_url/images/ClusterScout.png" style="float:left; padding-right: 5px;">
    };
    printImageHint($img);
    
}

sub printImageHint {
    my ($txt) = @_;
    print "<div id='hint' style='width: 880px;'>\n";
    print "<img src='$base_url/images/hint.gif' " . "width='67' height='32' alt='Hint' />";
    print "<p>\n";
    print $txt;
    print "</p>\n";
    print "</div>\n";
    print "<div class='clear'></div>\n";
}


############################################################################
# processClusterScoutResult
############################################################################
sub processClusterScoutResult {

    my $pfam_hooks = param('pfam_hooks');
    my $min_pfam_hooks = param('min_pfam_hooks');
    my $essential_pfams = param('essential_pfams');
    my $max_distance = param('max_distance');
    my $extend_by = param('extend_by');
    my $min_scaf_edge = param('$min_scaf_edge');
    my $name_of_search = param('name_of_search');

    if ( !$pfam_hooks || WebUtil::blankStr($pfam_hooks) ) {
        WebUtil::webError("PFam Hooks can not be empty.");
    }
    
    if ( !$min_pfam_hooks || WebUtil::blankStr($min_pfam_hooks) ) {
        $min_pfam_hooks = 3;
    }
    if ( !$max_distance || WebUtil::blankStr($max_distance) ) {
        $max_distance = 5000;
    }
    if ( !$extend_by || WebUtil::blankStr($extend_by) ) {
        $extend_by = 5000;
    }
    if ( !$min_scaf_edge || WebUtil::blankStr($min_scaf_edge) ) {
        $min_scaf_edge = 1000;
    }

    WebUtil::processSearchTerm($pfam_hooks);
    WebUtil::processSearchTerm($min_pfam_hooks);
    WebUtil::processSearchTerm($essential_pfams);
    WebUtil::processSearchTerm($max_distance);
    WebUtil::processSearchTerm($extend_by);
    WebUtil::processSearchTerm($min_scaf_edge);
    WebUtil::processSearchTerm($name_of_search);

    $pfam_hooks = MetaUtil::sanitizeVar($pfam_hooks);
    $min_pfam_hooks = WebUtil::sanitizeInt($min_pfam_hooks);
    $essential_pfams = MetaUtil::sanitizeVar($essential_pfams);
    $max_distance = WebUtil::sanitizeInt($max_distance);
    $extend_by = WebUtil::sanitizeInt($extend_by);
    $min_scaf_edge = WebUtil::sanitizeInt($min_scaf_edge);
    $name_of_search = MetaUtil::sanitizeVar($name_of_search);

    my @pfam_hooks_list = WebUtil::splitTerm( $pfam_hooks, 0, 0 );
    if ( scalar(@pfam_hooks_list) < 3 ) {
        WebUtil::webError("The minimum number of PFam Hooks list is 3.");
    }
    if ( scalar(@pfam_hooks_list) > 10 ) {
        WebUtil::webError("The max number of PFam Hooks list is 10.");
    }
    
    $pfam_hooks = '';
    my $hookCnt = 0;
    for my $pfam (@pfam_hooks_list) {
        if ($hookCnt > 0) {
            $pfam_hooks .= ',';            
        }
        $pfam_hooks .= $pfam;
        $hookCnt++;
    }

    if ( $essential_pfams && !WebUtil::blankStr($essential_pfams) ) {
        my @essential_pfams_list = WebUtil::splitTerm( $essential_pfams, 0, 0 );
        $essential_pfams = '';
        my $essPfamCnt = 0;
        for my $pfam (@essential_pfams_list) {
            if ( $pfam_hooks !~ /$pfam/i ) {
                WebUtil::webError("Essential PFams ($pfam) must be included in hooks list ($pfam_hooks).");
            }
            if ($essPfamCnt > 0) {
                $essential_pfams .= ',';            
            }
            $essential_pfams .= $pfam;
            $essPfamCnt++;
        }
    }

    if ( $max_distance > 20000 ) {
        $max_distance = 20000;
    }
    if ( $extend_by > 20000 ) {
        $extend_by = 20000;
    }
    if ( $min_scaf_edge < 1 ) {
        $min_scaf_edge = 1;
    }

    my $myEmail = param('myEmail');
    $myEmail =~ s/\r//g;
    $myEmail =~ s/^\s+//;
    $myEmail =~ s/\s+$//;
    #print "processClusterScoutResult() myEmail: $myEmail<br/>\n";

    my $title = "ClusterScout $name_of_search";
    print "<h1>$title</h1>\n";

    my $sid = WebUtil::getContactOid();
    my $file_name = "clusterScout_${sid}_$$";

    if (! -e $clusterScoutFileDir) {
        umask 0022;
        make_path( $clusterScoutFileDir, { mode => 0755 } );
    }

    my $info_file = "$clusterScoutFileDir/$file_name.info";
    #print "infoFile=$info_file<br/>\n";
    my $outputFile = "$clusterScoutFileDir/$file_name.txt";
    #print "outputFile=$outputFile<br/>\n";
    my $stderrFile = "$clusterScoutFileDir/$file_name.stderr";
    #print "stderrFile=$stderrFile<br/>\n";

    WebUtil::webDie("Cannot find the script file " . $clusterScoutScript) if (!-e $clusterScoutScript);
    
    my $essential_pfams_line;
    if ( $essential_pfams && !WebUtil::blankStr($essential_pfams) ) {
        $essential_pfams_line = "--essential $essential_pfams ";   
    }
    
    my $cmd = "python $clusterScoutScript --hooks $pfam_hooks --minim $min_pfam_hooks $essential_pfams_line --gap $max_distance --pad $extend_by --edge $min_scaf_edge ";
    $cmd = "$cmd >$outputFile 2>$stderrFile";
    #$cmd = "$cmd 2>$stderrFile";
    $cmd = each %{ { $cmd, 0 } };    # untaint
    #print "cmd=$cmd<br/>\n";

    ## output info file
    my $info_fs   = newWriteFileHandle($info_file);
    print $info_fs "$title\n";
    print $info_fs "--pfam_hooks $pfam_hooks\n";
    print $info_fs "--min_pfam_hooks $min_pfam_hooks\n";
    print $info_fs "--essential_pfams $essential_pfams\n";
    print $info_fs "--max_distance $max_distance\n";
    print $info_fs "--extend_by $extend_by\n";
    print $info_fs "--min_scaf_edge $min_scaf_edge\n";
    print $info_fs "--name_of_search $name_of_search\n";
    print $info_fs "--myEmail $myEmail\n";
    print $info_fs "--cmd $cmd\n";
    print $info_fs currDateTime() . "\n";
    close $info_fs;

    my $displayUrl = "$cgi_url/$main_cgi?section=ClusterScout&page=displayClusterScoutResult&file_name=$file_name";

    MailUtil::processSubmittedMessage($title);
    my $t = threads->new(
          \&threadjob_cs, $info_file, $outputFile, $stderrFile, $title, $myEmail, $displayUrl, $cmd
    );
    $t->join;

}

sub threadjob_cs {
    my ( $info_file, $outputFile, $stderrFile, $title, $myEmail, $displayUrl, $cmd ) = @_;

    eval {
        #webLog("threadjob_cs(): cmd=$cmd". currDateTime() ."\n");
        my $st = system($cmd);
        if ( $st != 0 ) {
            webLog("threadjob_cs(): st=$st". currDateTime() ."\n");
            webLog("Failure: run $cmd\n");
        }

        my $anyData = anyDataInClusterScoutOutputFile($outputFile);
        my $subject;
        my $errMag;
        if ($anyData) {
            $subject = "Search done for $title";
        }
        else {
            $subject = "No result data for $title.";
            $errMag = "Please also use below link to view error message if any.";
        }
        my $content = MailUtil::getDoNotReplyMailContent($displayUrl, , $errMag);
        MailUtil::sendEMailTo( $myEmail, '', $subject, $content );
    };
    if ($@) {
        my $monitor = "jinghuahuang\@lbl.gov";

        my $subject = "Search processing failed for $title.";
        my $content = "failed reason ==> $@ \n";
        MailUtil::sendEMailTo( $myEmail, $monitor, $subject, $content );

        $subject = "Search processing thread failed for $title.";
        $content = "failed reason ==> $@ \n";
        $content .= "info_file: $info_file\n";
        $content .= "outputFile: $outputFile\n";
        $content .= "errorFile: $stderrFile\n";
        MailUtil::sendEMailTo( '', $monitor, $subject, $content );
    }

}



############################################################################
# displayClusterScoutResult
############################################################################
sub displayClusterScoutResult {

    my $file_name = param('file_name');
    
    my $lineno = 0;
    my $title;
    my $pfam_hooks;
    my $essential_pfams;
    my $min_pfam_hooks;
    my $max_distance;
    my $extend_by;
    my $min_scaf_edge;
    my $name_of_search;
    my $myEmail;

    my $infoFile = "$clusterScoutFileDir/$file_name.info";
    if ( -e $infoFile && -s $infoFile > 10 ) {
        my $res = WebUtil::newReadFileHandle($infoFile, 'info file');
        while ( my $line = $res->getline() ) {
            chomp $line;
            if ( $lineno == 0 ) {
                $title = $line;
                #print "<p>Job Type: $job_type<br/>";
            } else {
                my ( $tag, $val ) = split( / /, $line, 2 );
                if ( $tag eq "--pfam_hooks" ) {
                    $pfam_hooks = $val;
                } elsif ( $tag eq "--essential_pfams" ) {
                    $essential_pfams = $val;
                } elsif ( $tag eq "--min_pfam_hooks" ) {
                    $min_pfam_hooks = $val;
                } elsif ( $tag eq "--max_distance" ) {
                    $max_distance = $val;
                } elsif ( $tag eq "--extend_by" ) {
                    $extend_by = $val;
                } elsif ( $tag eq "--min_scaf_edge" ) {
                    $min_scaf_edge = $val;
                } elsif ( $tag eq "--name_of_search" ) {
                    $name_of_search = $val;
                } elsif ( $tag eq "--myEmail" ) {
                    $myEmail = $val;
                }
                #print "$line<br/>\n";
            }
            $lineno++;
        }
        close $res;
    }

    # checking for errors
    my $stderrFile = "$clusterScoutFileDir/$file_name.stderr";
    if ( -e $stderrFile && -s $stderrFile > 10 ) {
        #print "<span style='color:red;'>Error: </span>see file $stderrFile<br>\n";
        print "<span style='color:red;'>Error: </span><br>\n";
        my $rfh = WebUtil::newReadFileHandle($stderrFile, 'error file');
        print "<pre style='color:red;'>\n";
        while ( my $s = $rfh->getline() ) {
            print "$s";
        }
        close $rfh;
        print "</pre>\n";
    }

    # read output file
    my @resultsLine;
    my @scaffold_oids;
    #my @clusterIds;
    my $outputFile = "$clusterScoutFileDir/$file_name.txt";
    if ( -e $outputFile && -s $outputFile > 10 ) {
        my $beginningResult = 0;
        my $rfh = WebUtil::newReadFileHandle( $outputFile, 'output file' );
        while ( my $s = $rfh->getline() ) {
            chomp $s;
            #print "$s <br/>\n";
            next if ( WebUtil::blankStr($s) );
            last if ( $s =~ /done/i );
            
            if ( $s =~ /^#Scaffold/i ) {
                #print "$s <br/>\n";
                $beginningResult = 1;
            } 
            elsif ( $beginningResult == 1 ) {
                #print "$s <br/>\n";
                push( @resultsLine, $s );
                my ( $scaffold_oid, $start_coord, $end_coord, $hooks, $bc_length ) = split( /\s+/, $s );
                push( @scaffold_oids, $scaffold_oid );
                #push( @clusterIds, "$scaffold $start $end" );
            }
        }
        $rfh->close();        
    }

    printMainForm();
    print "<h1>Results of $title</h1>";

    print qq{
        <p style="width: 650px;">
        Query: At least $min_pfam_hooks of ($pfam_hooks)
        <br>
        Essential PFams: $essential_pfams
        <br>
        Maximum Distance between Hooks: $max_distance nt
        <br>
        Extend Boundaries by: $extend_by nt
        <br>
        Minimum distance from scaffold edge: $min_scaf_edge
        </p>
    };

    # found genome ids
    my $dbh = dbLogin();
    my ($goid_href, $s2goid_href) = QueryUtil::fetchScaffoldGenomeOidsHash( $dbh, @scaffold_oids );

    my @taxonOids = keys %$goid_href;
    my %taxon_name_h = QueryUtil::fetchTaxonOid2NameHash($dbh, \@taxonOids);    
    
    #use: "and ((g.end_coord > ? and g.end_coord <= ?) or (g.start_coord >= ? and g.start_coord < ?))"
    #instead of "and g.start_coord >= ? and g.end_coord <= ?"
    #to make sure that the genes that starts below the starting range but ends within the range, 
    #or starts below the ending range but ends beyond the ending range, get in
    my $gc_sql = qq{
        select count(distinct g.gene_oid)
        from scaffold s, gene g
        where s.scaffold_oid = ?
        and g.scaffold = s.scaffold_oid
        and ((g.end_coord > ? and g.end_coord <= ?) or (g.start_coord >= ? and g.start_coord < ?))
        and g.start_coord > 0 
        and g.end_coord > 0
        and g.obsolete_flag = 'No'
        and s.ext_accession is not null
    };
        
    my $it = new InnerTable( 1, "processcs$$", "processcs", 1 );
    my $sd = $it->getSdDelim(); # sort delimiter

    # columns headers
    $it->addColSpec( "Select" );
    $it->addColSpec( "Gene Count",       "desc", "right" );
    $it->addColSpec( "Genome Name",      "asc",  "left" );
    $it->addColSpec( "Scaffold",         "asc",  "right" );
    $it->addColSpec( "Start Coord",      "asc",  "right" );
    $it->addColSpec( "End Coord",        "asc",  "right" );
    $it->addColSpec( "BC Length",        "asc",  "right" );
    $it->addColSpec( "Evidence Type",    "asc",  "left" );
    #$it->addColSpec( "Biosynthetic Cluster Type", "asc",  "left" );

    my $count = 0;
    my $url   = 'main.cgi?section=BiosyntheticDetail&page=cluster_detail&cluster_id=';

    foreach my $line (@resultsLine) {
        #print "line=$line<br/>\n";
        my ( $scaffold_oid, $start_coord, $end_coord, $hooks, $bc_length ) = split( /\s+/, $line );
        next if ( !$scaffold_oid );

        my $synthetic_cluster_id = "$scaffold_oid $start_coord $end_coord";

        # select
        my $row = $sd . "<input type='checkbox' name='bc_id' value='$synthetic_cluster_id' />\t";

        # gene count
        my $cur = execSql( $dbh, $gc_sql, $verbose, $scaffold_oid,
            $start_coord, $end_coord, $start_coord, $end_coord );
        my ($gene_count) = $cur->fetchrow();
        $cur->finish();
        if ( $gene_count > 0 ) {
            my $url2 =
                "main.cgi?section=ScaffoldDetail&page=scaffoldGenesInRange&scaffold_oid=$scaffold_oid"
              . "&start_coord=$start_coord&end_coord=$end_coord";
            $row .= $gene_count . $sd . alink( $url2, $gene_count ) . "\t";
        } else {
            $row .= $sd . "\t";
        }

        # taxon name
        my $taxon_oid = $s2goid_href->{$scaffold_oid};
        my $name = $taxon_name_h{$taxon_oid};
        $row .= $name . $sd . 
        alink("main.cgi?section=TaxonDetail&page=taxonDetail&taxon_oid=$taxon_oid", $name) . "\t";

        # scaffold oid
        my $s_url = "$main_cgi?section=ScaffoldDetail&page=scaffoldDetail&scaffold_oid=$scaffold_oid";
        $row .= $scaffold_oid . $sd . alink( $s_url, $scaffold_oid ) . "\t";

        # start coord
        $row .= $start_coord . $sd . $start_coord . "\t";

        # end coord
        $row .= $end_coord . $sd . $end_coord . "\t";

        # bc length
        $row .= $bc_length . $sd . $bc_length . "\t";

        # evidence type
        $row .= 'ClusterScout' . $sd . 'ClusterScout' . "\t";

        # bc type
        #$row .= $name_of_search . $sd . $name_of_search . "\t";
        #$row .= $sd . "\t";

        $it->addRow($row);
        $count++;
    }

    if ($count > 0) {
        print "<div id='cstab1'>";
        BcUtil::printSetDetailFooter("processcs") if ($count > 10);
        $it->printOuterTable(1);
        BcUtil::printSetDetailFooter("processcs");        
        print "</div>\n";
    
        print "<div id='cstab2'>";
        WorkspaceUtil::printSaveBcToWorkspace('bc_id');
        print "</div>\n";
    }
    
    print end_form();
    printStatusLine( "$count rows", 2 );
}

############################################################################
# anyDataInFile
############################################################################
sub anyDataInClusterScoutOutputFile {
    my ($outputFile) = @_;

    if (-f $outputFile && WebUtil::fileSize($outputFile) > 0) {
        my $bw = File::ReadBackwards->new( $outputFile ) or return 0;
        my $line;
        my $cnt= 0;
        while( $cnt < 3 && defined( $line = $bw->readline ) ) {
            print $line;
            last if ( $line =~ /^#Scaffold/i );
            if ( !WebUtil::blankStr($line) && $line !~ /^#Scaffold/i ) {
                $cnt++;
            }
        }
        $bw->close();
        if ( $cnt > 0) {
            return 1;
        }
    }

    return 0;
}


############################################################################
# isFileReady - not used
#while ( ! isFileReady($outputFile) ) {
#    print "Result file is not ready!<br/>\n";
#    sleep(20);
#}
############################################################################
sub isFileReady {
    my ($outputFile) = @_;

    if (-f $outputFile && WebUtil::fileSize($outputFile) > 0) {
        my $bw = File::ReadBackwards->new( $outputFile ) or return 0;
        my $line;
        my $cnt= 1;
        while( $cnt < 3 && defined( $line = $bw->readline ) ) {
            print $line;
            if ( $line =~ /done/i ) {
                return 1;
            }
            $cnt++;
        }
        $bw->close();
    }

    return 0;
}


1;
