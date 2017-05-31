use utf8;
package DBIC::IMG_Sat::Result::TcFamilyPfamsIain;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::TcFamilyPfamsIain

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TC_FAMILY_PFAMS_IAIN>

=cut

__PACKAGE__->table("TC_FAMILY_PFAMS_IAIN");

=head1 ACCESSORS

=head2 tc_family_num

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 pfam

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 tc_num

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 exceptions

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=cut

__PACKAGE__->add_columns(
  "tc_family_num",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "pfam",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "tc_num",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "exceptions",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mi2I0JWG7xy8/D6qOiIYZw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
