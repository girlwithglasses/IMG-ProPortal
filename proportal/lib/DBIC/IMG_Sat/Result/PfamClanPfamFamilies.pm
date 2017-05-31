use utf8;
package DBIC::IMG_Sat::Result::PfamClanPfamFamilies;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::PfamClanPfamFamilies

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PFAM_CLAN_PFAM_FAMILIES>

=cut

__PACKAGE__->table("PFAM_CLAN_PFAM_FAMILIES");

=head1 ACCESSORS

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 pfam_families

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "ext_accession",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "pfam_families",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/plsfBg8fcsZYlHtmt2Kfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
