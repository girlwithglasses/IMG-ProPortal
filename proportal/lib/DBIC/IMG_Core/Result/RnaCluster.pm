use utf8;
package DBIC::IMG_Core::Result::RnaCluster;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::RnaCluster

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<RNA_CLUSTER>

=cut

__PACKAGE__->table("RNA_CLUSTER");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 identification

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ga_thresh

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 tc_thresh

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 nc_thresh

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 entry_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seed_sequences

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_locus_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 overlap_rule

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 db_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 db_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 obsolete_flag

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "identification",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ga_thresh",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "tc_thresh",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "nc_thresh",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "entry_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seed_sequences",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_locus_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "overlap_rule",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "db_source",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "db_version",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "obsolete_flag",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</cluster_id>

=back

=cut

__PACKAGE__->set_primary_key("cluster_id");

=head1 RELATIONS

=head2 gene_rna_clusters

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneRnaCluster>

=cut

__PACKAGE__->has_many(
  "gene_rna_clusters",
  "DBIC::IMG_Core::Result::GeneRnaCluster",
  { "foreign.cluster_id" => "self.cluster_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 obsolete_flag

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Yesnocv>

=cut

__PACKAGE__->belongs_to(
  "obsolete_flag",
  "DBIC::IMG_Core::Result::Yesnocv",
  { flag_cv => "obsolete_flag" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XNIioZqDEWVU0jvyxIYPQA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
