use utf8;
package DBIC::IMG_Core::Result::ParalogGroupGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::ParalogGroupGene

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<PARALOG_GROUP_GENES>

=cut

__PACKAGE__->table("PARALOG_GROUP_GENES");

=head1 ACCESSORS

=head2 group_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [20,0]

=head2 genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "group_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [20, 0],
  },
  "genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ajbZnIVfUb1C8XWlcQpGQg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
