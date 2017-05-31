use utf8;
package DBIC::IMG_Core::Result::DtGeneKoModulePwy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtGeneKoModulePwy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_GENE_KO_MODULE_PWYS>

=cut

__PACKAGE__->table("DT_GENE_KO_MODULE_PWYS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 module_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 ko_terms

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pathway_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 image_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 scaffold

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "module_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "ko_terms",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pathway_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "image_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "scaffold",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XljiB0d5OVGFtemq179bPg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
