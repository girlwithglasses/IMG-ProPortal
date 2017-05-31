use utf8;
package DBIC::IMG_Core::Result::ImgAccCount;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ImgAccCount

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<IMG_ACC_COUNTS>

=cut

__PACKAGE__->table("IMG_ACC_COUNTS");

=head1 ACCESSORS

=head2 taxon

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 submission_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 accessions_#_in_img

  accessor: 'accessions___in_img'
  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "submission_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "accessions_#_in_img",
  {
    accessor    => "accessions___in_img",
    data_type   => "numeric",
    is_nullable => 1,
    original    => { data_type => "number" },
    size        => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8NYitNwrtNoomglVIg3aNg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
