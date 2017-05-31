use utf8;
package DBIC::IMG_Core::Result::AltTranscript;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::AltTranscript

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<ALT_TRANSCRIPT>

=cut

__PACKAGE__->table("ALT_TRANSCRIPT");

=head1 ACCESSORS

=head2 alt_transcript_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 gene

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 name

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

=head2 strand

  data_type: 'char'
  is_nullable: 1
  size: 1

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

=head2 aa_residue

  data_type: 'clob'
  is_nullable: 1

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 is_pseudogene

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "alt_transcript_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gene",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "name",
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
  "strand",
  { data_type => "char", is_nullable => 1, size => 1 },
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
  "aa_residue",
  { data_type => "clob", is_nullable => 1 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "ext_accession",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "is_pseudogene",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
);

=head1 PRIMARY KEY

=over 4

=item * L</alt_transcript_oid>

=back

=cut

__PACKAGE__->set_primary_key("alt_transcript_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wZL8/cXQFgT/UeIFBPbxPA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
