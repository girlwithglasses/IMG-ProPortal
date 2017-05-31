use utf8;
package DBIC::IMG_Core::Result::TaxonNodeLite;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TaxonNodeLite

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TAXON_NODE_LITE>

=cut

__PACKAGE__->table("TAXON_NODE_LITE");

=head1 ACCESSORS

=head2 node_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 rank_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 parent

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "node_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "display_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "rank_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "parent",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</node_oid>

=back

=cut

__PACKAGE__->set_primary_key("node_oid");

=head1 RELATIONS

=head2 parent

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::TaxonNodeLite>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "DBIC::IMG_Core::Result::TaxonNodeLite",
  { node_oid => "parent" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 taxon

Type: belongs_to

Related object: L<DBIC::IMG_Core::Result::Taxon>

=cut

__PACKAGE__->belongs_to(
  "taxon",
  "DBIC::IMG_Core::Result::Taxon",
  { taxon_oid => "taxon" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 taxon_node_lites

Type: has_many

Related object: L<DBIC::IMG_Core::Result::TaxonNodeLite>

=cut

__PACKAGE__->has_many(
  "taxon_node_lites",
  "DBIC::IMG_Core::Result::TaxonNodeLite",
  { "foreign.parent" => "self.node_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XwdrzsfEK0kTE7yz+JiMGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
