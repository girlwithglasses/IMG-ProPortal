use utf8;
package DbSchema::IMG_Core::Result::CvnaturalProds;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::CvnaturalProds

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<CVNATURAL_PRODS>

=cut

__PACKAGE__->table("CVNATURAL_PRODS");

=head1 ACCESSORS

=head2 np_id

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: 126

=head2 np_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_product_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 np_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 np_activity

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 img_compound_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "np_id",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => 126,
  },
  "np_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_product_link",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "np_type",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "np_activity",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "img_compound_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</np_id>

=back

=cut

__PACKAGE__->set_primary_key("np_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dipvHYqjJwbOUoPrw1t+XA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
