use utf8;
package DBIC::IMG_Sat::Result::KeggModule;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KeggModule

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KEGG_MODULE>

=cut

__PACKAGE__->table("KEGG_MODULE");

=head1 ACCESSORS

=head2 module_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 module_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 module_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 definition

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 pathway

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 ko_pathway_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 image_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "module_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "module_name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "module_type",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "definition",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "pathway",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "ko_pathway_id",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "image_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</module_id>

=back

=cut

__PACKAGE__->set_primary_key("module_id");

=head1 RELATIONS

=head2 kegg_module_compounds

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggModuleCompounds>

=cut

__PACKAGE__->has_many(
  "kegg_module_compounds",
  "DBIC::IMG_Sat::Result::KeggModuleCompounds",
  { "foreign.module_id" => "self.module_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_module_ko_terms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggModuleKoTerms>

=cut

__PACKAGE__->has_many(
  "kegg_module_ko_terms",
  "DBIC::IMG_Sat::Result::KeggModuleKoTerms",
  { "foreign.module_id" => "self.module_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_module_reactions

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggModuleReactions>

=cut

__PACKAGE__->has_many(
  "kegg_module_reactions",
  "DBIC::IMG_Sat::Result::KeggModuleReactions",
  { "foreign.module_id" => "self.module_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_pathway_modules

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggPathwayModules>

=cut

__PACKAGE__->has_many(
  "kegg_pathway_modules",
  "DBIC::IMG_Sat::Result::KeggPathwayModules",
  { "foreign.modules" => "self.module_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pathway

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::KeggPathway>

=cut

__PACKAGE__->belongs_to(
  "pathway",
  "DBIC::IMG_Sat::Result::KeggPathway",
  { pathway_oid => "pathway" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9hgFog40sAP3N9ljssLveA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
