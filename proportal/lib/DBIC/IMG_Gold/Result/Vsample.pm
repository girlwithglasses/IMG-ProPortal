use utf8;
package DBIC::IMG_Gold::Result::Vsample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Vsample

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<VSAMPLE>

=cut

__PACKAGE__->table("VSAMPLE");
__PACKAGE__->result_source_instance->view_definition("SELECT es.SAMPLE_OID,\n    es.GOLD_ID,\n    p.gold_stamp_id,\n    es.SAMPLE_DISPLAY_NAME,\n    es.SAMPLE_SITE,\n    es.DATE_COLLECTED,\n    es.GEO_LOCATION,\n    es.LATITUDE,\n    es.LONGITUDE,\n    es.ALTITUDE,\n    es. SAMPLING_STRATEGY,\n    es.SAMPLE_ISOLATION,\n    es.SAMPLE_VOLUME,\n    es.EST_BIOMASS,\n    es.EST_DIVERSITY,\n    es.OXYGEN_REQ,\n    es.TEMP,\n    es.SALINITY,\n    es.PRESSURE,\n    es.PH,\n    es. HOST_NCBI_TAXID,\n    es.HOST_NAME,\n    es.HOST_GENDER,\n    es.HOST_AGE,\n    es.HOST_HEALTH_CONDITION,\n    es.LIBRARY_METHOD,\n    es.EST_SIZE,\n    es.BINNING_METHOD,\n    es. CONTIG_COUNT,\n    es.SINGLET_COUNT,\n    es.UNITS,\n    es.GENE_COUNT,\n    es.COMMENTS,\n    es.ADD_DATE,\n    es.MOD_DATE,\n    es.MODIFIED_BY,\n    es.CONTACT,\n    es.PROJECT_INFO,\n    es. TEMP_RANGE,\n    es.SAMPLE_LINK,\n    es.ASSEMBLY_METHOD,\n    es.SEQ_DEPTH,\n    es.GENE_CALLING_METHOD,\n    es.GC_PERC,\n    es.CHROMOSOME_COUNT,\n    es.PLASMID_COUNT,\n    es. NCBI_PROJECT_ID,\n    es.IMG_OID,\n    es.ISO_COUNTRY,\n    es.PUB_JOURNAL,\n    es.PUB_VOL,\n    es.PUB_LINK,\n    es.NCBI_ARCHIVE_ID,\n    es.DEPTH,\n    es.ISO_COMMENTS,\n    es.ISO_SOURCE,\n    es. ECOSYSTEM,\n    es.ECOSYSTEM_CATEGORY,\n    es.ECOSYSTEM_TYPE,\n    es.ECOSYSTEM_SUBTYPE,\n    es.SPECIFIC_ECOSYSTEM,\n    es.SAMPLE_DESCRIPTION,\n    es. SEQ_STATUS,\n    es.SEQ_STATUS_LINK,\n    es.READS_COUNT,\n    es.VECTOR,\n    es.SEQ_COUNTRY,\n    es.SEQ_QUALITY,\n    es.HOST_SPEC,\n    es.HOST_RACE,\n    es.HOST_COMMENTS,\n    es. HOST_MEDICATION,\n    es.HOST_TAXON_ID,\n    es.ISO_PUBMED_ID,\n    es.SEQ_COMMENTS,\n    es.SRA_ID,\n    es.NCBI_PROJECT_NAME,\n    es.SEQ_CENTER_PID,\n    es.MRN,\n    es.BODY_SITE,\n    es. BODY_SUBSITE,\n    es.BODY_PRODUCT,\n    es.SEQ_CENTER_NAME,\n    es.SEQ_CENTER_URL,\n    es.IMAGE_URL,\n    es.SHOW_IN_DACC,\n    es.VISIT_NUM,\n    es.REPLICATE_NUM\n  FROM project_info p\n  INNER JOIN ENV_SAMPLE es\n  ON p.project_oid = es.project_info\n  where p.domain='MICROBIAL'\n ");

=head1 ACCESSORS

=head2 sample_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 gold_stamp_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 sample_display_name

  data_type: 'varchar2'
  is_nullable: 0
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
  is_nullable: 0
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
  "gold_stamp_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "sample_display_name",
  { data_type => "varchar2", is_nullable => 0, size => 512 },
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
  { data_type => "varchar2", is_nullable => 0, size => 256 },
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
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tVQi/1qTl9RKIjCBkT1uqQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
