use utf8;
package DBIC::IMG_Core::Result::GeneEnzyme;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneEnzyme

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_ENZYMES>

=cut

__PACKAGE__->table("GENE_ENZYMES");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 enzymes

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 img_ec_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 ec_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "enzymes",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "img_ec_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "ec_source",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RyU7iQy/MYaPl5wtSXU8fw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
