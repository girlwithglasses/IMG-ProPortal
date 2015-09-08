use utf8;
package DbSchema::IMG_Core::Result::GoldAnalysisProjectLookup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GoldAnalysisProjectLookup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<GOLD_ANALYSIS_PROJECT_LOOKUP>

=cut

__PACKAGE__->table("GOLD_ANALYSIS_PROJECT_LOOKUP");

=head1 ACCESSORS

=head2 gold_ap_lookup_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'gold_ap_lookup_id_seq'
  size: 126

=head2 gold_analysis_project_id

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 its_spid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 project_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 sample_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 pmo_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 goldv5_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=cut

__PACKAGE__->add_columns(
  "gold_ap_lookup_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "gold_ap_lookup_id_seq",
    size => 126,
  },
  "gold_analysis_project_id",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "its_spid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "project_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
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
  "pmo_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "goldv5_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
);

=head1 PRIMARY KEY

=over 4

=item * L</gold_ap_lookup_id>

=back

=cut

__PACKAGE__->set_primary_key("gold_ap_lookup_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<gold_ap_lookup_3>

=over 4

=item * L</gold_analysis_project_id>

=item * L</project_oid>

=item * L</sample_oid>

=item * L</goldv5_project_id>

=item * L</its_spid>

=item * L</pmo_project_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "gold_ap_lookup_3",
  [
    "gold_analysis_project_id",
    "project_oid",
    "sample_oid",
    "goldv5_project_id",
    "its_spid",
    "pmo_project_id",
  ],
);

=head1 RELATIONS

=head2 gold_analysis_project

Type: belongs_to

Related object: L<DbSchema::IMG_Core::Result::GoldAnalysisProject>

=cut

__PACKAGE__->belongs_to(
  "gold_analysis_project",
  "DbSchema::IMG_Core::Result::GoldAnalysisProject",
  { gold_analysis_project_id => "gold_analysis_project_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
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


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HUn+DoZ7jGL6CGWQrrtnTg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
