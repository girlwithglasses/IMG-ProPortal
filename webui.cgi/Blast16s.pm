############################################################################
# FindGenesBlast.pm - Formerly geneSearchBlast.pl
#   This handles the BLAST option under the "Find Genes" menu option.
#  --es 07/07/2005
#
# $Id: Blast16s.pm 37098 2017-05-23 20:38:51Z klchu $
############################################################################
package Blast16s;

use strict;
use CGI qw( :standard );
use Data::Dumper;
use Template;
use Date::Format;
use File::stat;
use Time::localtime;
use Storable;

use HtmlUtil;
use WebConfig;
use WebUtil;

$| = 1;

my $section                = "Blast16s";
my $env                    = getEnv();
my $main_cgi               = $env->{main_cgi};
my $section_cgi            = "$main_cgi?section=$section";
my $verbose                = $env->{verbose};
my $base_dir               = $env->{base_dir};
my $base_url               = $env->{base_url};
my $user_restricted_site   = $env->{user_restricted_site};
my $cgi_tmp_dir            = $env->{cgi_tmp_dir};
my $cgi_url                = $env->{cgi_url};
my $common_tmp_dir         = $env->{common_tmp_dir};
my $cgi_blast_cache_enable = $env->{cgi_blast_cache_enable};
my $taxon_lin_fna_dir = $env->{ taxon_lin_fna_dir };
my $img_ken                = $env->{img_ken};
sub getPageTitle {
	return 'BLAST 16s';
}

sub getAppHeaderData {
	my ($self) = @_;

	my @a = ("FindGenes");
	return @a;
}

############################################################################
# dispatch - Dispatch loop.
############################################################################
sub dispatch {
	my ( $self, $numTaxon ) = @_;

	if ( !$user_restricted_site ) {
		my $url =
		  WebUtil::alink( 'https://img.jgi.doe.gov/cgi-bin/mer/main.cgi',
			'IMG/M ER' );
		print "IMG BLAST is only available with login. Please use $url";
		return;
	}

	timeout( 60 * 40 );

	my $page = param("page");
	if ( $page eq 'blast16sResults' || $page eq 'allResults' || $page eq 'viralResults' || $page eq 'spacersResults') {
		require FindGenesBlast;
		FindGenesBlast::printGeneSearchBlastResults();
		
		
	} elsif($page eq 'output') {
		# user presses view raw blast or table
		printBlastOutput();
		
	} else {
		printForm();
	}
}

# base on the output format print raw blast data or a html table
sub printBlastOutput {
	my $outputformat = param('outputformat'); # table or raw
	my $blastfile = param('file'); # user session file
	my $blast_evalue = param('blast_evalue');
	my $blast_program = param('blast_program');
	my $use_db = param('use_db'); # can be blank - for virus or 16s
	my $blast16sResults = param('blast16sResults'); # can be blank - 16s
	
    my $blastSessionDir = WebUtil::getSessionCgiTmpDir('blast');    
    $blastfile = WebUtil::checkFileName($blastfile);
    my $aref = retrieve($blastSessionDir . '/' . $blastfile);


print qq{
	<h1>TODO</h1>
	outputformat $outputformat<br>
	blastfile $blastfile<br>
	blast_evalue $blast_evalue<br>
	blast_program $blast_program<br>
	use_db $use_db<br>
	blast16sResults $blast16sResults<br>
	<p>
} if($img_ken);
    WebUtil::printGeneCartFooter();   
     my $dbh = WebUtil::dbLogin();
    
     print "<pre><font color='blue'>\n";
    require FindGenesBlast;
    
    FindGenesBlast::processDnaSearchResult16s($dbh, $aref);
    
     print "</font></pre>\n";
WebUtil::printGeneCartFooter();   	
}

#
# see FindGenesBlast::processDnaSearchResult16s for db names too!
# see Blast16s.tt for db names too!
#
sub printForm {
    my $gene_oid = param('gene_oid') // ''; # isolate or metagenome
    my $taxon_oid = param('taxon_oid') //  ''; # isolate or metagenome
    my $data_type = param('data_type') // ''; # metagenome - it can be null or assembled
    my $scaffold_oid = param('scaffold_oid') // ''; # metagenome 

    my $page = param('page') // ''; # 16form viralform spacersform isolateform 

    # get dna sequence
    my $gene_display_name = '';
    my $ext_accession = '';
    my $rna_seq = '';
    my $strand = param('strand') // '';
    my $start_coord = param('start_coord') // 0;
    my $end_coord = param('end_coord') // 0;
    if($gene_oid) {
        # is it a isolate or metagenome
        if($data_type) {
            # metagenome
            $gene_display_name = $gene_oid;
            my $line = MetaUtil::getScaffoldFna( $taxon_oid, $data_type, $scaffold_oid );
            my $gene_seq    = "";
            if ( $strand eq '-' ) {
                $gene_seq = WebUtil::getSequence($line, $end_coord, $start_coord);
            } else {
                $gene_seq = WebUtil::getSequence($line, $start_coord, $end_coord);
            }
            $rna_seq = WebUtil::wrapSeq($gene_seq);
        } else {
            #isolate
            my $rclause = WebUtil::urClause('g.taxon');
            my $imgClause = WebUtil::imgClauseNoTaxon('g.taxon');
            my @bind = ($gene_oid);
            my $sql = qq{
select g.gene_oid, g.gene_display_name, g.taxon, scf.ext_accession, g.strand,
g.start_coord, g.end_coord
from gene g, scaffold scf
where g.gene_oid = ?
and g.scaffold = scf.scaffold_oid
$rclause
$imgClause
            };
            my $dbh = WebUtil::dbLogin();
            my $cur = WebUtil::execSql( $dbh, $sql, $verbose, @bind );        
            ($gene_oid, $gene_display_name, $taxon_oid, $ext_accession, $strand, $start_coord, $end_coord) = $cur->fetchrow();

            my $path = "$taxon_lin_fna_dir/$taxon_oid.lin.fna";
            my $seq = WebUtil::readLinearFasta( $path, $ext_accession, $start_coord, $end_coord, $strand );
            $rna_seq = WebUtil::wrapSeq($seq);
        }
    }


	# 16s blast db dates
	my $dir =
	  '/global/projectb/sandbox/IMG_web/img_web_data_secondary/blast.data/';
	my @text = ();
	my @blastdbs = ();
	my $title = '';
	my $rows;
	my $program = '<option value="blastn">blastn (DNA vs. DNA)</option>';
	my $blast_page = 'blast16sResults';
	
	if($page eq '16form') {
	    @text = ('16s rRNA Public Isolates', '16s rRNA Public Assembled Metagenomes');
	    @blastdbs = ('isolate16s.fna', 'metaa16s.fna');
	    $title = "16s rRNA BLAST";
	    $rows = [
	       {'value' => $blastdbs[0] , 'label' => $text[0] },
	       {'value' => $blastdbs[1], 'label' => $text[1]},
	    ];
	} elsif($page eq 'viralform') {
        @text = ('Virus Public');
        @blastdbs = ('viruses');
        $title = "Virus BLAST";
        $rows = [
           {'value' => $blastdbs[0] , 'label' => $text[0] },
        ];
        $blast_page = 'viralResults';	    
	} elsif($page eq 'spacersform') {
        @text = ('Viral Spacers Public', 'Metagenome Spacers Public');
        @blastdbs = ('viral_spacers', 'meta_spacers');
        $title = "Viral Spacers or Metagenome Spacers BLAST";
        $rows = [
           {'value' => $blastdbs[0] , 'label' => $text[0] },
           {'value' => $blastdbs[1], 'label' => $text[1]},
        ];   
        $blast_page = 'spacersResults';         
	} else {
	    # isolate all
        @text = ('All Isolates');
        @blastdbs = ('allFna');
        $title = "All Isolate BLAST";
        $rows = [
           {'value' => $blastdbs[0] , 'label' => $text[0] },
        ];
        $program = qq{
<option value="blastp">blastp (Protein vs. Protein)</option>
<option value="blastx">blastx (DNA vs. Protein)</option>
<option value="tblastn">tblastn (Protein vs. DNA -> Protein)</option>
<option value="blastn">blastn (DNA vs. DNA)</option>            
        };
        $blast_page = 'allResults';
	}
	   
	# my $page = param('page') // ''; # 16form viralform spacersform isolateform 
	   
	my @dates = ();

	my $count = 0;
	if($page ne '' && $page ne 'isolateform') {
	foreach my $db (@blastdbs) {
		my $file = $dir . $db;

        next if(!-e $file);
		# this does not support large files
		#my $date = WebUtil::fileAtime($file);
		my $date = stat($file)->mtime;

		$date = Date::Format::time2str( "%Y-%m-%d", $date );
		push( @dates, $text[$count] . ' ' . $date );
		$count++;
	}
	}

	my $tt = Template->new(
		{
			INCLUDE_PATH => $base_dir,
			INTERPOLATE  => 1,
		}
	) or die "$Template::ERROR\n";

    require WorkspaceBlast;
    my @files = WorkspaceBlast::getAllJobNames();
    
	my $vars = { 
	    last_dates => \@dates, 
	    rna_seq => $rna_seq,
	    filenames => \@files,
	    gene_name => "<h3>$gene_display_name</h3>",
	    title => $title,
	    blastdb_options => $rows,
	    program => $program,
	    blast_page => $blast_page,
	};

	$tt->process( "Blast16s.tt", $vars ) or die $tt->error();
}

1;
