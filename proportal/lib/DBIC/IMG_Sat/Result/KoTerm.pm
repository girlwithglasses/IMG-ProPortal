use utf8;
package DBIC::IMG_Sat::Result::KoTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KoTerm

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KO_TERM>

=cut

__PACKAGE__->table("KO_TERM");

=head1 ACCESSORS

=head2 ko_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 ko_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 definition

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "ko_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "ko_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "definition",
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

=item * L</ko_id>

=back

=cut

__PACKAGE__->set_primary_key("ko_id");

=head1 RELATIONS

=head2 image_roi_ko_terms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::ImageRoiKoTerms>

=cut

__PACKAGE__->has_many(
  "image_roi_ko_terms",
  "DBIC::IMG_Sat::Result::ImageRoiKoTerms",
  { "foreign.ko_terms" => "self.ko_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 kegg_module_ko_terms

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KeggModuleKoTerms>

=cut

__PACKAGE__->has_many(
  "kegg_module_ko_terms",
  "DBIC::IMG_Sat::Result::KeggModuleKoTerms",
  { "foreign.ko_terms" => "self.ko_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ko_term_classes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KoTermClasses>

=cut

__PACKAGE__->has_many(
  "ko_term_classes",
  "DBIC::IMG_Sat::Result::KoTermClasses",
  { "foreign.ko_id" => "self.ko_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ko_term_cogs

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KoTermCogs>

=cut

__PACKAGE__->has_many(
  "ko_term_cogs",
  "DBIC::IMG_Sat::Result::KoTermCogs",
  { "foreign.ko_id" => "self.ko_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ko_term_enzymes

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KoTermEnzymes>

=cut

__PACKAGE__->has_many(
  "ko_term_enzymes",
  "DBIC::IMG_Sat::Result::KoTermEnzymes",
  { "foreign.ko_id" => "self.ko_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ko_term_go_ids

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KoTermGoIds>

=cut

__PACKAGE__->has_many(
  "ko_term_go_ids",
  "DBIC::IMG_Sat::Result::KoTermGoIds",
  { "foreign.ko_id" => "self.ko_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ko_term_reactions

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::KoTermReactions>

=cut

__PACKAGE__->has_many(
  "ko_term_reactions",
  "DBIC::IMG_Sat::Result::KoTermReactions",
  { "foreign.ko_id" => "self.ko_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iaDxn8+CrJRcSrlC/0nDsA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
