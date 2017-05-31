use utf8;
package DBIC::IMG_Sat::Result::Reaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Reaction

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<REACTION>

=cut

__PACKAGE__->table("REACTION");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 rxn_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 rxn_definition

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 rxn_equation

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "rxn_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "rxn_definition",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "rxn_equation",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ext_accession>

=back

=cut

__PACKAGE__->set_primary_key("ext_accession");

=head1 RELATIONS

=head2 image_roi_reactions

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ImageRoiReactions>

=cut

__PACKAGE__->has_many(
  "image_roi_reactions",
  "DBIC::IMG_Sat::Result::ImageRoiReactions",
  { "foreign.reactions" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_module_reactions

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggModuleReactions>

=cut

__PACKAGE__->has_many(
  "kegg_module_reactions",
  "DBIC::IMG_Sat::Result::KeggModuleReactions",
  { "foreign.reactions" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ko_term_reactions

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KoTermReactions>

=cut

__PACKAGE__->has_many(
  "ko_term_reactions",
  "DBIC::IMG_Sat::Result::KoTermReactions",
  { "foreign.reactions" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reaction_compounds

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ReactionCompounds>

=cut

__PACKAGE__->has_many(
  "reaction_compounds",
  "DBIC::IMG_Sat::Result::ReactionCompounds",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reaction_enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ReactionEnzymes>

=cut

__PACKAGE__->has_many(
  "reaction_enzymes",
  "DBIC::IMG_Sat::Result::ReactionEnzymes",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reaction_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ReactionExtLinks>

=cut

__PACKAGE__->has_many(
  "reaction_ext_links",
  "DBIC::IMG_Sat::Result::ReactionExtLinks",
  { "foreign.ext_accession" => "self.ext_accession" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:03BZY2zoEnSQ4K/JsMpS1A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
