use utf8;
package DBIC::IMG_Gold::Result::BioprojectPropagation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::BioprojectPropagation

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOPROJECT_PROPAGATION>

=cut

__PACKAGE__->table("BIOPROJECT_PROPAGATION");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 propagation_timestamp

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 old_value

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 new_value

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 notes

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 fk_bioproject_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 field

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 0,
    original       => { data_type => "number", size => [38, 0] },
  },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "propagation_timestamp",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "old_value",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "new_value",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "notes",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "fk_bioproject_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "field",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 80 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<bioproject_propagation_1>

=over 4

=item * L</project_oid>

=item * L</field>

=item * L</fk_bioproject_oid>

=item * L</submission_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "bioproject_propagation_1",
  ["project_oid", "field", "fk_bioproject_oid", "submission_id"],
);

=head1 RELATIONS

=head2 field

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::CvpropagationDataType>

=cut

__PACKAGE__->belongs_to(
  "field",
  "DBIC::IMG_Gold::Result::CvpropagationDataType",
  { cv_term => "field" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 fk_bioproject_oid

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::ProjectInfoBioproject>

=cut

__PACKAGE__->belongs_to(
  "fk_bioproject_oid",
  "DBIC::IMG_Gold::Result::ProjectInfoBioproject",
  { bioproject_oid => "fk_bioproject_oid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 project_oid

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::ProjectInfo>

=cut

__PACKAGE__->belongs_to(
  "project_oid",
  "DBIC::IMG_Gold::Result::ProjectInfo",
  { project_oid => "project_oid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:g0/ibh6ezQs6ttEJlUH8cA
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/BioprojectPropagation.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::BioprojectPropagation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::BioprojectPropagation

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOPROJECT_PROPAGATION>

=cut

__PACKAGE__->table("BIOPROJECT_PROPAGATION");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 propagation_timestamp

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 old_value

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 new_value

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 notes

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 fk_bioproject_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 field

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 0,
    original       => { data_type => "number", size => [38, 0] },
  },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "propagation_timestamp",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "old_value",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "new_value",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "notes",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "fk_bioproject_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "field",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 80 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<bioproject_propagation_1>

=over 4

=item * L</project_oid>

=item * L</field>

=item * L</fk_bioproject_oid>

=item * L</submission_id>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "bioproject_propagation_1",
  ["project_oid", "field", "fk_bioproject_oid", "submission_id"],
);

=head1 RELATIONS

=head2 field

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::CvpropagationDataType>

=cut

__PACKAGE__->belongs_to(
  "field",
  "DBIC::IMG_Gold::Result::CvpropagationDataType",
  { cv_term => "field" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 fk_bioproject_oid

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::ProjectInfoBioproject>

=cut

__PACKAGE__->belongs_to(
  "fk_bioproject_oid",
  "DBIC::IMG_Gold::Result::ProjectInfoBioproject",
  { bioproject_oid => "fk_bioproject_oid" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 project_oid

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::ProjectInfo>

=cut

__PACKAGE__->belongs_to(
  "project_oid",
  "DBIC::IMG_Gold::Result::ProjectInfo",
  { project_oid => "project_oid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Dq/i8j17df+3Tdy65np/8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/BioprojectPropagation.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
