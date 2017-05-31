use utf8;
package DBIC::IMG_Gold::Result::Availabilitycv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Availabilitycv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<AVAILABILITYCV>

=cut

__PACKAGE__->table("AVAILABILITYCV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->set_primary_key("cv_term");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Q1G4ckDqhRXGIE1BJrzOrQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Availabilitycv.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::Availabilitycv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Availabilitycv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<AVAILABILITYCV>

=cut

__PACKAGE__->table("AVAILABILITYCV");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->set_primary_key("cv_term");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ksIDELE/X6tRnOvaI9y/dw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Availabilitycv.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
