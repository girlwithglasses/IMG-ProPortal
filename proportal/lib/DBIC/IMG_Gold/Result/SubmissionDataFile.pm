use utf8;
package DBIC::IMG_Gold::Result::SubmissionDataFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SubmissionDataFile

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION_DATA_FILES>

=cut

__PACKAGE__->table("SUBMISSION_DATA_FILES");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 file_type

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 file_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 md5sum

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "submission_id",
  {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 0,
    original       => { data_type => "number", size => [38, 0] },
  },
  "file_type",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "file_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "md5sum",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</submission_id>

=item * L</file_type>

=back

=cut

__PACKAGE__->set_primary_key("submission_id", "file_type");

=head1 RELATIONS

=head2 submission

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::Submission>

=cut

__PACKAGE__->belongs_to(
  "submission",
  "DBIC::IMG_Gold::Result::Submission",
  { submission_id => "submission_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:c0dqHxbet1n+E8rnfPeNBA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SubmissionDataFile.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::SubmissionDataFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::SubmissionDataFile

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION_DATA_FILES>

=cut

__PACKAGE__->table("SUBMISSION_DATA_FILES");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 file_type

  data_type: 'varchar2'
  is_nullable: 0
  size: 40

=head2 file_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 md5sum

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "submission_id",
  {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 0,
    original       => { data_type => "number", size => [38, 0] },
  },
  "file_type",
  { data_type => "varchar2", is_nullable => 0, size => 40 },
  "file_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "md5sum",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</submission_id>

=item * L</file_type>

=back

=cut

__PACKAGE__->set_primary_key("submission_id", "file_type");

=head1 RELATIONS

=head2 submission

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::Submission>

=cut

__PACKAGE__->belongs_to(
  "submission",
  "DBIC::IMG_Gold::Result::Submission",
  { submission_id => "submission_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e1mt9ITKeTwDkMEub1My7g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/SubmissionDataFile.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
