use utf8;
package DBIC::IMG_Sat::Result::EggnogHierarchy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::EggnogHierarchy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<EGGNOG_HIERARCHY>

=cut

__PACKAGE__->table("EGGNOG_HIERARCHY");

=head1 ACCESSORS

=head2 eggnog_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 function_group

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 level_1

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 level_2

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 nog_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "eggnog_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "function_group",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "level_1",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "level_2",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "nog_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</eggnog_oid>

=back

=cut

__PACKAGE__->set_primary_key("eggnog_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6C//y+xQQ+Dn+nxIycwmig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
