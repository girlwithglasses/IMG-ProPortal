use utf8;
package DBIC::IMG_Core::Result::DtHtHit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtHtHit

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_HT_HITS>

=cut

__PACKAGE__->table("DT_HT_HITS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 phylo_level

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylo_val

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 homolog

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 rank

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [17,0]

=head2 rev_gene_oid

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
  "phylo_level",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylo_val",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "homolog",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rank",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [17, 0],
  },
  "rev_gene_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ut4bk4b3XqJf1SzLvaVFfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
