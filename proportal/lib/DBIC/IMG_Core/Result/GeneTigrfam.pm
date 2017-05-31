use utf8;
package DBIC::IMG_Core::Result::GeneTigrfam;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneTigrfam

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_TIGRFAMS>

=cut

__PACKAGE__->table("GENE_TIGRFAMS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 sfstarts

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 sfsends

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 sfscores

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 bit_score

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 percent_identity

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 evalue

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 taxon

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 scaffold

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
  "ext_accession",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "sfstarts",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "sfsends",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "sfscores",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "bit_score",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "percent_identity",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "evalue",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "scaffold",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WZsjBEpH7bnRwKp619jSZw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
