use utf8;
package DbSchema::IMG_Core::Result::ImgGroupNews;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ImgGroupNews

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<IMG_GROUP_NEWS>

=cut

__PACKAGE__->table("IMG_GROUP_NEWS");

=head1 ACCESSORS

=head2 group_id

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 news_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 title

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 posted_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 is_public

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 released_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "group_id",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "news_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "title",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "posted_by",
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
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "is_public",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "released_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:7JhZ77MN29+B0zzrLyalXg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
