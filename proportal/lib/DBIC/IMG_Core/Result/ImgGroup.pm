use utf8;
package DBIC::IMG_Core::Result::ImgGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ImgGroup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<IMG_GROUP>

=cut

__PACKAGE__->table("IMG_GROUP");

=head1 ACCESSORS

=head2 group_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 group_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 lead

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "group_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "group_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "lead",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-07-13 15:21:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SnRDXLYMexdayzikQK7qow
# These lines were loaded from '/global/u1/a/aireland/gn-img-proportal-mojo/script/../lib/DBIC/IMG_Core/Result/ImgGroup.pm' found in @INC.
# They are now part of the custom portion of this file
# for you to hand-edit.  If you do not either delete
# this section or remove that file from @INC, this section
# will be repeated redundantly when you re-create this
# file again via Loader!  See skip_load_external to disable
# this feature.

use utf8;
package DBIC::IMG_Core::Result::ImgGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ImgGroup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<IMG_GROUP>

=cut

__PACKAGE__->table("IMG_GROUP");

=head1 ACCESSORS

=head2 group_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 group_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 lead

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "group_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "group_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "lead",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+S4ia6CCN0JsRYgdaadF6g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
# End of lines loaded from '/global/u1/a/aireland/gn-img-proportal-mojo/script/../lib/DBIC/IMG_Core/Result/ImgGroup.pm' 


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
