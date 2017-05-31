use utf8;
package DBIC::IMG_Gold::Result::Goldv5View;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Goldv5View

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLDV5_VIEW>

=cut

__PACKAGE__->table("GOLDV5_VIEW");

=head1 ACCESSORS

=head2 ap_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 48

=head2 analysis_project_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 img_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_annotation_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 analysis_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 240

=head2 seq_project_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 60

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 60

=head2 er_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 er_sample_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 its_spid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 pmo_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 3072

=head2 biosample_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 27

=head2 biosample_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 27

=head2 study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=cut

__PACKAGE__->add_columns(
  "ap_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 48 },
  "analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "img_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_annotation_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "analysis_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 240 },
  "seq_project_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 60 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 60 },
  "er_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "er_sample_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "its_spid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "pmo_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "project_name",
  { data_type => "varchar2", is_nullable => 1, size => 3072 },
  "biosample_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 27 },
  "biosample_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 27 },
  "study_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fSRZ7B7C+5nauyfEjsT8JQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Goldv5View.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::Goldv5View;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::Goldv5View

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLDV5_VIEW>

=cut

__PACKAGE__->table("GOLDV5_VIEW");

=head1 ACCESSORS

=head2 ap_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 48

=head2 analysis_project_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 img_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_annotation_at_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 analysis_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 240

=head2 seq_project_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 60

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 60

=head2 er_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 er_sample_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 its_spid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 pmo_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 3072

=head2 biosample_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 27

=head2 biosample_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 27

=head2 study_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=cut

__PACKAGE__->add_columns(
  "ap_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 48 },
  "analysis_project_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "img_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_annotation_at_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "analysis_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 240 },
  "seq_project_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 60 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 60 },
  "er_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "er_sample_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "its_spid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "pmo_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "project_name",
  { data_type => "varchar2", is_nullable => 1, size => 3072 },
  "biosample_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 27 },
  "biosample_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 27 },
  "study_name",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/ZRmUpd2xKzff15+oNA2Dw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/Goldv5View.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
