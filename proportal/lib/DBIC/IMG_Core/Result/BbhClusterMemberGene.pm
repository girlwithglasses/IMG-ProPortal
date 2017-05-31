use utf8;
package DBIC::IMG_Core::Result::BbhClusterMemberGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::BbhClusterMemberGene

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BBH_CLUSTER_MEMBER_GENES>

=cut

__PACKAGE__->table("BBH_CLUSTER_MEMBER_GENES");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 member_genes

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "member_genes",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 RELATIONS

=head2 member_gene

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Gene>

=cut

__PACKAGE__->belongs_to(
  "member_gene",
  "DBIC::IMG_Core::Result::Gene",
  { gene_oid => "member_genes" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uArdR5LbLlI9XlVdLx8SIQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
