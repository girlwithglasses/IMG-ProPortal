use utf8;
package DbSchema::IMG_Core::Result::GenbankRefseqCrossover;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::GenbankRefseqCrossover

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<GENBANK_REFSEQ_CROSSOVER>

=cut

__PACKAGE__->table("GENBANK_REFSEQ_CROSSOVER");

=head1 ACCESSORS

=head2 refseq_bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 genbank_bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_taxon_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 30

=head2 project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=cut

__PACKAGE__->add_columns(
  "refseq_bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "genbank_bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "display_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_taxon_id",
  { data_type => "varchar2", is_nullable => 1, size => 30 },
  "project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VjDb3+8hNDDjsDyu1SL8cg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
