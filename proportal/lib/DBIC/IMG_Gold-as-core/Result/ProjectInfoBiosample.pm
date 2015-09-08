use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoBiosample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoBiosample

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_BIOSAMPLE>

=cut

__PACKAGE__->table("PROJECT_INFO_BIOSAMPLE");

=head1 ACCESSORS

=head2 submission_status

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 machine

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 submission_action

  data_type: 'varchar2'
  default_value: 'INITIAL'
  is_nullable: 0
  size: 20

=head2 submission_comment

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 submission_request_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 sample_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 200

=head2 description

  data_type: 'varchar2'
  is_nullable: 0
  size: 3000

=head2 model

  data_type: 'varchar2'
  is_nullable: 0
  size: 200

=head2 link

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 tax_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 tax_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 biome

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 collection_date

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 env_package

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 feature

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 geo_loc_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 investigation_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 isol_growth_condt

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 lat_lon

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 material

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 num_replicons

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 ref_biomaterial

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 biotic_relationship

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 encoded_traits

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 estimated_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 experimental_factor

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 extrachrom_elements

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 health_disease_stat

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 host_spec_range

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 pathogenicity

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 rel_to_oxygen

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 samp_collect_device

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 samp_mat_process

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 samp_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 source_mat_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 specific_host

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 subspecf_gen_lin

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 trophic_level

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 ploidy

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 propagation

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 sample_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 jgi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 scientific_program

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 ncbi_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 portal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 biosample_oid

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'biosample_oid_seq'
  size: 126

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mims_me_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 db_identifiers

  data_type: 'varchar2'
  is_nullable: 0
  size: 500

=head2 bioproject_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 org_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 org_contact_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 org_contact_first_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 org_contact_last_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 ncbi_sample_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 ncbi_accession_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 locus_tag_prefix

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 is_update_for

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ncbi_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cultivar

  data_type: 'varchar2'
  is_nullable: 1
  size: 96

=cut

__PACKAGE__->add_columns(
  "submission_status",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "machine",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "submission_action",
  {
    data_type => "varchar2",
    default_value => "INITIAL",
    is_nullable => 0,
    size => 20,
  },
  "submission_comment",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "submission_request_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sample_id",
  { data_type => "varchar2", is_nullable => 0, size => 200 },
  "description",
  { data_type => "varchar2", is_nullable => 0, size => 3000 },
  "model",
  { data_type => "varchar2", is_nullable => 0, size => 200 },
  "link",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "tax_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "tax_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "biome",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "collection_date",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "env_package",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "feature",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "geo_loc_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "investigation_type",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "isol_growth_condt",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "lat_lon",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "material",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "num_replicons",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "ref_biomaterial",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "biotic_relationship",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "encoded_traits",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "estimated_size",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "experimental_factor",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "extrachrom_elements",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "health_disease_stat",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "host_spec_range",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "pathogenicity",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "rel_to_oxygen",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "samp_collect_device",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "samp_mat_process",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "samp_size",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "source_mat_id",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "specific_host",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "subspecf_gen_lin",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "trophic_level",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "ploidy",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "propagation",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "sample_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "jgi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "scientific_program",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "ncbi_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "portal_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "biosample_oid",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "biosample_oid_seq",
    size => 126,
  },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "mims_me_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "db_identifiers",
  { data_type => "varchar2", is_nullable => 0, size => 500 },
  "bioproject_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "org_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "org_contact_email",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "org_contact_first_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "org_contact_last_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "ncbi_sample_id",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "ncbi_accession_number",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "locus_tag_prefix",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "is_update_for",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ncbi_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cultivar",
  { data_type => "varchar2", is_nullable => 1, size => 96 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:drVaFOXCMtg6Ojau9KfgaA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
