use utf8;
package DBIC::IMG_Sat::Result::MpwPglPathwayReaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::MpwPglPathwayReaction

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MPW_PGL_PATHWAY_REACTION>

=cut

__PACKAGE__->table("MPW_PGL_PATHWAY_REACTION");

=head1 ACCESSORS

=head2 pathway_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 reaction_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 reaction_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 reaction_label

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 cofactor

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 requaired_condition

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 protein_group

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gene_group

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "pathway_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "reaction_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "reaction_order",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "reaction_label",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "cofactor",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "requaired_condition",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "protein_group",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gene_group",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SiTI167+yYfYfcarMcUksA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
