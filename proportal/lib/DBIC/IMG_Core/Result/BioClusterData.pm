use utf8;
package DBIC::IMG_Core::Result::BioClusterData;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::BioClusterData

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIO_CLUSTER_DATA>

=cut

__PACKAGE__->table("BIO_CLUSTER_DATA");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 attribute_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 attribute_value

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "attribute_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "attribute_value",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rFqro6TXc0T2wre+XFZGQw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
