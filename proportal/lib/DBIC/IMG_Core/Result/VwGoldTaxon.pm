use utf8;
package DBIC::IMG_Core::Result::VwGoldTaxon;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

DBIC::IMG_Core::Result::VwGoldTaxon

=cut

use strict;
use warnings;


=head1 BASE CLASS: L<DBIC::Schema>

=cut

use base 'DBIC::Schema';
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<VW_GOLD_TAXON>

=cut

__PACKAGE__->table("VW_GOLD_TAXON");
__PACKAGE__->result_source_instance->view_definition("SELECT \nALTITUDE,\nANALYSIS_PROJECT_ID,\nBIOTIC_REL,\nCELL_SHAPE,\nCHLOROPHYLL_CONCENTRATION,\nCLADE,\nCOMBINED_SAMPLE_FLAG,\nDEPTH,\nECOSYSTEM_CATEGORY,\nECOSYSTEM_SUBTYPE,\nECOSYSTEM_TYPE,\nECOSYSTEM,\nECOTYPE,\nFAMILY,\nGENOME_TYPE,\nGEO_LOCATION,\nGOLD_SEQUENCING_PROJECT.GOLD_ID,\nIR_CLASS,\nIR_ORDER,\nLATITUDE,\nLONGHURST_CODE,\nLONGHURST_DESCRIPTION,\nLONGITUDE,\nMOTILITY,\nNCBI_CLASS,\nNCBI_FAMILY,\nNCBI_GENUS,\nNCBI_KINGDOM,\nNCBI_ORDER,\nNCBI_PHYLUM,\nNCBI_SPECIES,\nNITRATE_CONCENTRATION,\nOXYGEN_CONCENTRATION,\nOXYGEN_REQ,\nPH,\nPHYLUM,\nPRESSURE,\nPROPORT_ISOLATION AS ISOLATION_PROPORTAL,\nPROPORT_OCEAN AS OCEAN,\nPROPORT_STATION AS STATION_PROPORTAL,\nPROPORT_WOA_DISSOLVED_OXYGEN AS DISSOLVED_OXYGEN_WOA,\nPROPORT_WOA_NITRATE AS NITRATE_WOA,\nPROPORT_WOA_PHOSPHATE AS PHOSPHATE_WOA,\nPROPORT_WOA_SALINITY AS SALINITY_WOA,\nPROPORT_WOA_SILICATE AS SILICATE_WOA,\nPROPORT_WOA_TEMPERATURE AS TEMPERATURE_WOA,\nSALINITY_CONCENTRATION,\nSALINITY,\nSAMPLE_COLLECT_TEMP,\nSEQUENCING_GOLD_ID,\nSPECIFIC_ECOSYSTEM,\nSPORULATION,\nSTUDY_GOLD_ID,\nTAXON_DISPLAY_NAME,\nTAXON_OID,\nTAXON.DOMAIN,\nTAXON.GENUS,\nTAXON.GRAM_STAIN,\nTAXON.NCBI_TAXON_ID,\nTAXON.SPECIES,\nTAXON.STRAIN,\nTEMP_RANGE,\nUNCULTURED_TYPE,\nCASE\n   WHEN taxon.genome_type = 'isolate' THEN\n    CASE\n      WHEN lower(taxon.taxon_display_name) LIKE 'prochlorococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'pro'\n          WHEN taxon.domain = 'Viruses' THEN 'pro_phage'\n        END\n      WHEN lower(taxon.taxon_display_name) LIKE 'synechococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'syn'\n          WHEN taxon.domain = 'Viruses' THEN 'syn_phage'\n        END\n      WHEN ( lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'marginal sea' OR lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'pelagic') THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'other'\n          WHEN taxon.domain = 'Viruses' THEN 'other_phage'\n        END\n    END\n   WHEN taxon.genome_type = 'metagenome' AND lower(GOLD_SEQUENCING_PROJECT.ecosystem_type) = 'marine' THEN taxon.genome_type\nEND\nAS PROPORTAL_SUBSET,\nCASE\n   WHEN taxon.genome_type = 'isolate' THEN\n    CASE\n      WHEN lower(taxon.taxon_display_name) LIKE 'prochlorococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'pro'\n          WHEN taxon.domain = 'Viruses' THEN 'pro_phage'\n        END\n      WHEN lower(taxon.taxon_display_name) LIKE 'synechococcus%' THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'syn'\n          WHEN taxon.domain = 'Viruses' THEN 'syn_phage'\n        END\n      WHEN ( lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'marginal sea' OR lower(GOLD_SEQUENCING_PROJECT.ecosystem_subtype) = 'pelagic') THEN\n        CASE\n          WHEN taxon.domain = 'Bacteria' THEN 'other'\n          WHEN taxon.domain = 'Viruses' THEN 'other_phage'\n        END\n    END\n   WHEN taxon.genome_type = 'metagenome' AND lower(GOLD_SEQUENCING_PROJECT.ecosystem_type) = 'marine' THEN taxon.genome_type\nEND\nAS PP_SUBSET\n\nFROM \n\n    GOLD_SEQUENCING_PROJECT INNER JOIN TAXON ON GOLD_SEQUENCING_PROJECT.gold_id = TAXON.sequencing_gold_id\n    WHERE taxon.OBSOLETE_FLAG = 'No' AND taxon.IS_PUBLIC='Yes'");

=head1 ACCESSORS

=head2 altitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 analysis_project_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 biotic_rel

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 cell_shape

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 chlorophyll_concentration

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 clade

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 combined_sample_flag

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 depth

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ecosystem_category

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_subtype

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 ecotype

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 family

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 genome_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 geo_location

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 gold_id

  data_type: 'varchar2'
  is_nullable: 0
  size: 50

=head2 ir_class

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ir_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 latitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 longhurst_code

  data_type: 'varchar2'
  is_nullable: 1
  size: 80

=head2 longhurst_description

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 longitude

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 motility

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_class

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

=head2 ncbi_kingdom

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_order

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ncbi_species

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 nitrate_concentration

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 oxygen_concentration

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 oxygen_req

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 ph

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 phylum

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pressure

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 isolation_proportal

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 ocean

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 station_proportal

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 dissolved_oxygen_woa

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,3]

=head2 nitrate_woa

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,3]

=head2 phosphate_woa

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,3]

=head2 salinity_woa

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,3]

=head2 silicate_woa

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,3]

=head2 temperature_woa

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,3]

=head2 salinity_concentration

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 salinity

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sample_collect_temp

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 sequencing_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 specific_ecosystem

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 sporulation

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 study_gold_id

  data_type: 'varchar2'
  is_nullable: 1
  size: 50

=head2 taxon_display_name

  data_type: 'varchar2'
  is_nullable: 1
  size: 1000

=head2 taxon_oid

  data_type: 'numeric'
  is_nullable: 0
  original: {data_type => "number"}
  size: [16,0]

=head2 domain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 genus

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 gram_stain

  data_type: 'varchar2'
  is_nullable: 1
  size: 10

=head2 ncbi_taxon_id

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [16,0]

=head2 species

  data_type: 'varchar2'
  is_nullable: 1
  size: 500

=head2 strain

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 temp_range

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 uncultured_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 proportal_subset

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=head2 pp_subset

  data_type: 'varchar2'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "altitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "analysis_project_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "biotic_rel",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "cell_shape",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "chlorophyll_concentration",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "clade",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "combined_sample_flag",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "depth",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ecosystem_category",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_subtype",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem_type",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "ecotype",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "genome_type",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "geo_location",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "gold_id",
  { data_type => "varchar2", is_nullable => 0, size => 50 },
  "ir_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ir_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "latitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "longhurst_code",
  { data_type => "varchar2", is_nullable => 1, size => 80 },
  "longhurst_description",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "longitude",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "motility",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_class",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_family",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_genus",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_kingdom",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_order",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ncbi_species",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "nitrate_concentration",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "oxygen_concentration",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "oxygen_req",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "ph",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "phylum",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pressure",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "isolation_proportal",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "ocean",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "station_proportal",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "dissolved_oxygen_woa",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 3],
  },
  "nitrate_woa",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 3],
  },
  "phosphate_woa",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 3],
  },
  "salinity_woa",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 3],
  },
  "silicate_woa",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 3],
  },
  "temperature_woa",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 3],
  },
  "salinity_concentration",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "salinity",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sample_collect_temp",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "sequencing_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "specific_ecosystem",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "sporulation",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "study_gold_id",
  { data_type => "varchar2", is_nullable => 1, size => 50 },
  "taxon_display_name",
  { data_type => "varchar2", is_nullable => 1, size => 1000 },
  "taxon_oid",
  {
    data_type => "numeric",
    is_nullable => 0,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "domain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "genus",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "gram_stain",
  { data_type => "varchar2", is_nullable => 1, size => 10 },
  "ncbi_taxon_id",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [16, 0],
  },
  "species",
  { data_type => "varchar2", is_nullable => 1, size => 500 },
  "strain",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "temp_range",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "uncultured_type",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "proportal_subset",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
  "pp_subset",
  { data_type => "varchar2", is_nullable => 1, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-03-20 15:04:19
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:feOGV0nXJozhL0S3yHmwKQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
