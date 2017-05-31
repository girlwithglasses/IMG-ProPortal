use utf8;
package DBIC::IMG_Sat::Result::MpwPglTaxonomy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::MpwPglTaxonomy

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<MPW_PGL_TAXONOMY>

=cut

__PACKAGE__->table("MPW_PGL_TAXONOMY");

=head1 ACCESSORS

=head2 path_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "path_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:TbzU4BBYMLUFGdKoNW/2zw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
