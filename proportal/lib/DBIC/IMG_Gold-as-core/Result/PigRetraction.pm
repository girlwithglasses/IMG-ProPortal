use utf8;
package DbSchema::IMG_Core::Result::PigRetraction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::PigRetraction

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PIG_RETRACTIONS>

=cut

__PACKAGE__->table("PIG_RETRACTIONS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 jgi_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 bioproject_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 ncbi_accession_number

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 retraction_reason_for_ncbi

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 retraction_root_cause

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 retraction_requested_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 retraction_requested_by

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 retraction_confirmed_at

  data_type: 'timestamp'
  is_nullable: 1

=head2 img_taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 img_submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 sequencing_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 culture_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 is_jgi_genome

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [1,0]

=head2 principal_investigator

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 insert_user_sso

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 insert_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 insert_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 update_user_sso

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 update_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 update_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 created_at

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 updated_at

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 pig_tracks_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "jgi_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "bioproject_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "ncbi_accession_number",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "retraction_reason_for_ncbi",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "retraction_root_cause",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "retraction_requested_at",
  { data_type => "timestamp", is_nullable => 1 },
  "retraction_requested_by",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "retraction_confirmed_at",
  { data_type => "timestamp", is_nullable => 1 },
  "img_taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "sequencing_status",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "culture_type",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "is_jgi_genome",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [1, 0],
  },
  "principal_investigator",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "insert_user_sso",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "insert_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "insert_time",
  { data_type => "timestamp", is_nullable => 1 },
  "update_user_sso",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "update_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "update_time",
  { data_type => "timestamp", is_nullable => 1 },
  "created_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "updated_at",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "display_name",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "pig_tracks_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9W5FFG5RyUuvTRCgGFbWiA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
