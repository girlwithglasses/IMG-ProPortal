use utf8;
package DBIC::IMG_Core::Result::VwTaxon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::VwTaxon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<VW_TAXON>

=cut

__PACKAGE__->table("VW_TAXON");
__PACKAGE__->result_source_instance->view_definition("select\n   tx.taxon_oid,\n   tx.submission_id,\n   tx.taxon_oid taxon_oid_display,\n   tx.taxon_display_name,\n   tx.genus,\n   tx.species,\n   tx.strain,\n   tx.ncbi_taxon_id,\n   tx.refseq_project_id,\n   tx.gbk_project_id,\n   tx.genome_type,\n   tx.domain,\n   tx.phylum,\n   tx.ir_class,\n   tx.ir_order,\n   tx.family,\n   tx.jgi_species_code,\n   tx.comments,\n   tx.env_sample,\n   tx.seq_status,\n   tx.seq_center,\n   tx.is_public,\n   tx.is_std_reference,\n   tx.is_replaced,\n   tx.funding_agency,\n   tx.jgi_project_id,\n   tx.img_version,\n   tx.ncbi_species_code,\n   tx.ncbi_project_id,\n   tx.gold_id,\n   tx.add_date,\n   tx.release_date,\n   tx.img_product_flag,\n   ts.total_gene_count,\n   ts.cds_genes,\n   ts.n_scaffolds,\n   ts.total_coding_bases,\n   ts.total_gatc,\n   ts.total_bases,\n   ts.gc_percent\nfrom taxon tx, taxon_stats ts\nwhere tx.taxon_oid = ts.taxon_oid\n");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 taxon_oid_display

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_display_name

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

=head2 ncbi_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

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

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

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

=head2 is_std_reference

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_replaced

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

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 img_product_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 total_gene_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 cds_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 n_scaffolds

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_coding_bases

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_gatc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_bases

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gc_percent

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "taxon_oid_display",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
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
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
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
  "is_std_reference",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_replaced",
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
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "img_product_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "total_gene_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "cds_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "n_scaffolds",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_coding_bases",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_gatc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_bases",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gc_percent",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ikemu7JrfjDG9I4PXj+sWw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
