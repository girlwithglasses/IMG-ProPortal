use utf8;
package DbSchema::IMG_Core::Result::MeshHeading;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::MeshHeading

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<MESH_HEADING>

=cut

__PACKAGE__->table("MESH_HEADING");

=head1 ACCESSORS

=head2 mesh_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 tree_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 qualifier_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "mesh_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "tree_number",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "qualifier_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</mesh_id>

=back

=cut

__PACKAGE__->set_primary_key("mesh_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YHZNoDNVnEX6UV675PxXbQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
