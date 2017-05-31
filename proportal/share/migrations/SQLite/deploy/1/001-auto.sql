-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Thu Jun 25 17:16:04 2015
-- 

;
BEGIN TRANSACTION;
--
-- Table: GOLD_ANALYSIS_PROJECT
--
CREATE TABLE GOLD_ANALYSIS_PROJECT (
  gold_analysis_project_id numeric(126) NOT NULL,
  its_analysis_project_id numeric(126),
  analysis_project_name varchar2(512),
  ncbi_tax_id numeric(126),
  img_dataset_id varchar2(255),
  analysis_product_name varchar2(255),
  visibility varchar2(32),
  domain varchar2(255),
  ncbi_phylum varchar2(255),
  ncbi_class varchar2(255),
  ncbi_order varchar2(255),
  ncbi_family varchar2(255),
  ncbi_genus varchar2(255),
  ncbi_species varchar2(255),
  gold_analysis_project_type varchar2(80),
  gold_proposal_name varchar2(4000),
  ecosystem varchar2(256),
  ecosystem_category varchar2(256),
  ecosystem_subtype varchar2(256),
  specific_ecosystem varchar2(256),
  reference_img_oid numeric(126),
  pi_name varchar2(256),
  pi_email varchar2(256),
  submitter_contact_oid numeric(126),
  ecosystem_type varchar2(255),
  specimen varchar2(64),
  comments varchar2(1024),
  reference_img_experiment_id numeric(126),
  reference_gold_ap_id numeric(126),
  gold_id varchar2(16),
  genome_size numeric(126),
  gene_count numeric(126),
  scaffold_count numeric(126),
  its_analysis_project_name varchar2(512),
  contig_count numeric(126),
  genbank_low_quality_annotation varchar2(3),
  genbank_low_quality_genome varchar2(3),
  completion_date timestamp,
  binning_method varchar2(1024),
  gene_calling_method varchar2(1024),
  submission_id numeric(126),
  img_analysis_complete varchar2(3),
  status varchar2(64),
  is_gene_primp varchar2(3) DEFAULT 'No',
  gene_primp_date timestamp,
  is_decontamination varchar2(3) DEFAULT 'No',
  is_img_annotation varchar2(3) DEFAULT 'No',
  its_annotation_at_id numeric(126),
  its_assembly_at_id numeric(126),
  is_assembled varchar2(16),
  genome_type varchar2(40),
  study_gold_id varchar2(20),
  locus_tag varchar2(20),
  cultured varchar2(10),
  jgi_sequenced varchar2(10),
  reference_gold_id varchar2(20),
  strain varchar2(255),
  mod_date datetime,
  submission_type varchar2(20),
  submitter_email varchar2(255),
  review_status varchar2(40),
  PRIMARY KEY (gold_analysis_project_id),
  FOREIGN KEY (reference_gold_ap_id) REFERENCES GOLD_ANALYSIS_PROJECT(gold_analysis_project_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_ANALYSIS_PROJECT_idx_reference_gold_ap_id ON GOLD_ANALYSIS_PROJECT (reference_gold_ap_id);
--
-- Table: GOLD_ANALYSIS_PROJECT_LOOKUP2
--
CREATE TABLE GOLD_ANALYSIS_PROJECT_LOOKUP2 (
  gold_id varchar2(20) NOT NULL,
  its_spid integer,
  project_oid integer,
  sample_oid integer,
  sp_gold_id varchar2(20),
  pmo_project_id integer
);
--
-- Table: GOLD_SEQUENCING_PROJECT
--
CREATE TABLE GOLD_SEQUENCING_PROJECT (
  gold_id varchar2(50) NOT NULL,
  display_name varchar2(1000) NOT NULL,
  strain varchar2(500),
  phylogeny varchar2(1000),
  ncbi_taxon_id integer,
  domain varchar2(255),
  ncbi_kingdom varchar2(255),
  ncbi_phylum varchar2(255),
  ncbi_class varchar2(255),
  ncbi_order varchar2(255),
  ncbi_family varchar2(255),
  ncbi_genus varchar2(255),
  ncbi_species varchar2(255),
  clade varchar2(255),
  ncbi_project_id integer,
  isolation varchar2(4000),
  oxygen_req varchar2(255),
  cell_shape varchar2(255),
  motility varchar2(255),
  sporulation varchar2(255),
  temp_range varchar2(255),
  salinity varchar2(255),
  comments varchar2(4000),
  seq_status varchar2(255),
  img_taxon_oid integer,
  add_date datetime,
  mod_date datetime,
  modified_by integer,
  contact_oid integer,
  iso_country varchar2(255),
  date_collected varchar2(255),
  geo_location varchar2(1000),
  latitude varchar2(255),
  longitude varchar2(255),
  altitude varchar2(255),
  gram_stain varchar2(255),
  host_name varchar2(255),
  host_gender varchar2(255),
  host_ncbi_taxid integer,
  biotic_rel varchar2(255),
  hmp_id integer,
  locus_tag varchar2(80),
  funding_program varchar2(255),
  type_strain varchar2(10),
  ecosystem varchar2(256),
  ecosystem_category varchar2(256),
  ecosystem_type varchar2(256),
  ecosystem_subtype varchar2(256),
  specific_ecosystem varchar2(256),
  sample_body_site varchar2(255),
  sample_body_subsite varchar2(255),
  mrn numeric(126),
  visit_num numeric(126),
  replicate_num numeric(126),
  pmo_project_id integer,
  project_id integer,
  cultured varchar2(16),
  uncultured_type varchar2(64),
  culture_type varchar2(64),
  bioproject_accession varchar2(64),
  biosample_accession varchar2(128),
  its_spid numeric(126),
  pi_email varchar2(255),
  pi_name varchar2(255),
  legacy_project_type varchar2(40),
  seq_quality varchar2(80),
  depth varchar2(255),
  sequencing_strategy varchar2(255),
  pm_email varchar2(255),
  pm_name varchar2(255),
  ecotype varchar2(80),
  longhurst_code varchar2(80),
  longhurst_description varchar2(255),
  project_status varchar2(255),
  PRIMARY KEY (gold_id)
);
--
-- Table: IMG_GROUP
--
CREATE TABLE IMG_GROUP (
  group_id integer NOT NULL,
  group_name varchar2(255),
  lead integer,
  add_date datetime,
  comments varchar2(1000)
);
--
-- Table: IMG_GROUP_NEWS
--
CREATE TABLE IMG_GROUP_NEWS (
  group_id integer NOT NULL,
  news_id integer,
  title varchar2(255),
  description varchar2(4000),
  posted_by integer,
  add_date datetime,
  mod_date datetime,
  is_public varchar2(10),
  released_by integer,
  release_date datetime
);
--
-- Table: GOLD_AP_GENBANK
--
CREATE TABLE GOLD_AP_GENBANK (
  id numeric(126) NOT NULL,
  gold_analysis_project_id numeric(126),
  genbank_id varchar2(1024),
  assembly_accession varchar2(64),
  PRIMARY KEY (id),
  FOREIGN KEY (gold_analysis_project_id) REFERENCES GOLD_ANALYSIS_PROJECT(gold_analysis_project_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_AP_GENBANK_idx_gold_analysis_project_id ON GOLD_AP_GENBANK (gold_analysis_project_id);
CREATE UNIQUE INDEX gold_ap_genbank_1 ON GOLD_AP_GENBANK (gold_analysis_project_id, genbank_id);
--
-- Table: GOLD_SP_CELL_ARRANGEMENT
--
CREATE TABLE GOLD_SP_CELL_ARRANGEMENT (
  gold_id varchar2(50) NOT NULL,
  cell_arrangement varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_CELL_ARRANGEMENT_idx_gold_id ON GOLD_SP_CELL_ARRANGEMENT (gold_id);
--
-- Table: GOLD_SP_COLLABORATOR
--
CREATE TABLE GOLD_SP_COLLABORATOR (
  gold_id varchar2(50) NOT NULL,
  name varchar2(255),
  country varchar2(255),
  url varchar2(500),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_COLLABORATOR_idx_gold_id ON GOLD_SP_COLLABORATOR (gold_id);
--
-- Table: GOLD_SP_DISEASE
--
CREATE TABLE GOLD_SP_DISEASE (
  gold_id varchar2(50) NOT NULL,
  disease varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_DISEASE_idx_gold_id ON GOLD_SP_DISEASE (gold_id);
--
-- Table: GOLD_SP_ENERGY_SOURCE
--
CREATE TABLE GOLD_SP_ENERGY_SOURCE (
  gold_id varchar2(50) NOT NULL,
  energy_source varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_ENERGY_SOURCE_idx_gold_id ON GOLD_SP_ENERGY_SOURCE (gold_id);
--
-- Table: GOLD_SP_GENOME_PUBLICATIONS
--
CREATE TABLE GOLD_SP_GENOME_PUBLICATIONS (
  gold_id varchar2(50) NOT NULL,
  pubmed_id integer,
  journal_name varchar2(255),
  volume varchar2(40),
  issue varchar2(40),
  page varchar2(80),
  title varchar2(500),
  publication_date varchar2(80),
  doi varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_GENOME_PUBLICATIONS_idx_gold_id ON GOLD_SP_GENOME_PUBLICATIONS (gold_id);
--
-- Table: GOLD_SP_HABITAT
--
CREATE TABLE GOLD_SP_HABITAT (
  gold_id varchar2(50) NOT NULL,
  habitat varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_HABITAT_idx_gold_id ON GOLD_SP_HABITAT (gold_id);
--
-- Table: GOLD_SP_METABOLISM
--
CREATE TABLE GOLD_SP_METABOLISM (
  gold_id varchar2(50) NOT NULL,
  metabolism varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_METABOLISM_idx_gold_id ON GOLD_SP_METABOLISM (gold_id);
--
-- Table: GOLD_SP_PHENOTYPE
--
CREATE TABLE GOLD_SP_PHENOTYPE (
  gold_id varchar2(50) NOT NULL,
  phenotype varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_PHENOTYPE_idx_gold_id ON GOLD_SP_PHENOTYPE (gold_id);
--
-- Table: GOLD_SP_RELEVANCE
--
CREATE TABLE GOLD_SP_RELEVANCE (
  gold_id varchar2(50) NOT NULL,
  relevance varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_RELEVANCE_idx_gold_id ON GOLD_SP_RELEVANCE (gold_id);
--
-- Table: GOLD_SP_SEQ_CENTER
--
CREATE TABLE GOLD_SP_SEQ_CENTER (
  gold_id varchar2(50) NOT NULL,
  name varchar2(255),
  country varchar2(255),
  url varchar2(500),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_SEQ_CENTER_idx_gold_id ON GOLD_SP_SEQ_CENTER (gold_id);
--
-- Table: GOLD_SP_SEQ_METHOD
--
CREATE TABLE GOLD_SP_SEQ_METHOD (
  gold_id varchar2(50) NOT NULL,
  seq_method varchar2(255),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_SEQ_METHOD_idx_gold_id ON GOLD_SP_SEQ_METHOD (gold_id);
--
-- Table: GOLD_SP_STUDY_GOLD_ID
--
CREATE TABLE GOLD_SP_STUDY_GOLD_ID (
  gold_id varchar2(50) NOT NULL,
  study_gold_id varchar2(50),
  FOREIGN KEY (gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE INDEX GOLD_SP_STUDY_GOLD_ID_idx_gold_id ON GOLD_SP_STUDY_GOLD_ID (gold_id);
--
-- Table: TAXON
--
CREATE TABLE TAXON (
  taxon_oid numeric(16,0) NOT NULL,
  taxon_name varchar2(1000),
  genus varchar2(500),
  species varchar2(500),
  strain varchar2(255),
  taxon_display_name varchar2(1000),
  ncbi_taxon_id numeric(16,0),
  domain varchar2(255),
  phylum varchar2(255),
  ir_class varchar2(255),
  ir_order varchar2(255),
  family varchar2(255),
  jgi_species_code varchar2(50),
  comments varchar2(1000),
  env_sample numeric(16,0),
  seq_status varchar2(100),
  seq_center varchar2(500),
  is_public varchar2(10) NOT NULL DEFAULT 'No',
  is_replaced varchar2(10),
  img_ec_flag varchar2(10),
  funding_agency varchar2(255),
  jgi_project_id numeric(16,0),
  img_version varchar2(50),
  ncbi_species_code varchar2(20),
  ncbi_project_id numeric(16,0),
  gold_id varchar2(50),
  release_date datetime,
  add_date datetime,
  ornl_species_code varchar2(50),
  is_big_euk varchar2(10),
  host_ncbi_taxon_id integer,
  is_std_reference varchar2(10),
  mod_date datetime,
  modified_by numeric(16,0),
  project numeric(16,0),
  genome_type varchar2(255),
  gram_stain varchar2(10),
  is_proxygene_set varchar2(10),
  obsolete_flag varchar2(10) NOT NULL DEFAULT 'No',
  is_pangenome varchar2(10),
  edit_flag varchar2(10),
  submission_id integer,
  img_product_flag varchar2(10),
  refseq_project_id numeric(126),
  gbk_project_id numeric(126),
  is_low_quality varchar2(10),
  phylodist_date datetime,
  proposal_name varchar2(2000),
  sample_gold_id varchar2(50),
  phylodist_method varchar2(200),
  in_file varchar2(10),
  ncbi_bioproject_id varchar2(20),
  combined_sample_flag varchar2(10),
  high_quality_flag varchar2(10),
  taxonomy_lock varchar2(10),
  locked_by numeric(16,0),
  lock_date datetime,
  distmatrix_date datetime,
  analysis_project_id varchar2(50),
  legacy_gold_id varchar2(50),
  ani_species varchar2(255),
  study_gold_id varchar2(50),
  sequencing_gold_id varchar2(50),
  PRIMARY KEY (taxon_oid),
  FOREIGN KEY (analysis_project_id) REFERENCES GOLD_ANALYSIS_PROJECT(gold_analysis_project_id),
  FOREIGN KEY (sequencing_gold_id) REFERENCES GOLD_SEQUENCING_PROJECT(gold_id)
);
CREATE INDEX TAXON_idx_analysis_project_id ON TAXON (analysis_project_id);
CREATE INDEX TAXON_idx_sequencing_gold_id ON TAXON (sequencing_gold_id);
COMMIT;
