use utf8;
package DBIC::IMG_Sat::Result::Cog2014;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Cog2014

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG2014>

=cut

__PACKAGE__->table("COG2014");

=head1 ACCESSORS

=head2 cog

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 func

  data_type: 'varchar2'
  is_nullable: 1
  size: 5

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "cog",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "func",
  { data_type => "varchar2", is_nullable => 1, size => 5 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EjV2/q1jMzSrbDPNestOfQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
