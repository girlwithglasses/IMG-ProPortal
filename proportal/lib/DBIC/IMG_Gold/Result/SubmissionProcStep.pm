use utf8;
package DBIC::IMG_Gold::Result::SubmissionProcStep;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SubmissionProcStep

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION_PROC_STEPS>

=cut

__PACKAGE__->table("SUBMISSION_PROC_STEPS");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 step

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 program_used

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 program_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 input_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 input_file_format

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 output_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 output_file_format

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 reference_db

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 command_arg

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 start_at

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 end_at

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "step",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "program_used",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "program_version",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "input_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "input_file_format",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "output_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "output_file_format",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "reference_db",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "command_arg",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "start_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "end_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EPZ0LijQ66rw0tjLPLXMeA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SubmissionProcStep.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::SubmissionProcStep;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SubmissionProcStep

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION_PROC_STEPS>

=cut

__PACKAGE__->table("SUBMISSION_PROC_STEPS");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 step

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 program_used

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 program_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 input_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 input_file_format

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 output_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 output_file_format

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 reference_db

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 command_arg

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 start_at

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 end_at

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "step",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "program_used",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "program_version",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "input_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "input_file_format",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "output_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "output_file_format",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "reference_db",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "command_arg",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "start_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "end_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fsnrcMlk2unecT1x1zsVUA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SubmissionProcStep.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
