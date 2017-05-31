use utf8;
package DBIC::IMG_Core::Result::BinStat;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::BinStat

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';

=head1 TABLE: C<BIN_STATS>

=cut

__PACKAGE__->table("BIN_STATS");

=head1 ACCESSORS

=head2 bin_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_gene_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 cds_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 cds_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 rna_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 rna_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 rrna_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 rrna_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 rrna5s_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 rrna5s_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 rrna16s_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 rrna16s_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 rrna18s_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 rrna18s_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 rrna23s_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 rrna23s_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 rrna28s_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 rrna28s_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 trna_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 trna_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 other_rna_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 other_rna_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_w_func_pred

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_w_func_pred_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_wo_func_pred_sim

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_wo_func_pred_sim_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_wo_func_pred_no_sim

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_wo_func_pred_no_sim_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_enzymes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_enzymes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_kegg

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_kegg_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_not_in_kegg

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_not_in_kegg_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_orthologs

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_orthologs_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_paralogs

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_paralogs_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_cog

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_cog_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_kog

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_kog_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_pfam

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_pfam_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_ipr

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_ipr_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_tigrfam

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_tigrfam_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_signalp

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_signalp_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_transmembrane

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_transmembrane_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_pos_cluster

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_pos_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 pseudo_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 pseudo_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 dubious_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 dubious_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_img_terms

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_img_terms_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_img_pways

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_img_pways_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_parts_list

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_parts_list_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_myimg

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_myimg_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 pfam_clusters

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 ortholog_groups

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 paralog_groups

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 n_scaffolds

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_coding_bases

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_gatc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_g

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_a

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_t

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_c

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_n

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_x

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 total_gc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 count_go

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 gc_percent

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,5]

=head2 total_bases

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_revised

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_revised_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_obsolete

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_obsolete_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 fused_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 fused_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 uncharacterized_genes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 uncharacterized_genes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 avg_gene_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,2]

=head2 avg_intergenic_length

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,2]

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 0
  original: {data_type => "date"}

=head2 fusion_components

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 fusion_components_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_genome_prop

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_genome_prop_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 cog_clusters

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 kog_clusters

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 tigrfam_clusters

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_cassettes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_cassettes_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 total_cassettes

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_metacyc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_metacyc_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_not_in_metacyc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_not_in_metacyc_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_ko

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_ko_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_not_in_ko

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_not_in_ko_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_wo_ez_w_ko

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_wo_ez_w_ko_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_hor_transfer

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_hor_transfer_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 crispr_count

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_sp

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_sp_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_not_in_sp

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_not_in_sp_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_seed

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_seed_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_not_in_seed

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_not_in_seed_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 genes_in_img_clusters

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_img_clusters_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 img_clusters

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_tc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 genes_in_tc_pc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=cut

__PACKAGE__->add_columns(
  "bin_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_gene_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "cds_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "cds_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "rna_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rna_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "rrna_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rrna_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "rrna5s_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rrna5s_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "rrna16s_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rrna16s_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "rrna18s_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rrna18s_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "rrna23s_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rrna23s_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "rrna28s_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "rrna28s_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "trna_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "trna_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "other_rna_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "other_rna_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_w_func_pred",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_w_func_pred_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_wo_func_pred_sim",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_wo_func_pred_sim_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_wo_func_pred_no_sim",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_wo_func_pred_no_sim_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_enzymes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_enzymes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_kegg",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_kegg_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_not_in_kegg",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_not_in_kegg_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_orthologs",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_orthologs_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_paralogs",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_paralogs_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_cog",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_cog_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_kog",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_kog_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_pfam",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_pfam_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_ipr",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_ipr_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_tigrfam",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_tigrfam_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_signalp",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_signalp_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_transmembrane",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_transmembrane_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_pos_cluster",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_pos_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "pseudo_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pseudo_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "dubious_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "dubious_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_img_terms",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_img_terms_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_img_pways",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_img_pways_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_parts_list",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_parts_list_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_myimg",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_myimg_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "pfam_clusters",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "ortholog_groups",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "paralog_groups",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "n_scaffolds",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_coding_bases",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_gatc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_g",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_a",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_t",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_c",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_n",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_x",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "total_gc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "count_go",
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
  "total_bases",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_revised",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_revised_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_obsolete",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_obsolete_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "fused_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "fused_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "uncharacterized_genes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "uncharacterized_genes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "avg_gene_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 2],
  },
  "avg_intergenic_length",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 2],
  },
  "mod_date",
  {
    data_type   => "datetime",
    is_nullable => 0,
    original    => { data_type => "date" },
  },
  "fusion_components",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "fusion_components_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_genome_prop",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_genome_prop_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "cog_clusters",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "kog_clusters",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "tigrfam_clusters",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_cassettes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_cassettes_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "total_cassettes",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_metacyc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_metacyc_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_not_in_metacyc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_not_in_metacyc_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_ko",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_ko_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_not_in_ko",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_not_in_ko_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_wo_ez_w_ko",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_wo_ez_w_ko_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_hor_transfer",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_hor_transfer_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "crispr_count",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_sp",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_sp_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_not_in_sp",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_not_in_sp_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_seed",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_seed_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_not_in_seed",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_not_in_seed_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "genes_in_img_clusters",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_img_clusters_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "img_clusters",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_tc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "genes_in_tc_pc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</bin_oid>

=back

=cut

__PACKAGE__->set_primary_key("bin_oid");


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/TJTyoeoR7fDdcPTvxCJxg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
