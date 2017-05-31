use utf8;
package DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 sample_oid

  data_type: 'numeric'
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
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "sample_oid",
  {
    data_type => "numeric",
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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lIn25V68716k5Q5/ZfO1+A
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldAnalysisProjectLookup.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldAnalysisProjectLookup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

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

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProject>

=cut

__PACKAGE__->belongs_to(
  "gold_analysis_project",
  "DBIC::IMG_Gold::Result::GoldAnalysisProject",
  { gold_analysis_project_id => "gold_analysis_project_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 project_oid

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::ProjectInfo>

=cut

__PACKAGE__->belongs_to(
  "project_oid",
  "DBIC::IMG_Gold::Result::ProjectInfo",
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

Related object: L<DBIC::IMG_Gold::Result::EnvSample>

=cut

__PACKAGE__->belongs_to(
  "sample_oid",
  "DBIC::IMG_Gold::Result::EnvSample",
  { sample_oid => "sample_oid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:upQtv0bueB9dgGo/KRJzew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/GoldAnalysisProjectLookup.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
