use utf8;
package DBIC::IMG_Sat::Result::CogFunctionObs;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CogFunctionObs

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG_FUNCTION_OBS>

=cut

__PACKAGE__->table("COG_FUNCTION_OBS");

=head1 ACCESSORS

=head2 function_code

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 definition

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 function_group

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "function_code",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "definition",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "function_group",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:szE5hmBQq2xbSuqzXerV4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
