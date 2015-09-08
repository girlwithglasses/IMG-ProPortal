use utf8;
package DbSchema::IMG_Core::Result::DaccLogon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::DaccLogon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<DACC_LOGON>

=cut

__PACKAGE__->table("DACC_LOGON");

=head1 ACCESSORS

=head2 id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [10,0]

=head2 username

  data_type: 'varchar2'
  is_nullable: 0
  size: 30

=head2 password

  data_type: 'varchar2'
  is_nullable: 0
  size: 16

=head2 full_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 is_admin

  data_type: 'varchar2'
  is_nullable: 1
  size: 3

=head2 contact_email_list

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [10, 0],
  },
  "username",
  { data_type => "varchar2", is_nullable => 0, size => 30 },
  "password",
  { data_type => "varchar2", is_nullable => 0, size => 16 },
  "full_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "is_admin",
  { data_type => "varchar2", is_nullable => 1, size => 3 },
  "contact_email_list",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<dacc_logon_uk>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("dacc_logon_uk", ["username"]);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qqKQu7CnloN2dL0VWWAflg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
