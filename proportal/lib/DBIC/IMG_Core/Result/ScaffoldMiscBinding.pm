use utf8;
package DBIC::IMG_Core::Result::ScaffoldMiscBinding;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ScaffoldMiscBinding

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SCAFFOLD_MISC_BINDINGS>

=cut

__PACKAGE__->table("SCAFFOLD_MISC_BINDINGS");

=head1 ACCESSORS

=head2 scaffold_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gbk_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 frag_coord

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 note

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 bound_moiety

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "scaffold_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gbk_tag",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "frag_coord",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "note",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "bound_moiety",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iG/eB8AJmaZwZFAJTM12Qw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
