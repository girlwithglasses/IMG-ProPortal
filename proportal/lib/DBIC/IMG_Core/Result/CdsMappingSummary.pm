use utf8;
package DBIC::IMG_Core::Result::CdsMappingSummary;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::CdsMappingSummary

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CDS_MAPPING_SUMMARY>

=cut

__PACKAGE__->table("CDS_MAPPING_SUMMARY");

=head1 ACCESSORS

=head2 old_taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 new_taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 old_taxon_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 new_taxon_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 replacement

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 old_cds_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 new_cds_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_mapped

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 percent_mapped

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 un_mapped_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 img_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 opm_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "old_taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "new_taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "old_taxon_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "new_taxon_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "replacement",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "old_cds_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "new_cds_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_mapped",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "percent_mapped",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "un_mapped_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "img_version",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "opm_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YzqlHKDOHhX/rABrQ8fDmA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
