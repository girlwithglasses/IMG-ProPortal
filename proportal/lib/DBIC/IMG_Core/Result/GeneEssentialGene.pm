use utf8;
package DBIC::IMG_Core::Result::GeneEssentialGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneEssentialGene

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_ESSENTIAL_GENES>

=cut

__PACKAGE__->table("GENE_ESSENTIAL_GENES");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 ext_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 essentiality

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 assertion_error

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 sp_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 func_role

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 func_cat

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

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
  "ext_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "essentiality",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "assertion_error",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "sp_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "func_role",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "func_cat",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);

=head1 RELATIONS

=head2 essentiality

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Yesnocv>

=cut

__PACKAGE__->belongs_to(
  "essentiality",
  "DBIC::IMG_Core::Result::Yesnocv",
  { flag_cv => "essentiality" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E0IrCxKYabHZRVSkUwKzYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
