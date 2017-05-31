use utf8;
package DBIC::IMG_Core::Result::TaxonGenePrefix;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TaxonGenePrefix

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TAXON_GENE_PREFIX>

=cut

__PACKAGE__->table("TAXON_GENE_PREFIX");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 id_prefix

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 data_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "id_prefix",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "data_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:i3GdgC4swrl4+L9Dtl6bRg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
