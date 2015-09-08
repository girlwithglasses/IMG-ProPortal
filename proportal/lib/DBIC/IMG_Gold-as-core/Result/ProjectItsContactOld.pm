use utf8;
package DbSchema::IMG_Core::Result::ProjectItsContactOld;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectItsContactOld

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<PROJECT_ITS_CONTACT_OLD>

=cut

__PACKAGE__->table("PROJECT_ITS_CONTACT_OLD");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 its_contact_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [10,0]

=head2 first_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 middle_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 last_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "its_contact_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "first_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "middle_name",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "last_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:d5GxHendiqpREE8V1a7rzA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
