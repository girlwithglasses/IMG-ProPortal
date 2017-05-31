use utf8;
package DBIC::IMG_Core::Result::BioClusterFeature;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::BioClusterFeature

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIO_CLUSTER_FEATURES>

=cut

__PACKAGE__->table("BIO_CLUSTER_FEATURES");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 feature_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 feature_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 probability

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 pfam_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 start_coord

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gene_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "feature_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "feature_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "probability",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "pfam_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "start_coord",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gene_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0IEwiR2G/riFhn3bNDEq0w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
