use utf8;
package DBIC::IMG_Core::Result::TempGeneName;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TempGeneName

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TEMP_GENE_NAMES>

=cut

__PACKAGE__->table("TEMP_GENE_NAMES");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gene_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 img_product_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 modified_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gene_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "img_product_source",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "modified_by",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KrwcelH2NKCyADEKsvKPxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
