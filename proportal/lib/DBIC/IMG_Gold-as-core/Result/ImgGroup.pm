use utf8;
package DbSchema::IMG_Core::Result::ImgGroup;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ImgGroup

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

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
