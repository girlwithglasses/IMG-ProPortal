use utf8;
package DBIC::IMG_Gold::Result::GoldAnalysisProjectUser;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Gold::Result::GoldAnalysisProjectUser

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GOLD_ANALYSIS_PROJECT_USERS>

=cut

__PACKAGE__->table("GOLD_ANALYSIS_PROJECT_USERS");

=head1 ACCESSORS

=head2 gold_id

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 20

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 email

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 role

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 caliban_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "gold_id",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 20 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "email",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "role",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "caliban_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);

=head1 RELATIONS

=head2 gold

Type: belongs_to

Related object: L<DBIC::IMG_Gold::Result::GoldAnalysisProject>

=cut

__PACKAGE__->belongs_to(
  "gold",
  "DBIC::IMG_Gold::Result::GoldAnalysisProject",
  { gold_id => "gold_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:03:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9l4fDWnwkPhCOP1u0tNl/w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
