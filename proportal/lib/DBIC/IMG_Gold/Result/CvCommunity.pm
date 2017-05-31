use utf8;
package DBIC::IMG_Gold::Result::CvCommunity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::CvCommunity

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CV_COMMUNITY>

=cut

__PACKAGE__->table("CV_COMMUNITY");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<pk_cv_community_cv_term>

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->add_unique_constraint("pk_cv_community_cv_term", ["cv_term"]);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GyjHEDp6xakL51wk70WSlQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/CvCommunity.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::CvCommunity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::CvCommunity

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CV_COMMUNITY>

=cut

__PACKAGE__->table("CV_COMMUNITY");

=head1 ACCESSORS

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "cv_term",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<pk_cv_community_cv_term>

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->add_unique_constraint("pk_cv_community_cv_term", ["cv_term"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XueV65oMU2Jt1+R32ZN+HA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/CvCommunity.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
