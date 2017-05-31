use utf8;
package DBIC::IMG_Gold::Result::ContactWorkspaceGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ContactWorkspaceGroup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CONTACT_WORKSPACE_GROUP>

=cut

__PACKAGE__->table("CONTACT_WORKSPACE_GROUP");

=head1 ACCESSORS

=head2 contact_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 data_set_type

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 data_set_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 group_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "contact_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "data_set_type",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "data_set_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "group_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MLlwlwZ1P4JW4vNvQF68Lw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ContactWorkspaceGroup.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::ContactWorkspaceGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::ContactWorkspaceGroup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<CONTACT_WORKSPACE_GROUP>

=cut

__PACKAGE__->table("CONTACT_WORKSPACE_GROUP");

=head1 ACCESSORS

=head2 contact_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 data_set_type

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 data_set_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 group_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "contact_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "data_set_type",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "data_set_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "group_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GPdwo8FpGQbbtoI3txdysQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/ContactWorkspaceGroup.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
