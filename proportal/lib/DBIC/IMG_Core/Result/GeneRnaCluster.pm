use utf8;
package DBIC::IMG_Core::Result::GeneRnaCluster;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneRnaCluster

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_RNA_CLUSTERS>

=cut

__PACKAGE__->table("GENE_RNA_CLUSTERS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 cluster_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 50

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 cds_frag_coord

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

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
  "cluster_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 50 },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "cds_frag_coord",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
);

=head1 RELATIONS

=head2 cluster

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::RnaCluster>

=cut

__PACKAGE__->belongs_to(
  "cluster",
  "DBIC::IMG_Core::Result::RnaCluster",
  { cluster_id => "cluster_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N+39lYMeoygOf4Lsygx4KA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
