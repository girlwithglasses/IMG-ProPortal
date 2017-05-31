use utf8;
package DBIC::IMG_Core::Result::GeneReplacement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneReplacement

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_REPLACEMENTS>

=cut

__PACKAGE__->table("GENE_REPLACEMENTS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 old_gene_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 img_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 method

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

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
  "old_gene_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "img_version",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "method",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZM1knwaS8EpTteZZuwTtPQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
