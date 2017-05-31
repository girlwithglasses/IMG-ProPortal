use utf8;
package DBIC::IMG_Sat::Result::CompoundExtLinks;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CompoundExtLinks

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COMPOUND_EXT_LINKS>

=cut

__PACKAGE__->table("COMPOUND_EXT_LINKS");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 50

=head2 db_name

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 255

=head2 id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 50 },
  "db_name",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 255 },
  "id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 RELATIONS

=head2 ext_accession

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Compound>

=cut

__PACKAGE__->belongs_to(
  "ext_accession",
  "DBIC::IMG_Sat::Result::Compound",
  { ext_accession => "ext_accession" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:43:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rvn+DgfaDImMO8fQK04XzA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
