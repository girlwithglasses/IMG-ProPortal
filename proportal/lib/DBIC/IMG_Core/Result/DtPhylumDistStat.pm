use utf8;
package DBIC::IMG_Core::Result::DtPhylumDistStat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtPhylumDistStat

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_PHYLUM_DIST_STATS>

=cut

__PACKAGE__->table("DT_PHYLUM_DIST_STATS");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 perc_ident_bin

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [3,0]

=head2 gene_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_count

  data_type: 'numeric'
  is_nullable: 1
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
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "perc_ident_bin",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [3, 0],
  },
  "gene_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LgU6wgZxRisHPlu9DxecpQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
