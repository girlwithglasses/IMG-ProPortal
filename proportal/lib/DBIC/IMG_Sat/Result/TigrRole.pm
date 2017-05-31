use utf8;
package DBIC::IMG_Sat::Result::TigrRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::TigrRole

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TIGR_ROLE>

=cut

__PACKAGE__->table("TIGR_ROLE");

=head1 ACCESSORS

=head2 role_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 main_role

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 sub_role

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "role_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "main_role",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "sub_role",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_id>

=back

=cut

__PACKAGE__->set_primary_key("role_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FmtdEe5EFLm05AD7wN9xNw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
