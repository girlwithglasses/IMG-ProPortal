use utf8;
package DBIC::IMG_Core::Result::TaxonPangenomeComposition;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TaxonPangenomeComposition

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TAXON_PANGENOME_COMPOSITION>

=cut

__PACKAGE__->table("TAXON_PANGENOME_COMPOSITION");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 pangenome_composition

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pangenome_composition",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 RELATIONS

=head2 pangenome_composition

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Taxon>

=cut

__PACKAGE__->belongs_to(
  "pangenome_composition",
  "DBIC::IMG_Core::Result::Taxon",
  { taxon_oid => "pangenome_composition" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 taxon_oid

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Taxon>

=cut

__PACKAGE__->belongs_to(
  "taxon_oid",
  "DBIC::IMG_Core::Result::Taxon",
  { taxon_oid => "taxon_oid" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NpSTdNc3RtTwW+0qqZHwgg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
