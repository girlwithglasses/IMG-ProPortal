use utf8;
package DBIC::IMG_Sat::Result::CogObs;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::CogObs

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<COG_OBS>

=cut

__PACKAGE__->table("COG_OBS");

=head1 ACCESSORS

=head2 cog_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 cog_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 db_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 seq_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "cog_id",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "cog_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "db_source",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "seq_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XbtEWOxwwA2b0F9VUWx6LQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
