use utf8;
package DBIC::IMG_Sat::Result::CogFunctions;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CogFunctions

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG_FUNCTIONS>

=cut

__PACKAGE__->table("COG_FUNCTIONS");

=head1 ACCESSORS

=head2 cog_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 functions

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "cog_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "functions",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FRTU8ym9nmZny/TvzuRq/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
