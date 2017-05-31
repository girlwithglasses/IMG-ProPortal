use utf8;
package DBIC::IMG_Core::Result::TmpGeneEnzyme;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::TmpGeneEnzyme

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<TMP_GENE_ENZYMES>

=cut

__PACKAGE__->table("TMP_GENE_ENZYMES");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 enzymes

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

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
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:82jSl2UfIG20rNbPRThe6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
