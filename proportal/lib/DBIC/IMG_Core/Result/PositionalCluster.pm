use utf8;
package DBIC::IMG_Core::Result::PositionalCluster;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::PositionalCluster

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<POSITIONAL_CLUSTER>

=cut

__PACKAGE__->table("POSITIONAL_CLUSTER");

=head1 ACCESSORS

=head2 group_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [20,0]

=head2 cluster_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 400

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "group_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [20, 0],
  },
  "cluster_name",
  { data_type => "varchar2", is_nullable => 1, size => 400 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</group_oid>

=back

=cut

__PACKAGE__->set_primary_key("group_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qV4H7OmfM8nM5JgIHxCtzQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
