package DataModel::IMG_Core;

use IMG::Util::Base;
use DBIx::DataModel;
use IMG::Model::UnitConverter;

DBIx::DataModel  # no semicolon (intentional)

#---------------------------------------------------------------------#
#                         SCHEMA DECLARATION                          #
#---------------------------------------------------------------------#
->Schema('DataModel::IMG_Core');


DataModel::IMG_Core->metadm->define_type(
	name     => 'Distance',
	handlers => {
		from_DB  => sub {
			my ($col_val, $obj, $col_name, $handler) = @_;
			if ($col_val) {
				my $nor_m = IMG::Model::UnitConverter::distance_in_m( $col_val );
				if ($nor_m) {
					$_[0] = $nor_m;
				}
				else {
					$obj->{ $col_name ."_string"} = $col_val;
					$_[0] = undef;
				}
			}
		},
#    to_DB    => sub { },
#    validate => sub {$_[0] =~ /1?\d?\d/}),
  });

DataModel::IMG_Core->metadm->define_type(
	name  => 'GenericClade',
	handlers => {
		from_DB => sub {
			my ($col_val, $obj, $col_name, $handler) = @_;
			if ($col_val) {
#				say "args: col value: $col_val, col name: $col_name, handler: $handler, obj: " . Dumper $obj;
				if ($col_name eq 'generic_clade') {
					$col_val = coerce_clade( $col_val );
				}
				$_[0] = $col_val;
			}
		},
	});

DataModel::IMG_Core->metadm->define_type(
	name => 'LatLng',
	handlers => {
		from_DB => sub { $_[0] = IMG::Model::UnitConverter::convertLatLong( $_[0] ) if $_[0]; },
	});

DataModel::IMG_Core->metadm->define_type(
	name => 'EcoNorm',
	handlers => {
		from_DB => sub { $_[0] = ucfirst( lc($_[0]) ) if $_[0] },
	});


#---------------------------------------------------------------------#
#                         TABLE DECLARATIONS                          #
#---------------------------------------------------------------------#
#          Class                      Table                         PK
#          =====                      =====                         ==
DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpCollaborator',
  db_name     => 'GOLD_SP_COLLABORATOR',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldApGenbank',
  db_name     => 'GOLD_AP_GENBANK',
  primary_key => 'id',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpRelevance',
  db_name     => 'GOLD_SP_RELEVANCE',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpDisease',
  db_name     => 'GOLD_SP_DISEASE',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpPhenotype',
  db_name     => 'GOLD_SP_PHENOTYPE',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpMetabolism',
  db_name     => 'GOLD_SP_METABOLISM',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpSeqMethod',
  db_name     => 'GOLD_SP_SEQ_METHOD',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSequencingProject',
  db_name     => 'GOLD_SEQUENCING_PROJECT',
  primary_key => 'gold_id',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldAnalysisProjectLookup2',
  db_name     => 'GOLD_ANALYSIS_PROJECT_LOOKUP2',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'Taxon',
  db_name     => 'TAXON',
  primary_key => 'taxon_oid',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'TaxonStats',
  db_name     => 'TAXON_STATS',
  primary_key => 'taxon_oid',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpEnergySource',
  db_name     => 'GOLD_SP_ENERGY_SOURCE',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldAnalysisProject',
  db_name     => 'GOLD_ANALYSIS_PROJECT',
  primary_key => 'gold_analysis_project_id',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpGenomePublication',
  db_name     => 'GOLD_SP_GENOME_PUBLICATIONS',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'ImgGroup',
  db_name     => 'IMG_GROUP',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpCellArrangement',
  db_name     => 'GOLD_SP_CELL_ARRANGEMENT',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpHabitat',
  db_name     => 'GOLD_SP_HABITAT',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpStudyGoldId',
  db_name     => 'GOLD_SP_STUDY_GOLD_ID',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldSpSeqCenter',
  db_name     => 'GOLD_SP_SEQ_CENTER',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'Contact',
  db_name     => 'CONTACT',
  primary_key => 'contact_oid',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'ContactImgGroups',
  db_name     => 'CONTACT_IMG_GROUPS',
  primary_key => 'contact_oid',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'ImgGroupNews',
  db_name     => 'IMG_GROUP_NEWS',
#  primary_key => '',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'Gene',
  db_name     => 'GENE',
  primary_key => 'gene_oid',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'Scaffold',
  db_name     => 'SCAFFOLD',
  primary_key => 'scaffold_oid',
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldTaxonVw',
  db_name     => 'VW_GOLD_TAXON',
  primary_key => 'gold_id',
	column_types => {
		GenericClade => [ qw( clade ) ],
		Distance     => [ qw( altitude depth ) ],
		LatLng       => [ qw( latitude longitude )],
		EcoNorm      => [ qw( ecosystem_subtype )],
	},
);

DataModel::IMG_Core->metadm->define_table(
  class       => 'ContactTaxonPermissions',
  db_name     => 'CONTACT_TAXON_PERMISSIONS',
);

DataModel::IMG_Core
#---------------------------------------------------------------------#
#                      ASSOCIATION DECLARATIONS                       #
#---------------------------------------------------------------------#
#     Class                      Role                         Mult Join
#     =====                      ====                         ==== ====
->Association(
  [qw/Gene                       gene                         1    scaffold                 /],
  [qw/Scaffold                   scaffold                     *    scaffold_oid /])

->Association(
  [qw/GoldAnalysisProject        reference_gold_ap            0..1 gold_analysis_project_id/],
  [qw/GoldAnalysisProject        gold_analysis_projects       *    reference_gold_ap_id    /])

->Association(
  [qw/GoldAnalysisProject        goldanaproj                  1    gold_analysis_project_id/],
  [qw/Taxon                      taxa                         *    analysis_project_id     /])

->Association(
  [qw/GoldAnalysisProject        gold_analysis_project        0..1 gold_analysis_project_id/],
  [qw/GoldApGenbank              gold_ap_genbanks             *    gold_analysis_project_id/])

->Association(
  [qw/GoldSequencingProject      goldseqproj                  1    gold_id                 /],
  [qw/Taxon                      taxa                         *    sequencing_gold_id      /])

->Association(
  [qw/Taxon                      taxon                        1    taxon_oid                 /],
  [qw/TaxonStats                 taxon_stats                  1    taxon_oid      /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpGenomePublication    gold_sp_genome_publications  *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpHabitat              gold_sp_habitats             *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpEnergySource         gold_sp_energy_sources       *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpPhenotype            gold_sp_phenotypes           *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpSeqCenter            gold_sp_seq_centers          *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpSeqMethod            gold_sp_seq_methods          *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpRelevance            gold_sp_relevances           *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpCellArrangement      gold_sp_cell_arrangements    *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpMetabolism           gold_sp_metabolisms          *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpStudyGoldId          gold_sp_study_gold_ids       *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpCollaborator         gold_sp_collaborators        *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpDisease              gold_sp_diseases             *    gold_id                 /])

# add in links for the GoldTaxonVw table->Association(
->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpGenomePublication    gold_sp_genome_publications  *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpHabitat              gold_sp_habitats             *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpEnergySource         gold_sp_energy_sources       *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpPhenotype            gold_sp_phenotypes           *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpSeqCenter            gold_sp_seq_centers          *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpSeqMethod            gold_sp_seq_methods          *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpRelevance            gold_sp_relevances           *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpCellArrangement      gold_sp_cell_arrangements    *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpMetabolism           gold_sp_metabolisms          *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpStudyGoldId          gold_sp_study_gold_ids       *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpCollaborator         gold_sp_collaborators        *    gold_id                 /])

->Association(
  [qw/GoldTaxonVw                gold_tax                     1    gold_id                 /],
  [qw/GoldSpDisease              gold_sp_diseases             *    gold_id                 /])

;

#---------------------------------------------------------------------#
#                             COLUMN TYPES                            #
#---------------------------------------------------------------------#
# DataModel::IMG_Core->ColumnType(ColType_Example =>
#   fromDB => sub {...},
#   toDB   => sub {...});

# DataModel::IMG_Core::SomeTable->ColumnType(ColType_Example =>
#   qw/column1 column2 .../);

# latlng
#DataModel::IMG_Core->ColumnType(latlng =>
#  fromDB => sub {},   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
#DataModel::IMG_Core::GoldSequencingProject->ColumnType(latlng => qw/latitude longitude/);

# depth/altitude
#DataModel::IMG_Core->ColumnType(dist_m =>
#  fromDB => sub {  },   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
#DataModel::IMG_Core::GoldSequencingProject->ColumnType(dist_m => qw/depth altitude/);

# normalize case
#	fromDB => sub {  },

=cut

DBIx::DataModel->Schema('HR') # Human Resources
->Table(Employee   => T_Employee   => qw/emp_id/);

HR->Type(Multival =>
  from_DB => sub {$_[0] = [split /;/, $_[0]]   if defined $_[0]},
  to_DB   => sub {$_[0] = join ";", @{$_[0]}   if defined $_[0]},
);

HR->Type(Upcase =>
  to_DB   => sub {$_[0] = uc($_[0])   if defined $_[0]},
);

my $meta_emp = HR->table('Employee')->metadm;

$meta_emp->define_column_type(Multival => qw/kids interests/);
$meta_emp->define_column_type(Upcase   => qw/interests/);

=cut

# latlng
#DataModel::IMG_Core->ColumnType(latlng =>
#  fromDB => sub {},   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
#DataModel::IMG_Core::GoldSequencingProject->ColumnType(latlng => qw/latitude longitude/);

# depth/altitude
#DataModel::IMG_Core->ColumnType(dist_m =>
#  fromDB => sub {  },   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
#DataModel::IMG_Core::GoldSequencingProject->ColumnType(dist_m => qw/depth altitude/);


=cut
# lists of values, stored as scalars with a ';' separator
My::Schema->metadm->define_type(
  name     => 'StrToLower',
  handlers => {
   from_DB  => sub { $_[0] = [split /;/, $_[0] || ""]     },
   to_DB    => sub {$_[0] = join ";", @$_[0] if ref $_[0]},
  });


# adding SQL type information for the DBD handler
My::Schema->metadm->define_type(
  name     => 'XML',
  handlers => {
   to_DB    => sub {$_[0] = [{dbd_attrs => {ora_type => ORA_XMLTYPE}}, $_[0]]
                      if $_[0]},
  });

=cut

sub coerce_clade {
	my $c = shift // return;

	say 'clade: "' . $c . '"';
	$c =~ s/^(\d\.\d[A-Z]?).*/$1/g;
	# remove non-\w and replace with underscores
	(my $web_safe_c = $c) =~ s/[^\w]/_/g;
	return wantarray ? ( $c, $web_safe_c ) : $c;
}

sub schema_id {
	return 'img_core';
}

1;
