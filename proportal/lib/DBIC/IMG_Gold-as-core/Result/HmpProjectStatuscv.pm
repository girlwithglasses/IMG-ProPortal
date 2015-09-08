use utf8;
package DbSchema::IMG_Core::Result::HmpProjectStatuscv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::HmpProjectStatuscv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<HMP_PROJECT_STATUSCV>

=cut

__PACKAGE__->table("HMP_PROJECT_STATUSCV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0mFefWjC48VfNLREgMVbnA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
