use utf8;
package DBIC::IMG_Sat::Result::Yesnocv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Yesnocv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<YESNOCV>

=cut

__PACKAGE__->table("YESNOCV");

=head1 ACCESSORS

=head2 flag_cv

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "flag_cv",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</flag_cv>

=back

=cut

__PACKAGE__->set_primary_key("flag_cv");

=head1 RELATIONS

=head2 biocyc_reaction_is_official_ecs

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReaction>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_is_official_ecs",
  "DBIC::IMG_Sat::Result::BiocycReaction",
  { "foreign.is_official_ec" => "self.flag_cv" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_reaction_is_orphans

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReaction>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_is_orphans",
  "DBIC::IMG_Sat::Result::BiocycReaction",
  { "foreign.is_orphan" => "self.flag_cv" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 biocyc_reaction_is_spontaneouses

Type: has_many

Related object: L<DBIC::IMG_Sat::Result::BiocycReaction>

=cut

__PACKAGE__->has_many(
  "biocyc_reaction_is_spontaneouses",
  "DBIC::IMG_Sat::Result::BiocycReaction",
  { "foreign.is_spontaneous" => "self.flag_cv" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PhfwSeVuNCmDvFk9kPAdoQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
