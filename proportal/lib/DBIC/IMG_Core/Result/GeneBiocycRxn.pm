use utf8;
package DBIC::IMG_Core::Result::GeneBiocycRxn;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::GeneBiocycRxn

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE_BIOCYC_RXNS>

=cut

__PACKAGE__->table("GENE_BIOCYC_RXNS");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 biocyc_enzrxn

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 biocyc_rxn

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ec_number

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 common_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 assign_basis

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 taxon

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 scaffold

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "biocyc_enzrxn",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "biocyc_rxn",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ec_number",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "assign_basis",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "scaffold",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mcp8pkqiU9IHwS0zi+Zo4Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
