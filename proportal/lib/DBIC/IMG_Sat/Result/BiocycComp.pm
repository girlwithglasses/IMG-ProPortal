use utf8;
package DBIC::IMG_Sat::Result::BiocycComp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::BiocycComp

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOCYC_COMP>

=cut

__PACKAGE__->table("BIOCYC_COMP");

=head1 ACCESSORS

=head2 unique_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

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

=head2 mol_wt

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,4]

=head2 smiles

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 db_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 formula

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 inch_i_key

  data_type: 'clob'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "unique_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "systematic_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "mol_wt",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 4],
  },
  "smiles",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "db_source",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "formula",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "inch_i_key",
  { data_type => "clob", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</unique_id>

=back

=cut

__PACKAGE__->set_primary_key("unique_id");

=head1 RELATIONS

=head2 biocyc_comp_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycCompExtLinks>

=cut

__PACKAGE__->has_many(
  "biocyc_comp_ext_links",
  "DBIC::IMG_Sat::Result::BiocycCompExtLinks",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_comp_synonyms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycCompSynonyms>

=cut

__PACKAGE__->has_many(
  "biocyc_comp_synonyms",
  "DBIC::IMG_Sat::Result::BiocycCompSynonyms",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_comp_types

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycCompTypes>

=cut

__PACKAGE__->has_many(
  "biocyc_comp_types",
  "DBIC::IMG_Sat::Result::BiocycCompTypes",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZokYSHfkiVQ8sEunbvE1XA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
