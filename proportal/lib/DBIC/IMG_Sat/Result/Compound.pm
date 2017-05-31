use utf8;
package DBIC::IMG_Sat::Result::Compound;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Compound

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COMPOUND>

=cut

__PACKAGE__->table("COMPOUND");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 db_source

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 compound_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 common_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 formula

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 parent

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 50

=head2 status

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mol_weight

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [22,10]

=head2 num_atoms

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [22,0]

=head2 smiles

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 inchi

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 inchi_key

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "db_source",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "compound_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "formula",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "parent",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 50 },
  "status",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mol_weight",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [22, 10],
  },
  "num_atoms",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [22, 0],
  },
  "smiles",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "inchi",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "inchi_key",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ext_accession>

=back

=cut

__PACKAGE__->set_primary_key("ext_accession");

=head1 RELATIONS

=head2 compound_aliases

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::CompoundAliases>

=cut

__PACKAGE__->has_many(
  "compound_aliases",
  "DBIC::IMG_Sat::Result::CompoundAliases",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 compound_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::CompoundExtLinks>

=cut

__PACKAGE__->has_many(
  "compound_ext_links",
  "DBIC::IMG_Sat::Result::CompoundExtLinks",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 compounds

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::Compound>

=cut

__PACKAGE__->has_many(
  "compounds",
  "DBIC::IMG_Sat::Result::Compound",
  { "foreign.parent" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 enzyme_products

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::EnzymeProducts>

=cut

__PACKAGE__->has_many(
  "enzyme_products",
  "DBIC::IMG_Sat::Result::EnzymeProducts",
  { "foreign.products" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 enzyme_substrates

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::EnzymeSubstrates>

=cut

__PACKAGE__->has_many(
  "enzyme_substrates",
  "DBIC::IMG_Sat::Result::EnzymeSubstrates",
  { "foreign.substrates" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 image_roi_compounds

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ImageRoiCompounds>

=cut

__PACKAGE__->has_many(
  "image_roi_compounds",
  "DBIC::IMG_Sat::Result::ImageRoiCompounds",
  { "foreign.compounds" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_module_compounds

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggModuleCompounds>

=cut

__PACKAGE__->has_many(
  "kegg_module_compounds",
  "DBIC::IMG_Sat::Result::KeggModuleCompounds",
  { "foreign.compounds" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Compound>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "DBIC::IMG_Sat::Result::Compound",
  { ext_accession => "parent" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 reaction_compounds

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ReactionCompounds>

=cut

__PACKAGE__->has_many(
  "reaction_compounds",
  "DBIC::IMG_Sat::Result::ReactionCompounds",
  { "foreign.compounds" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:43:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eqnKQzpWDrWSVPDJnPrUHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
