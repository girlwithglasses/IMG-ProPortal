use utf8;
package DbSchema::IMG_Core::Result::ProjectInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DbSchema::IMG_Core::Result::ProjectInfo

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DbSchema>

=cut

use base 'DbSchema';

=head1 TABLE: C<PROJECT_INFO>

=cut

__PACKAGE__->table("PROJECT_INFO");

=head1 ACCESSORS

=head2 project_oid

  data_type: 'integer'
  is_nullable: 0
  original: {data_type => "number",size => [38,0]}

=head2 gold_stamp_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 gold_id_old

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 display_name

  data_type: 'varchar2'
  is_nullable: 0
  size: 1000

=head2 common_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 genus_synonyms

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 species_synonyms

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 serovar

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylogeny

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 ncbi_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 ncbi_superkingdom

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 culture_collection

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 ncbi_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 symbiont

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 symbiont_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 isolation

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 oxygen_req

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cell_shape

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 motility

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sporulation

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 temp_range

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 temp_optimum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 salinity

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pressure

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ph

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 project_web_page

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_country

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 seq_status_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 project_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 library_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 binning_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 assembly_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 seq_depth

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gene_calling_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 contig_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 est_size

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 units

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gene_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gc_perc

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [5,2]

=head2 chromosome_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 plasmid_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 singlet_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 completion_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 contact_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 contact_email

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 contact_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 img_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 gcat_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 greengenes_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 strain_info_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 refseq_ids

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 refseq_link_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 map_link_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 wiki_link_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 information_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 information_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 add_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 modified_by

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 availability

  data_type: 'varchar2'
  is_nullable: 0
  size: 20

=head2 contact_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 genome_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 web_page_code

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 pub_journal

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 pub_vol

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 pub_link

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 iso_year

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 iso_country

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 geo_location

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 loc_coord

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 cell_diameter

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cell_length

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 color

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 latitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 longitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 altitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 gram_stain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_taxon_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 host_gender

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_age

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_health

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 biotic_rel

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 symbiotic_interaction

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 symbiotic_rel

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_archive_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 iso_pubmed_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 depth

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 vector

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 host_spec

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 iso_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 iso_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 habitat_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_race

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 hmp_isolation_bodysite

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 hmp_isolation_bodysubsite

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 host_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 hmp_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 ncbi_submit_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 locus_tag

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 funding_program

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 short_read_archive_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 seq_quality

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 type_strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 homd_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 host_medication

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 proj_desc

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 otu

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 no_of_reads

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 additional_body_sample_site

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 project_goal

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bei_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 biosafety_level

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 isolate_selected

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 hmp_iso_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 hmp_iso_avail_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 hmp_project_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 hmp_dna_received

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 hmp_date_dna_received

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 hmp_project_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 body_product

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 hmp_seq_begin_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 hmp_draft_seq_completion_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 proteomics_data

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 proteomics_link_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 transcriptomics_data

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 transcriptomics_link_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 organism_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 iso_method

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 id_16s

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 show_in_dacc

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 1
  size: 10

=head2 hmp_isolate_selection_source

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 image_url

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 submitters_project_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 seq_center_proj_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 proposal_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 dacc_display

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 pmid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 doi_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 publication_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 sample_oid

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 finishing_goal

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 current_finishing_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 scope_of_work

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 bioproject_relevance

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pmo_project_id

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 img_contact

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_proposal_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 scientific_program

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 jgi_project_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 jgi_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 gpts_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 gpts_last_mod_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 jgi_funding_program

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 jgi_dir_number

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 jgi_visibility

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 growth_conditions

  data_type: 'varchar2'
  is_nullable: 1
  size: 4000

=head2 coordinate_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 jgi_final_deliverable

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_product_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 jgi_funding_year

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 jgi_sequencing_goal

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 reviewed

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 organism_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 cultured

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 uncultured_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 nucleic_acid_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 16

=head2 culture_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 gpts_ncbi_scientific_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 gpts_bioclassification_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 scaffold_count

  data_type: 'integer'
  is_nullable: 1
  original: {data_type => "number",size => [38,0]}

=head2 bioproject_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 show_in_gold

  data_type: 'varchar2'
  is_nullable: 1
  size: 8

=head2 gpts_embargo_start_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 gpts_embargo_days

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 gpts_public_release_date

  data_type: 'datetime'
  is_nullable: 1
  original: {data_type => "date"}

=head2 phase

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 phase_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 related_project_oid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 its_spid

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 bioproject_description

  data_type: 'varchar2'
  is_nullable: 1
  size: 3000

=head2 bioproject_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 200

=head2 bioproject_title

  data_type: 'varchar2'
  is_nullable: 1
  size: 250

=head2 its_proposal_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 other_hosts

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 known_non_hosts

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 commercial_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 commercial

  data_type: 'varchar2'
  is_nullable: 1
  size: 8

=head2 taxon_doi_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 96

=head2 exemplar_doi_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 96

=head2 exemplar_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 project_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 annotator_comments

  data_type: 'varchar2'
  is_nullable: 1
  size: 2000

=head2 biosample_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 subspecies

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 er_sample_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 750

=head2 strain_habitat

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 its_spid_old

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 fk_study_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: 126

=head2 img_exp_oid

  data_type: 'varchar2'
  is_nullable: 1
  size: 100

=head2 goldv5_project_id

  data_type: 'numeric'
  is_auto_increment: 1
  is_nullable: 1
  original: {data_type => "number"}
  sequence: 'goldv5_project_id_seq'
  size: 126

=head2 viral_group

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 100

=head2 viral_subgroup

  data_type: 'varchar2'
  default_value: null
  is_nullable: 1
  size: 100

=head2 genbank_low_quality_annotation

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 3

=head2 genbank_low_quality_genome

  data_type: 'varchar2'
  default_value: 'No'
  is_nullable: 0
  size: 3

=head2 assembly_accession

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 legacy_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 clade

  data_type: 'varchar2'
  is_nullable: 1
  size: 40

=head2 ecotype

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 longhurst_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 longhurst_description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "project_oid",
  {
    data_type   => "integer",
    is_nullable => 0,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gold_stamp_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "gold_id_old",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "display_name",
  { data_type => "varchar2", is_nullable => 0, size => 1000 },
  "common_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "genus_synonyms",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "species_synonyms",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "serovar",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylogeny",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "ncbi_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "ncbi_superkingdom",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "culture_collection",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "ncbi_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "symbiont",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "symbiont_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "isolation",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "oxygen_req",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cell_shape",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "motility",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sporulation",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "temp_range",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "temp_optimum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "salinity",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pressure",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ph",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "project_web_page",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "project_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_country",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "seq_status_link",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "project_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "library_method",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "binning_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "assembly_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "seq_depth",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gene_calling_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "contig_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "est_size",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "units",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gene_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gc_perc",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [5, 2],
  },
  "chromosome_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "plasmid_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "singlet_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "completion_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "contact_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "contact_email",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "contact_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "img_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "gcat_id",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "greengenes_id",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "strain_info_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "refseq_ids",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "refseq_link_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "map_link_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "wiki_link_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "information_name",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "information_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
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
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "availability",
  { data_type => "varchar2", is_nullable => 0, size => 20 },
  "contact_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "genome_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "web_page_code",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "pub_journal",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "pub_vol",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "pub_link",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "iso_year",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "iso_country",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "geo_location",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "loc_coord",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "cell_diameter",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cell_length",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "color",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "latitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "longitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "altitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "gram_stain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_taxon_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "host_gender",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_age",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_health",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "biotic_rel",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "symbiotic_interaction",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "symbiotic_rel",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_archive_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "iso_pubmed_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "depth",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "vector",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "host_spec",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "iso_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "iso_source",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "habitat_category",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_race",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "hmp_isolation_bodysite",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "hmp_isolation_bodysubsite",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "host_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "hmp_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "ncbi_submit_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "locus_tag",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "funding_program",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "short_read_archive_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "seq_quality",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "type_strain",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "homd_id",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "host_medication",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "proj_desc",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "otu",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "no_of_reads",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "additional_body_sample_site",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "project_goal",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bei_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "biosafety_level",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "isolate_selected",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "hmp_iso_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "hmp_iso_avail_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "hmp_project_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "hmp_dna_received",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "hmp_date_dna_received",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "hmp_project_status",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "body_product",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "hmp_seq_begin_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "hmp_draft_seq_completion_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "proteomics_data",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "proteomics_link_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "transcriptomics_data",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "transcriptomics_link_url",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "organism_comments",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "iso_method",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "id_16s",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "show_in_dacc",
  {
    data_type => "varchar2",
    default_value => "No",
    is_nullable => 1,
    size => 10,
  },
  "hmp_isolate_selection_source",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "image_url",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "submitters_project_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "seq_center_proj_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "proposal_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "dacc_display",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "pmid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "doi_id",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "publication_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "sample_oid",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "finishing_goal",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "current_finishing_status",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "scope_of_work",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "bioproject_relevance",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pmo_project_id",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "img_contact",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_proposal_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "scientific_program",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "jgi_project_type",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "jgi_status",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "gpts_comments",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "gpts_last_mod_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "jgi_funding_program",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "jgi_dir_number",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "jgi_visibility",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "growth_conditions",
  { data_type => "varchar2", is_nullable => 1, size => 4000 },
  "coordinate_type",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "jgi_final_deliverable",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_product_name",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "jgi_funding_year",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "jgi_sequencing_goal",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "reviewed",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "organism_type",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "cultured",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "uncultured_type",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "nucleic_acid_type",
  { data_type => "varchar2", is_nullable => 1, size => 16 },
  "culture_type",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "gpts_ncbi_scientific_name",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "gpts_bioclassification_name",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "scaffold_count",
  {
    data_type   => "integer",
    is_nullable => 1,
    original    => { data_type => "number", size => [38, 0] },
  },
  "bioproject_accession",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "show_in_gold",
  { data_type => "varchar2", is_nullable => 1, size => 8 },
  "gpts_embargo_start_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "gpts_embargo_days",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "gpts_public_release_date",
  {
    data_type   => "datetime",
    is_nullable => 1,
    original    => { data_type => "date" },
  },
  "phase",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "phase_status",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "related_project_oid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "its_spid",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "bioproject_description",
  { data_type => "varchar2", is_nullable => 1, size => 3000 },
  "bioproject_name",
  { data_type => "varchar2", is_nullable => 1, size => 200 },
  "bioproject_title",
  { data_type => "varchar2", is_nullable => 1, size => 250 },
  "its_proposal_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "other_hosts",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "known_non_hosts",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "commercial_comments",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "commercial",
  { data_type => "varchar2", is_nullable => 1, size => 8 },
  "taxon_doi_id",
  { data_type => "varchar2", is_nullable => 1, size => 96 },
  "exemplar_doi_id",
  { data_type => "varchar2", is_nullable => 1, size => 96 },
  "exemplar_name",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "project_comments",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "annotator_comments",
  { data_type => "varchar2", is_nullable => 1, size => 2000 },
  "biosample_accession",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "subspecies",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "er_sample_id",
  { data_type => "varchar2", is_nullable => 1, size => 750 },
  "strain_habitat",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "its_spid_old",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "fk_study_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => 126,
  },
  "img_exp_oid",
  { data_type => "varchar2", is_nullable => 1, size => 100 },
  "goldv5_project_id",
  {
    data_type => "numeric",
    is_auto_increment => 1,
    is_nullable => 1,
    original => { data_type => "number" },
    sequence => "goldv5_project_id_seq",
    size => 126,
  },
  "viral_group",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 100,
  },
  "viral_subgroup",
  {
    data_type => "varchar2",
    default_value => \"null",
    is_nullable => 1,
    size => 100,
  },
  "genbank_low_quality_annotation",
  { data_type => "varchar2", default_value => "No", is_nullable => 0, size => 3 },
  "genbank_low_quality_genome",
  { data_type => "varchar2", default_value => "No", is_nullable => 0, size => 3 },
  "assembly_accession",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "legacy_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "clade",
  { data_type => "varchar2", is_nullable => 1, size => 40 },
  "ecotype",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "longhurst_code",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "longhurst_description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</project_oid>

=back

=cut

__PACKAGE__->set_primary_key("project_oid");

=head1 UNIQUE CONSTRAINTS

=head2 C<gold_stamp_id_uniq>

=over 4

=item * L</gold_stamp_id>

=back

=cut

__PACKAGE__->add_unique_constraint("gold_stamp_id_uniq", ["gold_stamp_id"]);

=head2 C<its_uniq>

=over 4

=item * L</its_spid>

=back

=cut

__PACKAGE__->add_unique_constraint("its_uniq", ["its_spid"]);

=head2 C<pmo_uniq>

=over 4

=item * L</pmo_project_id>

=back

=cut

__PACKAGE__->add_unique_constraint("pmo_uniq", ["pmo_project_id"]);

=head2 C<sys_c0033968>

=over 4

=item * L</goldv5_project_id>

=back

=cut

__PACKAGE__->add_unique_constraint("sys_c0033968", ["goldv5_project_id"]);

=head1 RELATIONS

=head2 bioproject_propagations

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::BioprojectPropagation>

=cut

__PACKAGE__->has_many(
  "bioproject_propagations",
  "DbSchema::IMG_Core::Result::BioprojectPropagation",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 gold_analysis_project_lookups

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::GoldAnalysisProjectLookup>

=cut

__PACKAGE__->has_many(
  "gold_analysis_project_lookups",
  "DbSchema::IMG_Core::Result::GoldAnalysisProjectLookup",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_info_bioprojects

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::ProjectInfoBioproject>

=cut

__PACKAGE__->has_many(
  "project_info_bioprojects",
  "DbSchema::IMG_Core::Result::ProjectInfoBioproject",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_info_body_products

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::ProjectInfoBodyProduct>

=cut

__PACKAGE__->has_many(
  "project_info_body_products",
  "DbSchema::IMG_Core::Result::ProjectInfoBodyProduct",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_info_body_sites

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::ProjectInfoBodySite>

=cut

__PACKAGE__->has_many(
  "project_info_body_sites",
  "DbSchema::IMG_Core::Result::ProjectInfoBodySite",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_info_data_links

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::ProjectInfoDataLink>

=cut

__PACKAGE__->has_many(
  "project_info_data_links",
  "DbSchema::IMG_Core::Result::ProjectInfoDataLink",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_info_nitrogen_fixations

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::ProjectInfoNitrogenFixation>

=cut

__PACKAGE__->has_many(
  "project_info_nitrogen_fixations",
  "DbSchema::IMG_Core::Result::ProjectInfoNitrogenFixation",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 project_info_project_relevances

Type: has_many

Related object: L<DbSchema::IMG_Core::Result::ProjectInfoProjectRelevance>

=cut

__PACKAGE__->has_many(
  "project_info_project_relevances",
  "DbSchema::IMG_Core::Result::ProjectInfoProjectRelevance",
  { "foreign.project_oid" => "self.project_oid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-06-23 13:17:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4C+cq5JqPrk2Xv8rJY+Z/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
