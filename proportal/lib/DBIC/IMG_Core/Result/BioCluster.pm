use utf8;
package DBIC::IMG_Core::Result::BioCluster;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::BioCluster

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIO_CLUSTER>

=cut

__PACKAGE__->table("BIO_CLUSTER");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 taxon

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 scaffold

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "scaffold",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JvcUWFj2U0WPOUXjQtE+kA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
