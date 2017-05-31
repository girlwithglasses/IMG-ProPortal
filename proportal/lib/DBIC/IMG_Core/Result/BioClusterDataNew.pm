use utf8;
package DBIC::IMG_Core::Result::BioClusterDataNew;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::BioClusterDataNew

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIO_CLUSTER_DATA_NEW>

=cut

__PACKAGE__->table("BIO_CLUSTER_DATA_NEW");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 evidence

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 probability

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,3]

=head2 bc_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 is_curated

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 genbank_acc

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 natural_prod

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "evidence",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "probability",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 3],
  },
  "bc_type",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "is_curated",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "genbank_acc",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "natural_prod",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FiSpKpLTS3LnpUsULNFBcg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
