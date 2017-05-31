use utf8;
package DBIC::IMG_Core::Result::Scaffold;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Scaffold

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<SCAFFOLD>

=cut

__PACKAGE__->table("SCAFFOLD");

=head1 ACCESSORS

=head2 scaffold_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 scaffold_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 255

=head2 chromosome

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mol_topology

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 mol_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 taxon

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 env_sample

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 ext_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 250

=head2 db_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_file

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 last_update

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 read_depth

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 dna_md5checksum

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 contig_id_map

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=cut

__PACKAGE__->add_columns(
  "scaffold_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "scaffold_name",
  { data_type => "varchar2", is_nullable => 0, size => 255 },
  "chromosome",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mol_topology",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "mol_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "env_sample",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "ext_accession",
  { data_type => "varchar2", is_nullable => 1, size => 250 },
  "db_source",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_file",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "last_update",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "read_depth",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "dna_md5checksum",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "contig_id_map",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
);

=head1 PRIMARY KEY

=over 4

=item * L</scaffold_oid>

=back

=cut

__PACKAGE__->set_primary_key("scaffold_oid");

=head1 RELATIONS

=head2 gene_cassette_panfolds

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneCassettePanfold>

=cut

__PACKAGE__->has_many(
  "gene_cassette_panfolds",
  "DBIC::IMG_Core::Result::GeneCassettePanfold",
  { "foreign.scaffold" => "self.scaffold_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_seed_names

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneSeedName>

=cut

__PACKAGE__->has_many(
  "gene_seed_names",
  "DBIC::IMG_Core::Result::GeneSeedName",
  { "foreign.scaffold" => "self.scaffold_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_tc_families

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneTcFamily>

=cut

__PACKAGE__->has_many(
  "gene_tc_families",
  "DBIC::IMG_Core::Result::GeneTcFamily",
  { "foreign.scaffold" => "self.scaffold_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 scaffold_intergenics

Type: has_many

Related object: L<DBIC::IMG_Core::Result::ScaffoldIntergenic>

=cut

__PACKAGE__->has_many(
  "scaffold_intergenics",
  "DBIC::IMG_Core::Result::ScaffoldIntergenic",
  { "foreign.scaffold_oid" => "self.scaffold_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 scaffold_notes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::ScaffoldNote>

=cut

__PACKAGE__->has_many(
  "scaffold_notes",
  "DBIC::IMG_Core::Result::ScaffoldNote",
  { "foreign.scaffold_oid" => "self.scaffold_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 scaffold_panfold_composition_panfold_compositions

Type: has_many

Related object: L<DBIC::IMG_Core::Result::ScaffoldPanfoldComposition>

=cut

__PACKAGE__->has_many(
  "scaffold_panfold_composition_panfold_compositions",
  "DBIC::IMG_Core::Result::ScaffoldPanfoldComposition",
  { "foreign.panfold_composition" => "self.scaffold_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 scaffold_panfold_composition_scaffold_oids

Type: has_many

Related object: L<DBIC::IMG_Core::Result::ScaffoldPanfoldComposition>

=cut

__PACKAGE__->has_many(
  "scaffold_panfold_composition_scaffold_oids",
  "DBIC::IMG_Core::Result::ScaffoldPanfoldComposition",
  { "foreign.scaffold_oid" => "self.scaffold_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ap1vW1mEQAgkZnI6lDXuvQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
