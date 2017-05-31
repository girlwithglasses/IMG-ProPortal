use utf8;
package DBIC::IMG_Core::Result::ScaffoldIntergenic;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ScaffoldIntergenic

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SCAFFOLD_INTERGENIC>

=cut

__PACKAGE__->table("SCAFFOLD_INTERGENIC");

=head1 ACCESSORS

=head2 scaffold_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 start_coord

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 end_coord

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "scaffold_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "start_coord",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "end_coord",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 RELATIONS

=head2 scaffold_oid

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Scaffold>

=cut

__PACKAGE__->belongs_to(
  "scaffold_oid",
  "DBIC::IMG_Core::Result::Scaffold",
  { scaffold_oid => "scaffold_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fIIYW81b+NzJ7+aJXZdRFg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
