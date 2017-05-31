use utf8;
package DBIC::IMG_Sat::Result::EnzymeEnzAliases;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::EnzymeEnzAliases

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENZYME_ENZ_ALIASES>

=cut

__PACKAGE__->table("ENZYME_ENZ_ALIASES");

=head1 ACCESSORS

=head2 ec_number

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 30

=head2 enz_aliases

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "ec_number",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 30 },
  "enz_aliases",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 RELATIONS

=head2 ec_number

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Enzyme>

=cut

__PACKAGE__->belongs_to(
  "ec_number",
  "DBIC::IMG_Sat::Result::Enzyme",
  { ec_number => "ec_number" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5jNft39NiQSZtSGxyODKGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
