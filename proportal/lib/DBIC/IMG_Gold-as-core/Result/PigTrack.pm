use utf8;
package DbSchema::IMG_Core::Result::PigTrack;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::PigTrack

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PIG_TRACKS>

=cut

__PACKAGE__->table("PIG_TRACKS");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}
  sequence: 'pig_tracks_id_inc'

=head2 jgi_project_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 biosample_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 chromosome_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 plasmid_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 author

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 linear_or_circular

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 final_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 assembly_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 file_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 contig_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 stage_of_contigs

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 stage_of_chromosomes

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 stage_of_plasmids

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 chromosome_count_readme

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 plasmid_count_readme

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 bioproject_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_status

  data_type: 'varchar2'
  default_value: 'IN_PREPARATION'
  is_nullable: 1
  size: 255

=head2 machine

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 locus_tag_prefix

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_authors

  data_type: 'clob'
  is_nullable: 1

=head2 dsmz_authors

  data_type: 'clob'
  is_nullable: 1

=head2 pi_authors

  data_type: 'clob'
  is_nullable: 1

=head2 author_editing_status

  data_type: 'varchar2'
  default_value: 'NOT_EDITED'
  is_nullable: 1
  size: 255

=head2 img_taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 comments_to_ncbi

  data_type: 'clob'
  is_nullable: 1

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 release_now

  data_type: 'numeric'
  default_value: 0
  is_nullable: 1
  original: {data_type => "number"}
  size: [1,0]

=head2 new_submission

  data_type: 'numeric'
  default_value: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [1,0]

=head2 comments_internal

  data_type: 'clob'
  is_nullable: 1

=head2 assembly_only

  data_type: 'numeric'
  default_value: 0
  is_nullable: 1
  original: {data_type => "number"}
  size: [1,0]

=head2 ncbi_accession_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 portal_file_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 insert_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 insert_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 update_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 update_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 submission_status_detail

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 author_update

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_authors

  data_type: 'clob'
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
  is_nullable: 1
  size: 255

=head2 img_submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 ncbi_submission_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 gold_ap_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    original          => { data_type => "number", size => [38, 0] },
    sequence          => "pig_tracks_id_inc",
  },
  "jgi_project_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "biosample_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "chromosome_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "plasmid_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "author",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "linear_or_circular",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "final_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "assembly_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "file_directory",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "contig_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "stage_of_contigs",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "stage_of_chromosomes",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "stage_of_plasmids",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "chromosome_count_readme",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "plasmid_count_readme",
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
  "submission_status",
  {
    data_type => "varchar2",
    default_value => "IN_PREPARATION",
    is_nullable => 1,
    size => 255,
  },
  "machine",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "locus_tag_prefix",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_authors",
  { data_type => "clob", is_nullable => 1 },
  "dsmz_authors",
  { data_type => "clob", is_nullable => 1 },
  "pi_authors",
  { data_type => "clob", is_nullable => 1 },
  "author_editing_status",
  {
    data_type => "varchar2",
    default_value => "NOT_EDITED",
    is_nullable => 1,
    size => 255,
  },
  "img_taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "comments_to_ncbi",
  { data_type => "clob", is_nullable => 1 },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "release_now",
  {
    data_type => "numeric",
    default_value => 0,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [1, 0],
  },
  "new_submission",
  {
    data_type => "numeric",
    default_value => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [1, 0],
  },
  "comments_internal",
  { data_type => "clob", is_nullable => 1 },
  "assembly_only",
  {
    data_type => "numeric",
    default_value => 0,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [1, 0],
  },
  "ncbi_accession_number",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "portal_file_directory",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "insert_user",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "insert_time",
  { data_type => "timestamp", is_nullable => 1 },
  "update_user",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "update_time",
  { data_type => "timestamp", is_nullable => 1 },
  "submission_status_detail",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "author_update",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "submission_authors",
  { data_type => "clob", is_nullable => 1 },
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
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "img_submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "ncbi_submission_time",
  { data_type => "timestamp", is_nullable => 1 },
  "gold_ap_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rvd2SSITubqwbO9d2UFZDQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
