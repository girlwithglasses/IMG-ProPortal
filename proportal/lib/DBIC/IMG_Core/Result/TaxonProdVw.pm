use utf8;
package DBIC::IMG_Core::Result::TaxonProdVw;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TaxonProdVw

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<TAXON_PROD_VW>

=cut

__PACKAGE__->table("TAXON_PROD_VW");
__PACKAGE__->result_source_instance->view_definition("select \"TAXON_OID\",\"TAXON_NAME\",\"GENUS\",\"SPECIES\",\"STRAIN\",\"TAXON_DISPLAY_NAME\",\"NCBI_TAXON_ID\",\"DOMAIN\",\"PHYLUM\",\"IR_CLASS\",\"IR_ORDER\",\"FAMILY\",\"JGI_SPECIES_CODE\",\"COMMENTS\",\"ENV_SAMPLE\",\"SEQ_STATUS\",\"SEQ_CENTER\",\"IS_PUBLIC\",\"IS_REPLACED\",\"IMG_EC_FLAG\",\"FUNDING_AGENCY\",\"JGI_PROJECT_ID\",\"IMG_VERSION\",\"NCBI_SPECIES_CODE\",\"NCBI_PROJECT_ID\",\"GOLD_ID\",\"RELEASE_DATE\",\"ADD_DATE\",\"ORNL_SPECIES_CODE\",\"IS_BIG_EUK\",\"HOST_NCBI_TAXON_ID\",\"IS_STD_REFERENCE\",\"MOD_DATE\",\"MODIFIED_BY\",\"PROJECT\",\"GENOME_TYPE\",\"GRAM_STAIN\",\"IS_PROXYGENE_SET\",\"OBSOLETE_FLAG\",\"IS_PANGENOME\",\"EDIT_FLAG\",\"SUBMISSION_ID\",\"IMG_PRODUCT_FLAG\",\"REFSEQ_PROJECT_ID\",\"GBK_PROJECT_ID\",\"IS_LOW_QUALITY\",\"PHYLODIST_DATE\",\"PROPOSAL_NAME\",\"SAMPLE_GOLD_ID\",\"PHYLODIST_METHOD\",\"IN_FILE\",\"NCBI_BIOPROJECT_ID\",\"COMBINED_SAMPLE_FLAG\",\"HIGH_QUALITY_FLAG\",\"TAXONOMY_LOCK\",\"LOCKED_BY\",\"LOCK_DATE\",\"DISTMATRIX_DATE\",\"ANALYSIS_PROJECT_ID\",\"LEGACY_GOLD_ID\",\"ANI_SPECIES\",\"STUDY_GOLD_ID\",\"SEQUENCING_GOLD_ID\",\"GENOME_COMPLETION\",\"IS_NR\",\"ITS_AP_ID\",\"ANALYSIS_PRODUCT_NAME\",\"ANALYSIS_PROJECT_TYPE\" from taxon\@core_v400_gemini2");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 species

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 ncbi_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 env_sample

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 seq_center

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 is_public

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 is_replaced

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_ec_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 funding_agency

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 img_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ncbi_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 ncbi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 ornl_species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 is_big_euk

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 host_ncbi_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 is_std_reference

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 project

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gram_stain

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_proxygene_set

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 obsolete_flag

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 is_pangenome

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 edit_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 img_product_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 refseq_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gbk_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_low_quality

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 phylodist_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 sample_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 phylodist_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 in_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 ncbi_bioproject_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 combined_sample_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 high_quality_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 taxonomy_lock

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 locked_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 lock_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 distmatrix_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ani_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 sequencing_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 genome_completion

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 is_nr

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 its_ap_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [7,0]

=head2 analysis_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 analysis_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "ncbi_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "env_sample",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "seq_center",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "is_public",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "is_replaced",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_ec_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "funding_agency",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "img_version",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ncbi_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "ncbi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "ornl_species_code",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "is_big_euk",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "host_ncbi_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "is_std_reference",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "project",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gram_stain",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_proxygene_set",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "obsolete_flag",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "is_pangenome",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "edit_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_product_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "refseq_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gbk_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_low_quality",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "phylodist_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "sample_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "phylodist_method",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "in_file",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "ncbi_bioproject_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "combined_sample_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "high_quality_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "taxonomy_lock",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "locked_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "lock_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "distmatrix_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ani_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "sequencing_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "genome_completion",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "is_nr",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "its_ap_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [7, 0],
  },
  "analysis_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "analysis_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p3w4XLnqKyP9VXTpNinBUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
