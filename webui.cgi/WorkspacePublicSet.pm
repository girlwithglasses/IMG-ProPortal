#
#
# $Id: WorkspacePublicSet.pm 36986 2017-04-24 20:21:19Z klchu $
#
package WorkspacePublicSet;

use strict;
use CGI qw( :standard);
use Data::Dumper;
use DBI;
use File::Copy;
use System::Command;
use HTML::Template;
use InnerTable;
use WebConfig;
use WebUtil;
use Workspace;
use WorkspaceUtil;
use OracleUtil;

$| = 1;

my $section              = "WorkspacePublicSet";
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
my $top_base_url         = $env->{top_base_url};
my $web_data_dir         = $env->{web_data_dir};
my $mer_data_dir         = $env->{mer_data_dir};
my $cgi_tmp_dir          = $env->{cgi_tmp_dir};
my $enable_workspace     = $env->{enable_workspace};
my $in_file              = $env->{in_file};

# user's sub folder names
my $GENOME_FOLDER = "genome";
my $GENE_FOLDER   = "gene";
my $SCAF_FOLDER   = "scaffold";
my $FUNC_FOLDER   = "function";
my $RULE_FOLDER   = "rule";
my $BC_FOLDER     = 'bc';

my $public_workspace_dir = "$workspace_dir/public/";

sub getPageTitle {
    return 'Workspace Public Sets';
}

sub getAppHeaderData {
    my ($self) = @_;

    my @a         = ();
    my $header    = param("header");
    my $ws_yui_js = Workspace::getStyles();    # Workspace related YUI JS and styles
    if ( WebUtil::paramMatch("wpload") ) {     ##use 'wpload' since param 'uploadFile' interferes 'load'
                                               # no header
    } elsif ( $header eq "" && WebUtil::paramMatch("noHeader") eq "" ) {
        @a = ( "AnaCart", "", "", $ws_yui_js, '', 'IMGWorkspaceUserGuide.pdf' );
    }
    return @a;
}

#
# "$workspace_dir/public/$folder"
#
#
sub dispatch {
    my ( $self, $numTaxon ) = @_;
    return if ( !$enable_workspace );
    return if ( !$user_restricted_site );

    my $page = param("page");

    my $contact_oid = getContactOid();

    return if ( $contact_oid == 0 || $contact_oid < 1 || $contact_oid eq '901' );

    if ( $page eq 'makeScaffoldPublic' || paramMatch("makeScaffoldPublic") ne "" ) {

        makeScaffoldSetPublic();
        printPublicScaffoldSets();
    } elsif ( $page eq 'copyPublicScaffold' || paramMatch("copyPublicScaffold") ne "" ) {
        my @setnames = param('filename');
        my $filename = param('copyfilename');
        copyScaffoldSetPublic( $setnames[0], $filename );

    } elsif ( $page eq 'deleteScaffoldSet' || paramMatch("deleteScaffoldSet") ne "" ) {

        deleteScaffoldSet();
        printPublicScaffoldSets();

    } elsif ( $page eq 'showScaffoldDetail' ) {
        printScafSetDetail();
    } else {

        # show list of public sets
        printPublicScaffoldSets();
    }
}

#
# to be only used in ken ui and by ken
#
sub deleteScaffoldSet {
    my @setnames    = param('filename'); # set id
    my $super_user  = WebUtil::getSuperUser();
    my $contact_oid = getContactOid();
 
    # only ken can delete
    if ( $img_ken && isUserKen() ) {
        my $dbh = WebUtil::dbLogin();
        foreach my $filename (@setnames) {
            WebUtil::checkFileName($filename);

            # this also untaints the name
            $filename = WebUtil::validFileName($filename);

            my $filePath = "$public_workspace_dir/$SCAF_FOLDER/$filename";
            print "Deleting file: $filePath<br>\n";
            chmod 0644, $filePath;
            unlink $filePath or print "Cannot delete file $filePath<br>\n";
            
            my $sql = qq{
delete from public_set where set_id = ?
            };
            
            #print "sql $sql  ==== $filename<br>\n";
            
            my $cur = execSql( $dbh, $sql, $verbose,  $filename);
            $cur->finish();
        }
    } else {
        print "Oh no, you cannot do that!<br>\n";
    }
}

# print list of public scaffold sets
sub printPublicScaffoldSets {
    opendir( DIR, "$public_workspace_dir/$SCAF_FOLDER" )
      or WebUtil::webDie("failed to open folder list");
    my @files = readdir(DIR);
    closedir(DIR);

    print "<h1>Public Scaffolds / Bins List</h1>";

    printMainForm();
    print qq{
        <script type="text/javascript" src="$top_base_url/js/Workspace.js" >
        </script>
    };    
    
    printStatusLine( "Loading ...", 1 );

    my %metadata;
    my $sql = qq{
select p.set_id,
p.name, p.set_type, c.name, p.description, to_char(p.add_date, 'yyyy-mm-dd'), p.scaffold_count, 
p.domain, p.phylum, p.ir_class, p.ir_order, p.family, p.genus, p.species    
from public_set p, contact c
where p.contact_oid = c.contact_oid
    };
    my $dbh = WebUtil::dbLogin();
    my $cur = WebUtil::execSql( $dbh, $sql, $verbose );
    for ( ; ; ) {
        my (
            $setid, $name,   $set_type, $contact, $description, $add_date, $scaffold_count, $domain,
            $phylum, $ir_class, $ir_order,    $family,      $genus,    $species
        ) = $cur->fetchrow();

        last if ( !$setid );
        $metadata{$setid} =
"$name\t$set_type\t$contact\t$description\t$add_date\t$scaffold_count\t$domain\t$phylum\t$ir_class\t$ir_order\t$family\t$genus\t$species";

    }

    my $count = 0;

    my $itID = "PublicList";
    my $it   = new InnerTable( 1, "$itID$$", $itID, 0 );
    my $sd   = $it->getSdDelim();                          # sort delimiter

    $it->addColSpec("Select");
    $it->addColSpec( "Id", "asc", "right" );
    $it->addColSpec( "Name",                "asc",  "left" );
    $it->addColSpec( "Number of Scaffolds", "desc", "right" );
    $it->addColSpec( "Created By", "asc", "left" );
    $it->addColSpec( "Date",       "asc", "left" );
    $it->addColSpec( "Comments",   "asc", "left" );
    $it->addColSpec( "Type",   "asc", "left" );
    $it->addColSpec( "Domain",  "asc", "left" );
    $it->addColSpec( "Phylum",  "asc", "left" );
    $it->addColSpec( "Class",   "asc", "left" );
    $it->addColSpec( "Order",   "asc", "left" );
    $it->addColSpec( "Family",  "asc", "left" );
    $it->addColSpec( "Genus",   "asc", "left" );
    $it->addColSpec( "Species", "asc", "left" );

    foreach my $id (@files) {
        next if ( $id =~ /^\./ );
        
        my $line = $metadata{$id};
        my ($name, $set_type, $contact, $description, $add_date, $scaffold_count, $domain,
            $phylum, $ir_class, $ir_order,    $family,      $genus,    $species
        ) = split(/\t/, $line);
        

        my $cnt = $scaffold_count;#;WorkspaceUtil::getFileLineCount( $workspace_dir, 'public', $SCAF_FOLDER, $file );

        my $row;
        $row .= $sd . "<input type='checkbox' name='filename' value='$id' />\t";
        $row .= $id . $sd . $id . "\t";
        
        my $url = alink( "main.cgi?section=$section&page=showScaffoldDetail&filename=$id", $name );
        $row .= $name . $sd . $url . "\t";
        
        $row .= $cnt . $sd . $cnt . "\t";

        $row .= $contact . $sd . $contact . "\t";
        $row .= $add_date . $sd . $add_date . "\t";
        $row .= $description . $sd . $description . "\t";
        
        $row .= $set_type . $sd . $set_type . "\t";
        $row .= $domain . $sd . $domain . "\t";
        $row .= $phylum . $sd . $phylum . "\t";
        $row .= $ir_class . $sd . $ir_class . "\t";
        $row .= $ir_order . $sd . $ir_order . "\t";
        $row .= $family . $sd . $family . "\t";
        $row .= $genus . $sd . $genus . "\t";
        $row .= $species . $sd . $species . "\t";

        $it->addRow($row);
        $count++;
    }

    $it->printOuterTable(1);
    printStatusLine( "$count Loaded.", 2 );


    my @names = getListUsersScaffoldSetNames();
    my $userSetNames = "'" . join("','", @names) . "'";

    my $file = "$base_dir/copyPublicSet.html";
    my $template = HTML::Template->new( filename => $file );
        
    $template->param( userSetNames => $userSetNames );
    print $template->output;

    my $super_user  = WebUtil::getSuperUser();
    my $contact_oid = getContactOid();
    if ( $img_ken && isUserKen() ) {
        print qq{
         <br><br>
         Delete is only available on Ken's dev site and for IMG user(s): Ken and Amy
         <br>
     <input type="submit" onclick="return window.confirm('Are your sure?');" class="medbutton" value="Delete Public Set" name="_section_WorkspacePublicSet_deleteScaffoldSet">
     };
    }
    print end_form();

}

# user's set file ids
sub getSetIds {
    my ( $filename, $folder ) = @_;
    my $sid = getContactOid();
    my @ids = ();
    my $res = newReadFileHandle("$workspace_dir/$sid/$folder/$filename");
    while ( my $id = $res->getline() ) {
        chomp $id;
        next if ( $id eq "" );
        push( @ids, $id );
    }
    close $res;
    return \@ids;
}

# checks all scaffold oids are public - eg public genomes / metagenomes
sub checkAllIdsPublic {
    my ($ids_aref) = @_;

    my %genomeIds   = ();
    my %scaffoldIds = ();

    foreach my $id (@$ids_aref) {
        my ( $genome, $datatype, $scaffoldId ) = split( /\s+/, $id );
        if ($datatype) {

            # merfs
            $genomeIds{$genome} = $genome;
        } else {

            # db - which means $genome is the scaffold oid
            $scaffoldIds{$genome} = $genome;
        }
    }

    my $dbh      = WebUtil::dbLogin();
    my $nopublic = 0;

    my $size = keys %genomeIds;
    if ( $size > 0 ) {
        my @vals     = keys %genomeIds;
        my $inClause = OracleUtil::getTaxonIdsInClause( $dbh, @vals );
        my $sql      = qq{
select distinct t.taxon_oid, t.taxon_display_name
from taxon t
where t.IS_PUBLIC = 'No'
and t.taxon_oid in($inClause)
        };
        my $cur = execSql( $dbh, $sql, $verbose );

        for ( ; ; ) {
            my ( $toid, $name ) = $cur->fetchrow();
            last if !$toid;
            print "Not Public $toid $name <br>\n";
            $nopublic = 1;
        }
    }

    my $size = keys %scaffoldIds;
    if ( $size > 0 ) {
        my @vals     = keys %scaffoldIds;
        my $inClause = OracleUtil::getNumberIdsInClause( $dbh, @vals );
        my $sql      = qq{
select distinct t.taxon_oid, t.taxon_display_name
from taxon t, scaffold s
where t.taxon_oid = s.taxon 
and t.IS_PUBLIC = 'No'
and s.SCAFFOLD_OID in($inClause)
        };
        my $cur = execSql( $dbh, $sql, $verbose );
        for ( ; ; ) {
            my ( $toid, $name ) = $cur->fetchrow();
            last if !$toid;
            print "Not Public $toid $name <br>\n";
            $nopublic = 1;
        }

    }

    if ($nopublic) {
        WebUtil::webError("Some Genomes / Metagenomes are not public!");
    }

}

# PRE CHECKS
# - public set name format is correct
# - public set name is unique
# - public set oids are public
#
# - do copy to public folder
# - update databaset with metadata
sub makeScaffoldSetPublic {
    if(!isJGISuperUser()) {
        print "Only JGI supers users can make sets public.<br>\n";
        return;
    }
    
    my $publicSetName = strTrim(param('publicfilename'));
    my $comments      = strTrim(param('commentSet'));
    my $typeSet       = param('typeSet');
    my @scaffolSets   = param('filename');
    
    my $contact_oid   = getContactOid();
    my $domainSet     = strTrim(param('domainSet'));
    my $phylumSet     = strTrim(param('phylumSet'));
    my $irClassSet    = strTrim(param('irClassSet'));
    my $irOrderSet    = strTrim(param('irOrderSet'));
    my $familySet     = strTrim(param('familySet'));
    my $genusSet      = strTrim(param('genusSet'));
    my $speciesSet    = strTrim(param('speciesSet'));

    if($#scaffolSets < 0 ) {
        WebUtil::webError("Please select ONE scaffold set!");
    } elsif($#scaffolSets > 0) {
        WebUtil::webError("Please select ONLY ONE scaffold set!");
    }
    my $sourceSetname = $scaffolSets[0];

    if ( WebUtil::blankStr($comments) ) {
        WebUtil::webError("Comments cannot be blank!");
    }

    if ( WebUtil::blankStr($typeSet) ) {
        WebUtil::webError("Set type cannot be blank!");
    }
    
    #print "Set type: $typeSet<br>\n";

    my $dbh = WebUtil::dbLogin();
    my $nextId = getNextSetId($dbh);


    $nextId = inspectSaveToWorkspace( "public", $SCAF_FOLDER, $nextId );

    # check filename
    # valid chars
    WebUtil::checkFileName($publicSetName);

    # this also untaints the name
    $publicSetName = WebUtil::validFileName($publicSetName);
    
    

    # ids can be oid in database or ids from mer_fs
    my $ids_aref = getSetIds( $sourceSetname, $SCAF_FOLDER );

    checkAllIdsPublic($ids_aref);
    my $scaffoldCount = $#$ids_aref + 1;


    my $sourcefile      = "$workspace_dir/$contact_oid/$SCAF_FOLDER/$sourceSetname";
    my $destinationfile = "$public_workspace_dir/$SCAF_FOLDER/$nextId"; # the saved filename is the set id
    
    #print "copy $sourcefile to $destinationfile <br>\n";
    copy( $sourcefile, $destinationfile ) or WebUtil::webError("Copy failed: $!");
    chmod 0444, $destinationfile;    # read only

    # add metadata
    my $sql = qq{
insert into public_set 
(set_id, name, set_type, contact_oid, description, add_date, scaffold_count, 
domain, phylum, ir_class, ir_order, family, genus, species)
values (?, ?, ?, $contact_oid, ?, sysdate, $scaffoldCount,
?, ?, ?, ?,?,?,?)
    };

      my @data = ($nextId, $publicSetName, $typeSet, $comments, $domainSet, $phylumSet, 
      $irClassSet, $irOrderSet, $familySet, $genusSet, $speciesSet );
    
    my $cur = WebUtil::execSqlBind( $dbh, $sql, \@data, $verbose );
    $cur->finish();

    #print "Metadata updated<br>\n";
}

#
# gets next set id via oracle sequence
#
sub getNextSetId {
    my($dbh) = @_;
    
    # \@img_ext
    my $sql = qq{
        SELECT set_id_seq.nextval FROM dual
    };
    
    # temp soln until seq has been created
#    my $sql = qq{
#        select max(set_id) + 1 from public_set
#    };
#    
    my $cur = WebUtil::execSql( $dbh, $sql, $verbose );
    my ($nextId) = $cur->fetchrow();    
    $cur->finish();
    
    return $nextId;    
}

# PRE CHECK
# - user's set name format is correct
# - user's set name unique
#
# - do copy
#
# copy $workspace_dir/public/scaffold/$publicSetName
# to $workspace_dir/$contact_oid/scaffold/$validFilename
#
# what about copying multiple public sets
#
sub copyScaffoldSetPublic {
    my ( $publicSetName, $usersSetname ) = @_;
    my $contact_oid = getContactOid();

    my $validFilename = inspectSaveToWorkspace( $contact_oid, $SCAF_FOLDER, $usersSetname );

    my $sourcefile      = "$public_workspace_dir/$SCAF_FOLDER/$publicSetName";
    my $destinationfile = "$workspace_dir/$contact_oid/$SCAF_FOLDER/$validFilename";

    #print "copy $sourcefile to $destinationfile <br>\n";

    copy( $sourcefile, $destinationfile ) or WebUtil::webError("Copy failed: $!");

    print qq{
<script>
window.location = "main.cgi?section=WorkspaceScafSet&page=home";
</script>
    };
}

#
# pre checks the filename / set name to used
#
sub inspectSaveToWorkspace {
    my ( $sid, $folder, $filename ) = @_;

    $filename =~ s/\W+/_/g;

    if ( !$filename ) {
        WebUtil::webError("Please enter a workspace file name.");
    }

    # check filename
    # valid chars
    WebUtil::checkFileName($filename);

    # this also untaints the name
    $filename = WebUtil::validFileName($filename);

    # check if filename already exist
    if ( -e "$workspace_dir/$sid/$folder/$filename" ) {
        WebUtil::webError("File name $filename already exists. Please enter a new file name.");
    }

    return $filename;
}

#
# prints public bin / public scaffold set details
#
sub printScafSetDetail {
    my $filename = param("filename"); # set id
    my $folder   = $SCAF_FOLDER;

    # check filename
    if ( $filename eq "" ) {
        WebUtil::webError("Cannot read file.");
        return;
    }
    WebUtil::checkFileName($filename);

    # this also untaints the name
    $filename = WebUtil::validFileName($filename);

    my $tblname = "scafSet_" . "$filename";
    print start_form(
        -id     => "$tblname" . "_frm",
        -name   => "mainForm",
        -action => "$main_cgi"
    );


    my $sql = qq{
      select name from public_set where set_id = ?  
    };
    
    my $dbh = WebUtil::dbLogin();
    my $cur = WebUtil::execSql( $dbh, $sql, $verbose, $filename );
    my ($name) = $cur->fetchrow();    
    $name = escapeHTML($name);

    print qq{
        <h1>Public Scaffold Set</h1>
        <h2>Set Name: <i>$name</i></h2>
        Set Id: $filename<br>
    };

    my $full_path_name = "$public_workspace_dir/$folder/$filename";
    if ( !( -e $full_path_name ) ) {
        WebUtil::webError("Scaffold set does not exist.");
        return;
    }

    my %names;
    my @db_ids;
    my @meta_ids;

    my $row   = 0;
    my $trunc = 0;
    my $res   = newReadFileHandle($full_path_name);
    if ( !$res ) {
        WebUtil::webError("Scaffold set does not exist.");
        return;
    }

    while ( my $id = $res->getline() ) {

        # set a limit so that it won't crash web browser
        if ( $row >= WorkspaceUtil::getMaxWorkspaceView() ) {
            $trunc = 1;
            last;
        }
        chomp $id;
        next if ( !$id );

        $id = WebUtil::strTrim($id);
        $names{$id} = 0;
        if ( WebUtil::isInt($id) ) {
            push @db_ids, ($id);
        } else {
            push @meta_ids, ($id);
        }
        $row++;
    }
    close $res;
    print "<p>\n";


    my %taxon_scaf_h;
    my %taxon_name_h;
    my %taxon_gene_count_h;
    my %taxon_seq_length_h;
    my %taxon_gc_percent_h;

    if ( scalar(@db_ids) > 0 ) {
        my $db_str = OracleUtil::getNumberIdsInClause( $dbh, @db_ids );
        my $sql    = QueryUtil::getScaffoldDataSql($db_str);
        my $cur    = execSql( $dbh, $sql, $verbose );
        for ( ; ; ) {
            my (
                $scaffold_oid,       $scaffold_name, $ext_acc,    $taxon_oid,
                $seq_length,         $gc_percent,    $read_depth, $gene_count,
                $taxon_display_name, $genome_type

            ) = $cur->fetchrow();
            last if !$scaffold_oid;

            if ( !$scaffold_name ) {
                $scaffold_name = "hypothetical protein";
            }
            $names{$scaffold_oid} = $scaffold_name;
            if ($taxon_oid) {
                $taxon_scaf_h{$scaffold_oid} = $taxon_oid;
                $taxon_display_name .= " (*)"
                  if ( $genome_type eq "metagenome" );
                $taxon_name_h{$taxon_oid} = $taxon_display_name;
            }
            $taxon_gene_count_h{$scaffold_oid} = $gene_count;
            $taxon_seq_length_h{$scaffold_oid} = $seq_length;
            $taxon_gc_percent_h{$scaffold_oid} = $gc_percent;
        }
        $cur->finish();

        OracleUtil::truncTable( $dbh, "gtt_num_id" )
          if ( $db_str =~ /gtt_num_id/i );
    }

    if ( scalar(@meta_ids) > 0 ) {
        my %scaf_id_h;
        my %taxon_oid_h;
        for my $s_oid (@meta_ids) {
            $scaf_id_h{$s_oid} = 1;
            my ( $taxon3, $type3, $id3 ) = split( / /, $s_oid );
            if ( $type3 eq 'assembled' || $type3 eq 'unassembled' ) {
                $taxon_oid_h{$taxon3} = 1;
                $taxon_scaf_h{$s_oid} = $taxon3;
                if ( !$names{$s_oid} ) {
                    $names{$s_oid} = $id3;

                    #print "printScafSetDetail() $s_oid: $id3<br/>\n";
                }
            }
        }
        my @taxonOids = keys(%taxon_oid_h);

        if ( scalar(@taxonOids) > 0 ) {
            my ( $taxon_name_h0_ref, $genome_type_h0_ref ) =
              QueryUtil::fetchTaxonOid2NameGenomeTypeHash( $dbh, \@taxonOids );
            my %taxon_name_h0  = %$taxon_name_h0_ref;
            my %genome_type_h0 = %$genome_type_h0_ref;

            for my $taxon_oid (@taxonOids) {

                # taxon
                my $taxon_display_name = $taxon_name_h0{$taxon_oid};
                my $genome_type        = $genome_type_h0{$taxon_oid};

                $taxon_display_name .= " (*)"
                  if ( $genome_type eq "metagenome" );
                $taxon_name_h{$taxon_oid} = $taxon_display_name;
            }
        }

        my %scaffold_h;
        my @metaOids = keys %scaf_id_h;

# TODO test dot thread
printStartWorkingDiv();
require Command;
Command::startDotThread(240); # 20 minutes
        MetaUtil::getAllMetaScaffoldInfo( \%scaf_id_h, \@metaOids, \%scaffold_h );
 # TODO test dot thread
Command::killDotThread();
if($img_ken) {
    printEndWorkingDiv('', 1);
} else {
    printEndWorkingDiv();
}

        for my $s_oid (@metaOids) {
            my ( $taxon_oid, $data_type, $scaffold_oid ) =
              split( / /, $s_oid );    #$s_oid is $workspace_id
            if ( !exists( $taxon_name_h{$taxon_oid} ) ) {

                #$taxon_oid not in hash, probably due to permission
                webLog("ScaffoldCart::printIndex() $taxon_oid not retrieved from database, probably due to permission.");
                next;
            }

            my ( $seq_length, $gc_percent, $gene_count, $read_depth, @junks ) = split( /\t/, $scaffold_h{$s_oid} );

            #print "printScafSetDetail() $s_oid: $seq_length, $gc_percent, $gene_count, $read_depth, @junks<br/>\n";
            $taxon_gene_count_h{$s_oid} = $gene_count;
            $taxon_seq_length_h{$s_oid} = $seq_length;
            $taxon_gc_percent_h{$s_oid} = $gc_percent;
        }
    }

    my $it = new InnerTable( 1, "$tblname" . "$$", "$tblname", 1 );
    my $sd = $it->getSdDelim();
    $it->addColSpec("Select");
    $it->addColSpec( "Scaffold ID",              "char asc",   "left" );
    $it->addColSpec( "Scaffold Name",            "char asc",   "left" );
    $it->addColSpec( "Genome ID",                "number asc", "right" );
    $it->addColSpec( "Genome Name",              "char asc",   "left" );
    $it->addColSpec( "Gene Count",               "asc",        "right" );
    $it->addColSpec( "Sequence Length<br/>(bp)", "asc",        "right" );
    $it->addColSpec( "GC Content",               "asc",        "right" );

    my $can_select = 0;
    for my $id ( keys %names ) {
        my $r;
        my $url;

        if ( $names{$id} ) {
            $can_select++;
            my $chk = "";
            $r = $sd . "<input type='checkbox' name='scaffold_oid' value='$id' $chk /> \t";

            # determine URL
            my $display_id;
            my ( $t1, $d1, $g1 ) = split( / /, $id );
            if ( !$g1 && isInt($t1) ) {
                $display_id = $id;
                $url        = "$main_cgi?section=ScaffoldDetail" . "&page=scaffoldDetail&scaffold_oid=$t1";
            } else {
                $display_id = $g1;
                $url        = "$main_cgi?section=MetaScaffoldDetail&page=metaScaffoldDetail"
                  . "&taxon_oid=$t1&scaffold_oid=$g1&data_type=$d1";
            }

            if ($url) {
                $r .= $id . $sd . alink( $url, $display_id ) . "\t";
            } else {
                $r .= $id . $sd . $id . "\t";
            }
            $r .= $names{$id} . $sd . $names{$id} . "\t";

            my $t_oid;
            if ( $taxon_scaf_h{$id} ) {
                $t_oid = $taxon_scaf_h{$id};
                $r .= $t_oid . $sd . $t_oid . "\t";

                my $taxon_name = $taxon_name_h{$t_oid};
                my $taxon_url;
                if ( !$g1 && isInt($t1) ) {
                    $taxon_url = "$main_cgi?section=TaxonDetail" . "&page=taxonDetail&taxon_oid=$t_oid";
                } else {
                    $taxon_name = HtmlUtil::appendMetaTaxonNameWithDataType( $taxon_name, $d1 );
                    $taxon_url = "$main_cgi?section=MetaDetail" . "&page=metaDetail&taxon_oid=$t_oid&";
                }
                my $exported_taxon_name = $t_oid;
                if ($taxon_name) {
                    $exported_taxon_name = $taxon_name;
                }
                $r .= $exported_taxon_name . $sd . "<a href=\"$taxon_url\" >" . $taxon_name . "</a> \t";
            } else {
                $r .= "-" . $sd . "-" . "\t";
            }

            my $gene_count = $taxon_gene_count_h{$id};
            if ($gene_count) {
                my $url3;
                if ( !$g1 && isInt($t1) ) {
                    $url3 = "$main_cgi?section=ScaffoldDetail" . "&page=scaffoldGenes" . "&scaffold_oid=$display_id";
                } else {
                    $url3 =
                        "$main_cgi?section=MetaScaffoldDetail"
                      . "&page=metaScaffoldGenes&scaffold_oid=$display_id"
                      . "&taxon_oid=$t_oid";
                }
                $r .= $gene_count . $sd . alink( $url3, $gene_count ) . "\t";
            } else {
                if ( ( !$g1 && isInt($t1) ) || $d1 eq 'assembled' ) {
                    $r .= "0" . $sd . "0" . "\t";
                } else {
                    $r .= $sd . "\t";
                }
            }

            my $seq_length = $taxon_seq_length_h{$id};
            if ($seq_length) {
                my $scaf_len_url;
                if ( !$g1 && isInt($t1) ) {
                    $scaf_len_url =
                        "$main_cgi?section=ScaffoldGraph"
                      . "&page=scaffoldGraph&scaffold_oid=$display_id"
                      . "&taxon_oid=$t_oid"
                      . "&start_coord=1&end_coord=$seq_length"
                      . "&seq_length=$seq_length";
                } else {
                    $scaf_len_url =
                        "$main_cgi?section=MetaScaffoldGraph"
                      . "&page=metaScaffoldGraph&scaffold_oid=$display_id"
                      . "&taxon_oid=$t_oid&data_type=$d1"
                      . "&start_coord=1&end_coord=$seq_length"
                      . "&seq_length=$seq_length";
                }
                $r .= $seq_length . $sd . alink( $scaf_len_url, $seq_length ) . "\t";
            } else {
                if ( ( !$g1 && isInt($t1) ) || $d1 eq 'assembled' ) {
                    $r .= "0" . $sd . "0" . "\t";
                } else {
                    $r .= $sd . "\t";
                }
            }

            my $gc_percent = $taxon_gc_percent_h{$id};
            if ($gc_percent) {
                $gc_percent = sprintf( " %.2f", $gc_percent );
            }
            $r .= $gc_percent . $sd . $gc_percent . "\t";

        } else {

            # not in database
            $r = $sd . " \t" . $id . $sd . $id . "\t" . "(not in this database)" . $sd . "(not in this database)" . "\t";
            $r .= $sd . "\t";
            $r .= "-" . $sd . "-" . "\t";
            $r .= $sd . "\t";
            $r .= $sd . "\t";
        }

        $it->addRow($r);
    }

    $it->printOuterTable(1);

    my $load_msg = "Loaded $row";
    if ( $can_select <= 0 ) {
        $load_msg .= "; none in this database.";
    } elsif ( $can_select < $row ) {
        $load_msg .= "; only $can_select selectable.";
    } else {
        $load_msg .= ".";
    }
    if ($trunc) {
        $load_msg .= " (additional rows truncated)";
    }
    $load_msg = "Loaded";

    printStatusLine( $load_msg, 2 );

    WebUtil::printScaffoldCartFooterInLineWithToggle($tblname);
    print end_form();
}

#
# get distinct list of all domain names
#
sub getCVDomain {
    my ($dbh) = @_;
    my $sql = qq{
        select distinct domain
        from taxon
        order by 1
    };
    my $cur = execSql( $dbh, $sql, $verbose );
    my @data;
    for ( ; ; ) {
        my ($name) = $cur->fetchrow();
        last if ( !$name );

        push( @data, $name );
    }
    $cur->finish();
    return \@data;
}

#
# prints html select's options
#
sub makeOption {
    my ($domain_aref) = @_;
    my $str = "";
    foreach my $x (@$domain_aref) {
        if($x eq 'Bacteria') {
            $str .= "<option value='$x' selected>$x</option>\n";
        } else {
            $str .= "<option value='$x'>$x</option>\n";
        }
    }
    return $str;
}


#
# for jgi super user's workspace scaffold set
# prints make public section
#
sub printMakeScaffoldSetPublic {
    if(isJGISuperUser()) {
        my $dbh = WebUtil::dbLogin();
        my $domain_aref = getCVDomain($dbh);
        my $domainStr = makeOption($domain_aref);
        
        #my @names = getListPublicScaffoldSetNames();
        #my $namesStr = "'" . join("','", @names) . "'";
        my $namesStr = "' '";
        
        my $file = "$base_dir/makeMySetPublic.html";
        my $template = HTML::Template->new( filename => $file );
        
        $template->param( setNames => $namesStr );
        $template->param( domainOption => $domainStr );
        
        print $template->output;
    }    
}

#
# gets list of public set names
#
sub getListPublicScaffoldSetNames {
    opendir( DIR, "$public_workspace_dir/$SCAF_FOLDER" )
        or WebUtil::webDie("failed to open folder list");
    my @files = readdir(DIR);
    closedir(DIR);

    my @names = ();
    for my $name ( sort @files ) {
        if ( $name ne "." && $name ne ".." ) {
            push @names, ($name);
        }
    }
    return @names;    
}

#
# gets list of user's scaffold sets names
#
# return an array
#
sub getListUsersScaffoldSetNames {
   return Workspace::getDataSetNames($SCAF_FOLDER);
}


#
# is user a JGI user and a super user
#
sub isJGISuperUser {
    my $super_user = WebUtil::getSuperUser();
    my $jgi_user = getSessionParam("jgi_user");
    
    if($super_user eq "Yes" && $jgi_user eq 'Yes') {
        return 1;
    } else {
        return 0;
    }
}


#
# is user Ken or Amy
#
sub isUserKen {
    my $contact_oid = getContactOid();
    my $super_user  = WebUtil::getSuperUser();
    
    # 3038 - ken
    # 312 - Amy
    if($contact_oid eq '3038' || $contact_oid eq '312') {
        return 1; 
    } else {
        return 0;
    }
}

1;
