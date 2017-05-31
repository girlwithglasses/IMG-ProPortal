use utf8;
package DBIC::IMG_Core::Result::EnvSampleTemp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::EnvSampleTemp

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENV_SAMPLE_TEMP>

=cut

__PACKAGE__->table("ENV_SAMPLE_TEMP");

=head1 ACCESSORS

=head2 sample_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 sample_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 sample_site

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 date_collected

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 geo_location

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 latitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 longitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 altitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sampling_strategy

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 sample_isolation

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sample_volume

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 est_biomass

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 est_diversity

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 oxygen_req

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 temp

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 salinity

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pressure

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ph

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_ncbi_taxid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 host_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_gender

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_age

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_health_condition

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 library_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 est_size

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 binning_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 contig_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 singlet_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 units

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gene_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 contact

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 project_info

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 temp_range

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sample_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 assembly_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 seq_depth

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gene_calling_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 gc_perc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 chromosome_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 plasmid_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 ncbi_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 img_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 iso_country

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pub_journal

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 pub_vol

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 pub_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 ncbi_archive_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 depth

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 iso_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 iso_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

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
  size: 256

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 sample_description

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_status_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 reads_count

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 vector

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 seq_country

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_quality

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_spec

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 host_race

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 host_medication

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 iso_pubmed_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 seq_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 sra_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 seq_center_pid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 mrn

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 body_site

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 body_subsite

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 body_product

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_center_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_center_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 image_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 show_in_dacc

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 visit_num

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 replicate_num

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 submitters_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 ncbi_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 scope_of_work

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pmo_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 sample_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 scientific_program

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 jgi_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 jgi_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 gpts_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 gpts_last_mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 jgi_funding_program

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 jgi_dir_number

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 jgi_funding_year

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 jgi_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_final_deliverable

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_visibility

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 growth_conditions

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 coordinate_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 scaffold_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 member_samples

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 gpts_public_release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 gpts_embargo_start_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 gpts_embargo_days

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 phase

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 phase_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 its_spid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 bioproject_description

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 locus_tag_prefix

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 nucleic_acid_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=cut

__PACKAGE__->add_columns(
  "sample_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "sample_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "sample_site",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "date_collected",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "geo_location",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "latitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "longitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "altitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sampling_strategy",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "sample_isolation",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sample_volume",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "est_biomass",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "est_diversity",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "oxygen_req",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "temp",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "salinity",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pressure",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ph",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_ncbi_taxid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "host_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_gender",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_age",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_health_condition",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "library_method",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "est_size",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "binning_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "contig_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "singlet_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "units",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gene_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "contact",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "project_info",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "temp_range",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sample_link",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "assembly_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "seq_depth",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gene_calling_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "gc_perc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "chromosome_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "plasmid_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "ncbi_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "iso_country",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pub_journal",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "pub_vol",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "pub_link",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "ncbi_archive_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "depth",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "iso_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "iso_source",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "sample_description",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_status_link",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "reads_count",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "vector",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "seq_country",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_quality",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_spec",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "host_race",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "host_medication",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "iso_pubmed_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "seq_comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "sra_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "seq_center_pid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "mrn",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "body_site",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "body_subsite",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "body_product",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_center_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_center_url",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "image_url",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "show_in_dacc",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "visit_num",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "replicate_num",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "submitters_name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "ncbi_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "scope_of_work",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pmo_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sample_type",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "scientific_program",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "jgi_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "jgi_status",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "gpts_comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "gpts_last_mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "jgi_funding_program",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "jgi_dir_number",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "jgi_funding_year",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "jgi_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_final_deliverable",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_visibility",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "growth_conditions",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "coordinate_type",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "scaffold_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "member_samples",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "gpts_public_release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "gpts_embargo_start_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "gpts_embargo_days",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "phase",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "phase_status",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "its_spid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "bioproject_description",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "locus_tag_prefix",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "nucleic_acid_type",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mKnQMMaU6fXo7abnTCXoyA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
