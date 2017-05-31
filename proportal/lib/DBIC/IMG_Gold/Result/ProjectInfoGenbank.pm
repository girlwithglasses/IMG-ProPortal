use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoGenbank

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PROJECT_INFO_GENBANK>

=cut

__PACKAGE__->table("PROJECT_INFO_GENBANK");

=head1 ACCESSORS

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
  size: 3072

=head2 linear_or_circular

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 final_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 assembly_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 file_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 300

=head2 contig_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 stage_of_contigs

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 stage_of_chromosomes

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 stage_of_plasmids

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

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
  size: 50

=head2 machine

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 locus_tag_prefix

  data_type: 'varchar2'
  is_nullable: 1
  size: 15

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
  size: 50

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
  size: 50

=head2 portal_file_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 300

=head2 insert_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 insert_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 update_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 update_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 submission_status_detail

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 author_update

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_authors

  data_type: 'clob'
  is_nullable: 1

=head2 ncbi_submission_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 gold_ap_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
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
  { data_type => "varchar2", is_nullable => 1, size => 3072 },
  "linear_or_circular",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "final_status",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "assembly_method",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "file_directory",
  { data_type => "varchar2", is_nullable => 1, size => 300 },
  "contig_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "stage_of_contigs",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "stage_of_chromosomes",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "stage_of_plasmids",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
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
    size => 50,
  },
  "machine",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "locus_tag_prefix",
  { data_type => "varchar2", is_nullable => 1, size => 15 },
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
    size => 50,
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
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "portal_file_directory",
  { data_type => "varchar2", is_nullable => 1, size => 300 },
  "insert_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "insert_time",
  { data_type => "timestamp", is_nullable => 1 },
  "update_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "update_time",
  { data_type => "timestamp", is_nullable => 1 },
  "submission_status_detail",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "author_update",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "submission_authors",
  { data_type => "clob", is_nullable => 1 },
  "ncbi_submission_time",
  { data_type => "timestamp", is_nullable => 1 },
  "gold_ap_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_ap_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_ap_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mao/2x7s8LcgK7wRQIU9hw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoGenbank.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::ProjectInfoGenbank;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ProjectInfoGenbank

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PROJECT_INFO_GENBANK>

=cut

__PACKAGE__->table("PROJECT_INFO_GENBANK");

=head1 ACCESSORS

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
  size: 3072

=head2 linear_or_circular

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 final_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 assembly_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 file_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 300

=head2 contig_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 stage_of_contigs

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 stage_of_chromosomes

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 stage_of_plasmids

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

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
  size: 50

=head2 machine

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 locus_tag_prefix

  data_type: 'varchar2'
  is_nullable: 1
  size: 15

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
  size: 50

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
  size: 50

=head2 portal_file_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 300

=head2 insert_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 insert_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 update_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 update_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 submission_status_detail

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 author_update

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_authors

  data_type: 'clob'
  is_nullable: 1

=head2 ncbi_submission_time

  data_type: 'timestamp'
  is_nullable: 1

=head2 gold_ap_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
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
  { data_type => "varchar2", is_nullable => 1, size => 3072 },
  "linear_or_circular",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "final_status",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "assembly_method",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "file_directory",
  { data_type => "varchar2", is_nullable => 1, size => 300 },
  "contig_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "stage_of_contigs",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "stage_of_chromosomes",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "stage_of_plasmids",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
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
    size => 50,
  },
  "machine",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "locus_tag_prefix",
  { data_type => "varchar2", is_nullable => 1, size => 15 },
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
    size => 50,
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
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "portal_file_directory",
  { data_type => "varchar2", is_nullable => 1, size => 300 },
  "insert_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "insert_time",
  { data_type => "timestamp", is_nullable => 1 },
  "update_user",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "update_time",
  { data_type => "timestamp", is_nullable => 1 },
  "submission_status_detail",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "author_update",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "submission_authors",
  { data_type => "clob", is_nullable => 1 },
  "ncbi_submission_time",
  { data_type => "timestamp", is_nullable => 1 },
  "gold_ap_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_ap_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_ap_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NI+AN1MyorvdQ19QQIH20w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ProjectInfoGenbank.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
