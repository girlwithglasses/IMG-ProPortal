use utf8;
package DBIC::IMG_Sat::Result::ImageRoi;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::ImageRoi

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<IMAGE_ROI>

=cut

__PACKAGE__->table("IMAGE_ROI");

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

=head2 pathway

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 related_pathway

  data_type: 'numeric'
  is_foreign_key: 1
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 coord_string

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

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
  "pathway",
  {
    data_type => "numeric",
    is_foreign_key => 1,
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
  "related_pathway",
  {
    data_type => "numeric",
    is_foreign_key => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "coord_string",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</roi_id>

=back

=cut

__PACKAGE__->set_primary_key("roi_id");

=head1 RELATIONS

=head2 pathway

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::KeggPathway>

=cut

__PACKAGE__->belongs_to(
  "pathway",
  "DBIC::IMG_Sat::Result::KeggPathway",
  { pathway_oid => "pathway" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 related_pathway

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::KeggPathway>

=cut

__PACKAGE__->belongs_to(
  "related_pathway",
  "DBIC::IMG_Sat::Result::KeggPathway",
  { pathway_oid => "related_pathway" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TsNkaTNC6EDR3a7k5DzxPQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
