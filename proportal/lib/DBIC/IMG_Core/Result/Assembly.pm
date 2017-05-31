use utf8;
package DBIC::IMG_Core::Result::Assembly;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Assembly

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ASSEMBLY>

=cut

__PACKAGE__->table("ASSEMBLY");

=head1 ACCESSORS

=head2 assembly_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 assembly_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 taxon

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 env_sample

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 assembly_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 assembler_pgm

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "assembly_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "assembly_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "taxon",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "env_sample",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "assembly_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "assembler_pgm",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 RELATIONS

=head2 taxon

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Taxon>

=cut

__PACKAGE__->belongs_to(
  "taxon",
  "DBIC::IMG_Core::Result::Taxon",
  { taxon_oid => "taxon" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:K/uP1AGoPzy0cVDZ9O0scg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
