use utf8;
package DBIC::IMG_Core::Result::DtTaxonKmoduleMcr;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtTaxonKmoduleMcr

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_TAXON_KMODULE_MCR>

=cut

__PACKAGE__->table("DT_TAXON_KMODULE_MCR");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 module_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 mcr

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "module_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "mcr",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R6Wz2lzKnlyfaNWLo7DePw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
