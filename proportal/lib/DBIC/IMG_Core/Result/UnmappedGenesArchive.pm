use utf8;
package DBIC::IMG_Core::Result::UnmappedGenesArchive;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::UnmappedGenesArchive

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<UNMAPPED_GENES_ARCHIVE>

=cut

__PACKAGE__->table("UNMAPPED_GENES_ARCHIVE");

=head1 ACCESSORS

=head2 old_gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 old_taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gene_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 start_coord

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 end_coord

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 dna_seq_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 aa_seq_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 aa_checksum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 scaffold_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 aa_residue

  data_type: 'clob'
  is_nullable: 1

=head2 img_version

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 add_date

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "old_gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "old_taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gene_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "start_coord",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "end_coord",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "dna_seq_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "aa_seq_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "aa_checksum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "scaffold_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "aa_residue",
  { data_type => "clob", is_nullable => 1 },
  "img_version",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "add_date",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</old_gene_oid>

=back

=cut

__PACKAGE__->set_primary_key("old_gene_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XFT9s6vLaz9jgkhNwSg+yA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
