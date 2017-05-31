use utf8;
package DBIC::IMG_Gold::Result::MeshHeading;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::MeshHeading

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MESH_HEADING>

=cut

__PACKAGE__->table("MESH_HEADING");

=head1 ACCESSORS

=head2 mesh_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 tree_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 qualifier_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "mesh_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "tree_number",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "qualifier_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</mesh_id>

=back

=cut

__PACKAGE__->set_primary_key("mesh_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e8rbt9JIRgXwFC9Lx1AW4Q
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/MeshHeading.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::MeshHeading;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::MeshHeading

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MESH_HEADING>

=cut

__PACKAGE__->table("MESH_HEADING");

=head1 ACCESSORS

=head2 mesh_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 tree_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 qualifier_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "mesh_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "tree_number",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "qualifier_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</mesh_id>

=back

=cut

__PACKAGE__->set_primary_key("mesh_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Yt/KbdWVlPCk/W6gVZcM4Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/MeshHeading.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
