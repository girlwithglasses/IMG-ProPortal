use utf8;
package DBIC::IMG_Core::Result::PpDataTypeView;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::PpDataTypeView

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<PP_DATA_TYPE_VIEW>

=cut

__PACKAGE__->table("PP_DATA_TYPE_VIEW");
__PACKAGE__->result_source_instance->view_definition("select\nCASE\n   WHEN genome_type = 'isolate' THEN\n    CASE\n      WHEN analysis_project_type in( 'Single Cell Analysis (unscreened)' , 'Single Cell Analysis (screened)') THEN 'single_cell'\n      WHEN exists ( select 1 from rnaseq_dataset where rnaseq_dataset.reference_taxon_oid = taxon.taxon_oid AND rnaseq_dataset.dataset_type = 'Transcriptome') THEN 'transcriptome'\n      ELSE genome_type\n    END\n   WHEN analysis_project_type = 'Metatranscriptome Analysis' THEN 'metatranscriptome'\n   ELSE genome_type\n   END\nAS dataset_type,\nCASE\n   WHEN taxon.genome_type = 'isolate' THEN\n    CASE\n      WHEN lower(taxon.taxon_display_name) LIKE 'prochlorococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'pro'\n          WHEN taxon.domain = 'Viruses' THEN 'pro_phage'\n        END\n      WHEN lower(taxon.taxon_display_name) LIKE 'synechococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'syn'\n          WHEN taxon.domain = 'Viruses' THEN 'syn_phage'\n        END\n      WHEN ( lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'marginal sea' OR lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'pelagic') THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'other'\n          WHEN taxon.domain = 'Viruses' THEN 'other_phage'\n        END\n    END\n   WHEN taxon.genome_type = 'metagenome' AND lower(GOLD_SEQUENCING_PROJECT.ecosystem_type) = 'marine' THEN taxon.genome_type\nEND\nAS PP_SUBSET,\nCASE\n   WHEN taxon.genome_type = 'isolate' THEN\n    CASE\n      WHEN lower(taxon.taxon_display_name) LIKE 'prochlorococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'pro'\n          WHEN taxon.domain = 'Viruses' THEN 'pro_phage'\n        END\n      WHEN lower(taxon.taxon_display_name) LIKE 'synechococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'syn'\n          WHEN taxon.domain = 'Viruses' THEN 'syn_phage'\n        END\n      WHEN ( lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'marginal sea' OR lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'pelagic') THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'other'\n          WHEN taxon.domain = 'Viruses' THEN 'other_phage'\n        END\n    END\n   WHEN taxon.genome_type = 'metagenome' AND lower(GOLD_SEQUENCING_PROJECT.ecosystem_type) = 'marine' THEN taxon.genome_type\nEND\nAS PROPORTAL_SUBSET,\n taxon.taxon_oid, taxon.is_public, taxon.taxon_display_name, taxon.genome_type\nFROM\ntaxon\nINNER JOIN\ngold_sequencing_project\nON\ntaxon.sequencing_gold_id = gold_sequencing_project.gold_id\n-- LEFT JOIN rnaseq_dataset ON rnaseq_dataset.reference_taxon_oid = taxon.taxon_oid\nWHERE\ntaxon.obsolete_flag = 'No' AND is_public = 'Yes'");

=head1 ACCESSORS

=head2 dataset_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pp_subset

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 proportal_subset

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 is_public

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 taxon_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "dataset_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pp_subset",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "proportal_subset",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "is_public",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "taxon_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cKutMTcsWA67Ygp5HEjh7A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
