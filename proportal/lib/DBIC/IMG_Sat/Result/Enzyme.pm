use utf8;
package DBIC::IMG_Sat::Result::Enzyme;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Enzyme

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENZYME>

=cut

__PACKAGE__->table("ENZYME");

=head1 ACCESSORS

=head2 ec_number

  data_type: 'varchar2'
  is_nullable: 0
  size: 30

=head2 enzyme_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 systematic_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 parent_class

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 30

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 rxn_desc

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 cas_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "ec_number",
  { data_type => "varchar2", is_nullable => 0, size => 30 },
  "enzyme_name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "systematic_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "parent_class",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 30 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "rxn_desc",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "cas_number",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ec_number>

=back

=cut

__PACKAGE__->set_primary_key("ec_number");

=head1 RELATIONS

=head2 enzyme_enz_aliases

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::EnzymeEnzAliases>

=cut

__PACKAGE__->has_many(
  "enzyme_enz_aliases",
  "DBIC::IMG_Sat::Result::EnzymeEnzAliases",
  { "foreign.ec_number" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 enzyme_ext_links

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::EnzymeExtLinks>

=cut

__PACKAGE__->has_many(
  "enzyme_ext_links",
  "DBIC::IMG_Sat::Result::EnzymeExtLinks",
  { "foreign.ec_number" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 enzyme_products

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::EnzymeProducts>

=cut

__PACKAGE__->has_many(
  "enzyme_products",
  "DBIC::IMG_Sat::Result::EnzymeProducts",
  { "foreign.ec_number" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 enzyme_substrates

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::EnzymeSubstrates>

=cut

__PACKAGE__->has_many(
  "enzyme_substrates",
  "DBIC::IMG_Sat::Result::EnzymeSubstrates",
  { "foreign.ec_number" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::Enzyme>

=cut

__PACKAGE__->has_many(
  "enzymes",
  "DBIC::IMG_Sat::Result::Enzyme",
  { "foreign.parent_class" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 image_roi_enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ImageRoiEnzymes>

=cut

__PACKAGE__->has_many(
  "image_roi_enzymes",
  "DBIC::IMG_Sat::Result::ImageRoiEnzymes",
  { "foreign.enzymes" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ko_term_enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KoTermEnzymes>

=cut

__PACKAGE__->has_many(
  "ko_term_enzymes",
  "DBIC::IMG_Sat::Result::KoTermEnzymes",
  { "foreign.enzymes" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent_class

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Enzyme>

=cut

__PACKAGE__->belongs_to(
  "parent_class",
  "DBIC::IMG_Sat::Result::Enzyme",
  { ec_number => "parent_class" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 reaction_enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ReactionEnzymes>

=cut

__PACKAGE__->has_many(
  "reaction_enzymes",
  "DBIC::IMG_Sat::Result::ReactionEnzymes",
  { "foreign.enzymes" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 tigrfam_enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::TigrfamEnzymes>

=cut

__PACKAGE__->has_many(
  "tigrfam_enzymes",
  "DBIC::IMG_Sat::Result::TigrfamEnzymes",
  { "foreign.enzymes" => "self.ec_number" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qtp4xIcFiHJW1Bu8gi8HSg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
