use utf8;
package DBIC::IMG_Core::Result::MerfsGeneMapping;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::MerfsGeneMapping

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MERFS_GENE_MAPPING>

=cut

__PACKAGE__->table("MERFS_GENE_MAPPING");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 merfs_gene_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 306

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon

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
  "merfs_gene_id",
  { data_type => "varchar2", is_nullable => 1, size => 306 },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jRyV961aGahBeOZRb85ZWA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
