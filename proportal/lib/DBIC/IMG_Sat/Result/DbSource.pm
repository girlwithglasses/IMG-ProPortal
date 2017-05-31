use utf8;
package DBIC::IMG_Sat::Result::DbSource;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::DbSource

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DB_SOURCE>

=cut

__PACKAGE__->table("DB_SOURCE");

=head1 ACCESSORS

=head2 db_code

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 base_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "db_code",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "base_url",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</db_code>

=back

=cut

__PACKAGE__->set_primary_key("db_code");

=head1 RELATIONS

=head2 cogs

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::Cog>

=cut

__PACKAGE__->has_many(
  "cogs",
  "DBIC::IMG_Sat::Result::Cog",
  { "foreign.db_source" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 compound_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::CompoundExtLinks>

=cut

__PACKAGE__->has_many(
  "compound_ext_links",
  "DBIC::IMG_Sat::Result::CompoundExtLinks",
  { "foreign.db_name" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 compounds

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::Compound>

=cut

__PACKAGE__->has_many(
  "compounds",
  "DBIC::IMG_Sat::Result::Compound",
  { "foreign.db_source" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 enzyme_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::EnzymeExtLinks>

=cut

__PACKAGE__->has_many(
  "enzyme_ext_links",
  "DBIC::IMG_Sat::Result::EnzymeExtLinks",
  { "foreign.db_name" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 go_terms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::GoTerm>

=cut

__PACKAGE__->has_many(
  "go_terms",
  "DBIC::IMG_Sat::Result::GoTerm",
  { "foreign.db_source" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_pathways

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggPathway>

=cut

__PACKAGE__->has_many(
  "kegg_pathways",
  "DBIC::IMG_Sat::Result::KeggPathway",
  { "foreign.db_source" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kogs

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::Kog>

=cut

__PACKAGE__->has_many(
  "kogs",
  "DBIC::IMG_Sat::Result::Kog",
  { "foreign.db_source" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pfam_family_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::PfamFamilyExtLinks>

=cut

__PACKAGE__->has_many(
  "pfam_family_ext_links",
  "DBIC::IMG_Sat::Result::PfamFamilyExtLinks",
  { "foreign.db_name" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pfam_family_v28s

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::PfamFamilyV28>

=cut

__PACKAGE__->has_many(
  "pfam_family_v28s",
  "DBIC::IMG_Sat::Result::PfamFamilyV28",
  { "foreign.db_source" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reaction_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ReactionExtLinks>

=cut

__PACKAGE__->has_many(
  "reaction_ext_links",
  "DBIC::IMG_Sat::Result::ReactionExtLinks",
  { "foreign.db_name" => "self.db_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:P/uIk9mn610l2iX2f/gHXA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
