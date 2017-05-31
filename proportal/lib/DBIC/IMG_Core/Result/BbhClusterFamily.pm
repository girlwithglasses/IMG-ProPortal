use utf8;
package DBIC::IMG_Core::Result::BbhClusterFamily;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::BbhClusterFamily

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BBH_CLUSTER_FAMILIES>

=cut

__PACKAGE__->table("BBH_CLUSTER_FAMILIES");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 families

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "families",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lwglVkZcvmG2n5gJaYtD9g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
