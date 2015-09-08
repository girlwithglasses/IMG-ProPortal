use utf8;
package DbSchema::IMG_Core::Result::Imgcv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Imgcv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<IMGCV>

=cut

__PACKAGE__->table("IMGCV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->set_primary_key("cv_term");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:t9dRT1ScIyTPnwm3Dq/QdQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
