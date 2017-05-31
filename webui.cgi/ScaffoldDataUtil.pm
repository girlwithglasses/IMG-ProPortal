############################################################################
# Utility subroutines for fetching scaffold data etc
# $Id: ScaffoldDataUtil.pm 35780 2016-06-15 20:41:20Z klchu $
############################################################################
package ScaffoldDataUtil;

use strict;
use CGI qw( :standard );
use Data::Dumper;
use DBI;
use WebConfig;
use WebUtil;
use OracleUtil;
use QueryUtil;
use MetaUtil;

$| = 1;

my $env      = getEnv();
my $main_cgi = $env->{main_cgi};
my $verbose  = $env->{verbose};
my $base_url = $env->{base_url};
my $YUI      = $env->{yui_dir_28};
my $in_file  = $env->{in_file};
my $user_restricted_site = $env->{user_restricted_site};


############################################################################    
#  getTaxonCrisprList     
############################################################################    
sub getTaxonCrisprList {
    my ( $dbh, $taxon_oid, $scaffolds_ref ) = @_;   
        
    my @recs;   
    if ( ! OracleUtil::isTableExist( $dbh, "taxon_crispr_summary" ) ) {     
        return (@recs);             
    }   
    
    my $scaffoldClause;     
    if ( $scaffolds_ref && scalar(@$scaffolds_ref) > 0 ) {  
        my $ids_str = OracleUtil::getFuncIdsInClause( $dbh, @$scaffolds_ref );  
        $scaffoldClause = "and tc.contig_id in ( $ids_str ) ";  
    }   
        
    my $rclause   = WebUtil::urClause('tc.taxon_oid');  
    my $imgClause = WebUtil::imgClauseNoTaxon('tc.taxon_oid');  
    my $sql       = qq{     
        select tc.contig_id, tc.start_coord, tc.end_coord, tc.crispr_no     
        from taxon_crispr_summary tc    
        where tc.taxon_oid = ?  
        $scaffoldClause     
        $rclause    
        $imgClause  
    };  
    #print "getTaxonCrisprList() sql=$sql<br/>\n";  
    my $cur = execSql( $dbh, $sql, $verbose, $taxon_oid );  
    
    for ( ; ; ) {   
        my ( $contig_id, $start, $end, $crispr_no ) = $cur->fetchrow();     
        last if !$contig_id;    
            
        my $rec;    
        $rec .= "$contig_id\t";     
        $rec .= "$start\t";     
        $rec .= "$end\t";   
        $rec .= "$crispr_no";   
        push( @recs, $rec );    
    }   
    $cur->finish();     
    
    OracleUtil::truncTable( $dbh, "gtt_func_id" )   
        if ( $scaffoldClause =~ /gtt_func_id/i );           
    
    return (@recs);     
}   

############################################################################    
#  getScaffoldCrisprList     
############################################################################    
sub getScaffoldCrisprList {
    my ( $dbh, $scaffold_oid, $scf_start_coord, $scf_end_coord ) = @_;   
        
    my @recs;   
    if ( ! OracleUtil::isTableExist( $dbh, "taxon_crispr_summary" ) ) {     
        return (@recs);             
    }   
    
    my $rclause   = WebUtil::urClause('tcs.taxon_oid');  
    my $imgClause = WebUtil::imgClauseNoTaxon('tcs.taxon_oid');
    my $sql = qq{
        select distinct tcs.contig_id, tcs.start_coord, tcs.end_coord, tcs.crispr_no
        from taxon_crispr_summary tcs, scaffold s
        where s.scaffold_oid = ?
        and s.taxon = tcs.taxon_oid
        and s.ext_accession = tcs.contig_id
        and ( tcs.end_coord - tcs.start_coord ) > 50
        and( ( tcs.start_coord > ? and
               tcs.end_coord < ? ) or
            ( ? <= tcs.start_coord and
           tcs.start_coord <= ? ) or
            ( ? <= tcs.end_coord and
           tcs.end_coord <= ? )
        )
        $rclause    
        $imgClause  
    };
    #print "getScaffoldCrisprList() sql: $sql<br/>\n";
    my $cur = execSql(
        $dbh,           $sql,             $verbose,       $scaffold_oid,    $scf_start_coord,
        $scf_end_coord, $scf_start_coord, $scf_end_coord, $scf_start_coord, $scf_end_coord
    );
    for ( ; ; ) {   
        my ( $contig_id, $start, $end, $crispr_no ) = $cur->fetchrow();     
        last if !$contig_id;    
            
        my $rec;    
        $rec .= "$contig_id\t";     
        $rec .= "$start\t";     
        $rec .= "$end\t";   
        $rec .= "$crispr_no";   
        push( @recs, $rec );    
    }   
    $cur->finish();
    
    return (@recs);     
}   


############################################################################
# addNxFeatures - Add feature on scaffold panel for long strings
#   of N's and X's.
#   Inputs:
#     dbh - database handle
#     scaffold_oid - scaffold object identifer
#     scf_panel - scaffold panel handle
#     panelStrand - panel strand orientation
#     scf_start_coord - scaffold start coorindate
#     scf_end_coord - scaffold end coordinate
############################################################################
sub addNxFeatures {
    my ( $dbh, $scaffold_oid, $scf_panel, $panelStrand, $scf_start_coord, $scf_end_coord ) = @_;
    my $sql = qq{
       select distinct ft.scaffold_oid, ft.start_coord, ft.end_coord
       from scaffold_nx_feature ft
       where ft.scaffold_oid = ?
       and ft.seq_length > 500
       and( ( ft.start_coord > ? and
               ft.end_coord < ? ) or
            ( ? <= ft.start_coord and
           ft.start_coord <= ? ) or
            ( ? <= ft.end_coord and
           ft.end_coord <= ? )
       )
   };
    my $cur = execSql(
        $dbh,           $sql,             $verbose,       $scaffold_oid,    $scf_start_coord,
        $scf_end_coord, $scf_start_coord, $scf_end_coord, $scf_start_coord, $scf_end_coord
    );
    my $count = 0;
    for ( ; ; ) {
        my ( $scaffold_oid, $start_coord, $end_coord ) = $cur->fetchrow();
        last if !$scaffold_oid;
        $count++;
        $scf_panel->addNxBrackets( $start_coord, $end_coord, $panelStrand );
    }
    $cur->finish();
    webLog "$count features found\n" if $verbose >= 3;
}

############################################################################
# addRepeats -  Mark crispr and other repeat features.
#   Inputs:
#     dbh - database handle
#     scaffold_oid - scaffold object identifer
#     scf_panel - scaffold panel handle
#     panelStrand - panel strand orientation
#     scf_start_coord - scaffold start coorindate
#     scf_end_coord - scaffold end coordinate
############################################################################
sub addRepeats {
    my ( $dbh, $scaffold_oid, $scf_panel, $panelStrand, $scf_start_coord, $scf_end_coord ) = @_;

    my $sql = qq{
       select distinct sr.start_coord, sr.end_coord, sr.n_copies, sr.type
       from scaffold_repeats sr
       where sr.scaffold_oid = ?
       and ( sr.end_coord - sr.start_coord ) > 50
       and( ( sr.start_coord > ? and
               sr.end_coord < ? ) or
            ( ? <= sr.start_coord and
           sr.start_coord <= ? ) or
            ( ? <= sr.end_coord and
           sr.end_coord <= ? )
       )
       and sr.type != 'CRISPR'
       and sr.type != 'crispr'
    };
    #print "addRepeats() sql: $sql<br/>\n";
    my $cur = execSql(
        $dbh,           $sql,             $verbose,       $scaffold_oid,    $scf_start_coord,
        $scf_end_coord, $scf_start_coord, $scf_end_coord, $scf_start_coord, $scf_end_coord
    );    
    my $count = 0;
    for ( ; ; ) {
        my ( $start_coord, $end_coord, $n_copies, $type ) = $cur->fetchrow();
        last if !$start_coord;
        $count++;
        #if ( $type eq "crispr" || $type eq "CRISPR" ) {
        #    $scf_panel->addCrispr( $start_coord, $end_coord, $panelStrand, $n_copies );
        #}
    }
    $cur->finish();
    
    my $crisprCount = addCrisprRepeats( $dbh, $scaffold_oid, $scf_panel, $panelStrand, $scf_start_coord, $scf_end_coord );
    $count += $crisprCount;
    
    #print "$count repeats found<br/>\n";
    #webLog "$count repeats found\n" if $verbose >= 1;
    
    return $count;
}


############################################################################
# addCrisprRepeats -  Mark crispr repeat features.
#   Inputs:
#     dbh - database handle
#     scaffold_oid - scaffold object identifer
#     scf_panel - scaffold panel handle
#     panelStrand - panel strand orientation
#     scf_start_coord - scaffold start coorindate
#     scf_end_coord - scaffold end coordinate
############################################################################
sub addCrisprRepeats {
    my ( $dbh, $scaffold_oid, $scf_panel, $panelStrand, $scf_start_coord, $scf_end_coord ) = @_;

    my @recs = getScaffoldCrisprList( $dbh, $scaffold_oid, $scf_start_coord, $scf_end_coord );

    my $count = 0;
    for my $rec ( @recs ) {
        my ( $contig_id, $sr_start, $sr_end, $crispr_no ) = split(/\t/, $rec);
        $scf_panel->addCrispr( $sr_start, $sr_end, $panelStrand, $crispr_no );
        $count++;
    }

    return $count;
}

#############################################################################
# addMetaCrisprRepeats
#############################################################################
sub addMetaCrisprRepeats {
    my (
        $taxon_oid,   $data_type, $scaffold_oid,    $scf_panel,
        $panelStrand, $scf_start_coord, $scf_end_coord
      )
      = @_;
    
    #print "addMetaCrisprRepeats() taxon_oid=$taxon_oid, scaffold_oid=$scaffold_oid<br/>\n";
    #print "addMetaCrisprRepeats() scf_start_coord=$scf_start_coord, scf_end_coord=$scf_end_coord<br/>\n";

    my @recs = MetaUtil::getMetaScaffoldCrisprList( $taxon_oid, $data_type, 
        $scaffold_oid, $scf_start_coord, $scf_end_coord );

    my $count = 0;
    for my $rec ( @recs ) {
        my ( $contig_id, $sr_start, $sr_end, $crispr_no ) = split(/\t/, $rec);
        $scf_panel->addCrispr( $sr_start, $sr_end, $panelStrand, $crispr_no );
        $count++;
    }

    return $count;    
}

############################################################################
# addIntergenic -  Mark intergenic regions.
#   Inputs:
#     dbh - database handle
#     scaffold_oid - scaffold object identifer
#     scf_panel - scaffold panel handle
#     panelStrand - panel strand orientation
#     scf_start_coord - scaffold start coorindate
#     scf_end_coord - scaffold end coordinate
############################################################################
sub addIntergenic {
    my ( $dbh, $scaffold_oid, $scf_panel, $panelStrand, $scf_start_coord, $scf_end_coord ) = @_;

    #return if !$img_internal;

    my $sql = qq{
       select distinct ig.start_coord, ig.end_coord
       from dt_intergenic ig
       where ig.scaffold_oid = ?
       and( ( ig.start_coord > ? and
               ig.end_coord < ? ) or
            ( ? <= ig.start_coord and
           ig.start_coord <= ? ) or
            ( ? <= ig.end_coord and
           ig.end_coord <= ? )
       )
   };
    my $cur = execSql(
        $dbh,           $sql,             $verbose,       $scaffold_oid,    $scf_start_coord,
        $scf_end_coord, $scf_start_coord, $scf_end_coord, $scf_start_coord, $scf_end_coord
    );
    my $count = 0;
    for ( ; ; ) {
        my ( $start_coord, $end_coord ) = $cur->fetchrow();
        last if !$start_coord;
        $count++;
        $scf_panel->addIntergenic( $scaffold_oid, $start_coord, $end_coord, $panelStrand );
    }
    $cur->finish();
    webLog "$count intergenic found\n" if $verbose >= 3;
}

############################################################################
# getScaffoldRepeatsSql
############################################################################
sub getScaffoldRepeatsSql {
    
    my $sql = qq{
        select sr.scaffold_oid, sr.start_coord, sr.end_coord, sr.type
        from scaffold_repeats sr
        where sr.scaffold_oid = ?
    };
    #order by sr.start_coord
    
    return $sql;
}

############################################################################
# getScaffoldCrisprRepeatsSql
############################################################################
sub getScaffoldCrisprRepeatsSql {
    
    my $sql = qq{
        select s.scaffold_oid, tcs.start_coord, tcs.end_coord
        from taxon_crispr_summary tcs, scaffold s
        where tcs.taxon_oid = s.taxon
        and s.scaffold_oid = ?
    };
    #order by tcs.start_coord
    
    return $sql;
}

############################################################################
# getScaffoldCrisprDetail
############################################################################
sub getScaffoldCrisprDetail {
    my ( $dbh, $scaffold_oid, $scf_start_coord, $scf_end_coord ) = @_;

    my $cur;
    if ( $scf_start_coord || $scf_end_coord ) {
        my $sql = qq{
            select distinct tcs.contig_id, tcs.crispr_no, tcs.start_coord, tcs.end_coord, tcd.pos, tcd.repeat_seq, tcd.spacer_seq
            from taxon_crispr_summary tcs, taxon_crispr_details tcd, scaffold s
            where s.scaffold_oid = ?
            and s.taxon = tcs.taxon_oid
            and s.ext_accession = tcs.contig_id
            and tcs.contig_id = tcd.contig_id
            and tcs.crispr_no = tcd.crispr_no
            and ( tcs.end_coord - tcs.start_coord ) > 50
            and( ( tcs.start_coord > ? and
                   tcs.end_coord < ? ) or
                ( ? <= tcs.start_coord and
               tcs.start_coord <= ? ) or
                ( ? <= tcs.end_coord and
               tcs.end_coord <= ? )
            )
            order by tcs.contig_id, tcs.crispr_no, tcd.pos
        };
        #print "getScaffoldCrisprDetail() in range sql: $sql<br/>\n";
        $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid, $scf_start_coord,
            $scf_end_coord, $scf_start_coord, $scf_end_coord, $scf_start_coord, $scf_end_coord );        
    }
    else {
        my $sql = qq{
            select distinct tcs.contig_id, tcs.crispr_no, tcs.start_coord, tcs.end_coord, tcd.pos, tcd.repeat_seq, tcd.spacer_seq
            from taxon_crispr_summary tcs, taxon_crispr_details tcd, scaffold s
            where s.scaffold_oid = ?
            and s.taxon = tcs.taxon_oid
            and s.ext_accession = tcs.contig_id
            and tcs.contig_id = tcd.contig_id
            and tcs.crispr_no = tcd.crispr_no
            order by tcs.contig_id, tcs.crispr_no, tcd.pos
        };
        #print "getScaffoldCrisprDetail() sql: $sql<br/>\n";
        $cur = execSql( $dbh, $sql, $verbose, $scaffold_oid );    
    }
    
    my @recs;
    for ( ; ; ) {
        my ( $contig_id, $crispr_no, $start_coord, $end_coord, $pos, $repeat_seq, $spacer_seq ) =
          $cur->fetchrow();
        last if !$contig_id;

        my $rec;
        $rec .= "$contig_id\t";
        $rec .= "$crispr_no\t";
        $rec .= "$start_coord\t";
        $rec .= "$end_coord\t";
        $rec .= "$pos\t";
        $rec .= "$repeat_seq\t";
        $rec .= "$spacer_seq";
        push(@recs, $rec);
    }
    
    return @recs;
}

############################################################################
# printScaffoldCrisprDetailTable
############################################################################
sub printScaffoldCrisprDetailTable {
    my ( @recs ) = @_;

    print "<h2>CRISPR Detail</h2>\n";

    ### BEGIN static YUI table ###
    my $it = new StaticInnerTable();
    my $sd = $it->getSdDelim();
    $it->addColSpec("CRISPR Number",    "asc", "right");
    $it->addColSpec("Start Coordinate", "asc", "right");
    $it->addColSpec("End Coordinate",   "asc", "right");
    $it->addColSpec("Position",         "asc", "right");
    $it->addColSpec("Repeat Sequence",  "asc", "left");
    $it->addColSpec("Spacer Sequence",  "asc", "left");

    for my $rec (@recs) {
        my ( $contig_id, $crispr_no, $start_coord, $end_coord, $pos, $repeat_seq, $spacer_seq )
          = split( /\t/, $rec );

        my $row;
        $row .= "$crispr_no\t";
        $row .= "$start_coord\t";
        $row .= "$end_coord\t";
        $row .= "$pos\t";
        $row .= "$repeat_seq\t";
        $row .= "$spacer_seq\t";
        $it->addRow($row);
    }
    $it->printTable();
    ### END static YUI table ###

}


1;
