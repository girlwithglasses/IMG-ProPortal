# IMG / ProPortal Development #

## Configuration ##





## Filters ##


### Subset ###

Taxonomic subsets

* Prochlorococcus spp
  * `genome_type = 'isolate' AND genus = 'Prochlorococcus'`

* Synechococcus spp
  * `genome_type = 'isolate' AND taxon.genus = 'Synechococcus' AND ( lower(ecosystem_subtype) = 'marginal sea' OR lower(ecosystem_subtype) = 'pelagic')`

* Synechococcus spp
  * `genome_type = 'isolate' AND lower(taxon_display_name) LIKE 'synechococcus%' AND taxon.domain = 'Viruses'`

* Prochlorococcus phage
  * `genome_type = 'isolate' AND lower(taxon_display_name) LIKE 'prochlorococcus%' AND taxon.domain = 'Viruses'`

* Isolates: all the above

* Coccus: Prochlorococcus and Synechococcus

* Phage: Prochlorococcus phages and Synechococcus phages

* Metagenomes
  * `genome_type = 'metagenome' AND lower(ecosystem_type) = 'marine'`


### Data type ###

* Transcriptomes:

  * `rnaseq_dataset.dataset_type = 'Transcriptome'` -- detailed expression data in `rnaseq_expression` table

* Metatranscriptomes:

  * `rnaseq_dataset.dataset_type = 'Metatranscriptome'` -- loaded as RNASeq data (i.e. read depths, etc.)
  * `gold_sequencing_project.sequencing_strategy = 'Metatranscriptome` -- loaded as if they are metagenomes (with genes, etc.)

* Single cells:

  * `gold_sequencing_project.uncultured_type = 'Single Cell'`

* Other: the `genome_type` (isolate or metagenome) designator is used
