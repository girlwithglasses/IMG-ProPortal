use utf8;
package DBIC::IMG_Sat::Result::EnzymeProducts;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::EnzymeProducts

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ENZYME_PRODUCTS>

=cut

__PACKAGE__->table("ENZYME_PRODUCTS");

=head1 ACCESSORS

=head2 ec_number

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 0
  size: 30

=head2 products

  data_type: 'varchar2'
  is_foreign_key: 1
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "ec_number",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 0, size => 30 },
  "products",
  { data_type => "varchar2", is_foreign_key => 1, is_nullable => 1, size => 50 },
);

=head1 RELATIONS

=head2 ec_number

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Enzyme>

=cut

__PACKAGE__->belongs_to(
  "ec_number",
  "DBIC::IMG_Sat::Result::Enzyme",
  { ec_number => "ec_number" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 product

Type: belongs_to

Related object: L<DBIC::IMG_Sat::Result::Compound>

=cut

__PACKAGE__->belongs_to(
  "product",
  "DBIC::IMG_Sat::Result::Compound",
  { ext_accession => "products" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OfPRngVe/CAF7Gik/5pZfQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
