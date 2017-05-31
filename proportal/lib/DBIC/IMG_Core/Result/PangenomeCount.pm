use utf8;
package DBIC::IMG_Core::Result::PangenomeCount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::PangenomeCount

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PANGENOME_COUNT>

=cut

__PACKAGE__->table("PANGENOME_COUNT");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 genome_count

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [8,0]

=head2 gene_count

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [8,0]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
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
  "gene_count",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [8, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TacT0juEZnk9DZvqzs6Pmg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
