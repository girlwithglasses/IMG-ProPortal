use utf8;
package DbSchema::IMG_Core::Result::BeiStatuscv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::BeiStatuscv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<BEI_STATUSCV>

=cut

__PACKAGE__->table("BEI_STATUSCV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qWfZUROaf8oWoRTeT9Wacw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
