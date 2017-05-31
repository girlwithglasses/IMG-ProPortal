use utf8;
package DBIC::IMG_Core::Result::DtViralCluster;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtViralCluster

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_VIRAL_CLUSTERS>

=cut

__PACKAGE__->table("DT_VIRAL_CLUSTERS");

=head1 ACCESSORS

=head2 scaffold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 habitat

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 perc_vpfs

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,2]

=head2 viral_clusters

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 host

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_detection

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pogs_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pogs_family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pogs_subfamily

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pogs_genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mvc

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 putative_retrovirus

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 body_site

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "scaffold_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "habitat",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "perc_vpfs",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 2],
  },
  "viral_clusters",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "host",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_detection",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pogs_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pogs_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pogs_subfamily",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pogs_genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mvc",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "putative_retrovirus",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "body_site",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rKQz/EegKHYRZmLkvdmnzQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
