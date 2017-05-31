use utf8;
package DBIC::IMG_Core::Result::EnvSampleObsolete;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::EnvSampleObsolete

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENV_SAMPLE_OBSOLETE>

=cut

__PACKAGE__->table("ENV_SAMPLE_OBSOLETE");

=head1 ACCESSORS

=head2 sample_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 sample_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

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

=head2 energy_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 oxygen_req

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 temp

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 salinity

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 pressure

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ph

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_ncbi_taxid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

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

=head2 seq_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 library_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 est_size

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 binning_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 contig_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 singlet_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gene_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 project

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "sample_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "sample_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
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
  "energy_source",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "oxygen_req",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "temp",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "salinity",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "pressure",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ph",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_ncbi_taxid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "host_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_gender",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_age",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_health_condition",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "seq_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "library_method",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "est_size",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "binning_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "contig_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "singlet_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gene_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "project",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zmtJ9alSHp71ivJMIOK0HA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
