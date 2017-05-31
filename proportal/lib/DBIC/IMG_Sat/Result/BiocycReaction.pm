use utf8;
package DBIC::IMG_Sat::Result::BiocycReaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::BiocycReaction

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIOCYC_REACTION>

=cut

__PACKAGE__->table("BIOCYC_REACTION");

=head1 ACCESSORS

=head2 unique_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 common_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 balance_state

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ec_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 is_official_ec

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 is_orphan

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 is_spontaneous

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=cut

__PACKAGE__->add_columns(
  "unique_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "balance_state",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ec_number",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "is_official_ec",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "is_orphan",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
  "is_spontaneous",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
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

=head2 biocyc_reaction_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReactionExtLinks>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_ext_links",
  "DBIC::IMG_Sat::Result::BiocycReactionExtLinks",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_reaction_left_hands

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReactionLeftHand>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_left_hands",
  "DBIC::IMG_Sat::Result::BiocycReactionLeftHand",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_reaction_right_hands

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReactionRightHand>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_right_hands",
  "DBIC::IMG_Sat::Result::BiocycReactionRightHand",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_reaction_synonyms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReactionSynonyms>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_synonyms",
  "DBIC::IMG_Sat::Result::BiocycReactionSynonyms",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_reaction_types

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReactionTypes>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_types",
  "DBIC::IMG_Sat::Result::BiocycReactionTypes",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_reactions_in_pwys

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReactionInPwys>

=cut

__PACKAGE__->has_many(
  "biocyc_reactions_in_pwys",
  "DBIC::IMG_Sat::Result::BiocycReactionInPwys",
  { "foreign.unique_id" => "self.unique_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:43:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CTdbm+a20pakYBApNJzbTQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
