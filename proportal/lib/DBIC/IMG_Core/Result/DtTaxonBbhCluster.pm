use utf8;
package DBIC::IMG_Core::Result::DtTaxonBbhCluster;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::DtTaxonBbhCluster

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<DT_TAXON_BBH_CLUSTER>

=cut

__PACKAGE__->table("DT_TAXON_BBH_CLUSTER");

=head1 ACCESSORS

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 cluster_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 cluster_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "cluster_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "cluster_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pNv0XK9/Mc9fMvfW4BOdEQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
