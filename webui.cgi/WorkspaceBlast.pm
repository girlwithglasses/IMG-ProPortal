########################################################################
#
# BLAST 16s and Viral
#
# $Id: WorkspaceBlast.pm 37097 2017-05-23 17:49:20Z klchu $
########################################################################
package WorkspaceBlast;

use strict;
use CGI qw( :standard);
use Data::Dumper;
use DBI;
use Tie::File;
use File::Copy;
use File::Path qw(make_path remove_tree);
use Template;
use FileHandle;


use TabHTML;
use InnerTable;
use HtmlUtil;
use WebConfig;
use WebUtil;
use WorkspaceUtil;
use Workspace;
use Command;

$| = 1;

my $section              = "WorkspaceBlast";
my $env                  = getEnv();
my $main_cgi             = $env->{main_cgi};
my $section_cgi          = "$main_cgi?section=$section";
my $verbose              = $env->{verbose};
my $base_dir             = $env->{base_dir};
my $base_url             = $env->{base_url};
my $user_restricted_site = $env->{user_restricted_site};
my $img_internal         = $env->{img_internal};
my $img_er               = $env->{img_er};
my $img_ken              = $env->{img_ken};
my $tmp_dir              = $env->{tmp_dir};
my $workspace_dir        = $env->{workspace_dir};
my $workspace_sandbox_dir        = $env->{workspace_sandbox_dir};
my $YUI                  = $env->{yui_dir_28};
my $mer_data_dir         = $env->{mer_data_dir};
my $cgi_tmp_dir          = $env->{cgi_tmp_dir};
my $enable_workspace     = $env->{enable_workspace};
my $top_base_url = $env->{top_base_url};

my $sid                  = WebUtil::getContactOid();
my $contact_oid          = $sid;

my $GENOME_FOLDER = "genome";
my $GENE_FOLDER   = "gene";
my $SCAF_FOLDER   = "scaffold";
my $FUNC_FOLDER   = "function";
my $BC_FOLDER = "bc";
my $BLAST_FOLDER  = 'blast';

sub getPageTitle {
    return 'Workspace';
}

sub getAppHeaderData {
    my ($self) = @_;

    my @a = ();
    if ( WebUtil::paramMatch("noHeader") ne "" ) {
        return @a;
    } else {
        push( @a, "AnaCart" );
        return @a;
    }
}

sub dispatch {
    my ( $self, $numTaxon ) = @_;
    if (!$enable_workspace) {
        return;
    }

    my $page      = param('page');
    Workspace::initialize();

    if($page eq 'blast') {
        submitJobBlast();
    } else {
        require Blast16s;
        Blast16s::printForm();
        #printForm();
    }    
}

#
# submit background blast job
#
sub submitJobBlast {
    my $blast_program = param('blast_program');
    my $blast_evalue = param('blast_evalue');
    my $use_db = param('use_db');
    my $fasta = param('fasta');
    my $blast_save_mode = param('blast_save_mode');
    my $blast_job_result_name = param('blast_job_result_name');
    my $blast_selected_job_name = param('blast_selected_job_name');
    
    my $postfix = '.fna';
     if (!$use_db && ( $blast_program eq "tblastn" || $blast_program eq "blastn" )) {
         #dna
         $use_db = 'allFna';
     } elsif(!$use_db) {
         # protein
         $use_db = 'allFaa';
     }
    
     if ( $blast_program eq "tblastn" || $blast_program eq "blastn" ) {
         #dna
         $postfix = '.fna';
     } elsif(!$use_db) {
         # protein
         $postfix = '.faa';
     }    
    
    
    print qq{
      TODO <br>
      $fasta <br>
      $blast_program <br>
      $blast_evalue  <br>
      $use_db  <br>
      $blast_save_mode  <br>
      $blast_job_result_name  <br>
      $blast_selected_job_name  <br>
    };
    

    if(WebUtil::blankStr($fasta)) {
         WebUtil::webError("Sequence is required.<br>\n");
    }

    if($blast_save_mode eq 'replace') {
        $blast_selected_job_name =~ s/\W+/_/g;
        WebUtil::checkFileName($blast_selected_job_name);
        $blast_selected_job_name = WebUtil::validFileName($blast_selected_job_name);        
        
        # TODO remove old job 
        # on webfs 
        # and on sandbox
        my $job_dir = "$workspace_dir/$sid/job/$blast_selected_job_name/";
        remove_tree($job_dir);
        
        my $job_sandbox_dir = "$workspace_sandbox_dir/$sid/job/$blast_selected_job_name/";
        remove_tree($job_sandbox_dir);
        
        $blast_job_result_name = $blast_selected_job_name;
    } else {
        $blast_job_result_name =~ s/\W+/_/g;
         
        # check filename
        # valid chars
        WebUtil::checkFileName($blast_job_result_name);

        # this also untaints the name
        $blast_job_result_name = WebUtil::validFileName($blast_job_result_name);

        # check for existsing job name
        my $job_dir = "$workspace_dir/$sid/job/$blast_job_result_name/";
        if(-e $job_dir) {
            WebUtil::webError("$blast_job_result_name name already exists.<br>\n");
        }
    }

    
    my $output_name = $blast_job_result_name;
    my $job_file_dir = Workspace::getJobFileDirReady( $sid, $output_name );
 
 
    # save seq to a file file
    my $fastaFilename = $blast_job_result_name . $postfix;
    my $seq_file = $job_file_dir . '/' . $fastaFilename;
    my $wfh   = newWriteFileHandle($seq_file);
    print $wfh $fasta;
    close $wfh; 
 
    ## output info file
    my $info_file = "$job_file_dir/info.txt";
    my $info_fs   = newWriteFileHandle($info_file);
    print $info_fs "Sequence blast\n";
    print $info_fs "--evalue $blast_evalue\n";
    print $info_fs "--fasta $fastaFilename\n";
    print $info_fs "--blast_program $blast_program\n";
    print $info_fs "--use_blast_db $use_db\n";
    print $info_fs currDateTime() . "\n";
    close $info_fs; 
    
    my $queue_dir = WorkspaceUtil::getQueueDir();
    my $queue_filename = $sid . '_sequenceBlast_' . $output_name; 
    
    
#[klchu@gpweb36 QUEUE]$ more 3038_sequenceBlast_blasttest2
#--program=sequenceBlast
#--contact=3038
#--blast_program=blastn
#--output=blasttest2
#--evalue=1e-5
#--use_blast_db=isolate16s.fna
#--fasta=blasttest2.fna    
    my $wfh = newWriteFileHandle( $queue_dir . $queue_filename );
    print $wfh "--program=sequenceBlast\n";
    print $wfh "--contact=$sid\n";
    print $wfh "--blast_program=$blast_program\n";
    print $wfh "--output=$output_name\n";
    print $wfh "--evalue=$blast_evalue\n";
    print $wfh "--use_blast_db=$use_db\n";
    print $wfh "--fasta=${blast_job_result_name}" . $postfix . "\n"; # the dir should be the sandbox one
    close $wfh;
    
    if($img_ken) {
        print "<p>queue file: $queue_dir . $queue_filename<br>\n";
    }
    
    Workspace::rsync($sid);
    print "<p>Job is submitted successfully.\n";
    
}

sub printForm_old {
    my $tt = Template->new(
        {
            INCLUDE_PATH => $base_dir,
            INTERPOLATE  => 1,
        }
    ) or die "$Template::ERROR\n";

    my @files = getAllJobNames();

    my $vars = { 
        filenames => \@files, 
    };

    $tt->process( "BlastWorkspace.tt", $vars ) or die $tt->error();    
}


#
# list all job names
#
sub getAllJobNames {
    my $job_dir = "$workspace_dir/$sid/job";
    
    
    my @files = WebUtil::dirList($job_dir);
    
    return @files;
}

#
# prints the blast results
#
sub printResults {
    my($job_name, $use_blast_db, $evalue, $blast_program) = @_;
    
    
    my $job_dir = "$workspace_dir/$sid/job/$job_name/";

    # buttons
    if($use_blast_db eq 'isolate16s.fna' || $use_blast_db eq 'metaa16s.fna' ) {
        WebUtil::printGeneCartFooter();
    } elsif($use_blast_db eq 'viruses' || $use_blast_db eq 'viral_spacers' || $use_blast_db eq 'meta_spacers' ) {
        WebUtil::printScaffoldCartFooter();
    } elsif ($use_blast_db eq 'allFna' ) {
        
        #if($blast_program eq 'blastn' || $blast_program eq 'tblastn') {
            # dna
            WebUtil::printScaffoldCartFooter();    
    } elsif ($use_blast_db eq 'allFaa') {
            # protein
            #} elsif($blast_program eq 'blastp' || $blast_program eq 'blastx') {
            #print "TODO - add cart buttons<br>\n"    
        WebUtil::printGeneCartFooter();
    }

    
    
    # read seq file too
     print "<pre><font color='blue'>\n";
    print "Seqeunce:\n";
    
    my $seqfile = $job_dir . $job_name . '.fna';
    if($use_blast_db eq 'allFaa') {
        $seqfile = $job_dir . $job_name . '.faa';
    }

    my $rfh = newReadFileHandle($seqfile);
    while(my $line = $rfh->getline()) {
        print $line;
    }     
    close $rfh;
    print "\n\n";    
    print "</font></pre>\n";
         
    # get blast.txt file
    my $file = $job_dir . 'blast.txt';
    my $rfh = newReadFileHandle($file);
    my @lines = ();
    while(my $line = $rfh->getline()) {
        chomp $line;
        push(@lines, $line);
    }
    close $rfh;

    # format output
    if($use_blast_db eq 'isolate16s.fna' || $use_blast_db eq 'metaa16s.fna' ) {
        
        # 16s blast
        my $dbh = WebUtil::dbLogin();
        require FindGenesBlast;
        #FindGenesBlast::processDnaSearchResult16s($dbh, \@lines, $use_blast_db);
        my $blastfile = FindGenesBlast::saveRawBlastFile("blastDnaAll_", \@lines);
        my $urlview = "main.cgi?section=Blast16s" 
        . "&page=output"
        . "&outputformat=raw"
        . "&file=$blastfile"
        . "&blast_program=blastn";
        $urlview .= "&use_db=$use_blast_db";
        $urlview .= "&blast16sResults=blast16sResults";
        $urlview .= "&outputformat=raw";
        #  . "&blast_evalue=$evalue"
        
        print qq{
            <br>
<a href='$urlview' target="_blank"> View raw Blast data file</a><br>
<br>
        };        
        
        
        FindGenesBlast::processDnaSearchResult16sHtml($dbh, \@lines, $use_blast_db);
    
    } elsif ($use_blast_db eq 'viruses' || $use_blast_db eq 'viral_spacers' || $use_blast_db eq 'meta_spacers') {

        # virus blast
        my $dbh = WebUtil::dbLogin();
        require FindGenesBlast;
        print "<pre><font color='blue'>\n";
        FindGenesBlast::processDnaSearchResult( $dbh, \@lines, '', 0, $evalue, $use_blast_db );
         print "</font></pre>\n";
    } elsif ($use_blast_db eq 'allFna' ) {
    
         #if($blast_program eq 'blastn' || $blast_program eq 'tblastn') {
            # dna
            # all isolate blast
            my $dbh = WebUtil::dbLogin();
            require FindGenesBlast;
             print "<pre><font color='blue'>\n";
            FindGenesBlast::processDnaSearchResult( $dbh, \@lines, '', 0, $evalue, $use_blast_db );
     print "</font></pre>\n";
        

    } elsif($use_blast_db eq 'allFaa') {
        #} elsif($blast_program eq 'blastp' || $blast_program eq 'blastx') {
        
            # protein
            #print "TODO - blastp output here<br>\n";
        
            require  FindGenesBlast;
             print "<pre><font color='blue'>\n";
             FindGenesBlast::processProteinBlastResult(\@lines, '', '', 0, $use_blast_db);
         print "</font></pre>\n";
    } else {

        # error
        print "Unknown $use_blast_db\n";
    }
   

    # buttons
    if($use_blast_db eq 'isolate16s.fna' || $use_blast_db eq 'metaa16s.fna' ) {
        WebUtil::printGeneCartFooter();
    } elsif($use_blast_db eq 'viruses' || $use_blast_db eq 'viral_spacers' || $use_blast_db eq 'meta_spacers' ) {
        WebUtil::printScaffoldCartFooter();
    } elsif ($use_blast_db eq 'allFna' ) {
        
        #if($blast_program eq 'blastn' || $blast_program eq 'tblastn') {
            # dna
            WebUtil::printScaffoldCartFooter();    
    } elsif ($use_blast_db eq 'allFaa') {
            # protein
            #} elsif($blast_program eq 'blastp' || $blast_program eq 'blastx') {
            #print "TODO - add cart buttons<br>\n"
        WebUtil::printGeneCartFooter();
        ## save to workspace
        WorkspaceUtil::printSaveGeneToWorkspace2('gene_oid');
                    
    }
}

1;
