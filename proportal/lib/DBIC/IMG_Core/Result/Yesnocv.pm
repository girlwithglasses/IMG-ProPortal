use utf8;
package DBIC::IMG_Core::Result::Yesnocv;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Yesnocv

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<YESNOCV>

=cut

__PACKAGE__->table("YESNOCV");

=head1 ACCESSORS

=head2 flag_cv

  data_type: 'varchar2'
  is_nullable: 0
  size: 10

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "flag_cv",
  { data_type => "varchar2", is_nullable => 0, size => 10 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</flag_cv>

=back

=cut

__PACKAGE__->set_primary_key("flag_cv");

=head1 RELATIONS

=head2 gene_essential_genes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneEssentialGene>

=cut

__PACKAGE__->has_many(
  "gene_essential_genes",
  "DBIC::IMG_Core::Result::GeneEssentialGene",
  { "foreign.essentiality" => "self.flag_cv" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 rna_clusters

Type: has_many

Related object: L<DBIC::IMG_Core::Result::RnaCluster>

=cut

__PACKAGE__->has_many(
  "rna_clusters",
  "DBIC::IMG_Core::Result::RnaCluster",
  { "foreign.obsolete_flag" => "self.flag_cv" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e/Kc+diA0SgIQaqTM6zuYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
