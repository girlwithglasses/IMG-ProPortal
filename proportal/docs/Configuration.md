# IMG / ProPortal Development #

## Configuration ##





## Filters ##


### ProPortal Subset ###

Taxonomic subsets

For isolate genomes (`taxon.genome_type = 'isolate'`):

* `taxon_display_name` starts with 'Prochlorococcus':
  * `domain` is bacteria: subset Prochlorococcus
  * `domain` is viruses: subset Prochlorococcus phage

* `taxon_display_name` start with 'synechococcus':
  * `domain` is bacteria: subset Synechococcus
  * `domain` is viruses: subset Synechococcus phage

* `ecosystem_subtype` is 'marginal sea' or 'pelagic':
  * `domain` is bacteria: subset other
  * `domain` is viruses: subset other phage


* Isolates: all the above

* Coccus: Prochlorococcus and Synechococcus

* Phage: Prochlorococcus phages and Synechococcus phages

* Metagenomes
  * `genome_type = 'metagenome' AND lower(ecosystem_type) = 'marine'`


### Data type ###

* Single cells:

  * `taxon.genome_type = 'isolate' AND gold_sequencing_project.uncultured_type = 'Single Cell'`

* Transcriptomes:

  * `rnaseq_dataset.dataset_type = 'Transcriptome'`

* Metatranscriptomes:

  * `rnaseq_dataset.dataset_type = 'Metatranscriptome'` -- loaded as RNASeq data
  * `gold_sequencing_project.sequencing_strategy = 'Metatranscriptome'` -- loaded as metagenomes

* Other: the `genome_type` (isolate or metagenome) designator is used
