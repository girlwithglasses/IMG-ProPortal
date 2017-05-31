use utf8;
package DBIC::IMG_Sat::Result::BiocycEnzrxn;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::BiocycEnzrxn

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOCYC_ENZRXN>

=cut

__PACKAGE__->table("BIOCYC_ENZRXN");

=head1 ACCESSORS

=head2 unique_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 biocyc_enzyme

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 100

=head2 common_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 assign_basis

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 reaction

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 rxn_direction

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=cut

__PACKAGE__->add_columns(
  "unique_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "biocyc_enzyme",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 100 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "assign_basis",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "reaction",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "rxn_direction",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</unique_id>

=back

=cut

__PACKAGE__->set_primary_key("unique_id");

=head1 RELATIONS

=head2 biocyc_enzrxn_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycEnzrxnExtLinks>

=cut

__PACKAGE__->has_many(
  "biocyc_enzrxn_ext_links",
  "DBIC::IMG_Sat::Result::BiocycEnzrxnExtLinks",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_enzrxn_prosth_groups

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycEnzrxnProsthGroups>

=cut

__PACKAGE__->has_many(
  "biocyc_enzrxn_prosth_groups",
  "DBIC::IMG_Sat::Result::BiocycEnzrxnProsthGroups",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_enzrxn_synonyms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycEnzrxnSynonyms>

=cut

__PACKAGE__->has_many(
  "biocyc_enzrxn_synonyms",
  "DBIC::IMG_Sat::Result::BiocycEnzrxnSynonyms",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_enzyme

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::BiocycProtein>

=cut

__PACKAGE__->belongs_to(
  "biocyc_enzyme",
  "DBIC::IMG_Sat::Result::BiocycProtein",
  { unique_id => "biocyc_enzyme" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 biocyc_protein_catalyzes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycProteinCatalyzes>

=cut

__PACKAGE__->has_many(
  "biocyc_protein_catalyzes",
  "DBIC::IMG_Sat::Result::BiocycProteinCatalyzes",
  { "foreign.enzrxn" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RonluJebAW/WbxFsts7HbA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
