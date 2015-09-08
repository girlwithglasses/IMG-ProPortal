use utf8;
package DbSchema::IMG_Core::Result::SubmissionDataFile;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::SubmissionDataFile

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

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

Related object: L<DbSchema::IMG_Core::Result::Submission>

=cut

__PACKAGE__->belongs_to(
  "submission",
  "DbSchema::IMG_Core::Result::Submission",
  { submission_id => "submission_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LVSRJA33IISRYfbBfiLY7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
