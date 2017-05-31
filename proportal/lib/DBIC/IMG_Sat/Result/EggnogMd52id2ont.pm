use utf8;
package DBIC::IMG_Sat::Result::EggnogMd52id2ont;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::EggnogMd52id2ont

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<EGGNOG_MD52ID2ONT>

=cut

__PACKAGE__->table("EGGNOG_MD52ID2ONT");

=head1 ACCESSORS

=head2 md5_signature

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 nog_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 level_2

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "md5_signature",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "nog_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "level_2",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DuRkqdfgN3hwGiT8+SukCw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
