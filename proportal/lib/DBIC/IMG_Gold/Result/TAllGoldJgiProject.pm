use utf8;
package DBIC::IMG_Gold::Result::TAllGoldJgiProject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::TAllGoldJgiProject

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<T_ALL_GOLD_JGI_PROJECTS>

=cut

__PACKAGE__->table("T_ALL_GOLD_JGI_PROJECTS");

=head1 ACCESSORS

=head2 its_spid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 project_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 project_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 source

  data_type: 'char'
  is_nullable: 1
  size: 2

=cut

__PACKAGE__->add_columns(
  "its_spid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "project_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "source",
  { data_type => "char", is_nullable => 1, size => 2 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SB0Sn9Mh4Z38m4i+inVhdw
# These lines were loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/TAllGoldJgiProject.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Gold::Result::TAllGoldJgiProject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::TAllGoldJgiProject

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<T_ALL_GOLD_JGI_PROJECTS>

=cut

__PACKAGE__->table("T_ALL_GOLD_JGI_PROJECTS");

=head1 ACCESSORS

=head2 its_spid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 project_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 project_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 source

  data_type: 'char'
  is_nullable: 1
  size: 2

=cut

__PACKAGE__->add_columns(
  "its_spid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "project_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "source",
  { data_type => "char", is_nullable => 1, size => 2 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-09-18 13:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fFs6brUsuPvlKhKB4aGJ5A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/homes/a/aireland/webUI/proportal/lib/DBIC/IMG_Gold/Result/TAllGoldJgiProject.pm'


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
