use utf8;
package DBIC::IMG_Sat::Result::KeggGeneNcbiGeneIds;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KeggGeneNcbiGeneIds

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KEGG_GENE_NCBI_GENE_IDS>

=cut

__PACKAGE__->table("KEGG_GENE_NCBI_GENE_IDS");

=head1 ACCESSORS

=head2 kegg_gene_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 ncbi_gene_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 source

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "kegg_gene_id",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "ncbi_gene_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "source",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VU7yaYBCeUvkGV65/62SLw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
