use utf8;
package DBIC::IMG_Sat::Result::GoTermParents;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::GoTermParents

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GO_TERM_PARENTS>

=cut

__PACKAGE__->table("GO_TERM_PARENTS");

=head1 ACCESSORS

=head2 go_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 parent

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 rel_type

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "go_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "parent",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "rel_type",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 RELATIONS

=head2 go

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::GoTerm>

=cut

__PACKAGE__->belongs_to(
  "go",
  "DBIC::IMG_Sat::Result::GoTerm",
  { go_id => "go_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
  },
);

=head2 parent

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::GoTerm>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "DBIC::IMG_Sat::Result::GoTerm",
  { go_id => "parent" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5tAr33TPdz4vnR9ABLL4Mg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
