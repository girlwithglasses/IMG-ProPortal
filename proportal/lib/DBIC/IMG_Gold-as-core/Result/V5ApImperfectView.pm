use utf8;
package DbSchema::IMG_Core::Result::V5ApImperfectView;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::V5ApImperfectView

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<V5_AP_IMPERFECT_VIEW>

=cut

__PACKAGE__->table("V5_AP_IMPERFECT_VIEW");

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
  is_nullable: 1
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
  { data_type => "varchar2", is_nullable => 1, size => 16 },
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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bJOv4SSxW7Xslx9HDBW8Mw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
