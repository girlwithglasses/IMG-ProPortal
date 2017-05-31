use utf8;
package DBIC::IMG_Sat::Result::KmImageRoi;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KmImageRoi

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KM_IMAGE_ROI>

=cut

__PACKAGE__->table("KM_IMAGE_ROI");

=head1 ACCESSORS

=head2 roi_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 shape

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 roi_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 roi_label

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 x_coord

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 y_coord

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 height

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 width

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 coord_string

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 kegg_module

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "roi_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "shape",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "roi_type",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "roi_label",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "x_coord",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "y_coord",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "height",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "width",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "coord_string",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "kegg_module",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XQHdG0/EP+EIhUGloNi8+w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
