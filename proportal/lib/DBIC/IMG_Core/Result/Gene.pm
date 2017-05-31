use utf8;
package DBIC::IMG_Core::Result::Gene;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::Gene

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<GENE>

=cut

__PACKAGE__->table("GENE");

=head1 ACCESSORS

=head2 gene_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 gene_symbol

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 gene_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 locus_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 scaffold

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 chromosome

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

=head2 is_partial_w

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 start_coord_w

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 end_coord_w

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

=head2 is_pseudogene

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 description

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 protein_seq_accid

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 taxon

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 img_orf_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 img_orf_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 img_mod_desc

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 obsolete_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 aa_residue

  data_type: 'clob'
  is_nullable: 1

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 auto_translation

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_pending

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 img_product_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 dt_protein_seq_accid_lc

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 dt_gene_symbol_lc

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 dt_locus_tag_lc

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cds_frag_coord

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 is_proxygene

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 is_low_quality

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 partial_gene

  data_type: 'char'
  is_nullable: 1
  size: 2

=head2 copy_number

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 est_copy

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gc_percent

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 codon_start

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=cut

__PACKAGE__->add_columns(
  "gene_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gene_symbol",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "gene_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "product_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "locus_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "scaffold",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "chromosome",
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
  "is_partial_w",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "start_coord_w",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "end_coord_w",
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
  "is_pseudogene",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "description",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "protein_seq_accid",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "taxon",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "img_orf_id",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "img_orf_type",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "img_mod_desc",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "obsolete_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "aa_residue",
  { data_type => "clob", is_nullable => 1 },
  "add_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "modified_by",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "auto_translation",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_pending",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "img_product_source",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "dt_protein_seq_accid_lc",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "dt_gene_symbol_lc",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "dt_locus_tag_lc",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cds_frag_coord",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "is_proxygene",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "is_low_quality",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "partial_gene",
  { data_type => "char", is_nullable => 1, size => 2 },
  "copy_number",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "est_copy",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "gc_percent",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 5],
  },
  "codon_start",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</gene_oid>

=back

=cut

__PACKAGE__->set_primary_key("gene_oid");

=head1 RELATIONS

=head2 bbh_cluster_member_genes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::BbhClusterMemberGene>

=cut

__PACKAGE__->has_many(
  "bbh_cluster_member_genes",
  "DBIC::IMG_Core::Result::BbhClusterMemberGene",
  { "foreign.member_genes" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_aliases

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneAlias>

=cut

__PACKAGE__->has_many(
  "gene_aliases",
  "DBIC::IMG_Core::Result::GeneAlias",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_eggnogs

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneEggnog>

=cut

__PACKAGE__->has_many(
  "gene_eggnogs",
  "DBIC::IMG_Core::Result::GeneEggnog",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_essential_genes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneEssentialGene>

=cut

__PACKAGE__->has_many(
  "gene_essential_genes",
  "DBIC::IMG_Core::Result::GeneEssentialGene",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_orthologs_gene_oids

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneOrtholog>

=cut

__PACKAGE__->has_many(
  "gene_orthologs_gene_oids",
  "DBIC::IMG_Core::Result::GeneOrtholog",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_orthologs_orthologs

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneOrtholog>

=cut

__PACKAGE__->has_many(
  "gene_orthologs_orthologs",
  "DBIC::IMG_Core::Result::GeneOrtholog",
  { "foreign.ortholog" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_pangene_composition_gene_oids

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GenePangeneComposition>

=cut

__PACKAGE__->has_many(
  "gene_pangene_composition_gene_oids",
  "DBIC::IMG_Core::Result::GenePangeneComposition",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_pangene_composition_pangene_compositions

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GenePangeneComposition>

=cut

__PACKAGE__->has_many(
  "gene_pangene_composition_pangene_compositions",
  "DBIC::IMG_Core::Result::GenePangeneComposition",
  { "foreign.pangene_composition" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_paralogs_gene_oids

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneParalog>

=cut

__PACKAGE__->has_many(
  "gene_paralogs_gene_oids",
  "DBIC::IMG_Core::Result::GeneParalog",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_paralogs_paralogs

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneParalog>

=cut

__PACKAGE__->has_many(
  "gene_paralogs_paralogs",
  "DBIC::IMG_Core::Result::GeneParalog",
  { "foreign.paralog" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_pdb_xrefs

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GenePdbXref>

=cut

__PACKAGE__->has_many(
  "gene_pdb_xrefs",
  "DBIC::IMG_Core::Result::GenePdbXref",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_prev_versions_gene_oids

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GenePrevVersion>

=cut

__PACKAGE__->has_many(
  "gene_prev_versions_gene_oids",
  "DBIC::IMG_Core::Result::GenePrevVersion",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_prev_versions_prev_versions

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GenePrevVersion>

=cut

__PACKAGE__->has_many(
  "gene_prev_versions_prev_versions",
  "DBIC::IMG_Core::Result::GenePrevVersion",
  { "foreign.prev_version" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_replacements

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneReplacement>

=cut

__PACKAGE__->has_many(
  "gene_replacements",
  "DBIC::IMG_Core::Result::GeneReplacement",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_rna_clusters

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneRnaCluster>

=cut

__PACKAGE__->has_many(
  "gene_rna_clusters",
  "DBIC::IMG_Core::Result::GeneRnaCluster",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_seed_names

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneSeedName>

=cut

__PACKAGE__->has_many(
  "gene_seed_names",
  "DBIC::IMG_Core::Result::GeneSeedName",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_swissprot_names

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneSwissprotName>

=cut

__PACKAGE__->has_many(
  "gene_swissprot_names",
  "DBIC::IMG_Core::Result::GeneSwissprotName",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gene_tc_families

Type: has_many

Related object: L<DBIC::IMG_Core::Result::GeneTcFamily>

=cut

__PACKAGE__->has_many(
  "gene_tc_families",
  "DBIC::IMG_Core::Result::GeneTcFamily",
  { "foreign.gene_oid" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 img_cluster_member_genes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::ImgClusterMemberGene>

=cut

__PACKAGE__->has_many(
  "img_cluster_member_genes",
  "DBIC::IMG_Core::Result::ImgClusterMemberGene",
  { "foreign.member_genes" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pangenome_count_genes_genes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::PangenomeCountGene>

=cut

__PACKAGE__->has_many(
  "pangenome_count_genes_genes",
  "DBIC::IMG_Core::Result::PangenomeCountGene",
  { "foreign.gene" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 pangenome_count_genes_pangenes

Type: has_many

Related object: L<DBIC::IMG_Core::Result::PangenomeCountGene>

=cut

__PACKAGE__->has_many(
  "pangenome_count_genes_pangenes",
  "DBIC::IMG_Core::Result::PangenomeCountGene",
  { "foreign.pangene" => "self.gene_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XpUTxCcrv+kazL9kxvBktQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
