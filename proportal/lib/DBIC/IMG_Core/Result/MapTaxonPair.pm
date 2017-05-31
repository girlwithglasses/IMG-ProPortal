use utf8;
package DBIC::IMG_Core::Result::MapTaxonPair;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::MapTaxonPair

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MAP_TAXON_PAIRS>

=cut

__PACKAGE__->table("MAP_TAXON_PAIRS");

=head1 ACCESSORS

=head2 new_taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 old_taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "new_taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "old_taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jB6efft1LKozHvtM1JLAoQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
