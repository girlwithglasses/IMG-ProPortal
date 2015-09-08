use utf8;
package DbSchema::IMG_Core::Result::ProjectInfoJgiUrl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfoJgiUrl

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO_JGI_URL>

=cut

__PACKAGE__->table("PROJECT_INFO_JGI_URL");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 db_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 db_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 url

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "db_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "db_id",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "url",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sF2PqDPkS4B+pLgb0LqxIA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
