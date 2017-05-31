use utf8;
package DBIC::IMG_Core::Result::ScaffoldPanfoldComposition;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ScaffoldPanfoldComposition

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SCAFFOLD_PANFOLD_COMPOSITION>

=cut

__PACKAGE__->table("SCAFFOLD_PANFOLD_COMPOSITION");

=head1 ACCESSORS

=head2 scaffold_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 panfold_composition

  data_type: 'numeric'
  is_foreign_key: 1
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
  "panfold_composition",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 RELATIONS

=head2 panfold_composition

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Scaffold>

=cut

__PACKAGE__->belongs_to(
  "panfold_composition",
  "DBIC::IMG_Core::Result::Scaffold",
  { scaffold_oid => "panfold_composition" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TByb1o8xPaKT/yDcGbnwAw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
