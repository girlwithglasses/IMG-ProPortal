use utf8;
package DBIC::IMG_Sat::Result::BiocycProtein;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::BiocycProtein

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOCYC_PROTEIN>

=cut

__PACKAGE__->table("BIOCYC_PROTEIN");

=head1 ACCESSORS

=head2 unique_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 100

=head2 common_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 systematic_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 func_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 biocyc_gene

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "unique_id",
  { data_type => "varchar2", is_nullable => 0, size => 100 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "systematic_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "func_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "biocyc_gene",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</unique_id>

=back

=cut

__PACKAGE__->set_primary_key("unique_id");

=head1 RELATIONS

=head2 biocyc_enzrxns

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycEnzrxn>

=cut

__PACKAGE__->has_many(
  "biocyc_enzrxns",
  "DBIC::IMG_Sat::Result::BiocycEnzrxn",
  { "foreign.biocyc_enzyme" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_protein_catalyzes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycProteinCatalyzes>

=cut

__PACKAGE__->has_many(
  "biocyc_protein_catalyzes",
  "DBIC::IMG_Sat::Result::BiocycProteinCatalyzes",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_protein_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycProteinExtLinks>

=cut

__PACKAGE__->has_many(
  "biocyc_protein_ext_links",
  "DBIC::IMG_Sat::Result::BiocycProteinExtLinks",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_protein_synonyms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycProteinSynonyms>

=cut

__PACKAGE__->has_many(
  "biocyc_protein_synonyms",
  "DBIC::IMG_Sat::Result::BiocycProteinSynonyms",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_protein_types

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycProteinTypes>

=cut

__PACKAGE__->has_many(
  "biocyc_protein_types",
  "DBIC::IMG_Sat::Result::BiocycProteinTypes",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_proteins_in_species

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycProteinInSpecies>

=cut

__PACKAGE__->has_many(
  "biocyc_proteins_in_species",
  "DBIC::IMG_Sat::Result::BiocycProteinInSpecies",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ej8JYBDYnO9FHVxSWPo3JA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
