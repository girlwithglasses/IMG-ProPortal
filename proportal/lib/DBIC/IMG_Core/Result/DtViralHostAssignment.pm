use utf8;
package DBIC::IMG_Core::Result::DtViralHostAssignment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtViralHostAssignment

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_VIRAL_HOST_ASSIGNMENT>

=cut

__PACKAGE__->table("DT_VIRAL_HOST_ASSIGNMENT");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 scaffold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mvc

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 viral_clusters

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 host_detection_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 spacer_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 spacer_length

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 perc_spacer_identity

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,2]

=head2 host_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 host_scaffold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 spacer_host

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 spacer_start

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 spacer_stop

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 host_genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 spacer_seq

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 crispr_no

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 pos

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "scaffold_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mvc",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "viral_clusters",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "host_detection_method",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "spacer_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "spacer_length",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "perc_spacer_identity",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 2],
  },
  "host_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "host_scaffold_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "spacer_host",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "spacer_start",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "spacer_stop",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "host_genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "spacer_seq",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "crispr_no",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pos",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YCv4OgV/iRCoISH8isP+Cw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
