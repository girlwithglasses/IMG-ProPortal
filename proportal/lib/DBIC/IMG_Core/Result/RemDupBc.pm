use utf8;
package DBIC::IMG_Core::Result::RemDupBc;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::RemDupBc

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<REM_DUP_BC>

=cut

__PACKAGE__->table("REM_DUP_BC");

=head1 ACCESSORS

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 remove

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "cluster_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "remove",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:488AwIX8u6ztwU4DLEmpCw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
