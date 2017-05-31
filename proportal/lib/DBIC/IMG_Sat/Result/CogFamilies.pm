use utf8;
package DBIC::IMG_Sat::Result::CogFamilies;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CogFamilies

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG_FAMILIES>

=cut

__PACKAGE__->table("COG_FAMILIES");

=head1 ACCESSORS

=head2 cog_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 20

=head2 families

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "cog_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 20 },
  "families",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);

=head1 RELATIONS

=head2 cog

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Cog>

=cut

__PACKAGE__->belongs_to(
  "cog",
  "DBIC::IMG_Sat::Result::Cog",
  { cog_id => "cog_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JtrhKwyJtBZSTC5Emicnww


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
