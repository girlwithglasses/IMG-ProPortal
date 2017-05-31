use utf8;
package DBIC::IMG_Sat::Result::TcFamily;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::TcFamily

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TC_FAMILY>

=cut

__PACKAGE__->table("TC_FAMILY");

=head1 ACCESSORS

=head2 tc_family_num

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 tc_family_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "tc_family_num",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "tc_family_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</tc_family_num>

=back

=cut

__PACKAGE__->set_primary_key("tc_family_num");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AMfexVUT8WJ4pdV6B6o7oA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
