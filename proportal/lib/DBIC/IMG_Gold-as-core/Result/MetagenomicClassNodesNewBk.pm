use utf8;
package DbSchema::IMG_Core::Result::MetagenomicClassNodesNewBk;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::MetagenomicClassNodesNewBk

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<METAGENOMIC_CLASS_NODES_NEW_BK>

=cut

__PACKAGE__->table("METAGENOMIC_CLASS_NODES_NEW_BK");

=head1 ACCESSORS

=head2 mc_node_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 node

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 node_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "mc_node_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "node",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "node_type",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PQER235qyUc5vF2L0rr+pg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
