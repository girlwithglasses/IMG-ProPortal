use utf8;
package DBIC::IMG_Gold::Result::SubmissionStatuscv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SubmissionStatuscv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION_STATUSCV>

=cut

__PACKAGE__->table("SUBMISSION_STATUSCV");

=head1 ACCESSORS

=head2 term_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 cv_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 terminal_status

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "term_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "cv_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "terminal_status",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_oid>

=back

=cut

__PACKAGE__->set_primary_key("term_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tCN/6bCnvJLnv+EPHoojLA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SubmissionStatuscv.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::SubmissionStatuscv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SubmissionStatuscv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION_STATUSCV>

=cut

__PACKAGE__->table("SUBMISSION_STATUSCV");

=head1 ACCESSORS

=head2 term_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 cv_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 terminal_status

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "term_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "cv_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "terminal_status",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</term_oid>

=back

=cut

__PACKAGE__->set_primary_key("term_oid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5m3Q83ciTog/cMYg98Zreg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SubmissionStatuscv.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
