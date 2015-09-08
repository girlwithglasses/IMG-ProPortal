use utf8;
package DbSchema::IMG_Core::Result::SubmissionProcStep;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::SubmissionProcStep

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wSd6VNX8U+Rse3XiioT/zw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
