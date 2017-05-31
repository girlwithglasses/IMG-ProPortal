use utf8;
package DBIC::IMG_Gold::Result::V5ApImperfectView;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::V5ApImperfectView

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<V5_AP_IMPERFECT_VIEW>

=cut

__PACKAGE__->table("V5_AP_IMPERFECT_VIEW");
__PACKAGE__->result_source_instance->view_definition("select\n    ap.GOLD_ANALYSIS_PROJECT_ID, ap.\"ITS_ANALYSIS_PROJECT_ID\", ap.\"ITS_ASSEMBLY_AT_ID\", ap.\"ITS_ANNOTATION_AT_ID\", ap.\"ANALYSIS_PROJECT_NAME\",\n    ap.\"ITS_ANALYSIS_PROJECT_NAME\", ap.\"GOLD_ID\", ap.\"REFERENCE_GOLD_AP_ID\", ap.\"IMG_DATASET_ID\",\n    ap.\"ANALYSIS_PRODUCT_NAME\", ap.\"NCBI_TAX_ID\", \"VISIBILITY\", ap.\"DOMAIN\", ap.\"NCBI_PHYLUM\", ap.\"NCBI_CLASS\", ap.\"NCBI_ORDER\",\n    ap.\"NCBI_FAMILY\", ap.\"NCBI_GENUS\", ap.\"NCBI_SPECIES\", ap.\"GOLD_ANALYSIS_PROJECT_TYPE\", null as study_gold_id, ap.\"GOLD_PROPOSAL_NAME\",\n    ap.\"ECOSYSTEM\", ap.\"ECOSYSTEM_CATEGORY\", ap.\"ECOSYSTEM_TYPE\", ap.\"ECOSYSTEM_SUBTYPE\", ap.\"SPECIFIC_ECOSYSTEM\",\n    ap.\"PI_NAME\", ap.\"PI_EMAIL\", SUBMITTER_CONTACT_OID, c.name as \"SUBMITTER_NAME\", c.email as \"SUBMITTER_EMAIL\", ap.\"SPECIMEN\", ap.\"COMMENTS\",\n    ap.\"SUBMISSION_ID\", ap.\"IS_ASSEMBLED\", ap.\"IS_DECONTAMINATION\", ap.\"IS_GENE_PRIMP\", ap.\"GENE_PRIMP_DATE\", ap.\"CONTIG_COUNT\", ap.\"SCAFFOLD_COUNT\",\n    ap.status\n  from\n    gold_analysis_project ap\n      left join contact c on ap.submitter_contact_oid = c.contact_oid");

=head1 ACCESSORS

=head2 gold_analysis_project_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 its_analysis_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_assembly_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_annotation_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 analysis_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 its_analysis_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 16

=head2 reference_gold_ap_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_dataset_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 analysis_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_tax_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 visibility

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gold_analysis_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 0

=head2 gold_proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 pi_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 pi_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 submitter_contact_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 submitter_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 submitter_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 specimen

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 submission_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_assembled

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 is_decontamination

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 is_gene_primp

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 gene_primp_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 contig_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 scaffold_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=cut

__PACKAGE__->add_columns(
  "gold_analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "its_analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_assembly_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_annotation_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "analysis_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "its_analysis_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "gold_id",
  { data_type => "varchar2", is_nullable => 0, size => 16 },
  "reference_gold_ap_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_dataset_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "analysis_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_tax_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "visibility",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gold_analysis_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 0 },
  "gold_proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "pi_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "pi_email",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "submitter_contact_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "submitter_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "submitter_email",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "specimen",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "submission_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_assembled",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "is_decontamination",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "is_gene_primp",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "gene_primp_date",
  { data_type => "timestamp", is_nullable => 1 },
  "contig_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "scaffold_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+cEFeK4P4+sdSscXvuC15Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
