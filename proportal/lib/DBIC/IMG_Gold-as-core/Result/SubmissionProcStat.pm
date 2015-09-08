use utf8;
package DbSchema::IMG_Core::Result::SubmissionProcStat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::SubmissionProcStat

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<SUBMISSION_PROC_STATS>

=cut

__PACKAGE__->table("SUBMISSION_PROC_STATS");

=head1 ACCESSORS

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 step

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 total_seq

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 total_bases

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 shortest_seq

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 longest_seq

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 avg_seq

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 median_seq

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 standard_dev

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 picture_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 type_of_feature

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 no_pred_features

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

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
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "total_seq",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "total_bases",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "shortest_seq",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "longest_seq",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "avg_seq",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "median_seq",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "standard_dev",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "picture_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "type_of_feature",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "no_pred_features",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xE+AkrGJVzMihTI6rO2M7Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
