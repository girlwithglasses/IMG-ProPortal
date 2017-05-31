use utf8;
package DBIC::IMG_Sat::Result::BiocycPathway;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::BiocycPathway

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOCYC_PATHWAY>

=cut

__PACKAGE__->table("BIOCYC_PATHWAY");

=head1 ACCESSORS

=head2 unique_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 common_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 net_rxn_eqn

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 credits

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "unique_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "net_rxn_eqn",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "credits",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</unique_id>

=back

=cut

__PACKAGE__->set_primary_key("unique_id");

=head1 RELATIONS

=head2 biocyc_pathway_comments

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwayComments>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_comments",
  "DBIC::IMG_Sat::Result::BiocycPathwayComments",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwayExtLinks>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_ext_links",
  "DBIC::IMG_Sat::Result::BiocycPathwayExtLinks",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_pwy_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwayPwyLinks>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_pwy_links",
  "DBIC::IMG_Sat::Result::BiocycPathwayPwyLinks",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_sub_pwys_sub_pwys

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwaySubPwys>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_sub_pwys_sub_pwys",
  "DBIC::IMG_Sat::Result::BiocycPathwaySubPwys",
  { "foreign.sub_pwys" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_sub_pwys_uniques

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwaySubPwys>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_sub_pwys_uniques",
  "DBIC::IMG_Sat::Result::BiocycPathwaySubPwys",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_super_pwys_super_pwys

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwaySuperPwys>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_super_pwys_super_pwys",
  "DBIC::IMG_Sat::Result::BiocycPathwaySuperPwys",
  { "foreign.super_pwys" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_super_pwys_uniques

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwaySuperPwys>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_super_pwys_uniques",
  "DBIC::IMG_Sat::Result::BiocycPathwaySuperPwys",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_taxon_ranges

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwayTaxonRange>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_taxon_ranges",
  "DBIC::IMG_Sat::Result::BiocycPathwayTaxonRange",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathway_types

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwayTypes>

=cut

__PACKAGE__->has_many(
  "biocyc_pathway_types",
  "DBIC::IMG_Sat::Result::BiocycPathwayTypes",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_pathways_in_species

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycPathwayInSpecies>

=cut

__PACKAGE__->has_many(
  "biocyc_pathways_in_species",
  "DBIC::IMG_Sat::Result::BiocycPathwayInSpecies",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1bfK03xxuxKIo9qibxxAKw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
