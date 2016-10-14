############################################################################
# GeneTableConfiguration.pm - share use
#
# $Id: GeneTableConfiguration.pm 35581 2016-04-21 19:42:33Z jinghuahuang $
############################################################################
package GeneTableConfiguration;

require Exporter;
@ISA    = qw( Exporter );
@EXPORT = qw(
);

use strict;
use CGI qw( :standard );
use DBI;
use Data::Dumper;
use WebConfig;
use WebUtil;
use TreeViewFrame;
use GenomeList;
use MerFsUtil;

my $env                = getEnv();
my $main_cgi           = $env->{main_cgi};
my $verbose            = $env->{verbose};
my $base_url           = $env->{base_url};
my $cog_base_url       = $env->{cog_base_url};
my $pfam_base_url      = $env->{pfam_base_url};
my $tigrfam_base_url   = $env->{tigrfam_base_url};
my $enzyme_base_url    = $env->{enzyme_base_url};
my $kegg_orthology_url = $env->{kegg_orthology_url};
my $top_base_url = $env->{top_base_url};
my $YUI        = $env->{yui_dir_28};
my $yui_tables = $env->{yui_tables};

my $dDelim = "===";
my $fDelim = "<<>>";

my $defaultFixedColIDs = "gene_oid,locus_tag,desc,desc_orig,taxon_oid,taxon_display_name,batch_id,scaffold_oid,";

### optional gene field columns to configuration and display
my @gOptCols = (
    'gene_symbol',
    'protein_seq_accid',
    'chromosome',
    'start_coord',
    'end_coord',
    'strand',
    'dna_seq_length',
    'aa_seq_length',
    'locus_type',
    'is_pseudogene',
    'obsolete_flag',
    'partial_gene',
    #'img_orf_type',
    'add_date',
);

my @tOptCols = (
    'is_public',
    #'taxon_oid',    
);

my $FEATURE_TYPE = 'feature_type';
my $SIG_PEPTIDES = 'sig_peptides';

my @gtsOptCols = (
    $FEATURE_TYPE,
    $SIG_PEPTIDES,
);

## optional scaffold/Contig field columns to configuration and display,
my @sfOptCols = ( 'scaffold_oid', 'ext_accession', 'scaffold_name', 'read_depth', );
my @ssOptCols = ( 'seq_length',   'gc_percent', );

##'ko_id, ko_name, definition',
my @fOptCols = (
    'cog_id,cog_name',
    'pfam_id,pfam_name',
    'tigrfam_id,tigrfam_name',
    'ec_number,enzyme_name',
    #'ko_id',
    #'ko_name',
    #'definition',
    'ko_id,ko_name,definition',
    'img_term'
);

### Maps database column name to UI friendly label.
my %colName2Label = (
      locus_tag                  => 'Locus Tag',
      locus_type                 => 'Locus Type',
      gene_symbol                => 'Gene Symbol',
      gene_display_name          => 'Gene Display Name',
      product_name               => 'Product Name',
      protein_seq_accid          => 'GenBank Accession',
      chromosome                 => 'Chromosome',
      start_coord                => 'Start Coord',
      end_coord                  => 'End Coord',
      strand                     => 'Strand',
      dna_seq_length             => 'DNA Sequence Length',
      aa_seq_length              => 'Amino Acid Sequence Length',
      is_pseudogene              => 'Is Pseudogene',
      obsolete_flag              => 'Is Obsolete',
      partial_gene               => 'Is Partial Gene',
      img_orf_type               => "IMG ORF Type",
      add_date                   => 'Add Date',
      is_public                  => 'Is Public',
      feature_type               => 'Transmembrane Helices',
      sig_peptides               => 'Signal Peptides',
      scaffold                   => 'Scaffold ID',
      scaffold_oid               => 'Scaffold ID',
      ext_accession              => 'Scaffold External Accession',
      scaffold_name              => 'Scaffold Name',
      read_depth                 => 'Scaffold Read Depth',
      seq_length                 => 'Scaffold Length',
      gc_percent                 => 'Scaffold GC %',
      cog_id                     => "COG ID",
      cog_name                   => "COG Name",
      'cog_id,cog_name'          => "COG ID and Name",
      pfam_id                    => "Pfam ID",
      pfam_name                  => "Pfam Name",
      'pfam_id,pfam_name'        => "Pfam ID and Name",
      tigrfam_id                 => "Tigrfam ID",
      tigrfam_name               => "Tigrfam Name",
      'tigrfam_id,tigrfam_name'  => "Tigrfam ID and Name",
      ec_number                  => "Enzyme ID",
      enzyme_name                => "Enzyme Name",
      'ec_number,enzyme_name'    => "Enzyme ID and Name",
      ko_id                      => "KO ID",
      ko_name                    => "KO Name",
      definition                 => "KO Definition",
      'ko_id,ko_name,definition' => "KEGG Orthology ID, Name and Definition",
      'img_term'                 => 'IMG Term',
      'taxon_oid'                => 'Genome ID',
);

my %colName2Label_special = (
      dna_seq_length => 'DNA Sequence Length<br/>(bp)',
      aa_seq_length  => 'Amino Acid Sequence Length<br/>(aa)',
      seq_length     => 'Scaffold Length<br/>(bp)',
);

my %colName2Align = (
      locus_tag         => 'char asc left',
      locus_type        => 'char asc left',
      gene_symbol       => 'char asc left',
      gene_display_name => 'char asc left',
      product_name      => 'char asc left',
      protein_seq_accid => 'char asc left',
      chromosome        => 'char asc left',
      start_coord       => 'num asc right',
      end_coord         => 'num asc right',
      strand            => 'char asc center',
      dna_seq_length    => 'num desc right',
      aa_seq_length     => 'num desc right',
      is_pseudogene     => 'char asc left',
      obsolete_flag     => 'char asc left',
      partial_gene      => 'char asc left',
      img_orf_type      => "char asc left",
      add_date          => 'char asc left',
      is_public         => 'char asc left',
      scaffold          => 'num asc right',
      scaffold_oid      => 'num asc right',
      ext_accession     => 'char asc left',
      scaffold_name     => 'char asc left',
      read_depth        => 'num desc right',
      seq_length        => 'num desc right',
      gc_percent        => 'num desc right',
      cog_id            => "char asc left",
      cog_name          => "char asc left",
      pfam_id           => "char asc left",
      pfam_name         => "char asc left",
      tigrfam_id        => "char asc left",
      tigrfam_name      => "char asc left",
      ec_number         => "char asc left",
      enzyme_name       => "char asc left",
      ko_id             => "char asc left",
      ko_name           => "char asc left",
      definition        => "char asc left",
      img_term          => "char asc left",
      'taxon_oid' =>'num desc right',
);

sub getDefaultFixedColIDs {
    return $defaultFixedColIDs;
}

sub getGeneFieldAttrs {
    return @gOptCols;
}

sub getFunctionFieldAttrs {
    return @fOptCols;
}

sub getFeatureType {
    return $FEATURE_TYPE;
}

sub getSigPeptides {
    return $SIG_PEPTIDES;
}

############################################################################
# findColType - Find col belonging to which type
############################################################################
sub findColType {
    my ($col) = @_;

    if ( grep $_ eq $col, @gOptCols ) {
        return 'g';
    } elsif ( grep $_ eq $col, @tOptCols ) {
        return 't';
    } elsif ( grep $_ eq $col, @gtsOptCols ) {
        return 'gts';
    } elsif ( grep $_ eq $col, @sfOptCols ) {
        return 'sf';
    } elsif ( grep $_ eq $col, @ssOptCols ) {
        return 'ss';
    } elsif ( grep $_ eq $col, @fOptCols ) {
        return 'f';
    } elsif (    $col =~ /cog_id/i
              || $col =~ /cog_name/i
              || $col =~ /pfam_id/i
              || $col =~ /pfam_name/i
              || $col =~ /tigrfam_id/i
              || $col =~ /tigrfam_name/i
              || $col =~ /ec_number/i
              || $col =~ /enzyme_name/i
              || $col =~ /ko_id/i
              || $col =~ /ko_name/i
              || $col =~ /definition/i )
    {
        return 'f';
    } elsif ( GenomeList::isProjectMetadataAttr($col) ) {
        return 'p';
    }        

    return '';
}

############################################################################
# getColLabel - get label for col
############################################################################
sub getColLabel {
    my ($col) = @_;
    my $val = $colName2Label{$col};
    return $col if ( $val eq '' );
    return $val;
}

############################################################################
# getColLabel - get label for col
############################################################################
sub getColLabelSpecial {
    my ($col) = @_;
    my $val = $colName2Label_special{$col};
    return $val;
}

############################################################################
# getColAlign - get Align for col
############################################################################
sub getColAlign {
    my ($col) = @_;
    my $val = $colName2Align{$col};
    return $val;
}


############################################################################
# appendGeneTableConfiguration - Print output attributtes for optional
#   configuration information.
############################################################################
sub appendGeneTableConfiguration {
    my ( $outputColHash_ref, $name, $include_project_metadata ) = @_;

    printTreeViewMarkup();

    print "<h2>Table Configuration</h2>";
    print submit(
          -id    => "moreGo",
          -name  => $name,
          -value => "Display Genes Again",
          -class => "meddefbutton"
    );

    print qq{
        <div id='genomeConfiguration'>      
          <script type='text/javascript' src='$top_base_url/js/genomeConfig.js'></script>

          <table border='0'>
            <tr>
            <td>
              <span class='hand' id='plus_minus_span5' onclick="javascript:showFilter(5, '$base_url')">
                <img id='plus_minus1' alt='close' src='$base_url/images/elbow-minus-nl.gif'/>
              </span>
              Gene Field
            </td>
            <td>
              <span class='hand' id='plus_minus_span6' onclick="javascript:showFilter(6, '$base_url')">
                <img id='plus_minus3' alt='close' src='$base_url/images/elbow-minus-nl.gif'/>
              </span>
              Scaffold/Contig Field
            </td>
            <td style='width:550px;'>
              <span class='hand' id='plus_minus_span7' onclick="javascript:showFilter(7, '$base_url')">
                <img id='plus_minus4' alt='close' src='$base_url/images/elbow-minus-nl.gif'/>
              </span>
              Function Field
            </td>
    };
    if ($include_project_metadata) {
        print qq{
                <td>
                  <span class='hand' id='plus_minus_span2' onclick="javascript:showFilter(2, '$base_url')">
                    <img id='plus_minus2' alt='close' src='$base_url/images/elbow-minus-nl.gif'/>
                  </span>
                  Project Metadata
                </td>
        };
    }
    print "</tr><tr>";

    my @gtOptCols = ();   # add @gOptCols, @tOptCols, and @gtsOptCols into @gtOptCols
    push( @gtOptCols, @gOptCols, @tOptCols, @gtsOptCols ); 

    my @sOptCols = ();    # add @sfOptCols and @ssOptCols into @sOptCols
    push( @sOptCols, @sfOptCols );
    splice( @sOptCols, 3, 0, @ssOptCols );

    my @categoryOptCols = ( \@gtOptCols, \@sOptCols, \@fOptCols );
    my @categoryOptColNames = ( "gene_field_col", "scaffold_field_col", "function_field_col" );
    my @categoryOptColIds = ( "geneField", "scaffoldField", "functionField" );

    my %projectMetadataColumns;
    if ($include_project_metadata) {
        %projectMetadataColumns = GenomeList::getProjectMetadataColumns();
        my @projectMetadataColumnsOrder = GenomeList::getProjectMetadataAttrs();
        push(@categoryOptCols, \@projectMetadataColumnsOrder );
        push(@categoryOptColNames, "metadata_col" );
        push(@categoryOptColIds, "projectMetadata" );
    }

    for ( my $i = 0; $i < scalar(@categoryOptColNames); $i++ ) {
        my $field_col_name = $categoryOptColNames[$i];
        my $field_col_id = $categoryOptColIds[$i];
        print qq{ 
            <td>
              <div id='$field_col_id' class='myborder'>
                <input type="button" value="All"   onclick="selectObject(1, '$field_col_name')">
                <input type="button" value="Clear" onclick="selectObject(0, '$field_col_name')">
                <br/>
        };
    
        # taxon attributes have a pre-defined sort order
        my $categoryOptCols_ref = $categoryOptCols[$i];
        foreach my $key (@$categoryOptCols_ref) {
            my $value;
            if ( $field_col_name eq 'metadata_col' ) {
                $value = $projectMetadataColumns{$key};                
            }
            else {
                $value = $colName2Label{$key};
            }

            my $str;
            if (    $outputColHash_ref->{$key} ne ''
                 || ( $key eq 'cog_id,cog_name'          && $outputColHash_ref->{'cog_id'}  ne '' )
                 || ( $key eq 'pfam_id,pfam_name'        && $outputColHash_ref->{'pfam_id'} ne '' )
                 || ( $key eq 'tigrfam_id,tigrfam_name'  && $outputColHash_ref->{'tigrfam_id'} ne '' )
                 || ( $key eq 'ec_number,enzyme_name'    && $outputColHash_ref->{'ec_number'} ne '' )
                 || ( $key eq 'ko_id,ko_name,definition' && $outputColHash_ref->{'ko_id'}   ne '' ) )
            {
                $str = 'checked';
            }

            print qq{
                <input type="checkbox" value="$key" name="$field_col_name" $str> $value <br/>
            };
        }
        
        print qq{
                  </div>
                </td>
    
        };            
    }

    print qq{
          </tr>
        </table>
      </div>\n
    };

    print submit(
          -id    => "moreGo",
          -name  => $name,
          -value => "Display Genes Again",
          -class => "meddefbutton"
    );

}


############################################################################
# appendGeneTableConfiguration_old - Print output attributtes for optional
#   configuration information.
# Keep the old one for potential use
############################################################################
sub appendGeneTableConfiguration_old {
    my ( $outputColHash_ref, $name ) = @_;

    printTreeViewMarkup();

    print "<h2>Table Configuration</h2>\n";
    print "<table id='configurationTable' class='img' border='0'>\n";
    print qq{
        <tr class='img'>
        <th class='img' colspan='3' nowrap>Additional Output Columns<br />
            <input type='button' class='khakibutton' id='moreExpand' name='expand' value='Expand All'>
            <input type='button' class='khakibutton' id='moreCollapse' name='collapse' value='Collapse All'>
        </th>
        </tr>
    };

    print "<tr valign='top'>\n";
    my @categoryNames = ( "Gene Field", "Scaffold/Contig Field", "Function Field" );
    my $numCategories = scalar(@categoryNames);
    my @gtOptCols = ();   # add @gOptCols and @tOptCols into @gtOptCols
    push( @gtOptCols, @gOptCols, @tOptCols ); 
    my @sOptCols = ();    # add @sfOptCols and @ssOptCols into @sOptCols
    push( @sOptCols, @sfOptCols );
    splice( @sOptCols, 3, 0, @ssOptCols );
    my @categoryOptCols = ( \@gtOptCols, \@sOptCols, \@fOptCols );
    my %categories = ();

    for ( my $i = 0 ; $i < $numCategories ; $i++ ) {
        my $treeId = $categoryNames[$i];
        print "<td class='img' nowrap>\n";
        print "<div id='$treeId' class='ygtv-checkbox'>\n";

        my $jsObject            = "{label:'<b>$treeId</b>', children: [";
        my $categoryOptCols_ref = $categoryOptCols[$i];
        my @optCols             = @$categoryOptCols_ref;
        my $hiLiteCnt           = 0;
        for ( my $j = 0 ; $j < scalar(@optCols) ; $j++ ) {
            my $key = $optCols[$j];
            next if ( $key eq 'locus_tag' || $key eq 'gene_display_name' );

            if ( $j != 0 ) {
                $jsObject .= ", ";
            }
            my $val = $colName2Label{$key};

            #print "$key => $val<br/>\n";
            #my $myLabel = "<input type='checkbox' name='outputCol' value='$key' />$val";
            #$jsObject .= "{id:\"$key\", label:\"$myLabel\"}";
            #$jsObject .= "{id:\"$key\", label:\"$val\"}";
            $jsObject .= "{id:\"$key\", label:\"$val\"";
            if (    $outputColHash_ref->{$key} ne ''
                 || ( $key eq 'cog_id,cog_name'          && $outputColHash_ref->{'cog_id'}  ne '' )
                 || ( $key eq 'pfam_id,pfam_name'        && $outputColHash_ref->{'pfam_id'} ne '' )
                 || ( $key eq 'tigrfam_id,tigrfam_name'  && $outputColHash_ref->{'tigrfam_id'} ne '' )
                 || ( $key eq 'ec_number,enzyme_name'    && $outputColHash_ref->{'ec_number'} ne '' )
                 || ( $key eq 'ko_id,ko_name,definition' && $outputColHash_ref->{'ko_id'}   ne '' ) )
            {
                $jsObject .= ", highlightState:1";
                $hiLiteCnt++;
            }
            $jsObject .= "}";
        }
        $jsObject .= "]";
        if ( $hiLiteCnt > 0 ) {
            if ( $hiLiteCnt == scalar(@optCols) ) {
                $jsObject .= ", highlightState:1";
            } else {
                $jsObject .= ", highlightState:2";
            }
        }
        $jsObject .= "}";

        $categories{ $categoryNames[$i] } = $jsObject;
        print "</div></td>\n";
    }

    print "</tr>\n";
    print "</table>\n";

    my $categoriesObj = "{category:[";
    for ( my $i = 0 ; $i < $numCategories ; $i++ ) {
        $categoriesObj .= "{name:'$categoryNames[$i]', ";
        #$categoriesObj .= "value : $categories{$categoryNames[$i]}}";
        $categoriesObj .= "value:[" . $categories{ $categoryNames[$i] } . "]}";
        if ( $i != $numCategories - 1 ) {
            $categoriesObj .= ", ";
        }
    }

    $categoriesObj .= "]}";

    setJSObjects($categoriesObj);

    print submit(
                  -id    => "moreGo",
                  -name  => $name,
                  -value => "Display Genes Again",
                  -class => "meddefbutton"
    );
    print nbsp(1);

    print "<input id='selAll' type=button name=SelectAll value='Select All' class='smbutton' />\n";
    print nbsp(1);
    print "<input id='clrAll' type=button name=ClearAll value='Clear All' class='smbutton' />\n";
}

sub printTreeViewMarkup {
    printTreeMarkup();
    print qq{
        <script language='JavaScript' type='text/javascript' src='$top_base_url/js/findGenesTree.js'>
        </script>
    };
}

sub setJSObjects {
    my ($categoriesObj) = @_;
    print qq{
        <script type="text/javascript">
           setMoreJSObjects($categoriesObj);
           setExpandAll();
           moreTreeInit();
        </script>
    };
}

sub compareTwoArrays {
    my ( $first, $second ) = @_;
    return 0 unless @$first == @$second;
    for ( my $i = 0 ; $i < @$first ; $i++ ) {
        return 0 if $first->[$i] ne $second->[$i];
    }
    return 1;
}

sub getOutputCols {
    my ($fixedColIDs, $tool, $useAll) = @_;

    my @geneFieldCols = param('gene_field_col');
    my @scaffoldFieldCols = param('scaffold_field_col');
    my @functionFieldCols = param('function_field_col');
    my @projectMetadataCols = param('metadata_col');
    
    if ( $useAll ) {
        my @gtOptCols = ();   # add @gOptCols, @tOptCols, and @gtsOptCols into @gtOptCols
        push( @gtOptCols, @gOptCols, @tOptCols, @gtsOptCols ); 
        @geneFieldCols = @gtOptCols;

        my @sOptCols = ();    # add @sfOptCols and @ssOptCols into @sOptCols
        push( @sOptCols, @sfOptCols );
        splice( @sOptCols, 3, 0, @ssOptCols );
        @scaffoldFieldCols = @sOptCols;
        
        @functionFieldCols = @fOptCols;
        
        my @projectMetadataColumnsOrder = GenomeList::getProjectMetadataAttrs();
        @projectMetadataCols = @projectMetadataColumnsOrder;
    }

    my @outputCols;
    push(@outputCols, @geneFieldCols, @scaffoldFieldCols, @functionFieldCols, @projectMetadataCols);

    #To keep the old implementation intact
    if ( scalar(@outputCols) == 0 ) {
        my $outputColStr = param("outputCol");
        #my @fixedCols = WebUtil::processParamValue($fixedColIDs);
        #foreach my $c (@fixedCols) {
        #    $outputColStr  =~ s/$c//i;
        #}
        @outputCols = WebUtil::processParamValue($outputColStr);        
        #print "getOutputCols() 0 outputCols: @outputCols<br/>\n";
    } 

    if (scalar(@outputCols) == 0 
        && paramMatch("setGeneOutputCol") eq '' 
        && $tool) {
        my $colIDsExist = readColIdFile($tool);
        #print "getOutputCols() $tool colIDsExist: $colIDsExist<br/>\n";
        if ( $colIDsExist ) {
            $colIDsExist =~ s/$fixedColIDs//i;
            my @outColsExist = WebUtil::processParamValue($colIDsExist);
            push(@outputCols, @outColsExist);
        }
        #print "getOutputCols() $tool outputCols: @outputCols<br/>\n";
    }

    return \@outputCols;
}

sub getOutputColClauses {
    my ($fixedColIDs, $tool, $useAll) = @_;
    
    my $outputCols_ref = getOutputCols($fixedColIDs, $tool, $useAll);
    #print "getOutputColClauses() outputCols_ref: @$outputCols_ref<br/>\n";

    my $outColClause;
    
    my $taxonJoinClause;
    my $scfJoinClause;
    my $ssJoinClause;

    my $cogQueryClause;
    my $pfamQueryClause;
    my $tigrfamQueryClause;
    my $ecQueryClause;
    my $koQueryClause;
    my $imgTermQueryClause;

    my $get_taxon_public = 0;
    my $get_taxon_oid    = 0;
    my $get_gene_info    = 0;
    my $get_gene_faa     = 0;
    my $get_gene_tmh     = 0;
    my $get_gene_sig     = 0;
    my $get_scaf_info    = 0;

    my @projectMetadataCols;
    
    for (my $i = 0 ; $i < scalar(@$outputCols_ref) ; $i++) {
        my $c = $outputCols_ref->[$i];
    	if ($c eq 'is_public') {
    	    $get_taxon_public = 1;
    	} elsif ($c eq 'taxon_oid') {
            $get_taxon_oid = 1;

    	} elsif ($c eq 'locus_type'
    	      || $c eq '$start_coord'
    	      || $c eq '$end_coord'
    	      || $c eq '$strand'
    	      || $c eq 'dna_seq_length'
    	      || $c eq 'scaffold_oid') {
    	    $get_gene_info = 1;
    	} elsif ($c eq 'aa_seq_length') {
    	    $get_gene_faa = 1;
    	} elsif ($c eq 'seq_length'
    	      || $c eq 'gc_percent'
    	      || $c eq 'read_depth') {
    	    $get_gene_info = 1;
    	    $get_scaf_info = 1;
        } elsif ($c eq $FEATURE_TYPE) {
            $get_gene_tmh = 1;
        } elsif ($c eq $SIG_PEPTIDES) {
            $get_gene_sig = 1;
    	}

        my $tableType = findColType($c);
        
        webLog("tableType === $tableType\n");
        if ($tableType eq 'g') {
            if ($c =~ /add_date/i) {
                # use iso format yyyy-mm-dd s.t. its ascii sortable - ken
                $outColClause .= ", to_char(g.$c, 'yyyy-mm-dd') ";
            } else {
                $outColClause .= ", g.$c ";
            }
        } elsif ($tableType eq 'gts') {
            $outColClause .= ", '$c' ";
        } elsif ($tableType eq 't') {
            $outColClause .= ", tx.$c ";
            $taxonJoinClause = qq{
                left join taxon tx on g.taxon = tx.taxon_oid
            } if ($scfJoinClause eq '');
        } elsif ($tableType eq 'sf') {
            $outColClause .= ", scf.$c ";
            $scfJoinClause = qq{
                left join scaffold scf on g.scaffold = scf.scaffold_oid
            } if ($scfJoinClause eq '');

        } elsif ($tableType eq 'ss') {
            $outColClause .= ", ss.$c ";
            $ssJoinClause = qq{
                left join scaffold_stats ss on g.scaffold = ss.scaffold_oid
            } if ($ssJoinClause eq '');

        } elsif ($tableType eq 'f') {
            if ($c =~ /cog_id/i || $c =~ /cog_name/i) {
                $cogQueryClause .= ", cg.$c ";
            } elsif ($c =~ /pfam_id/i || $c =~ /pfam_name/i) {
                $pfamQueryClause .= ", pf.ext_accession " if ($c =~ /pfam_id/i);
                $pfamQueryClause .= ", pf.name "          if ($c =~ /pfam_name/i);
            } elsif ($c =~ /tigrfam_id/i || $c =~ /tigrfam_name/i) {
                $tigrfamQueryClause .= ", tf.ext_accession " if ($c =~ /tigrfam_id/i);
                $tigrfamQueryClause .= ", tf.expanded_name " if ($c =~ /tigrfam_name/i);
            } elsif ($c =~ /ec_number/i || $c =~ /enzyme_name/i) {
                $ecQueryClause .= ", ec.$c ";
            } elsif ($c =~ /ko_id/i || $c =~ /ko_name/i || $c =~ /definition/i) {
                $koQueryClause .= ", kt.$c ";
            } elsif ($c eq 'img_term') {
                $imgTermQueryClause .= ", itx.term_oid, itx.term ";
            }
        } elsif ($tableType eq 'p') {
            push(@projectMetadataCols, $c);
        }
    }

    return ($outColClause, 
        $taxonJoinClause,$scfJoinClause, $ssJoinClause, 
        $get_gene_tmh,   $get_gene_sig,
	    $cogQueryClause, $pfamQueryClause, $tigrfamQueryClause, 
	    $ecQueryClause,  $koQueryClause, $imgTermQueryClause, 
	    \@projectMetadataCols, $outputCols_ref, $get_taxon_public, 
	    $get_gene_info,  $get_gene_faa, $get_scaf_info, $get_taxon_oid);
}

sub addColIDs {
    my ($it, $outCols_aref) = @_;

    #print "addColIDs() outCols_aref: @$outCols_aref<br/>\n";
    if (scalar(@$outCols_aref) > 0) {
        foreach my $col (@$outCols_aref) {
            next if (   $col eq 'cog_name'
		     || $col eq 'pfam_name'
		     || $col eq 'tigrfam_name'
		     || $col eq 'enzyme_name'
		     || $col eq 'ko_name'
		     || $col eq 'definition');

            my $colAlign;
            my $colName;
            my $tooltip;
            
            if ($col eq 'cog_id') {
                $colName = "COG";
                $tooltip = 'COG ID and Name';
            } elsif ($col eq 'pfam_id') {
                $colName = "Pfam";
                $tooltip = 'Pfam ID and Name';
            } elsif ($col eq 'tigrfam_id') {
                $colName = "Tigrfam";
                $tooltip = 'Tigrfam ID and Name';
            } elsif ($col eq 'ec_number') {
                $colName = "Enzyme";
                $tooltip = 'Enzyme ID and Name';
            } elsif ($col eq 'ko_id') {
                $colName = "KO";
                $tooltip = 'KO ID, Name and Definition';
            } elsif ( GenomeList::isProjectMetadataAttr($col) ) {
                $colName = GenomeList::getProjectMetadataColName($col);                
                $colAlign = GenomeList::getProjectMetadataColAlign($col);
            } else {
                $colName = getColLabelSpecial($col);
                $colName = getColLabel($col) if ($colName eq '');
            }

            $colAlign = getColAlign($col) if ( !$colAlign );
            
            if ($colAlign eq "num asc right") {
                $it->addColSpec("$colName", "asc", "right", "", $tooltip);
            } elsif ($colAlign eq "num desc right") {
                $it->addColSpec("$colName", "desc", "right", "", $tooltip);
            } elsif ($colAlign eq "num desc left") {
                $it->addColSpec("$colName", "desc", "left", "", $tooltip);
            } elsif ($colAlign eq "char asc left") {
                $it->addColSpec("$colName", "asc", "left", "", $tooltip);
            } elsif ($colAlign eq "char desc left") {
                $it->addColSpec("$colName", "desc", "left", "", $tooltip);
            } elsif ($colAlign eq "char asc center") {
                $it->addColSpec("$colName", "asc", "center", "", $tooltip);
            } else {
                $it->addColSpec("$colName", "", "", "", $tooltip);
            }
        }
    }

    return $it;
}

sub printColIDs {
    my ($outCols_aref, $wfh) = @_;

    if (scalar(@$outCols_aref) > 0) {
        foreach my $col (@$outCols_aref) {
            next if (   $col eq 'cog_name'
             || $col eq 'pfam_name'
             || $col eq 'tigrfam_name'
             || $col eq 'enzyme_name'
             || $col eq 'ko_name'
             || $col eq 'definition');

            my $colName;
            
            if ($col eq 'dna_seq_length') {
                $colName = "DNA Sequence Length (bp)";
            } elsif ($col eq 'aa_seq_length') {
                $colName = "Amino Acid Sequence Length (aa)";
            } elsif ($col eq 'seq_length') {
                $colName = "Scaffold Length (bp)";
            } elsif ($col eq 'cog_id') {
                $colName = "COG";
            } elsif ($col eq 'pfam_id') {
                $colName = "Pfam";
            } elsif ($col eq 'tigrfam_id') {
                $colName = "Tigrfam";
            } elsif ($col eq 'ec_number') {
                $colName = "Enzyme";
            } elsif ($col eq 'ko_id') {
                $colName = "KO";
            } elsif ( GenomeList::isProjectMetadataAttr($col) ) {
                $colName = GenomeList::getProjectMetadataColName($col);                
            } else {
                $colName = getColLabelSpecial($col);
                $colName = getColLabel($col) if ($colName eq '');
            }
            if ( $wfh ) {            
                print $wfh "$colName\t";
            }
            else {
                print "$colName\t";                
            }
        }
    }
}

############################################################################
# addCols2Row - adds the selected output column values to the row
############################################################################
sub addCols2Row {
    my ($gene_oid, $data_type, $taxon_oid, $scaffold_oid, 
    	$row, $sd, $outCols_ref, $outColVals_ref) = @_;

    #my $cols = join(",", @$outCols_ref);
    #my $vals = join(",", @$outColVals_ref);

    for (my $j = 0; $j < scalar(@$outCols_ref); $j++) {
    	my $col = $outCols_ref->[$j];
        next
          if (    $col eq 'cog_name'
               || $col eq 'pfam_name'
               || $col eq 'tigrfam_name'
               || $col eq 'enzyme_name'
               || $col eq 'ko_name'
        	   || $col eq 'definition' );

    	my $colVal = $outColVals_ref->[$j];

    	if ($col eq 'gc_percent' && $colVal) {
    	    $colVal = sprintf("%.2f", $colVal);
    	    $row .= $colVal . $sd . $colVal . "\t";
    	} elsif ($col eq 'read_depth' && $colVal) {
    	    $row .= $colVal . $sd . $colVal . "\t";
    	} elsif ($col eq 'scaffold_oid' && $colVal) {
    	    $scaffold_oid = $colVal;
    	    my $scaffold_url;
    	    if ($data_type eq 'database' && WebUtil::isInt($colVal)) {
        		$scaffold_url = 
        		    "$main_cgi?section=ScaffoldDetail"
        		  . "&page=scaffoldDetail&scaffold_oid=$colVal";
    	    } else {
        		$scaffold_url =
        		    "$main_cgi?section=MetaScaffoldDetail"
        		  . "&page=metaScaffoldDetail&scaffold_oid=$colVal"
        		  . "&taxon_oid=$taxon_oid&data_type=$data_type";
    	    }
    	    $scaffold_url = alink($scaffold_url, $colVal);
    	    $row .= $colVal . $sd . $scaffold_url . "\t";
    
    	} elsif ($col eq 'seq_length' && $colVal) {
    	    my $scaf_len_url;
    	    if ($scaffold_oid ne '') {
        		if ($data_type eq 'database' && WebUtil::isInt($colVal)) {
        		    $scaf_len_url =
        			"$main_cgi?section=ScaffoldGraph"
        		       . "&page=scaffoldGraph&scaffold_oid=$scaffold_oid"
        		       . "&taxon_oid=$taxon_oid"
        		       . "&start_coord=1&end_coord=$colVal"
        		       . "&marker_gene=$gene_oid&seq_length=$colVal";
        		} elsif ($data_type eq 'assembled') {
        		    $scaf_len_url =
        			"$main_cgi?section=MetaScaffoldGraph"
                      . "&page=metaScaffoldGraph&scaffold_oid=$scaffold_oid"
        		      . "&taxon_oid=$taxon_oid&data_type=$data_type"
        		      . "&start_coord=1&end_coord=$colVal"
        		      . "&marker_gene=$gene_oid&seq_length=$colVal";
        		}
    	    }
    	    if ($scaf_len_url ne '') {
        		$row .= $colVal . $sd . alink($scaf_len_url, $colVal) . "\t";
    	    } else {
        		$row .= $colVal . $sd . $colVal . "\t";
    	    }
    
    	} elsif ($col eq 'cog_id' && $colVal) {
    	    my $cog_all;
    	    my @cogIdNameGroups = split($fDelim, $colVal);
    	    foreach my $cogIdName (@cogIdNameGroups) {
        		my ($cogId, $cogName) = split($dDelim, $cogIdName);
        		my $cogid_url = alink($cog_base_url . $cogId, $cogId);
        		$cog_all .= $cogid_url . " - " . $cogName . "<br/><br/>";
    	    }
    	    $row .= $colVal . $sd . $cog_all . "\t";
            #print "addCols2Row() col=$col colVal=$colVal cog_all=$cog_all<br/>\n";

    	} elsif ($col eq 'pfam_id' && $colVal) {
    	    my $pfam_all;
    	    my @pfamIdNameGroups = split($fDelim, $colVal);
    	    foreach my $pfamIdName (@pfamIdNameGroups) {
        		my ($pfamId, $pfamName) = split($dDelim, $pfamIdName);
        		my $pfam_id2 = $pfamId;
        		$pfam_id2 =~ s/pfam/PF/i;
        		my $pfamid_url = alink($pfam_base_url . $pfam_id2, $pfamId);
        		$pfam_all .= $pfamid_url . " - " . $pfamName . "<br/><br/>";
    	    }
    	    $row .= $colVal . $sd . $pfam_all . "\t";
            #print "addCols2Row() col=$col colVal=$colVal pfam_all=$pfam_all<br/>\n";
    
    	} elsif ($col eq 'tigrfam_id' && $colVal) {
    	    my $tigrfam_all;
    	    my @tigrfamIdNameGroups = split($fDelim, $colVal);
    	    foreach my $tigrfamIdName (@tigrfamIdNameGroups) {
        		my ($tigrfamId, $tigrfamName) = split($dDelim, $tigrfamIdName);
        		my $tigrfamid_url = alink($tigrfam_base_url . $tigrfamId, $tigrfamId);
        		$tigrfam_all .= $tigrfamid_url . " - " . $tigrfamName . "<br/><br/>";
    	    }
    	    $row .= $colVal . $sd . $tigrfam_all . "\t";
            #print "addCols2Row() col=$col colVal=$colVal tigrfam_all=$tigrfam_all<br/>\n";
    
    	} elsif ($col eq 'ec_number' && $colVal) {
    	    my $ec_all;
    	    my @ecIdNameGroups = split($fDelim, $colVal);
    	    foreach my $ecIdName (@ecIdNameGroups) {
        		my ($ecId, $ecName) = split($dDelim, $ecIdName);
        		my $ecid_url = alink($enzyme_base_url . $ecId, $ecId);
        		$ec_all .= $ecid_url . " - " . $ecName . "<br/><br/>";
    	    }
    	    $row .= $colVal . $sd . $ec_all . "\t";
            #print "addCols2Row() col=$col colVal=$colVal ec_all=$ec_all<br/>\n";

    	} elsif ($col eq 'ko_id' && $colVal) {
    	    my $ko_all;
    	    my @koIdNameDefGroups = split($fDelim, $colVal);
    	    foreach my $koIdNameDef (@koIdNameDefGroups) {
        		my ($ko_id, $ko_name, $ko_def) = split($dDelim, $koIdNameDef);
        		my $koid_url = alink($kegg_orthology_url . $ko_id, $ko_id);
                my $koname_url =
                    "main.cgi?section=KeggPathwayDetail"
                  . "&page=keggModulePathway"
                  . "&ko_id=$ko_id&ko_name=$ko_name"
                  . "&ko_def=$ko_def&gene_oid=$gene_oid"
                  . "&taxon_oid=$taxon_oid";
        		$koname_url = alink($koname_url, $ko_name);
        		$ko_all .= $koid_url . " - " . $koname_url . "; " . $ko_def . "<br/><br/>";
    	    }
    	    $row .= $colVal . $sd . $ko_all . "\t";
            #print "addCols2Row() col=$col colVal=$colVal ko_all=$ko_all<br/>\n";

    	} elsif ($col eq 'img_term' && $colVal) {
    	    my $imgterm_all;
    	    my @imgTermIdNameGroups = split($fDelim, $colVal);
    	    foreach my $imgTermIdName (@imgTermIdNameGroups) {
        		my ($imgTermId, $imgTermName) = split($dDelim, $imgTermIdName);
        		my $imgterm_url = "main.cgi?section=ImgTermBrowser" 
	                . "&page=imgTermDetail&term_oid=$imgTermId";
        		$imgterm_url = alink( $imgterm_url, $imgTermId );
        		$imgterm_all .= $imgterm_url . " - " . $imgTermName . "<br/><br/>";
    	    }
    	    $row .= $colVal . $sd . $imgterm_all . "\t";
            #print "addCols2Row() col=$col colVal=$colVal imgterm_all=$imgterm_all<br/>\n";

        } elsif ( GenomeList::isProjectMetadataAttr($col) ) {
            #print "addCols2Row() col=$col colVal=$colVal<br/>\n";
            if ( $colVal eq '' || blankStr($colVal) ) {
                my $tmp = GenomeList::getProjectMetadataColAlign($col);
                if ( $tmp =~ /^char/ ) {
                    $row .= 'zzz' . $sd . '_' . "\t";
                } else {
                    $row .= '0' . $sd . '_' . "\t";
                }
            } elsif ( GenomeList::getColAsUrl($col) ) {
                my $url;
                if ( $col eq 'p.gold_stamp_id' ) {
                    # Gs or Gp
                    $url = HtmlUtil::getGoldUrl($colVal);
                    $url = "<a href='$url'>$colVal</a>";                    
                }
                else {
                    $url = GenomeList::getColAsUrl($col) . $colVal;
                    $url = alink( $url, $colVal );                    
                }
                $row .= $colVal . $sd . $url . "\t";
            } else {
                $row .= $colVal . $sd . $colVal . "\t";
            }
    	} else {
    	    $colVal = nbsp(1) if !$colVal;
    	    $row .= $colVal . $sd . $colVal . "\t";
    	}
    }

    return $row;
}

sub printCols2Row {
    my ($gene_oid, $data_type, $taxon_oid, $scaffold_oid, 
        $outCols_ref, $outColVals_ref, $wfh) = @_;

    for (my $j = 0; $j < scalar(@$outCols_ref); $j++) {
        my $col = $outCols_ref->[$j];
        next
          if (    $col eq 'cog_name'
               || $col eq 'pfam_name'
               || $col eq 'tigrfam_name'
               || $col eq 'enzyme_name'
               || $col eq 'ko_name'
               || $col eq 'definition' );

        my $colVal = $outColVals_ref->[$j];

        if ($col eq 'gc_percent' && $colVal) {
            $colVal = sprintf("%.2f", $colVal);
            if ( $wfh ) {            
                print $wfh $colVal . "\t";
            }
            else {
                print $colVal . "\t";
            }

        } elsif ($col eq 'cog_id' && $colVal) {
            my $cog_all;
            my @cogIdNameGroups = split($fDelim, $colVal);
            foreach my $cogIdName (@cogIdNameGroups) {
                my ($cogId, $cogName) = split($dDelim, $cogIdName);
                $cog_all .= $cogId . " - " . $cogName . "<br/><br/>";
            }
            if ( $wfh ) {            
                print $wfh $cog_all . "\t";        
            }
            else {
                print $cog_all . "\t";        
            }

        } elsif ($col eq 'pfam_id' && $colVal) {
            my $pfam_all;
            my @pfamIdNameGroups = split($fDelim, $colVal);
            foreach my $pfamIdName (@pfamIdNameGroups) {
                my ($pfamId, $pfamName) = split($dDelim, $pfamIdName);
                $pfam_all .= $pfamId . " - " . $pfamName . "<br/><br/>";
            }
            if ( $wfh ) {            
                print $wfh $pfam_all . "\t";        
            }
            else {
                print $pfam_all . "\t";        
            }
    
        } elsif ($col eq 'tigrfam_id' && $colVal) {
            my $tigrfam_all;
            my @tigrfamIdNameGroups = split($fDelim, $colVal);
            foreach my $tigrfamIdName (@tigrfamIdNameGroups) {
                my ($tigrfamId, $tigrfamName) = split($dDelim, $tigrfamIdName);
                $tigrfam_all .= $tigrfamId . " - " . $tigrfamName . "<br/><br/>";
            }
            if ( $wfh ) {            
                print $wfh $tigrfam_all . "\t";        
            }
            else {
                print $tigrfam_all . "\t";        
            }

        } elsif ($col eq 'ec_number' && $colVal) {
            my $ec_all;
            my @ecIdNameGroups = split($fDelim, $colVal);
            foreach my $ecIdName (@ecIdNameGroups) {
                my ($ecId, $ecName) = split($dDelim, $ecIdName);
                $ec_all .= $ecId . " - " . $ecName . "<br/><br/>";
            }
            if ( $wfh ) {            
                print $wfh $ec_all . "\t";        
            }
            else {
                print $ec_all . "\t";        
            }

        } elsif ($col eq 'ko_id' && $colVal) {
            my $ko_all;
            my @koIdNameDefGroups = split($fDelim, $colVal);
            foreach my $koIdNameDef (@koIdNameDefGroups) {
                my ($ko_id, $ko_name, $ko_def) = split($dDelim, $koIdNameDef);
                $ko_all .= $ko_id . " - " . $ko_name . "; " . $ko_def . "<br/><br/>";
            }
            if ( $wfh ) {            
                print $wfh $ko_all . "\t";        
            }
            else {
                print $ko_all . "\t";        
            }

        } elsif ($col eq 'img_term' && $colVal) {
            my $imgterm_all;
            my @imgTermIdNameGroups = split($fDelim, $colVal);
            foreach my $imgTermIdName (@imgTermIdNameGroups) {
                my ($imgTermId, $imgTermName) = split($dDelim, $imgTermIdName);
                $imgterm_all .= $imgTermId . " - " . $imgTermName . "<br/><br/>";
            }
            if ( $wfh ) {            
                print $wfh $imgterm_all . "\t";        
            }
            else {
                print $imgterm_all . "\t";        
            }

        } elsif ( GenomeList::isProjectMetadataAttr($col) ) {
            #print "addCols2Row() col=$col colVal=$colVal<br/>\n";
            if ( $colVal eq '' || blankStr($colVal) ) {
                if ( $wfh ) {            
                    print $wfh '_' . "\t";        
                }
                else {
                    print '_' . "\t";        
                }
            } else {
                if ( $wfh ) {            
                    print $wfh $colVal . "\t";        
                }
                else {
                    print $colVal . "\t";        
                }
            }
        } else {
            if ( $wfh ) {            
                print $wfh $colVal . "\t";        
            }
            else {
                print $colVal . "\t";        
            }
        }
    }

}


###########################################################################
# readColIdFile
###########################################################################
sub readColIdFile {
    my ($tool) = @_;

    my $colIDs = "";
    my $res = newReadFileHandle(getFile("colid", $tool), "runJob", 1);
    if ($res) {
        my $line = $res->getline();
        chomp $line;
        $colIDs = $line;
        close $res;
    }
    return $colIDs;
}

###########################################################################
# writeColIdFile
###########################################################################
sub writeColIdFile {
    my ($colIDs, $tool) = @_;

    if ($colIDs eq "") {
        wunlink(getFile("colid", $tool)); # remove col id file
    } else {
        my $res = newWriteFileHandle(getFile("colid", $tool), "runJob", 1);
        if ($res) {
            print $res "$colIDs\n";
            close $res;
        }
    }
}

###########################################################################
# readRecsFile
###########################################################################
sub readRecsFile {
    my ($tool) = @_;
    
    my %records;
    my $res = newReadFileHandle( getStorFile($tool), "runJob", 1 );
    if ( !$res ) {
        return \%records;
    }
    while ( my $line = $res->getline() ) {
        chomp $line;
        next if ( $line eq "" );
        my ( $oid, @junk ) = split( /\t/, $line );
        $oid = WebUtil::strTrim($oid);
        if ( $oid && WebUtil::hasAlphanumericChar($oid) ) {
            $records{$oid} = $line;
        }
    }
    close $res;

    #print "readRecsFile() oids: " . keys(%records) . "<br/><br/>\n\n";
    return \%records;
}

###########################################################################
# writeRecsFile
###########################################################################
sub writeRecsFile {
    my ($recs, $tool) = @_;

    my $res = newWriteFileHandle( getStorFile($tool), "runJob", 1 );
    foreach my $key ( keys %{$recs} ) {
        my $rec = $recs->{$key};
        if ($rec) {
            print $res $rec . "\n";
        }
    }
    close $res;
}

###########################################################################
# getFile
###########################################################################
sub getFile {
    my ($fileNameEnd, $tool) = @_;
    
    my ($cartDir, $sessionId) = WebUtil::getCartDir();
    my $sessionFile = "$cartDir/$tool.$sessionId." . $fileNameEnd;
    return $sessionFile;
}

###########################################################################
# getStorFile
###########################################################################
sub getStorFile {
    my ($tool) = @_;

    return getFile("stor", $tool);
}



1;
