use utf8;
package DBIC::IMG_Gold::Result::StudyLoad;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::StudyLoad

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<STUDY_LOAD>

=cut

__PACKAGE__->table("STUDY_LOAD");

=head1 ACCESSORS

=head2 new_study_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'load_study_pk_seq'
  size: 126

=head2 gold_study_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=head2 its_proposal_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ncbi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 add_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 mod_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 contact_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 last_mod_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_public

  data_type: 'varchar2'
  is_nullable: 1
  size: 24

=head2 gpts_proposal_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 project_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 active

  data_type: 'varchar2'
  default_value: 'Y'
  is_nullable: 0
  size: 3

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 9

=head2 bioproject_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 gold_study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 9

=head2 metagenomic

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 20

=head2 study_type_id

  data_type: 'integer'
  default_value: 2
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "new_study_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "load_study_pk_seq",
    size => 126,
  },
  "gold_study_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "study_name",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
  "its_proposal_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ncbi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "add_date",
  { data_type => "timestamp", is_nullable => 1 },
  "mod_date",
  { data_type => "timestamp", is_nullable => 1 },
  "contact_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "last_mod_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_public",
  { data_type => "varchar2", is_nullable => 1, size => 24 },
  "gpts_proposal_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "active",
  { data_type => "varchar2", default_value => "Y", is_nullable => 0, size => 3 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 9 },
  "bioproject_name",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "gold_study_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 9 },
  "metagenomic",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 0,
    size => 20,
  },
  "study_type_id",
  {
    data_type     => "integer",
    default_value => 2,
    is_nullable   => 0,
    original      => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</new_study_id>

=back

=cut

__PACKAGE__->set_primary_key("new_study_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+OX6nfmOiCVhQz0yduQD0g
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/StudyLoad.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::StudyLoad;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::StudyLoad

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<STUDY_LOAD>

=cut

__PACKAGE__->table("STUDY_LOAD");

=head1 ACCESSORS

=head2 new_study_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 0
  original: {data_type => "number"}
  sequence: 'load_study_pk_seq'
  size: 126

=head2 gold_study_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=head2 its_proposal_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 ncbi_project_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 add_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 mod_date

  data_type: 'timestamp'
  is_nullable: 1

=head2 contact_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 last_mod_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 is_public

  data_type: 'varchar2'
  is_nullable: 1
  size: 24

=head2 gpts_proposal_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 project_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 active

  data_type: 'varchar2'
  default_value: 'Y'
  is_nullable: 0
  size: 3

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 9

=head2 bioproject_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 gold_study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 9

=head2 metagenomic

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 20

=head2 study_type_id

  data_type: 'integer'
  default_value: 2
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "new_study_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    sequence => "load_study_pk_seq",
    size => 126,
  },
  "gold_study_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "study_name",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
  "its_proposal_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "ncbi_project_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "add_date",
  { data_type => "timestamp", is_nullable => 1 },
  "mod_date",
  { data_type => "timestamp", is_nullable => 1 },
  "contact_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "last_mod_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "is_public",
  { data_type => "varchar2", is_nullable => 1, size => 24 },
  "gpts_proposal_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "active",
  { data_type => "varchar2", default_value => "Y", is_nullable => 0, size => 3 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 9 },
  "bioproject_name",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "gold_study_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 9 },
  "metagenomic",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 0,
    size => 20,
  },
  "study_type_id",
  {
    data_type     => "integer",
    default_value => 2,
    is_nullable   => 0,
    original      => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</new_study_id>

=back

=cut

__PACKAGE__->set_primary_key("new_study_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XIWsvSdTXBM5hmnNs4zVxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/StudyLoad.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
