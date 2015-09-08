use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoDataLinks112013;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoDataLinks112013

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_DATA_LINKS_112013>

=cut

__PACKAGE__->table("PROJECT_INFO_DATA_LINKS_112013");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 db_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 link_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "db_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "link_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hCpItGVUfJpss+AiSYkBJQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
