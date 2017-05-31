use utf8;
package DBIC::IMG_Core::Result::TmpTaxonPfam;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TmpTaxonPfam

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TMP_TAXON_PFAM>

=cut

__PACKAGE__->table("TMP_TAXON_PFAM");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 2100

=head2 pfam_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "phylum",
  { data_type => "varchar2", is_nullable => 1, size => 2100 },
  "pfam_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F/Ktl8QlzZaA2mp6+lzIRQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
