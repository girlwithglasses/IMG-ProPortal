use utf8;
package DBIC::IMG_Gold::Result::CvpropagationDataType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::CvpropagationDataType

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CVPROPAGATION_DATA_TYPE>

=cut

__PACKAGE__->table("CVPROPAGATION_DATA_TYPE");

=head1 ACCESSORS

=head2 pk_data_type

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=cut

__PACKAGE__->add_columns(
  "pk_data_type",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk_data_type>

=back

=cut

__PACKAGE__->set_primary_key("pk_data_type");

=head1 UNIQUE CONSTRAINTS

=head2 C<sys_c0034033>

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->add_unique_constraint("sys_c0034033", ["cv_term"]);

=head1 RELATIONS

=head2 bioproject_propagations

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::BioprojectPropagation>

=cut

__PACKAGE__->has_many(
  "bioproject_propagations",
  "DBIC::IMG_Gold::Result::BioprojectPropagation",
  { "foreign.field" => "self.cv_term" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:U4vx47YRmogP0p9JPa/OPQ
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/CvpropagationDataType.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::CvpropagationDataType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::CvpropagationDataType

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CVPROPAGATION_DATA_TYPE>

=cut

__PACKAGE__->table("CVPROPAGATION_DATA_TYPE");

=head1 ACCESSORS

=head2 pk_data_type

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 cv_term

  data_type: 'varchar2'
  is_nullable: 0
  size: 80

=cut

__PACKAGE__->add_columns(
  "pk_data_type",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "cv_term",
  { data_type => "varchar2", is_nullable => 0, size => 80 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk_data_type>

=back

=cut

__PACKAGE__->set_primary_key("pk_data_type");

=head1 UNIQUE CONSTRAINTS

=head2 C<sys_c0034033>

=over 4

=item * L</cv_term>

=back

=cut

__PACKAGE__->add_unique_constraint("sys_c0034033", ["cv_term"]);

=head1 RELATIONS

=head2 bioproject_propagations

Type: has_many

Related object: L<DBIC::IMG_Gold::Result::BioprojectPropagation>

=cut

__PACKAGE__->has_many(
  "bioproject_propagations",
  "DBIC::IMG_Gold::Result::BioprojectPropagation",
  { "foreign.field" => "self.cv_term" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E34aHHIVobE5VcwLMEMeBA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/CvpropagationDataType.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
