use utf8;
package DBIC::IMG_Sat::Result::TcFamilyPfams;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::TcFamilyPfams

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TC_FAMILY_PFAMS>

=cut

__PACKAGE__->table("TC_FAMILY_PFAMS");

=head1 ACCESSORS

=head2 tc_family_num

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 tc_num

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 pfam

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "tc_family_num",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "tc_num",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "pfam",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cXCKSmnXO0LZt6kVWBqBiQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
