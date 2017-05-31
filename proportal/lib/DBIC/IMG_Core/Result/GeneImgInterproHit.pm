use utf8;
package DBIC::IMG_Core::Result::GeneImgInterproHit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneImgInterproHit

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_IMG_INTERPRO_HITS>

=cut

__PACKAGE__->table("GENE_IMG_INTERPRO_HITS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 domaindb

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 domainid

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 domaindesc

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 sfcount

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 sfstarts

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 sfends

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 sfscores

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 iprid

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 iprdesc

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 go_info

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 scaffold

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "domaindb",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "domainid",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "domaindesc",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "sfcount",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "sfstarts",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "sfends",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "sfscores",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "iprid",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "iprdesc",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "go_info",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "scaffold",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:buP6hpAxuy8ui4aBO+sYaw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
