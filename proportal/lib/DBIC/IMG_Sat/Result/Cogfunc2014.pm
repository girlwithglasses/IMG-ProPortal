use utf8;
package DBIC::IMG_Sat::Result::Cogfunc2014;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::Cogfunc2014

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COGFUNC2014>

=cut

__PACKAGE__->table("COGFUNC2014");

=head1 ACCESSORS

=head2 code

  data_type: 'char'
  is_nullable: 1
  size: 1

=head2 name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "code",
  { data_type => "char", is_nullable => 1, size => 1 },
  "name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cneKmL23VDDp4gRrGVU3yg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
