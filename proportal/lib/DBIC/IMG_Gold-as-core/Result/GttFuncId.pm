use utf8;
package DbSchema::IMG_Core::Result::GttFuncId;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GttFuncId

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<GTT_FUNC_ID>

=cut

__PACKAGE__->table("GTT_FUNC_ID");

=head1 ACCESSORS

=head2 id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fTRfLhi7P1Zj+7ptEuZm4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
