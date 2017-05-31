use utf8;
package DBIC::IMG_Core::Result::GeneEggnog;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneEggnog

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_EGGNOGS>

=cut

__PACKAGE__->table("GENE_EGGNOGS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 nog_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 level_2

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 md5_signature

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

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
  "nog_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "level_2",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "md5_signature",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zpwY04swbCvlszxidKx1qA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
