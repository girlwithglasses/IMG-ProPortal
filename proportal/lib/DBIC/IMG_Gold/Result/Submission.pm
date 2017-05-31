use utf8;
package DBIC::IMG_Gold::Result::Submission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Submission

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION>

=cut

__PACKAGE__->table("SUBMISSION");

=head1 ACCESSORS

=head2 database

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 contact

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 project_info

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 genbank_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 img_ec_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_product_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 scaffold_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 error_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gene_calling_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 file_location

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 sample_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 contigs_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 singlets_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 binning_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 is_img_public

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 admin_notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 mol_topology

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 approval_status

  data_type: 'varchar2'
  default_value: 'pending review'
  is_nullable: 1
  size: 80

=head2 approved_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 replace_taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 error_msg

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 img_dev_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 remove_duplicate_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 subtitle

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bin_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 stats_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 assembled_seq_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 assembler_used

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 reads_for_assembly

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_454_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_454_quality_trim

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 unassembled_454_trim_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_illumina_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cluster_seq

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 quality_based_trim

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 seq_coverage_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_illum_quality_trim

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 unassembled_illum_trim_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 loaded_into_img

  data_type: 'varchar2'
  default_value: 'Yes'
  is_nullable: 1
  size: 10

=head2 in_file

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 10

=head2 permute

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 all_reads

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 assembly_qd_report

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 assembly_qc_report

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 info_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 agp_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 add_to_portal

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 portal_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 portal_release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 names_map_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 batch_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 prev_submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 embargo_days

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 refseq_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gbk_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gff_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 approval_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 bam_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 result_wig_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 result_exp_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 reference_sub_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 exp_experiment_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 library_info

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 genbank_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 h5_files

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 rqc_assembly_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 unassembled_pacbio_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jat_key_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 passed_quality_chk

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_jgi

  data_type: 'varchar2'
  default_value: 'Yes'
  is_nullable: 1
  size: 10

=head2 contact_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 met_processing

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 set_embargo_date

  data_type: 'varchar2'
  default_value: 'Yes'
  is_nullable: 1
  size: 10

=head2 pushed_to_met_ws

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 img_term_transfer_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 is_contaminated

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 genome_completion

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 img_handler

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "database",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "contact",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "project_info",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "submission_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "genbank_file",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "img_ec_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_product_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "species_code",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "scaffold_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "error_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "status",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gene_calling_flag",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "file_location",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "sample_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "contigs_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "singlets_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "binning_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "is_img_public",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "admin_notes",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "mol_topology",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "approval_status",
  {
    data_type => "varchar2",
    default_value => "pending review",
    is_nullable => 1,
    size => 80,
  },
  "approved_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "replace_taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "error_msg",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "img_dev_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "remove_duplicate_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "subtitle",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bin_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "stats_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "assembled_seq_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "assembler_used",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "reads_for_assembly",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_454_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_454_quality_trim",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "unassembled_454_trim_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_illumina_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cluster_seq",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "quality_based_trim",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "seq_coverage_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_illum_quality_trim",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "unassembled_illum_trim_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "loaded_into_img",
  {
    data_type => "varchar2",
    default_value => "Yes",
    is_nullable => 1,
    size => 10,
  },
  "in_file",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 10,
  },
  "permute",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "all_reads",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "assembly_qd_report",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "assembly_qc_report",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "info_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "agp_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "add_to_portal",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "portal_url",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "portal_release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "names_map_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "batch_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "prev_submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "embargo_days",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "refseq_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gbk_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gff_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "approval_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "bam_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "result_wig_directory",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "result_exp_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "reference_sub_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "exp_experiment_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "library_info",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "genbank_id",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "h5_files",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "rqc_assembly_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "unassembled_pacbio_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jat_key_id",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "passed_quality_chk",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_jgi",
  {
    data_type => "varchar2",
    default_value => "Yes",
    is_nullable => 1,
    size => 10,
  },
  "contact_email",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "met_processing",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "set_embargo_date",
  {
    data_type => "varchar2",
    default_value => "Yes",
    is_nullable => 1,
    size => 10,
  },
  "pushed_to_met_ws",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "img_term_transfer_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "is_contaminated",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "genome_completion",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "img_handler",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</submission_id>

=back

=cut

__PACKAGE__->set_primary_key("submission_id");

=head1 RELATIONS

=head2 bad_depth_file_warnings

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::BadDepthFileWarning>

=cut

__PACKAGE__->has_many(
  "bad_depth_file_warnings",
  "DBIC::IMG_Gold::Result::BadDepthFileWarning",
  { "foreign.submission_id" => "self.submission_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 submission_data_files

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::SubmissionDataFile>

=cut

__PACKAGE__->has_many(
  "submission_data_files",
  "DBIC::IMG_Gold::Result::SubmissionDataFile",
  { "foreign.submission_id" => "self.submission_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Wefx/ao928P7EmLMyFW+Xw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Submission.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::Submission;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Submission

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SUBMISSION>

=cut

__PACKAGE__->table("SUBMISSION");

=head1 ACCESSORS

=head2 database

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 contact

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 project_info

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 genbank_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 img_ec_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_product_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 species_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 scaffold_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 error_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 status

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gene_calling_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 file_location

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 sample_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 submission_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 contigs_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 singlets_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 binning_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 is_img_public

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 admin_notes

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 mol_topology

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 approval_status

  data_type: 'varchar2'
  default_value: 'pending review'
  is_nullable: 1
  size: 80

=head2 approved_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 replace_taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 error_msg

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 img_dev_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 remove_duplicate_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 subtitle

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bin_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 stats_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 assembled_seq_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 assembler_used

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 reads_for_assembly

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_454_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_454_quality_trim

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 unassembled_454_trim_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_illumina_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cluster_seq

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 quality_based_trim

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 seq_coverage_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 unassembled_illum_quality_trim

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 unassembled_illum_trim_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 loaded_into_img

  data_type: 'varchar2'
  default_value: 'Yes'
  is_nullable: 1
  size: 10

=head2 in_file

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 10

=head2 permute

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 all_reads

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 assembly_qd_report

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 assembly_qc_report

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 info_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 agp_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 add_to_portal

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 portal_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 portal_release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 names_map_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 batch_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 prev_submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 embargo_days

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 refseq_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gbk_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gff_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 approval_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 bam_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 result_wig_directory

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 result_exp_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 reference_sub_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 exp_experiment_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 library_info

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 genbank_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 h5_files

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 rqc_assembly_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 unassembled_pacbio_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jat_key_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 passed_quality_chk

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_jgi

  data_type: 'varchar2'
  default_value: 'Yes'
  is_nullable: 1
  size: 10

=head2 contact_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 met_processing

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 set_embargo_date

  data_type: 'varchar2'
  default_value: 'Yes'
  is_nullable: 1
  size: 10

=head2 pushed_to_met_ws

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 img_term_transfer_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 is_contaminated

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 genome_completion

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 img_handler

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "database",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "contact",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "project_info",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "submission_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "genbank_file",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "img_ec_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_product_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "species_code",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "scaffold_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "error_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "status",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gene_calling_flag",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "file_location",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "sample_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "contigs_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "singlets_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "binning_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "is_img_public",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "admin_notes",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "mol_topology",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "approval_status",
  {
    data_type => "varchar2",
    default_value => "pending review",
    is_nullable => 1,
    size => 80,
  },
  "approved_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "replace_taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "error_msg",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "img_dev_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "remove_duplicate_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "subtitle",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bin_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "stats_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "assembled_seq_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "assembler_used",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "reads_for_assembly",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_454_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_454_quality_trim",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "unassembled_454_trim_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_illumina_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cluster_seq",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "quality_based_trim",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "seq_coverage_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "unassembled_illum_quality_trim",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "unassembled_illum_trim_method",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "loaded_into_img",
  {
    data_type => "varchar2",
    default_value => "Yes",
    is_nullable => 1,
    size => 10,
  },
  "in_file",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 10,
  },
  "permute",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "all_reads",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "assembly_qd_report",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "assembly_qc_report",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "info_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "agp_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "add_to_portal",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "portal_url",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "portal_release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "names_map_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "batch_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "prev_submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "embargo_days",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "refseq_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gbk_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gff_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "approval_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "bam_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "result_wig_directory",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "result_exp_file",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "reference_sub_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "exp_experiment_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "library_info",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "genbank_id",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "h5_files",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "rqc_assembly_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "unassembled_pacbio_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jat_key_id",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "passed_quality_chk",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_jgi",
  {
    data_type => "varchar2",
    default_value => "Yes",
    is_nullable => 1,
    size => 10,
  },
  "contact_email",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "met_processing",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "set_embargo_date",
  {
    data_type => "varchar2",
    default_value => "Yes",
    is_nullable => 1,
    size => 10,
  },
  "pushed_to_met_ws",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "img_term_transfer_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "is_contaminated",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "genome_completion",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "img_handler",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</submission_id>

=back

=cut

__PACKAGE__->set_primary_key("submission_id");

=head1 RELATIONS

=head2 submission_data_files

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::SubmissionDataFile>

=cut

__PACKAGE__->has_many(
  "submission_data_files",
  "DBIC::IMG_Gold::Result::SubmissionDataFile",
  { "foreign.submission_id" => "self.submission_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:X5kDU9cpvmD2r46me5+DHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Submission.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
