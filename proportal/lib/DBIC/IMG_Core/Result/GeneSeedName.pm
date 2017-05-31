use utf8;
package DBIC::IMG_Core::Result::GeneSeedName;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneSeedName

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_SEED_NAMES>

=cut

__PACKAGE__->table("GENE_SEED_NAMES");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 source

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 subsystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 md5_checksum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 subsystem_flag

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 scaffold

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "product_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "source",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "subsystem",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "md5_checksum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "subsystem_flag",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "scaffold",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 RELATIONS

=head2 gene_oid

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "gene_oid",
  "DBIC::IMG_Core::Result::Gene",
  { gene_oid => "gene_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 scaffold

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Scaffold>

=cut

__PACKAGE__->belongs_to(
  "scaffold",
  "DBIC::IMG_Core::Result::Scaffold",
  { scaffold_oid => "scaffold" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IpB3Rcx+OCkSIJbnIZDnXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
