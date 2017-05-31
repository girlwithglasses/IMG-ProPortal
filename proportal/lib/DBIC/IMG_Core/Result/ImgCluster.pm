use utf8;
package DBIC::IMG_Core::Result::ImgCluster;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ImgCluster

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<IMG_CLUSTER>

=cut

__PACKAGE__->table("IMG_CLUSTER");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 cluster_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cluster_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "cluster_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cluster_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UN1Mqz/J07N2sD73GuCmeQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
