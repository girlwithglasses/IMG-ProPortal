############################################################################
# Utility subroutines for fetching gene data
# $Id: GeneDataUtil.pm 35780 2016-06-15 20:41:20Z klchu $
############################################################################
package GeneDataUtil;

use strict;
use CGI qw( :standard );
use Data::Dumper;
use DBI;
use WebConfig;
use WebUtil;
use OracleUtil;
use QueryUtil;
use GeneTableConfiguration;
use MetaUtil;

$| = 1;

my $env      = getEnv();
my $main_cgi = $env->{main_cgi};
my $verbose  = $env->{verbose};
my $base_url = $env->{base_url};
my $YUI      = $env->{yui_dir_28};
my $in_file  = $env->{in_file};
my $user_restricted_site = $env->{user_restricted_site};

my $dDelim = "===";
my $fDelim = "<<>>";

############################################################################
# flushGeneBatch  - Flush one batch.
############################################################################
sub flushGeneBatch {
    my (
         $fixedColIDs, $recs, $dbh, 
         $batch_gene_oids_ref, $goid2BatchIds_ref, $batch_id_new, $outColClause,   
         $taxonJoinClause,$scfJoinClause, $ssJoinClause, 
         $get_gene_tmh,   $get_gene_sig,
         $cogQueryClause, $pfamQueryClause, $tigrfamQueryClause, 
         $ecQueryClause,  $koQueryClause,   $imgTermQueryClause, 
         $projectMetadataCols_ref, $outputCol_ref, $needNewRecs
      )
      = @_;

    my $recsNum = scalar(keys %$recs);
    #print "flushGeneBatch() 0 recsNum=$recsNum<br/>\n";
    if ( $recsNum && $recsNum > CartUtil::getMaxDisplayNum() ) {
        return '';        
    }

    #print "GeneDataUtil::flushGeneBatch() outColClause: $outColClause<br/>\n";
    #print "GeneDataUtil::flushGeneBatch() outputCol_ref: @$outputCol_ref<br/>\n";

    if ( ! $batch_gene_oids_ref || scalar(@$batch_gene_oids_ref) == 0 ) {
        return '';
    }

    webLog "flushGeneBatch() " . currDateTime() . "\n" if $verbose >= 1;

    my $gidInClause = OracleUtil::getIdClause( $dbh, 'gtt_num_id', '', $batch_gene_oids_ref );

    my $gene2tmh_href = getGene2Tmh
        ($dbh, $batch_gene_oids_ref, $get_gene_tmh, $gidInClause);

    my $gene2sig_href = getGene2Sig
        ($dbh, $batch_gene_oids_ref, $get_gene_sig, $gidInClause);

    my $gene2cogs_href = getGene2Cog
        ($dbh, $batch_gene_oids_ref, $cogQueryClause, $gidInClause);

    my $gene2pfams_href = getGene2Pfam
        ($dbh, $batch_gene_oids_ref, $pfamQueryClause, $gidInClause);

    my $gene2tigrfams_href = getGene2Tigrfam
        ($dbh, $batch_gene_oids_ref, $tigrfamQueryClause, $gidInClause);

    my $gene2ecs_href = getGene2Ec
        ($dbh, $batch_gene_oids_ref, $ecQueryClause, $gidInClause);

    my $gene2kos_href = getGene2Ko
        ($dbh, $batch_gene_oids_ref, $koQueryClause, $gidInClause);

    my $gene2imgTerms_href = getGene2Term
        ($dbh, $batch_gene_oids_ref, $imgTermQueryClause, $gidInClause);

    my ($gene2taxonInfo_href, $taxon2metaInfo_href)
        = getGene2TaxonInfo($dbh, $batch_gene_oids_ref, $gidInClause);

    my $taxon_metadata_href;
    if ( $projectMetadataCols_ref && scalar(@$projectMetadataCols_ref) > 0 ) {
        $taxon_metadata_href = getTaxon2projectMetadataInfo($taxon2metaInfo_href);
        $gidInClause = OracleUtil::getIdClause( $dbh, 'gtt_num_id', '', $batch_gene_oids_ref );    
    }

    webLog "gene query " . currDateTime() . "\n" if $verbose >= 1;

    my $scf_ext_accession_idx = -1;
    my @outCols               = ();
    if ( $outputCol_ref ne '' ) {
        @outCols = @$outputCol_ref;
        for ( my $i = 0 ; $i < scalar(@outCols) ; $i++ ) {
            if ( $outCols[$i] eq 'ext_accession' ) {
                $scf_ext_accession_idx = $i;
                last;
            }
        }
    }

    my %scaffold2Bin;
    if ( $scf_ext_accession_idx >= 0 ) {
        my $sql = qq{
            select distinct bs.scaffold, b.bin_oid, b.display_name
            from gene g, bin_scaffolds bs, bin b
            where g.gene_oid $gidInClause
            and g.scaffold = bs.scaffold
            and bs.bin_oid = b.bin_oid
            order by bs.scaffold, b.display_name
        };
        my $cur = execSql( $dbh, $sql, $verbose );
        for ( ; ; ) {
            my ( $scaffold, $bin_oid, $bin_display_name ) = $cur->fetchrow();
            last if !$scaffold;
            $scaffold2Bin{$scaffold} .= " $bin_display_name;";
        }
        $cur->finish();
    }

    my $sql = qq{
        select distinct g.gene_oid, g.locus_type, g.locus_tag,
            g.gene_symbol, g.gene_display_name, g.scaffold
            $outColClause
        from gene g
        $taxonJoinClause
        $scfJoinClause
        $ssJoinClause
        where g.gene_oid $gidInClause
        order by g.gene_oid
    };
    #print "GeneDataUtil::flushGeneBatch() sql: $sql<br/>\n";
    my $cur = execSql( $dbh, $sql, $verbose );

    for ( ; ; ) {
        my (
             $gene_oid, $locus_type, $locus_tag, $gene_symbol, $gene_display_name,
             $scaffold, @outColVals
          )
          = $cur->fetchrow();
        last if !$gene_oid;

        my $batch_id = $batch_id_new;
        if ( $batch_id eq '' && $goid2BatchIds_ref && defined($goid2BatchIds_ref) ) {
            $batch_id = $goid2BatchIds_ref->{$gene_oid};
        }

        my $desc = $gene_display_name;
        $desc = "($locus_type $gene_symbol)" if $locus_type =~ /RNA/;
        my $desc_orig = $desc;

        my $r = "$gene_oid\t";
        $r .= "$locus_tag\t";
        $r .= "$desc\t";
        $r .= "$desc_orig\t";

        my $taxon_info = $gene2taxonInfo_href->{$gene_oid};
        my ($taxon_oid, $taxon_display_name) = split(/\t/, $taxon_info);
        $r .= "$taxon_oid\t";
        $r .= "$taxon_display_name\t";
        $r .= "$batch_id\t";
        $r .= "$scaffold\t";

        #print "GeneDataUtil::flushGeneBatch() outColVals: @outColVals<br/>\n";
        for ( my $j = 0 ; $j < scalar(@outColVals) ; $j++ ) {
            if ( $scf_ext_accession_idx >= 0 && $scf_ext_accession_idx == $j ) {
                my $scf_ext_accession = $outColVals[$j];
                my $bin_display_names = $scaffold2Bin{$scaffold};
                chop $bin_display_names;
                $scf_ext_accession .= " (bin(s):$bin_display_names)"
                  if $bin_display_names ne "";
                $r .= "$scf_ext_accession\t";
            } elsif ( $outColVals[$j] eq GeneTableConfiguration::getFeatureType() ) {
                my $val = $gene2tmh_href->{$gene_oid};
                $r .= "$val\t";
            } elsif ( $outColVals[$j] eq GeneTableConfiguration::getSigPeptides() ) {
                my $val = $gene2sig_href->{$gene_oid};
                $r .= "$val\t";
            } else {
                $r .= "$outColVals[$j]\t";
            }
        }

        if ($cogQueryClause) {
            my $val = $gene2cogs_href->{$gene_oid};
            $r .= "$val\t\t";
        }

        if ($pfamQueryClause) {
            my $val = $gene2pfams_href->{$gene_oid};
            $r .= "$val\t\t";
        }

        if ($tigrfamQueryClause) {
            my $val = $gene2tigrfams_href->{$gene_oid};
            $r .= "$val\t\t";
        }

        if ($ecQueryClause) {
            my $val = $gene2ecs_href->{$gene_oid};
            $r .= "$val\t\t";
        }

        if ($koQueryClause) {
            my $val = $gene2kos_href->{$gene_oid};
            $r .= "$val\t\t\t";
        }

        if ($imgTermQueryClause) {
            my $val = $gene2imgTerms_href->{$gene_oid};
            $r .= "$val\t";
        }

        #project metadata
        if ( $projectMetadataCols_ref && scalar(@$projectMetadataCols_ref) > 0 ) {
            my $sub_href = $taxon_metadata_href->{$taxon_oid};
            foreach my $col (@$projectMetadataCols_ref) {
                my $val = $sub_href->{$col};
                $val = GenomeList::cellValueEscape($val);
                $r .= "$val\t";
            }            
        }

        $recs->{$gene_oid} = $r;
        $recsNum = scalar(keys %$recs);
        if ( !$needNewRecs && $recsNum >= CartUtil::getMaxDisplayNum() ) {
            last;
        }
    }

    OracleUtil::truncTable( $dbh, "gtt_num_id" )
      if ( $gidInClause =~ /gtt_num_id/i );
    webLog "gene query done " . currDateTime() . "\n" if $verbose >= 1;
    #print "flushGeneBatch() 1 recsNum=$recsNum<br/>\n";

    my $colIDs = $fixedColIDs;
    foreach my $col (@outCols) {
        $colIDs .= "$col,";
    }

    return $colIDs;
}

sub getGene2Tmh {
    my ($dbh, $gene_oids_aref, $get_gene_tmh, $gidInClause) = @_;

    my %gene2tmh;
    return \%gene2tmh if (!$get_gene_tmh || $get_gene_tmh eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $tmh_sql = qq{
      select gene_oid, count(*)
      from gene_tmhmm_hits
      where gene_oid $gidInClause
      and feature_type = 'TMhelix'
      group by gene_oid
    };
    #print "getGene2Tmh() tmh_sql: $tmh_sql<br/>\n";

    my $cur = execSql($dbh, $tmh_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, $val) = $cur->fetchrow();
        last if !$gene_oid;
        $gene2tmh{$gene_oid} = $val;
    }
    $cur->finish();
    #print "getGene2Tmh() gene2tmh:<br/>\n";
    #print Dumper(\%gene2tmh);
    #print "<br/>\n";

    return \%gene2tmh;
}

sub getGene2Sig {
    my ($dbh, $gene_oids_aref, $get_gene_sig, $gidInClause) = @_;

    my %gene2sig;
    return \%gene2sig if (!$get_gene_sig || $get_gene_sig eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $sig_sql = qq{
      select gene_oid, count(*)
      from gene_sig_peptides
      where gene_oid $gidInClause
      group by gene_oid
    };
    #print "getGene2Sig() sig_sql: $sig_sql<br/>\n";

    my $cur = execSql($dbh, $sig_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, $val) = $cur->fetchrow();
        last if !$gene_oid;
        $gene2sig{$gene_oid} = $val;
    }
    $cur->finish();
    #print "getGene2Sig() gene2sig:<br/>\n";
    #print Dumper(\%gene2sig);
    #print "<br/>\n";

    return \%gene2sig;
}


sub getGene2Cog {
    my ($dbh, $gene_oids_aref, $cogQueryClause, $gidInClause) = @_;

    my %gene2cogs;
    return \%gene2cogs if (!$cogQueryClause || $cogQueryClause eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $cog_sql = qq{
        select distinct g.gene_oid $cogQueryClause
        from gene_cog_groups g, cog cg
        where g.gene_oid $gidInClause
        and g.cog = cg.cog_id
    };

    my $cur = execSql($dbh, $cog_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, @colVals) = $cur->fetchrow();
        last if !$gene_oid;
        my $r;
        for (my $j = 0; $j < scalar(@colVals); $j++) {
            if ($j != 0) {
            $r .= "$dDelim";
            }
            $r .= "$colVals[$j]";
        }
        if ($gene2cogs{$gene_oid}) {
            $gene2cogs{$gene_oid} .= "$fDelim$r";
        } else {
            $gene2cogs{$gene_oid} = $r;
        }
    }
    $cur->finish();

    return \%gene2cogs;
}

sub getGene2Pfam {
    my ($dbh, $gene_oids_aref, $pfamQueryClause, $gidInClause) = @_;

    my %gene2pfams;
    return \%gene2pfams if (!$pfamQueryClause || $pfamQueryClause eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $pfam_sql = qq{
        select distinct g.gene_oid $pfamQueryClause
        from gene_pfam_families g, pfam_family pf
        where g.gene_oid $gidInClause
        and g.pfam_family = pf.ext_accession
    };

    my $cur = execSql($dbh, $pfam_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, @colVals) = $cur->fetchrow();
        last if !$gene_oid;
        my $r;
        for (my $j = 0; $j < scalar(@colVals); $j++) {
            if ($j != 0) {
                $r .= "$dDelim";
            }
            $r .= "$colVals[$j]";
        }
        if ($gene2pfams{$gene_oid}) {
            $gene2pfams{$gene_oid} .= "$fDelim$r";
        } else {
            $gene2pfams{$gene_oid} = $r;
        }
    }
    $cur->finish();

    return \%gene2pfams;
}

sub getGene2Tigrfam {
    my ($dbh, $gene_oids_aref, $tigrfamQueryClause, $gidInClause) = @_;

    my %gene2tigrfams;
    return \%gene2tigrfams
    if (!$tigrfamQueryClause || $tigrfamQueryClause eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $tigrfam_sql = qq{
        select distinct g.gene_oid $tigrfamQueryClause
        from gene_tigrfams g, tigrfam tf
        where g.gene_oid $gidInClause
        and g.ext_accession = tf.ext_accession
    };

    my $cur = execSql($dbh, $tigrfam_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, @colVals) = $cur->fetchrow();
        last if !$gene_oid;
        my $r;
        for (my $j = 0; $j < scalar(@colVals); $j++) {
            if ($j != 0) {
            $r .= "$dDelim";
            }
            $r .= "$colVals[$j]";
        }
        if ($gene2tigrfams{$gene_oid}) {
            $gene2tigrfams{$gene_oid} .= "$fDelim$r";
        } else {
            $gene2tigrfams{$gene_oid} = $r;
        }
    }
    $cur->finish();

    return \%gene2tigrfams;
}

sub getGene2Ec {
    my ($dbh, $gene_oids_aref, $ecQueryClause, $gidInClause) = @_;

    my %gene2ecs;
    return \%gene2ecs if (!$ecQueryClause || $ecQueryClause eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $ec_sql = qq{
        select distinct g.gene_oid $ecQueryClause
        from gene_ko_enzymes g, enzyme ec
        where g.gene_oid $gidInClause
        and g.enzymes = ec.ec_number
    };

    my $cur = execSql($dbh, $ec_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, @colVals) = $cur->fetchrow();
        last if !$gene_oid;
        my $r;
        for (my $j = 0; $j < scalar(@colVals); $j++)  {
            if ($j != 0) {
            $r .= "$dDelim";
            }
            $r .= "$colVals[$j]";
        }
        if ($gene2ecs{$gene_oid}) {
            $gene2ecs{$gene_oid} .= "$fDelim$r";
        } else {
            $gene2ecs{$gene_oid} = $r;
        }
    }
    $cur->finish();

    return \%gene2ecs;
}

sub getGene2Ko {
    my ($dbh, $gene_oids_aref, $koQueryClause, $gidInClause) = @_;

    my %gene2kos;
    return \%gene2kos if (!$koQueryClause || $koQueryClause eq "");

    if ( ! $gidInClause ) {
        $gidInClause = getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $ko_sql = qq{
        select distinct g.gene_oid $koQueryClause
        from gene_ko_terms g, ko_term kt
        where g.gene_oid $gidInClause
        and g.ko_terms = kt.ko_id
    };
    #print "getGene2Ko() ko_sql: $ko_sql<br/>\n";

    my $cur = execSql($dbh, $ko_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, @colVals) = $cur->fetchrow();
        last if !$gene_oid;
        my $r;
        for (my $j = 0; $j < scalar(@colVals); $j++) {
            if ($j != 0) {
                $r .= "$dDelim";
            }
            $r .= "$colVals[$j]";
        }
        if ($gene2kos{$gene_oid}) {
            $gene2kos{$gene_oid} .= "$fDelim$r";
        } else {
            $gene2kos{$gene_oid} = $r;
        }
    }
    $cur->finish();

    return \%gene2kos;
}

sub getGene2Term {
    my ($dbh, $gene_oids_aref, $imgTermQueryClause, $gidInClause) = @_;

    my %gene2terms;
    return \%gene2terms if (!$imgTermQueryClause || $imgTermQueryClause eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }
    my $img_sql = qq{
        select distinct g.gene_oid $imgTermQueryClause
        from gene_img_functions g, img_term itx
        where g.gene_oid $gidInClause
        and g.function = itx.term_oid
    };

    my $cur = execSql($dbh, $img_sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, @colVals) = $cur->fetchrow();
        last if !$gene_oid;
        my $r;
        for (my $j = 0; $j < scalar(@colVals); $j++) {
            if ($j != 0) {
            $r .= "$dDelim";
            }
            $r .= "$colVals[$j]";
        }
        if ($gene2terms{$gene_oid}) {
            $gene2terms{$gene_oid} .= "$fDelim$r";
        } else {
            $gene2terms{$gene_oid} = $r;
        }
    }
    $cur->finish();

    return \%gene2terms;
}

sub getGene2TaxonInfo {
    my ($dbh, $gene_oids_aref, $gidInClause) = @_;

    my %gene2TaxonInfo;
    my %taxon2metaInfo;
    return (\%gene2TaxonInfo, \%taxon2metaInfo)
        if (!$gene_oids_aref || $gene_oids_aref eq "");

    if ( ! $gidInClause ) {
        $gidInClause = OracleUtil::getIdClause($dbh, 'gtt_num_id', '', $gene_oids_aref);        
    }

    my $rclause = WebUtil::urClause('t');
    my $imgClause = WebUtil::imgClause('t');

    my $sql       = qq{
        select distinct g.gene_oid, t.taxon_oid, t.taxon_display_name, 
            t.sequencing_gold_id, t.sample_gold_id, t.submission_id, t.is_public, t.analysis_project_id
        from gene g, taxon t
        where g.gene_oid $gidInClause
        and g.taxon = t.taxon_oid
        $rclause
        $imgClause
    };
    my $cur = execSql($dbh, $sql, $verbose);
    for ( ;; ) {
        my ($gene_oid, $taxon_oid, $taxon_display_name, @colVals) = $cur->fetchrow();
        last if !$gene_oid;

        $gene2TaxonInfo{$gene_oid} = "$taxon_oid\t$taxon_display_name";

        if ( ! $taxon2metaInfo{$taxon_oid} ) {
            my $r;
            for (my $j = 0; $j < scalar(@colVals); $j++) {
                if ($j != 0) {
                    $r .= "\t";
                }
                $r .= "$colVals[$j]";
            }
            $taxon2metaInfo{$taxon_oid} = $r;            
        }
    }
    $cur->finish();
    #print "getGene2TaxonInfo() gene2TaxonInfo: <br/>\n";
    #print Dumper(\%gene2TaxonInfo);
    #print "<br/>\n";
    #print "getGene2TaxonInfo() taxon2metaInfo: <br/>\n";
    #print Dumper(\%taxon2metaInfo);
    #print "<br/>\n";

    return (\%gene2TaxonInfo, \%taxon2metaInfo);
}

sub getTaxon2projectMetadataInfo {
    my ($taxon2metaInfo_href) = @_;

    my %taxon_data;           # hash of hashes taxon oid => hash columns name to value
    my %goldId_data;          # gold id => hash of taxon_oid
    #my %sampleId_data;        # sample id => hash of taxon oid
    #my %submissionId_data;    # submission_id => hash of taxon_oid
    #my %taxon_public_data;    # taxon_oid => Yes or No for is public
    #my %analysisId_data;      # Ga id => taxon oid

    for my $taxon_oid (keys %$taxon2metaInfo_href) {
        my $taxon_meta_info = $taxon2metaInfo_href->{$taxon_oid};
        my ($gold_id, $sample_gold_id, $submission_id, $is_public, $analysis_project_id) = split(/\t/, $taxon_meta_info);

        #$taxon_public_data{$taxon_oid}         = $is_public;
        #$analysisId_data{$analysis_project_id} = $taxon_oid;

        my %hash;
        $taxon_data{$taxon_oid} = \%hash;
        $hash{gold_id} = $gold_id;
        if ( $gold_id ne '' ) {
            if ( exists $goldId_data{$gold_id} ) {
                my $href = $goldId_data{$gold_id};
                $href->{$taxon_oid} = 1;
            } else {
                my %h = ( $taxon_oid => 1 );
                $goldId_data{$gold_id} = \%h;
            }
        }

        #if ( $sample_gold_id ne '' ) {
        #    if ( exists $sampleId_data{$sample_gold_id} ) {
        #        my $href = $sampleId_data{$sample_gold_id};
        #        $href->{$taxon_oid} = 1;
        #    } else {
        #        my %h = ( $taxon_oid => 1 );
        #        $sampleId_data{$sample_gold_id} = \%h;
        #    }
        #}
        #
        #if ( $submission_id ne '' ) {
        #    $hash{submissionId} = $submission_id;
        #    if ( exists $submissionId_data{$submission_id} ) {
        #        my $href = $submissionId_data{$submission_id};
        #        $href->{$taxon_oid} = 1;
        #    } else {
        #        my %h = ( $taxon_oid => 1 );
        #        $submissionId_data{$submission_id} = \%h;
        #    }
        #}
            
    }

    GenomeList::getProjectMetadata( \%taxon_data, \%goldId_data);
    #print "getTaxon2projectMetadataInfo() taxon_data: <br/>\n";
    #print Dumper(\%taxon_data);
    #print "<br/>\n";
    #print "getTaxon2projectMetadataInfo() goldId_data: <br/>\n";
    #print Dumper(\%goldId_data);
    #print "<br/>\n";

    return \%taxon_data;
}

############################################################################
# flushMetaGeneBatch  - Flush one batch.
############################################################################
sub flushMetaGeneBatch {
    my ( $fixedColIDs, $recs, $dbh, 
        $meta_gene_oids_ref, $goid2BatchIds_ref, $batch_id_new, 
        $projectMetadataCols_ref, $outputCol_ref, 
        $workingDivNotNeeded, $needNewRecs, $print_msg ) = @_;

    my $recsNum = scalar(keys %$recs);
    #print "flushMetaGeneBatch() 0 recsNum=$recsNum<br/>\n";
    if ( $recsNum && $recsNum > CartUtil::getMaxDisplayNum() ) {
        return '';        
    }

    if ( scalar(@$meta_gene_oids_ref) == 0 ) {
        return '';
    }

    #test use
    #print "GeneCartStor::flushMetaGeneBatch() meta_gene_oids_ref: @$meta_gene_oids_ref<br/>\n";
    #print "GeneCartStor::flushMetaGeneBatch() outputCol_ref: @$outputCol_ref<br/>\n";

    #print "GeneCartStor::flushMetaGeneBatch() workingDivNotNeeded: $workingDivNotNeeded<br/>\n";
    if ( !$workingDivNotNeeded ) {
        printStartWorkingDiv();
    }

    #webLog "GeneCartStor::flushMetaGeneBatch() start " . currDateTime() . "\n" if $verbose >= 1;
    #print "GeneCartStor::flushMetaGeneBatch() 0 " . currDateTime() . "<br/>\n";

    my %genes_h;
    my %taxon_oid_h;

    #my $k = 0;
    for my $workspace_id (@$meta_gene_oids_ref) {
        $genes_h{$workspace_id} = 1;

        my @vals = split( / /, $workspace_id );
        if ( scalar(@vals) >= 3 ) {
            $taxon_oid_h{ $vals[0] } = 1;

            #$k++;
            #if ( $k > $maxGeneListResults ) {
            #   last;
            #}
        }
    }
    my @taxonOids = keys(%taxon_oid_h);

    my $taxon_name_href;
    my $taxon_genome_type_href;
    my $taxon_metaInfo_href;
    if ( scalar(@taxonOids) > 0 ) {
        ( $taxon_name_href, $taxon_genome_type_href, $taxon_metaInfo_href ) =
          QueryUtil::fetchTaxonMetaInfo( $dbh, \@taxonOids );
    }
    #print "flushMetaGeneBatch() taxon2metaInfo: <br/>\n";
    #print Dumper($taxon_metaInfo_href);
    #print "<br/>\n";

    my $get_taxon_public = 0;
    my $get_taxon_oid = 0;
    my $get_gene_info    = 0;
    my $get_gene_faa     = 0;
    my $get_scaf_info    = 0;
    my $get_gene_cog     = 0;
    my $get_gene_pfam    = 0;
    my $get_gene_tigrfam = 0;
    my $get_gene_ec      = 0;
    my $get_gene_ko      = 0;

    my @outCols;
    if ( $outputCol_ref ) {
        @outCols = @$outputCol_ref;
        foreach my $outCol ( @outCols ) {
            if ( $outCol eq 'is_public' ) {
                $get_taxon_public = 1;
            } elsif ( $outCol eq 'taxon_oid' ) {
                $get_taxon_oid = 1;
            } elsif (    $outCol eq 'locus_type'
                      || $outCol eq '$start_coord'
                      || $outCol eq '$end_coord'
                      || $outCol eq '$strand'
                      || $outCol eq 'dna_seq_length'
                      || $outCol eq 'scaffold_oid' )
            {
                $get_gene_info = 1;
            } elsif ( $outCol eq 'aa_seq_length' ) {
                $get_gene_faa = 1;
            } elsif (    $outCol eq 'seq_length'
                      || $outCol eq 'gc_percent'
                      || $outCol eq 'read_depth' )
            {
                $get_gene_info = 1;
                $get_scaf_info = 1;
            } elsif ( $outCol =~ /cog_id/i ) {
                $get_gene_cog = 1;
            } elsif ( $outCol =~ /pfam_id/i ) {
                $get_gene_pfam = 1;
            } elsif ( $outCol =~ /tigrfam_id/i ) {
                $get_gene_tigrfam = 1;
            } elsif ( $outCol =~ /ec_number/i ) {
                $get_gene_ec = 1;
            } elsif ( $outCol =~ /ko_id/i ) {
                $get_gene_ko = 1;
            }
        }
    }
    #print "GeneCartStor::flushMetaGeneBatch() outCols=@outCols<br/>\n";
    #print "GeneCartStor::flushMetaGeneBatch() outCols size=" . @outCols . "<br/>\n";

    my %taxon_public_h;
    if ( $get_taxon_public && scalar(@taxonOids) > 0 ) {
        %taxon_public_h = QueryUtil::fetchTaxonOid2PublicHash( $dbh, \@taxonOids );
    }

    my %taxon_genes = MetaUtil::getOrganizedTaxonGenes(@$meta_gene_oids_ref);

    my %gene_name_h;
    MetaUtil::getAllMetaGeneNames( \%genes_h, $meta_gene_oids_ref, \%gene_name_h, \%taxon_genes, $print_msg );

    #print "GeneCartStor::flushMetaGeneBatch() 0b " . currDateTime() . "<br/>\n";

    my %gene_info_h;
    my %scaf_id_h;
    if ( $get_gene_info && scalar( keys %genes_h ) > 0 ) {
        MetaUtil::getAllMetaGeneInfo( \%genes_h, $meta_gene_oids_ref, \%gene_info_h, \%scaf_id_h, \%taxon_genes, $print_msg, 0, 1 );
        #print "GeneCartStor::flushMetaGeneBatch() gene_info_h:<br/>\n";
        #print Dumper(\%gene_info_h);
        #print "<br/>\n";
        #print "GeneCartStor::flushMetaGeneBatch() getAllMetaGeneInfo() called " . currDateTime() . "<br/>\n";
        #print Dumper(\%scaf_id_h);
    }

    # gene-faa
    my %gene_faa_h;
    if ( $get_gene_faa && scalar( keys %genes_h ) > 0 ) {
        MetaUtil::getAllMetaGeneFaa( \%genes_h, $meta_gene_oids_ref, \%gene_faa_h, \%taxon_genes, $print_msg );
    }

    my %scaffold_h;
    if ( $get_scaf_info && scalar( keys %scaf_id_h ) > 0 ) {
        MetaUtil::getAllScaffoldInfo( \%scaf_id_h, \%scaffold_h );
        #print "GeneCartStor::flushMetaGeneBatch() scaffold_h:<br/>\n";
        #print Dumper(\%scaffold_h);
        #print "<br/>\n";
        #print "GeneCartStor::flushMetaGeneBatch() getAllScaffoldInfo() called " . currDateTime() . "<br/>\n";
    }

    # gene-cog
    my %gene_cog_h;
    my %cog_name_h;
    if ( $get_gene_cog && scalar( keys %genes_h ) > 0 ) {
        MetaUtil::getAllMetaGeneFuncs( 'cog', $meta_gene_oids_ref, \%genes_h, \%gene_cog_h );
        #Todo: should use gene_cog_h results
        QueryUtil::fetchAllCogIdNameHash( $dbh, \%cog_name_h );
        #print Dumper(\%gene_cog_h);
        #print "<br/>\n";
        #print "GeneCartStor::flushMetaGeneBatch() getAllMetaGeneFuncs() called " . currDateTime() . "<br/>\n";
    }

    # gene-pfam
    my %gene_pfam_h;
    my %pfam_name_h;
    if ( $get_gene_pfam && scalar( keys %genes_h ) > 0 ) {
        MetaUtil::getAllMetaGeneFuncs( 'pfam', $meta_gene_oids_ref, \%genes_h, \%gene_pfam_h );
        #Todo: should use gene_pfam_h results
        QueryUtil::fetchAllPfamIdNameHash( $dbh, \%pfam_name_h );
    }

    # gene-tigrfam
    my %gene_tigrfam_h;
    my %tigrfam_name_h;
    if ( $get_gene_tigrfam && scalar( keys %genes_h ) > 0 ) {
        MetaUtil::getAllMetaGeneFuncs( 'tigr', $meta_gene_oids_ref, \%genes_h, \%gene_tigrfam_h );
        #print "flushMetaGeneBatch() gene_tigrfam_h:<br/>\n";
        #print Dumper(\%gene_tigrfam_h);
        #print "<br/>\n";
        #Todo: should use gene_tigrfam_h results
        QueryUtil::fetchAllTigrfamIdNameHash( $dbh, \%tigrfam_name_h );
    }

    # gene-ec
    my %gene_ec_h;
    my %ec_name_h;
    if ( $get_gene_ec && scalar( keys %genes_h ) > 0 ) {
        MetaUtil::getAllMetaGeneFuncs( 'ec', $meta_gene_oids_ref, \%genes_h, \%gene_ec_h );
        #print "flushMetaGeneBatch() gene_ec_h:<br/>\n";
        #print Dumper(\%gene_ec_h);
        #print "<br/>\n";
        #Todo: should use gene_ec_h results
        QueryUtil::fetchAllEnzymeNumberNameHash( $dbh, \%ec_name_h );
    }

    # gene-ko
    my %gene_ko_h;
    my %ko_name_h;
    my %ko_def_h;
    if ( $get_gene_ko && scalar( keys %genes_h ) > 0 ) {
        MetaUtil::getAllMetaGeneFuncs( 'ko', $meta_gene_oids_ref, \%genes_h, \%gene_ko_h );
        #Todo: should use gene_ko_h results
        QueryUtil::fetchAllKoIdNameDefHash( $dbh, \%ko_name_h, \%ko_def_h );
    }

    my $taxon_metadata_href;
    if ( $projectMetadataCols_ref && scalar(@$projectMetadataCols_ref) > 0 ) {
        $taxon_metadata_href = getTaxon2projectMetadataInfo($taxon_metaInfo_href);
    }
    #print "flushMetaGeneBatch() taxon_metadata_href: <br/>\n";
    #print Dumper($taxon_metadata_href);
    #print "<br/>\n";

    #print "GeneCartStor::flushMetaGeneBatch 2 " . currDateTime() . "<br/>\n";

    my $trunc      = 0;
    my $gene_count = 0;
    for my $workspace_id (@$meta_gene_oids_ref) {
        my $batch_id = $batch_id_new;
        if ( $batch_id eq '' && $goid2BatchIds_ref && defined($goid2BatchIds_ref) ) {
            $batch_id = $goid2BatchIds_ref->{$workspace_id};
        }

        my ( $taxon_oid, $data_type, $gene_oid ) = split( / /, $workspace_id );
        if ( !exists( $taxon_name_href->{$taxon_oid} ) ) {
            #$taxon_oid not in hash, probably due to permission
            webLog("GeneCartStor flushMetaGeneBatch:: $taxon_oid not retrieved from database, probably due to permission.");
            next;
        }

        my ( $locus_type, $locus_tag, $gene_display_name, $start_coord, $end_coord, $strand, $scaffold_oid, $tid2, $dtype2 );
        if ( exists( $gene_info_h{$workspace_id} ) ) {
            ( $locus_type, $locus_tag, $gene_display_name, $start_coord, $end_coord, $strand, $scaffold_oid, $tid2, $dtype2 )
              = split( /\t/, $gene_info_h{$workspace_id} );
            #print "flushMetaGeneBatch() gene_info_h{$workspace_id}" . $gene_info_h{$workspace_id} . "<br/>\n";
        } else {
            $locus_tag = $gene_oid;
        }

        if ( !$taxon_oid && $tid2 ) {
            $taxon_oid = $tid2;
            if ( !exists( $taxon_name_href->{$taxon_oid} ) ) {
                my $taxon_name = QueryUtil::fetchSingleTaxonName( $dbh, $taxon_oid );

                # save taxon display name to prevent repeat retrieving
                $taxon_name_href->{$taxon_oid} = $taxon_name;
            }
        }

        # taxon
        my $taxon_display_name = $taxon_name_href->{$taxon_oid};
        my $genome_type = $taxon_genome_type_href->{$taxon_oid};
        $taxon_display_name .= " (*)"
          if ( $genome_type eq "metagenome" );

        if ( $gene_name_h{$workspace_id} ) {
            $gene_display_name = $gene_name_h{$workspace_id};
        }
        if ( !$gene_display_name ) {
            $gene_display_name = 'hypothetical protein';
        }
        my $desc      = $gene_display_name;
        my $desc_orig = $desc;

        # scaffold
        my $scaf_len;
        my $scaf_gc;
        my $scaf_gene_cnt;
        my $scaf_depth;
        if ( $data_type eq 'assembled' && $scaffold_oid && scalar( keys %scaffold_h ) > 0 ) {
            my $ws_scaf_id = "$taxon_oid $data_type $scaffold_oid";
            ( $scaf_len, $scaf_gc, $scaf_gene_cnt, $scaf_depth ) = split( /\t/, $scaffold_h{$ws_scaf_id} );
            if ( !$scaf_depth ) {
                $scaf_depth = 1;
            }
            $scaf_gc = sprintf( "%.2f", $scaf_gc );
        }

        my $r = "$workspace_id\t";
        $r .= "$locus_tag\t";
        $r .= "$desc\t";
        $r .= "$desc_orig\t";
        $r .= "$taxon_oid\t";
        $r .= "$taxon_display_name\t";
        $r .= "$batch_id\t";
        $r .= "$scaffold_oid\t";

        foreach my $outCol ( @outCols ) {
            #print "flushMetaGeneBatch() outCol=$outCol<br/>\n";
            if ( $outCol eq 'dna_seq_length' ) {
                my $dna_seq_length = $end_coord - $start_coord + 1;
                $r .= "$dna_seq_length\t";
            } elsif ( $outCol eq 'aa_seq_length' ) {
                #takes too long for getGeneFaa(), get Kosta's permission for the division in metagenome
                #my $aa_seq_length = $dna_seq_length / 3;
                my $faa           = $gene_faa_h{$workspace_id};
                my $aa_seq_length = length($faa);
                $r .= "$aa_seq_length\t";
            } elsif ( $outCol eq 'start_coord' ) {
                $r .= "$start_coord\t";
            } elsif ( $outCol eq 'end_coord' ) {
                $r .= "$end_coord\t";
            } elsif ( $outCol eq 'strand' ) {
                $r .= "$strand\t";
            } elsif ( $outCol eq 'locus_type' ) {
                $r .= "$locus_type\t";
            } elsif ( $outCol eq 'is_public' ) {
                my $is_public = $taxon_public_h{$taxon_oid};
                $r .= "$is_public\t";
            } elsif ( $outCol eq 'taxon_oid' ) {
                $r .= "$taxon_oid\t";
            } elsif ( $outCol eq 'scaffold_oid' ) {
                $r .= "$scaffold_oid\t";
            } elsif ( $outCol eq 'scaffold_name' ) {
                $r .= "$scaffold_oid\t";
            } elsif ( $outCol eq 'seq_length' ) {
                $r .= "$scaf_len\t";
            } elsif ( $outCol eq 'gc_percent' ) {
                $r .= "$scaf_gc\t";
            } elsif ( $outCol eq 'read_depth' ) {
                $r .= "$scaf_depth\t";
            } elsif ( $outCol =~ /cog_id/i ) {
                my @cog_recs;
                my $cogs = $gene_cog_h{$workspace_id};
                if ($cogs) {
                    @cog_recs = split( /\t/, $cogs );
                }

                my $cog_all;
                for my $cog_id (@cog_recs) {
                    my $cog_name = $cog_name_h{$cog_id};
                    if ($cog_all) {
                        $cog_all .= "$fDelim$r";
                    }
                    $cog_all = $cog_id . $dDelim . $cog_name;
                }
                $r .= "$cog_all\t\t";

            } elsif ( $outCol =~ /pfam_id/i ) {
                my @pfam_recs;
                my $pfams = $gene_pfam_h{$workspace_id};
                if ($pfams) {
                    @pfam_recs = split( /\t/, $pfams );
                }

                my $pfam_all;
                for my $pfam_id (@pfam_recs) {
                    my $pfam_name = $pfam_name_h{$pfam_id};
                    if ($pfam_all) {
                        $pfam_all .= "$fDelim$r";
                    }
                    $pfam_all = $pfam_id . $dDelim . $pfam_name;
                }
                $r .= "$pfam_all\t\t";

            } elsif ( $outCol =~ /tigrfam_id/i ) {
                my @tigrfam_recs;
                my $tigrfams = $gene_tigrfam_h{$workspace_id};
                if ($tigrfams) {
                    @tigrfam_recs = split( /\t/, $tigrfams );
                }

                my $tigrfam_all;
                for my $tigrfam_id (@tigrfam_recs) {
                    my $tigrfam_name = $tigrfam_name_h{$tigrfam_id};
                    if ($tigrfam_all) {
                        $tigrfam_all .= "$fDelim$r";
                    }
                    $tigrfam_all = $tigrfam_id . $dDelim . $tigrfam_name;
                }
                $r .= "$tigrfam_all\t\t";

            } elsif ( $outCol =~ /ec_number/i ) {
                my @ec_recs;
                my $ecs = $gene_ec_h{$workspace_id};
                if ($ecs) {
                    @ec_recs = split( /\t/, $ecs );
                }

                my $ec_all;
                for my $ec_id (@ec_recs) {
                    my $ec_name = $ec_name_h{$ec_id};
                    if ($ec_all) {
                        $ec_all .= "$fDelim$r";
                    }
                    $ec_all = $ec_id . $dDelim . $ec_name;
                }
                $r .= "$ec_all\t\t";

            } elsif ( $outCol =~ /ko_id/i ) {
                my @ko_recs;
                my $kos = $gene_ko_h{$workspace_id};
                if ($kos) {
                    @ko_recs = split( /\t/, $kos );
                }

                my $ko_all;
                for my $ko_id (@ko_recs) {
                    my $ko_name = $ko_name_h{$ko_id};
                    my $ko_def  = $ko_def_h{$ko_id};
                    if ($ko_all) {
                        $ko_all .= "$fDelim$r";
                    }
                    $ko_all = $ko_id . $dDelim . $ko_name . $dDelim . $ko_def;
                }
                $r .= "$ko_all\t\t\t";
            } elsif ( $projectMetadataCols_ref 
                && scalar(@$projectMetadataCols_ref) > 0 
                && GenomeList::isProjectMetadataAttr($outCol) ) {
                #to be applied later, ProjectMetadataAttr must be listed as last group
                last;
            } else {
                $r .= "\t";
            }
        }

        #project metadata
        if ( $projectMetadataCols_ref && scalar(@$projectMetadataCols_ref) > 0 ) {
            my $sub_href = $taxon_metadata_href->{$taxon_oid};
            foreach my $col (@$projectMetadataCols_ref) {
                my $val = $sub_href->{$col};
                $val = GenomeList::cellValueEscape($val);
                $r .= "$val\t";
            }            
        }

        $recs->{$workspace_id} = $r;
        #print "flushMetaGeneBatch() r: $r<br/>\n";
        #my @splitColVals  = split( /\t/, $r );
        #print "flushMetaGeneBatch() splitColVals size: " . scalar(@splitColVals) . "<br/>\n";
        #print "flushMetaGeneBatch() splitColVals: @splitColVals<br/>\n";
        $recsNum = scalar(keys %$recs);
        if ( !$needNewRecs && $recsNum >= CartUtil::getMaxDisplayNum() ) {
            last;
        }
    }

    #test use
    #foreach my $key (keys %{$recs}) {
    #    my $rec = $recs -> {$key};
    #    print "flushMetaGeneBatch 1 record for $key:<br/>\n$rec<br/>\n";
    #}

    if ( !$workingDivNotNeeded ) {
        printEndWorkingDiv();
    }

    #webLog "GeneCartStor::flushMetaGeneBatch done " . currDateTime() . "\n" if $verbose >= 1;
    #print "GeneCartStor::flushMetaGeneBatch 3 " . currDateTime() . "<br/>\n";
    #print "flushMetaGeneBatch() 1 recsNum=$recsNum<br/>\n";

    my $colIDs = $fixedColIDs;
    foreach my $col (@outCols) {
        $colIDs .= "$col,";
    }

    return $colIDs;
}

############################################################################
# printGeneDataFile - Print gene data for exporting to excel
############################################################################
sub printGeneDataFile {
    my ($gene_oids_ref, $outFile) = @_;

    return if ( scalar(@$gene_oids_ref) == 0 );

    my $fixedColIDs = GeneTableConfiguration::getDefaultFixedColIDs();
    my $tool = 'gene_data';
    
    my (
         $outColClause,   
         $taxonJoinClause,$scfJoinClause,   $ssJoinClause, 
         $get_gene_tmh,   $get_gene_sig, 
         $cogQueryClause, $pfamQueryClause, $tigrfamQueryClause, 
         $ecQueryClause,  $koQueryClause,   $imgTermQueryClause, 
         $projectMetadataCols_ref, $outputCol_ref,  @rest
      )
      = GeneTableConfiguration::getOutputColClauses($fixedColIDs, $tool, 1);
    #print "printGeneSetDetail(configureCols=$configureCols) outputCol_ref=@$outputCol_ref<br/>\n";

    my ($trunc, $recs) = processWebConfigureGenes(
        $gene_oids_ref,  $tool, $fixedColIDs, $outColClause,   
        $taxonJoinClause,$scfJoinClause,   $ssJoinClause, 
        $get_gene_tmh,   $get_gene_sig,  
        $cogQueryClause, $pfamQueryClause, $tigrfamQueryClause, 
        $ecQueryClause,  $koQueryClause,   $imgTermQueryClause, 
        $projectMetadataCols_ref, $outputCol_ref
    );

    my $colIDs = GeneTableConfiguration::readColIdFile($tool);
    #print "printGeneSetDetail() colIDs: $colIDs<br/>\n";
    $colIDs =~ s/$fixedColIDs//i;
    my @outCols = WebUtil::processParamValue($colIDs);
    #print "printGeneSetDetail() outCols size: " . scalar(@outCols) . "<br/>\n";

    my $wfh;
    if ( $outFile ) {
        $wfh = newAppendFileHandle( $outFile, "writeScaffoldFastaFile" );
    }

    if ( $wfh ) {            
        print $wfh "gene_oid\t";
        print $wfh "Locus Tag\t";
        print $wfh "Gene Product Name\t";
        print $wfh "Genome ID\t";
        print $wfh "Genome Name\t";
        GeneTableConfiguration::printColIDs(\@outCols, $wfh);
        print $wfh "\n";
    }
    else {
        print "gene_oid\t";
        print "Locus Tag\t";
        print "Gene Product Name\t";
        print "Genome ID\t";
        print "Genome Name\t";
        GeneTableConfiguration::printColIDs(\@outCols);
        print "\n";
    }

    for my $id ( keys %$recs ) {
        my $r = $recs->{$id};
        #print "printGeneSetDetail() id=$id r: $r<br/>\n";
        #my @splitColVals  = split( /\t/, $r );
        #print "printGeneSetDetail() splitColVals size: " . scalar(@splitColVals) . "<br/>\n";
        #print "printGeneSetDetail() splitColVals: @splitColVals<br/>\n";

        my ( $workspace_id, $locus_tag, $desc, $desc_orig, $taxon_oid, 
         $orgName, $batch_id, $scaffold_oid, @outColVals ) = split( /\t/, $r );
        #print "printGeneSetDetail() outColVals size: " . scalar(@outColVals) . "<br/>\n";
        #print "printGeneSetDetail() outColVals: @outColVals<br/>\n";

        my $data_type = '';
        my $gene_oid;
        my $notInDatabase;
        if ( $workspace_id && WebUtil::isInt($workspace_id) ) {
            $data_type = 'database';
            $gene_oid  = $workspace_id;
            if ( !$desc && !$taxon_oid ) { 
                $notInDatabase = 1;
            }                
        } else {
            my @vals = split( / /, $workspace_id );
            $data_type = $vals[1];
            $gene_oid  = $vals[2];
        }

        if ( $notInDatabase ) { 
            # not in database
            if ( $wfh ) {            
                print $wfh "\t" . $id . "\t" . "(not in this database)" . "\t" . "-" . "\t";
            }
            else {
                print "\t" . $id . "\t" . "(not in this database)" . "\t" . "-" . "\t";
            }
        } 
        else { 
            if ( $wfh ) {            
                print $wfh $workspace_id . "\t";
                print $wfh $locus_tag . "\t";
                print $wfh $desc . "\t";
                print $wfh $taxon_oid . "\t";
                print $wfh $orgName . "\t";
            }
            else {
                print $workspace_id . "\t";
                print $locus_tag . "\t";
                print $desc . "\t";
                print $taxon_oid . "\t";
                print $orgName . "\t";
            }
        }

        if ( $wfh ) {            
            GeneTableConfiguration::printCols2Row
                ($gene_oid, $data_type, $taxon_oid, $scaffold_oid, 
                 \@outCols, \@outColVals, $wfh);
            print $wfh "\n";
        }
        else {
            GeneTableConfiguration::printCols2Row
                ($gene_oid, $data_type, $taxon_oid, $scaffold_oid, 
                 \@outCols, \@outColVals);
            print "\n";
        }
    }

}

############################################################################
# webConfigureGenes - Configure gene set display.
############################################################################
sub processWebConfigureGenes {    
    my ( $gene_oids_ref,  $tool, $fixedColIDs, $outColClause,   
         $taxonJoinClause,$scfJoinClause,      $ssJoinClause, 
         $get_gene_tmh,   $get_gene_sig,
         $cogQueryClause, $pfamQueryClause,    $tigrfamQueryClause, $ecQueryClause,
         $koQueryClause,  $imgTermQueryClause, $projectMetadataCols_ref, $outputCol_ref
      )
      = @_;

    my ($trunc, $recs);

    my ( $dbOids_ref, $metaOids_ref ) = MerFsUtil::splitDbAndMetaOids(@$gene_oids_ref);
    my @dbOids   = @$dbOids_ref;
    my @metaOids = @$metaOids_ref;

    my $dbh     = dbLogin();
    my $colIDs  = '';

    if ( scalar(@dbOids) > 0 ) {
        for my $gene_oid (@dbOids) {
            my $rec    = $recs->{$gene_oid};
            my @fields = split( /\t/, $rec );
        }
        my $colIDsNew = flushGeneBatch(
            $fixedColIDs,    $recs, $dbh, 
            \@dbOids, '', '', $outColClause,   
            $taxonJoinClause,$scfJoinClause, $ssJoinClause, 
            $get_gene_tmh,   $get_gene_sig,
            $cogQueryClause, $pfamQueryClause, $tigrfamQueryClause, 
            $ecQueryClause,  $koQueryClause,   $imgTermQueryClause, 
            $projectMetadataCols_ref, $outputCol_ref, 1
        );
        if ($colIDsNew) {
            $colIDs = $colIDsNew;
        }
        #print "webConfigureGenes() dbOids=@dbOids<br/>\n";    
    }

    if ( scalar(@metaOids) > 0 ) {
        for my $mOid (@metaOids) {
            my $rec    = $recs->{$mOid};
            my @fields = split( /\t/, $rec );
        }
        my $colIDsNew = flushMetaGeneBatch( 
            $fixedColIDs, $recs, $dbh, 
            \@metaOids, '', '', 
            $projectMetadataCols_ref, $outputCol_ref, 
            1, 1 
        );
        if ($colIDsNew) {
            $colIDs = $colIDsNew;
        }
        #print "webConfigureGenes() metaOids=@metaOids<br/>\n";    
    }

    GeneTableConfiguration::writeColIdFile($colIDs, $tool);

    return ($trunc, $recs);
}

1;
