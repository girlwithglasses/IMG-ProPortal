use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoBioproject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoBioproject

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_BIOPROJECT>

=cut

__PACKAGE__->table("PROJECT_INFO_BIOPROJECT");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 jgi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 organism_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 250

=head2 organism_strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 isolate

  data_type: 'varchar2'
  is_nullable: 1
  size: 250

=head2 project_title

  data_type: 'varchar2'
  is_nullable: 1
  size: 250

=head2 project_desc

  data_type: 'varchar2'
  is_nullable: 0
  size: 3000

=head2 locus_tag_prefix

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 relevance

  data_type: 'varchar2'
  default_value: 'OTHER: Comparative Genomics'
  is_nullable: 0
  size: 200

=head2 target_capture

  data_type: 'varchar2'
  is_nullable: 0
  size: 200

=head2 target_material

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 sample_scope

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 bioproject_method

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 objectives

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 submission_status

  data_type: 'varchar2'
  default_value: 'IN_PREPARATION'
  is_nullable: 0
  size: 50

=head2 ncbi_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 ncbi_taxon_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 ncbi_accession_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 machine

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 submission_action

  data_type: 'varchar2'
  default_value: 'INITIAL'
  is_nullable: 0
  size: 20

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 submission_request_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 ncbi_organism_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 250

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 portal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 scientific_program

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=head2 project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 bioproject_oid

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'bioproject_oid_seq'
  size: 126

=head2 is_update_for

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 sample_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 intended_data_type_set

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 link

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 submission_error_message

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 cultivar

  data_type: 'varchar2'
  is_nullable: 1
  size: 48

=head2 ncbi_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "jgi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "organism_name",
  { data_type => "varchar2", is_nullable => 0, size => 250 },
  "organism_strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "isolate",
  { data_type => "varchar2", is_nullable => 1, size => 250 },
  "project_title",
  { data_type => "varchar2", is_nullable => 1, size => 250 },
  "project_desc",
  { data_type => "varchar2", is_nullable => 0, size => 3000 },
  "locus_tag_prefix",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "relevance",
  {
    data_type => "varchar2",
    default_value => "OTHER: Comparative Genomics",
    is_nullable => 0,
    size => 200,
  },
  "target_capture",
  { data_type => "varchar2", is_nullable => 0, size => 200 },
  "target_material",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "sample_scope",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "bioproject_method",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "objectives",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "submission_status",
  {
    data_type => "varchar2",
    default_value => "IN_PREPARATION",
    is_nullable => 0,
    size => 50,
  },
  "ncbi_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "ncbi_taxon_id",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "ncbi_accession_number",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "machine",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "submission_action",
  {
    data_type => "varchar2",
    default_value => "INITIAL",
    is_nullable => 0,
    size => 20,
  },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "submission_request_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "ncbi_organism_name",
  { data_type => "varchar2", is_nullable => 1, size => 250 },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "portal_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "scientific_program",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
  "project_name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "bioproject_oid",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "bioproject_oid_seq",
    size => 126,
  },
  "is_update_for",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "sample_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "intended_data_type_set",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "link",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "submission_error_message",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "cultivar",
  { data_type => "varchar2", is_nullable => 1, size => 48 },
  "ncbi_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</bioproject_oid>

=back

=cut

__PACKAGE__->set_primary_key("bioproject_oid");

=head1 RELATIONS

=head2 bioproject_propagations

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::BioprojectPropagation>

=cut

__PACKAGE__->has_many(
  "bioproject_propagations",
  "DbSchema::IMG_Core::Result::BioprojectPropagation",
  { "foreign.fk_bioproject_oid" => "self.bioproject_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_oid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::ProjectInfo>

=cut

__PACKAGE__->belongs_to(
  "project_oid",
  "DbSchema::IMG_Core::Result::ProjectInfo",
  { project_oid => "project_oid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 sample_oid

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::EnvSample>

=cut

__PACKAGE__->belongs_to(
  "sample_oid",
  "DbSchema::IMG_Core::Result::EnvSample",
  { sample_oid => "sample_oid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V71TBaMXBYpJDojnQSBAZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
