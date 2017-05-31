use utf8;
package DBIC::IMG_Core::Result::PangenomeCountGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::PangenomeCountGene

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PANGENOME_COUNT_GENES>

=cut

__PACKAGE__->table("PANGENOME_COUNT_GENES");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 pangenome_taxon

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 genome_count

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [8,0]

=head2 pangene

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 gene

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pangenome_taxon",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genome_count",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [8, 0],
  },
  "pangene",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gene",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 RELATIONS

=head2 gene

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "gene",
  "DBIC::IMG_Core::Result::Gene",
  { gene_oid => "gene" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 pangene

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "pangene",
  "DBIC::IMG_Core::Result::Gene",
  { gene_oid => "pangene" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6bHHLKNveBcUSwx2nVCzpw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
