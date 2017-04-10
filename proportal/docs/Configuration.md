# IMG / ProPortal Development #

## Configuration ##





## Filters ##


### ProPortal Subset ###

#### Taxonomic subsets ####

This is the SQL case statement that defines the ProPortal subset:

```sql

CASE
   WHEN taxon.genome_type = 'isolate' THEN
    CASE
      WHEN lower(taxon_display_name) LIKE 'prochlorococcus%' THEN
        CASE
          WHEN taxon.domain = 'Bacteria' THEN 'pro'
          WHEN taxon.domain = 'Viruses' THEN 'pro_phage'
        END
      WHEN lower(taxon_display_name) LIKE 'synechococcus%' THEN
        CASE
          WHEN taxon.domain = 'Bacteria' AND ecosystem_type = 'Marine' THEN 'syn'
          WHEN taxon.domain = 'Viruses' THEN 'syn_phage'
        END
      WHEN ( lower(ecosystem_subtype) = 'marginal sea' OR lower(ecosystem_subtype) = 'pelagic') THEN
        CASE
          WHEN taxon.domain = 'Bacteria' THEN 'other'
          WHEN taxon.domain = 'Viruses' THEN 'other_phage'
        END
    END
   WHEN genome_type = 'metagenome' AND lower(ecosystem_type) = 'marine' THEN genome_type
END
AS pp_subset

```

For isolate genomes (`taxon.genome_type = 'isolate'`):

* `taxon_display_name` starts with 'Prochlorococcus':
  * `domain` is bacteria: subset Prochlorococcus (`pro`)
  * `domain` is viruses: subset Prochlorococcus phage (`pro_phage`)

* `taxon_display_name` start with 'synechococcus':
  * `domain` is bacteria and `ecosystem_type` is 'marine': subset Synechococcus (`syn`)
  * `domain` is viruses: subset Synechococcus phage (`syn_phage`)

* `ecosystem_subtype` is 'marginal sea' or 'pelagic':
  * `domain` is bacteria: subset other (`other`)
  * `domain` is viruses: subset other phage (`other_phage`)


* Isolates: all the above

* Coccus: Prochlorococcus and Synechococcus

* Phage: Prochlorococcus phages and Synechococcus phages

* Metagenomes
  * `genome_type = 'metagenome' AND lower(ecosystem_type) = 'marine'` (`metagenome`)


### Data type ###

```sql
CASE
   WHEN genome_type = 'isolate' THEN
    CASE
      WHEN analysis_project_type in( 'Single Cell Analysis (unscreened)' , 'Single Cell Analysis (screened)') THEN 'single_cell'
      WHEN exists ( select 1 from rnaseq_dataset where rnaseq_dataset.reference_taxon_oid = taxon.taxon_oid AND rnaseq_dataset.dataset_type = 'Transcriptome') THEN 'transcriptome'
      ELSE genome_type
    END
   WHEN analysis_project_type = 'Metatranscriptome Analysis' THEN 'metatranscriptome'
   ELSE genome_type
   END
AS dataset_type
```

For isolate genomes (`taxon.genome_type = 'isolate'`):

* `taxon.genome_type = 'isolate'` and `analysis_project_type` = Single Cell Analysis (screened/unscreened): single cells (`single_cell`)

* `rnaseq_dataset.dataset_type = 'Transcriptome'` and `rnaseq_dataset.reference_taxon_oid` = taxon_oid: transcriptomes (`transcriptome`)

* anything else: `isolate`

For metagenomes (`taxon.genome_type = 'metagenome'`):

* `analysis_project_type` = 'Metatranscriptome Analysis': metatranscriptome (`metatranscriptome`)

* anything else: `metagenome`
