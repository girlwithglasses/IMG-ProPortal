use utf8;
package DBIC::IMG_Sat::Result::DtKoEcCogPfam;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::DtKoEcCogPfam

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_KO_EC_COG_PFAM>

=cut

__PACKAGE__->table("DT_KO_EC_COG_PFAM");

=head1 ACCESSORS

=head2 ko_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 ec

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 cog

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 pfam

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "ko_id",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "ec",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "cog",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "pfam",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5qNewImPhtmOVGMwPDH9Kw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
