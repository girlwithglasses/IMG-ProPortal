use utf8;
package DBIC::IMG_Sat::Result::KeggGene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Sat::Result::KeggGene

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<KEGG_GENE>

=cut

__PACKAGE__->table("KEGG_GENE");

=head1 ACCESSORS

=head2 kegg_gene_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 aa_seq_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=cut

__PACKAGE__->add_columns(
  "kegg_gene_id",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "aa_seq_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</kegg_gene_id>

=back

=cut

__PACKAGE__->set_primary_key("kegg_gene_id");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-10 22:41:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zZT7Bhj3jkUuAqXyBiDuJA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
