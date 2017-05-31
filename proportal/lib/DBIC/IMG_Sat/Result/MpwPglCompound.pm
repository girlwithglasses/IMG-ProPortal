use utf8;
package DBIC::IMG_Sat::Result::MpwPglCompound;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::MpwPglCompound

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MPW_PGL_COMPOUND>

=cut

__PACKAGE__->table("MPW_PGL_COMPOUND");

=head1 ACCESSORS

=head2 compound_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 compound_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 compound_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "compound_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "compound_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "compound_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6Y5Ra81W+j0bRoYa41d7Ow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
