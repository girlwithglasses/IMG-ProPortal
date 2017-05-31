use utf8;
package DBIC::IMG_Sat::Result::PfamFamilyCogs;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::PfamFamilyCogs

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PFAM_FAMILY_COGS>

=cut

__PACKAGE__->table("PFAM_FAMILY_COGS");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 cog

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 functions

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "cog",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "functions",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 10 },
);

=head1 RELATIONS

=head2 function

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::CogFunction>

=cut

__PACKAGE__->belongs_to(
  "function",
  "DBIC::IMG_Sat::Result::CogFunction",
  { function_code => "functions" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:xP+ry3owd5kQbBXnF4DgUA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
