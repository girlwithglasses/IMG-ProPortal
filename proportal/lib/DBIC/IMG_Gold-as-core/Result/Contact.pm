use utf8;
package DbSchema::IMG_Core::Result::Contact;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::Contact

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<CONTACT>

=cut

__PACKAGE__->table("CONTACT");

=head1 ACCESSORS

=head2 contact_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 username

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 password

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 title

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 department

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phone

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 organization

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 address

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 city

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 state

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 country

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 super_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_editor

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_group

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 jgi_user

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 img_editing_level

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 caliban_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 caliban_user_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "contact_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "username",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "password",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "title",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "department",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phone",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "organization",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "address",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "city",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "state",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "country",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "super_user",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_editor",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_group",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "jgi_user",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "img_editing_level",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "caliban_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "caliban_user_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</contact_oid>

=back

=cut

__PACKAGE__->set_primary_key("contact_oid");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cFSe9y8jjpHoxKKAezANPQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
