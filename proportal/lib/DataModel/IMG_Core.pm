package DataModel::IMG_Core;

use IMG::Util::Import 'LogErr';
use DBIx::DataModel;
use IMG::Model::UnitConverter;

sub schema_id {
	return 'img_core';
}

DBIx::DataModel  # no semicolon (intentional)

#---------------------------------------------------------------------#
#                         SCHEMA DECLARATION                          #
#---------------------------------------------------------------------#
->Schema('DataModel::IMG_Core')

#---------------------------------------------------------------------#
#                         TABLE DECLARATIONS                          #
#---------------------------------------------------------------------#
#          Class                      Table                         PK
#          =====                      =====                         ==
->Table(qw/AccessionTypes              ACCESSION_TYPES                unknown_pk         /)
->Table(qw/AltTranscript               ALT_TRANSCRIPT                 alt_transcript_oid /)
->Table(qw/AniClique                   ANI_CLIQUE                     clique_id          /)
->Table(qw/AniCliqueMembers            ANI_CLIQUE_MEMBERS             unknown_pk         /)
->Table(qw/AniInterClique              ANI_INTER_CLIQUE               unknown_pk         /)
->Table(qw/AniNewTaxons                ANI_NEW_TAXONS                 unknown_pk         /)
->Table(qw/AniOldTaxons                ANI_OLD_TAXONS                 unknown_pk         /)
->Table(qw/Assembly                    ASSEMBLY                       unknown_pk         /)
->Table(qw/BbhCluster                  BBH_CLUSTER                    cluster_id         /)
->Table(qw/BbhClusterFamilies          BBH_CLUSTER_FAMILIES           unknown_pk         /)
->Table(qw/BbhClusterMemberGenes       BBH_CLUSTER_MEMBER_GENES       unknown_pk         /)
->Table(qw/BcType                      BC_TYPE                        unknown_pk         /)
->Table(qw/Bin                         BIN                            bin_oid            /)
->Table(qw/BinMethod                   BIN_METHOD                     bin_method_oid     /)
->Table(qw/BinScaffolds                BIN_SCAFFOLDS                  unknown_pk         /)
->Table(qw/BinStats                    BIN_STATS                      bin_oid            /)
->Table(qw/BioCluster                  BIO_CLUSTER                    cluster_id         /)
->Table(qw/BioClusterData              BIO_CLUSTER_DATA               unknown_pk         /)
->Table(qw/BioClusterDataNew           BIO_CLUSTER_DATA_NEW           unknown_pk         /)
->Table(qw/BioClusterFeatures          BIO_CLUSTER_FEATURES           unknown_pk         /)
->Table(qw/BioClusterFeaturesNew       BIO_CLUSTER_FEATURES_NEW       unknown_pk         /)
->Table(qw/BioClusterNew               BIO_CLUSTER_NEW                unknown_pk         /)
->Table(qw/CassetteBox                 CASSETTE_BOX                   box_oid            /)
->Table(qw/CassetteBoxBbh              CASSETTE_BOX_BBH               unknown_pk         /)
->Table(qw/CassetteBoxBbhXlogs         CASSETTE_BOX_BBH_XLOGS         unknown_pk         /)
->Table(qw/CassetteBoxCassettesBbh     CASSETTE_BOX_CASSETTES_BBH     unknown_pk         /)
->Table(qw/CassetteBoxCassettesCog     CASSETTE_BOX_CASSETTES_COG     unknown_pk         /)
->Table(qw/CassetteBoxCassettesPfam    CASSETTE_BOX_CASSETTES_PFAM    unknown_pk         /)
->Table(qw/CassetteBoxCog              CASSETTE_BOX_COG               unknown_pk         /)
->Table(qw/CassetteBoxCogXlogs         CASSETTE_BOX_COG_XLOGS         unknown_pk         /)
->Table(qw/CassetteBoxPfam             CASSETTE_BOX_PFAM              unknown_pk         /)
->Table(qw/CassetteBoxPfamXlogs        CASSETTE_BOX_PFAM_XLOGS        unknown_pk         /)
->Table(qw/CdsMappingSummary           CDS_MAPPING_SUMMARY            unknown_pk         /)
->Table(qw/Concurrencytest             CONCURRENCYTEST                unknown_pk         /)
->Table(qw/Copy                        COPY                           unknown_pk         /)
->Table(qw/CopyErFinal                 COPY_ER_FINAL                  unknown_pk         /)
->Table(qw/CopyMerAll                  COPY_MER_ALL                   unknown_pk         /)
->Table(qw/CopyMerFinal                COPY_MER_FINAL                 unknown_pk         /)
->Table(qw/CopyMerPhase1               COPY_MER_PHASE1                unknown_pk         /)
# ->Table(qw/DbSource                    DB_SOURCE                      db_code            /)
->Table(qw/DeleteGenes                 DELETE_GENES                   unknown_pk         /)
->Table(qw/DeleteScaffolds             DELETE_SCAFFOLDS               unknown_pk         /)
->Table(qw/DeleteTaxons                DELETE_TAXONS                  unknown_pk         /)
->Table(qw/DtBc2ec                     DT_BC2EC                       unknown_pk         /)
->Table(qw/DtCog                       DT_COG                         unknown_pk         /)
->Table(qw/DtCogStats                  DT_COG_STATS                   taxon_oid          /)
->Table(qw/DtDbStatus                  DT_DB_STATUS                   unknown_pk         /)
->Table(qw/DtFuncsObs                  DT_FUNCS_OBS                   unknown_pk         /)
->Table(qw/DtFuncCombo4iterms          DT_FUNC_COMBO_4ITERMS          unknown_pk         /)
->Table(qw/DtFuncCombo4ko              DT_FUNC_COMBO_4KO              unknown_pk         /)
->Table(qw/DtFuncComboGenes4iterms     DT_FUNC_COMBO_GENES_4ITERMS    unknown_pk         /)
->Table(qw/DtFuncComboGenes4ko         DT_FUNC_COMBO_GENES_4KO        unknown_pk         /)
->Table(qw/DtGeneKoModulePwys          DT_GENE_KO_MODULE_PWYS         unknown_pk         /)
->Table(qw/DtHtHits                    DT_HT_HITS                     unknown_pk         /)
->Table(qw/DtImgGeneProtPepSample      DT_IMG_GENE_PROT_PEP_SAMPLE    unknown_pk         /)
->Table(qw/DtImgTermPath               DT_IMG_TERM_PATH               unknown_pk         /)
->Table(qw/DtIntergenic                DT_INTERGENIC                  unknown_pk         /)
->Table(qw/DtKo                        DT_KO                          unknown_pk         /)
->Table(qw/DtKogStats                  DT_KOG_STATS                   taxon_oid          /)
->Table(qw/DtKoTermComboStats          DT_KO_TERM_COMBO_STATS         unknown_pk         /)
->Table(qw/DtKoTermParalogStats        DT_KO_TERM_PARALOG_STATS       unknown_pk         /)
->Table(qw/DtMvcTaxonomy               DT_MVC_TAXONOMY                unknown_pk         /)
->Table(qw/DtPfam                      DT_PFAM                        unknown_pk         /)
->Table(qw/DtPhylodistNewTaxons        DT_PHYLODIST_NEW_TAXONS        unknown_pk         /)
->Table(qw/DtPhylumDistGenes           DT_PHYLUM_DIST_GENES           unknown_pk         /)
->Table(qw/DtPhylumDistStats           DT_PHYLUM_DIST_STATS           unknown_pk         /)
->Table(qw/DtScogs                     DT_SCOGS                       unknown_pk         /)
->Table(qw/DtScogGenes                 DT_SCOG_GENES                  unknown_pk         /)
->Table(qw/DtTaxonBbhCluster           DT_TAXON_BBH_CLUSTER           unknown_pk         /)
->Table(qw/DtTaxonKmoduleMcr           DT_TAXON_KMODULE_MCR           unknown_pk         /)
->Table(qw/DtTaxonNodeLite             DT_TAXON_NODE_LITE             unknown_pk         /)
->Table(qw/DtTemp                      DT_TEMP                        unknown_pk         /)
->Table(qw/DtTemp2                     DT_TEMP_2                      unknown_pk         /)
->Table(qw/DtTfam                      DT_TFAM                        unknown_pk         /)
->Table(qw/DtViralsFromMetag           DT_VIRALS_FROM_METAG           unknown_pk         /)
->Table(qw/DtViralClusters             DT_VIRAL_CLUSTERS              unknown_pk         /)
->Table(qw/DtViralHostAssignment       DT_VIRAL_HOST_ASSIGNMENT       unknown_pk         /)
->Table(qw/DtViralSpacer               DT_VIRAL_SPACER                unknown_pk         /)
->Table(qw/EnvSampleObsolete           ENV_SAMPLE_OBSOLETE            unknown_pk         /)
->Table(qw/EnvSampleOld                ENV_SAMPLE_OLD                 sample_oid         /)
->Table(qw/EnvSampleTemp               ENV_SAMPLE_TEMP                unknown_pk         /)
->Table(qw/Gene                        GENE                           gene_oid           /)
->Table(qw/GeneAliases                 GENE_ALIASES                   unknown_pk         /)
->Table(qw/GeneAllFusionComponents     GENE_ALL_FUSION_COMPONENTS     unknown_pk         /)
->Table(qw/GeneBiocycRxns              GENE_BIOCYC_RXNS               unknown_pk         /)
->Table(qw/GeneCandidateKoTerms        GENE_CANDIDATE_KO_TERMS        unknown_pk         /)
->Table(qw/GeneCassette                GENE_CASSETTE                  cassette_oid       /)
->Table(qw/GeneCassetteGenes           GENE_CASSETTE_GENES            unknown_pk         /)
->Table(qw/GeneCassettePanfolds        GENE_CASSETTE_PANFOLDS         unknown_pk         /)
->Table(qw/GeneCogGroups               GENE_COG_GROUPS                unknown_pk         /)
->Table(qw/GeneDnaUblast               GENE_DNA_UBLAST                unknown_pk         /)
->Table(qw/GeneEggnogs                 GENE_EGGNOGS                   unknown_pk         /)
->Table(qw/GeneEnzymes                 GENE_ENZYMES                   unknown_pk         /)
->Table(qw/GeneEssentialGenes          GENE_ESSENTIAL_GENES           unknown_pk         /)
->Table(qw/GeneExceptions              GENE_EXCEPTIONS                unknown_pk         /)
->Table(qw/GeneExtLinks                GENE_EXT_LINKS                 unknown_pk         /)
->Table(qw/GeneFeatureTags             GENE_FEATURE_TAGS              unknown_pk         /)
->Table(qw/GeneFragCoords              GENE_FRAG_COORDS               unknown_pk         /)
->Table(qw/GeneFusionComponents        GENE_FUSION_COMPONENTS         unknown_pk         /)
->Table(qw/GeneGoTerms                 GENE_GO_TERMS                  unknown_pk         /)
->Table(qw/GeneImgInterproHits         GENE_IMG_INTERPRO_HITS         unknown_pk         /)
->Table(qw/GeneKogGroups               GENE_KOG_GROUPS                unknown_pk         /)
->Table(qw/GeneKoEnzymes               GENE_KO_ENZYMES                unknown_pk         /)
->Table(qw/GeneKoTerms                 GENE_KO_TERMS                  unknown_pk         /)
->Table(qw/GeneLipoPeptides            GENE_LIPO_PEPTIDES             unknown_pk         /)
->Table(qw/GeneMapping                 GENE_MAPPING                   unknown_pk         /)
->Table(qw/GeneMd5dna                  GENE_MD5DNA                    unknown_pk         /)
->Table(qw/GeneNotes                   GENE_NOTES                     unknown_pk         /)
->Table(qw/GeneOrthologs               GENE_ORTHOLOGS                 unknown_pk         /)
->Table(qw/GenePangeneComposition      GENE_PANGENE_COMPOSITION       unknown_pk         /)
->Table(qw/GeneParalogs                GENE_PARALOGS                  unknown_pk         /)
->Table(qw/GenePdbXrefs                GENE_PDB_XREFS                 unknown_pk         /)
->Table(qw/GenePfamFamilies            GENE_PFAM_FAMILIES             unknown_pk         /)
->Table(qw/GenePfamFamiliesOld         GENE_PFAM_FAMILIES_OLD         unknown_pk         /)
->Table(qw/GenePrevVersions            GENE_PREV_VERSIONS             unknown_pk         /)
->Table(qw/GeneReplacements            GENE_REPLACEMENTS              unknown_pk         /)
->Table(qw/GeneRnaClusters             GENE_RNA_CLUSTERS              unknown_pk         /)
->Table(qw/GeneSeedNames               GENE_SEED_NAMES                unknown_pk         /)
->Table(qw/GeneSigPeptides             GENE_SIG_PEPTIDES              unknown_pk         /)
->Table(qw/GeneSwissprotNames          GENE_SWISSPROT_NAMES           unknown_pk         /)
->Table(qw/GeneTcFamilies              GENE_TC_FAMILIES               unknown_pk         /)
->Table(qw/GeneTigrfams                GENE_TIGRFAMS                  unknown_pk         /)
->Table(qw/GeneTmhmmHits               GENE_TMHMM_HITS                unknown_pk         /)
->Table(qw/GeneXrefFamilies            GENE_XREF_FAMILIES             unknown_pk         /)
->Table(qw/GoldAccCounts               GOLD_ACC_COUNTS                unknown_pk         /)
->Table(qw/GttFunctionGene             GTT_FUNCTION_GENE              unknown_pk         /)
->Table(qw/GttFuncId                   GTT_FUNC_ID                    unknown_pk         /)
->Table(qw/GttFuncId1                  GTT_FUNC_ID1                   unknown_pk         /)
->Table(qw/GttFuncId2                  GTT_FUNC_ID2                   unknown_pk         /)
->Table(qw/GttFuncId3                  GTT_FUNC_ID3                   unknown_pk         /)
->Table(qw/GttKen                      GTT_KEN                        unknown_pk         /)
->Table(qw/GttKen2                     GTT_KEN2                       unknown_pk         /)
->Table(qw/GttKp                       GTT_KP                         unknown_pk         /)
->Table(qw/GttNumId                    GTT_NUM_ID                     unknown_pk         /)
->Table(qw/GttNumId1                   GTT_NUM_ID1                    unknown_pk         /)
->Table(qw/GttNumId2                   GTT_NUM_ID2                    unknown_pk         /)
->Table(qw/GttNumId3                   GTT_NUM_ID3                    unknown_pk         /)
->Table(qw/GttTaxonOid                 GTT_TAXON_OID                  unknown_pk         /)
->Table(qw/ImgAccCounts                IMG_ACC_COUNTS                 unknown_pk         /)
->Table(qw/ImgBuild                    IMG_BUILD                      build_oid          /)
->Table(qw/ImgCluster                  IMG_CLUSTER                    cluster_id         /)
->Table(qw/ImgClusterFamilies          IMG_CLUSTER_FAMILIES           unknown_pk         /)
->Table(qw/ImgClusterMemberGenes       IMG_CLUSTER_MEMBER_GENES       unknown_pk         /)
->Table(qw/ImgContentHistory           IMG_CONTENT_HISTORY            img_version        /)
->Table(qw/ImgOrfType                  IMG_ORF_TYPE                   orf_type           /)
->Table(qw/InsurCustLtvSample          INSUR_CUST_LTV_SAMPLE          unknown_pk         /)
->Table(qw/KpLinks                     KP_LINKS                       unknown_pk         /)
->Table(qw/KpTaxons                    KP_TAXONS                      unknown_pk         /)
->Table(qw/KpTemp                      KP_TEMP                        unknown_pk         /)
->Table(qw/KpTmp                       KP_TMP                         unknown_pk         /)
->Table(qw/MapTaxonPairs               MAP_TAXON_PAIRS                unknown_pk         /)
->Table(qw/MerfsGeneMapping            MERFS_GENE_MAPPING             unknown_pk         /)
->Table(qw/MerInfileTaxon0918          MER_INFILE_TAXON_0918          unknown_pk         /)
->Table(qw/MvBioClusterSeqlen          MV_BIO_CLUSTER_SEQLEN          unknown_pk         /)
->Table(qw/MvBioClusterStat            MV_BIO_CLUSTER_STAT            unknown_pk         /)
->Table(qw/MvMetacycStats              MV_METACYC_STATS               unknown_pk         /)
->Table(qw/MvTaxonCogStat              MV_TAXON_COG_STAT              unknown_pk         /)
->Table(qw/MvTaxonEcStat               MV_TAXON_EC_STAT               unknown_pk         /)
->Table(qw/MvTaxonIprStat              MV_TAXON_IPR_STAT              unknown_pk         /)
->Table(qw/MvTaxonItermsStat           MV_TAXON_ITERMS_STAT           unknown_pk         /)
->Table(qw/MvTaxonKeggCatStat          MV_TAXON_KEGG_CAT_STAT         unknown_pk         /)
->Table(qw/MvTaxonKeggModStat          MV_TAXON_KEGG_MOD_STAT         unknown_pk         /)
->Table(qw/MvTaxonKeggStat             MV_TAXON_KEGG_STAT             unknown_pk         /)
->Table(qw/MvTaxonKogStat              MV_TAXON_KOG_STAT              unknown_pk         /)
->Table(qw/MvTaxonKoStat               MV_TAXON_KO_STAT               unknown_pk         /)
->Table(qw/MvTaxonMetacycStat          MV_TAXON_METACYC_STAT          unknown_pk         /)
->Table(qw/MvTaxonPfamStat             MV_TAXON_PFAM_STAT             unknown_pk         /)
->Table(qw/MvTaxonTcStat               MV_TAXON_TC_STAT               unknown_pk         /)
->Table(qw/MvTaxonTfamStat             MV_TAXON_TFAM_STAT             unknown_pk         /)
->Table(qw/NcbiProjectsListByApid      NCBI_PROJECTS_LIST_BY_APID     unknown_pk         /)
->Table(qw/NcbiProjectsListByGoldId    NCBI_PROJECTS_LIST_BY_GOLD_ID  unknown_pk         /)
->Table(qw/NewReplaceTaxons            NEW_REPLACE_TAXONS             unknown_pk         /)
->Table(qw/NewTaxons                   NEW_TAXONS                     unknown_pk         /)
->Table(qw/NewTaxons0201               NEW_TAXONS_0201                unknown_pk         /)
->Table(qw/NewTaxons0405               NEW_TAXONS_0405                unknown_pk         /)
->Table(qw/NewTaxonsBatch              NEW_TAXONS_BATCH               unknown_pk         /)
->Table(qw/NewTaxonsMerAva             NEW_TAXONS_MER_AVA             unknown_pk         /)
->Table(qw/NewTaxonsMini1130           NEW_TAXONS_MINI_1130           unknown_pk         /)
->Table(qw/NewTaxonsPfam30             NEW_TAXONS_PFAM30              unknown_pk         /)
->Table(qw/NewTaxonsPfamkotfamRedo     NEW_TAXONS_PFAMKOTFAM_REDO     unknown_pk         /)
->Table(qw/NewTaxonsPfamv29kegg771     NEW_TAXONS_PFAMV29KEGG77_1     unknown_pk         /)
->Table(qw/NewTaxonsPfamFix            NEW_TAXONS_PFAM_FIX            unknown_pk         /)
->Table(qw/NewTaxonsTfamFix            NEW_TAXONS_TFAM_FIX            unknown_pk         /)
->Table(qw/OldTaxons                   OLD_TAXONS                     unknown_pk         /)
->Table(qw/PangenomeCount              PANGENOME_COUNT                unknown_pk         /)
->Table(qw/PangenomeCountGenes         PANGENOME_COUNT_GENES          unknown_pk         /)
->Table(qw/ParalogGroup                PARALOG_GROUP                  group_oid          /)
->Table(qw/ParalogGroupGenes           PARALOG_GROUP_GENES            unknown_pk         /)
->Table(qw/PositionalCluster           POSITIONAL_CLUSTER             group_oid          /)
->Table(qw/PositionalClusterGenes      POSITIONAL_CLUSTER_GENES       unknown_pk         /)
->Table(qw/Promotemygenes1014          PROMOTEMYGENES_1014            unknown_pk         /)
->Table(qw/RecomputeTaxons             RECOMPUTE_TAXONS               unknown_pk         /)
->Table(qw/RefseqUniprot               REFSEQ_UNIPROT                 unknown_pk         /)
->Table(qw/RemDupBc                    REM_DUP_BC                     unknown_pk         /)
->Table(qw/Repair16sGenomes            REPAIR_16S_GENOMES             unknown_pk         /)
->Table(qw/RevisedCogClusterCount      REVISED_COG_CLUSTER_COUNT      unknown_pk         /)
->Table(qw/RevisedCogCountCombined     REVISED_COG_COUNT_COMBINED     unknown_pk         /)
->Table(qw/RnaCluster                  RNA_CLUSTER                    cluster_id         /)
->Table(qw/Scaffold                    SCAFFOLD                       scaffold_oid       /)
->Table(qw/ScaffoldExtLinks            SCAFFOLD_EXT_LINKS             unknown_pk         /)
->Table(qw/ScaffoldIntergenic          SCAFFOLD_INTERGENIC            unknown_pk         /)
->Table(qw/ScaffoldMiscBindings        SCAFFOLD_MISC_BINDINGS         unknown_pk         /)
->Table(qw/ScaffoldMiscFeatures        SCAFFOLD_MISC_FEATURES         unknown_pk         /)
->Table(qw/ScaffoldNotes               SCAFFOLD_NOTES                 unknown_pk         /)
->Table(qw/ScaffoldNxFeature           SCAFFOLD_NX_FEATURE            unknown_pk         /)
->Table(qw/ScaffoldPanfoldComposition  SCAFFOLD_PANFOLD_COMPOSITION   unknown_pk         /)
->Table(qw/ScaffoldRepeats             SCAFFOLD_REPEATS               unknown_pk         /)
->Table(qw/ScaffoldSigPeptides         SCAFFOLD_SIG_PEPTIDES          unknown_pk         /)
->Table(qw/ScaffoldStats               SCAFFOLD_STATS                 scaffold_oid       /)
->Table(qw/T1                          T1                             unknown_pk         /)
->Table(qw/T2                          T2                             unknown_pk         /)
->Table(qw/T3                          T3                             unknown_pk         /)
->Table(qw/Taxon                       TAXON                          taxon_oid          /)
->Table(qw/TaxonAaStats                TAXON_AA_STATS                 taxon_oid          /)
->Table(qw/TaxonAniMatrix              TAXON_ANI_MATRIX               unknown_pk         /)
->Table(qw/TaxonAniNullPairs           TAXON_ANI_NULL_PAIRS           unknown_pk         /)
->Table(qw/TaxonCodonStats             TAXON_CODON_STATS              taxon_oid          /)
->Table(qw/TaxonCrisprDetails          TAXON_CRISPR_DETAILS           unknown_pk         /)
->Table(qw/TaxonCrisprSummary          TAXON_CRISPR_SUMMARY           unknown_pk         /)
->Table(qw/TaxonDistMatrix             TAXON_DIST_MATRIX              unknown_pk         /)
->Table(qw/TaxonExtLinks               TAXON_EXT_LINKS                unknown_pk         /)
->Table(qw/TaxonGenePrefix             TAXON_GENE_PREFIX              unknown_pk         /)
->Table(qw/TaxonNodeLite               TAXON_NODE_LITE                node_oid           /)
->Table(qw/TaxonPangenomeComposition   TAXON_PANGENOME_COMPOSITION    unknown_pk         /)
->Table(qw/TaxonQualityMeasure         TAXON_QUALITY_MEASURE          taxon_oid          /)
->Table(qw/TaxonRelatedTaxons          TAXON_RELATED_TAXONS           unknown_pk         /)
->Table(qw/TaxonReplacements           TAXON_REPLACEMENTS             unknown_pk         /)
->Table(qw/TaxonScafPrefix             TAXON_SCAF_PREFIX              unknown_pk         /)
->Table(qw/TaxonStats                  TAXON_STATS                    taxon_oid          /)
->Table(qw/TaxonStatsMerfs             TAXON_STATS_MERFS              unknown_pk         /)
->Table(qw/TdmNewTaxons                TDM_NEW_TAXONS                 unknown_pk         /)
->Table(qw/TdmOldTaxons                TDM_OLD_TAXONS                 unknown_pk         /)
->Table(qw/TempGeneNames               TEMP_GENE_NAMES                unknown_pk         /)
->Table(qw/TestKp                      TEST_KP                        unknown_pk         /)
->Table(qw/TmpGeneEnzymes              TMP_GENE_ENZYMES               unknown_pk         /)
->Table(qw/TmpPfamDomain               TMP_PFAM_DOMAIN                unknown_pk         /)
->Table(qw/TmpPfamPhylum               TMP_PFAM_PHYLUM                unknown_pk         /)
->Table(qw/TmpTaxonPfam                TMP_TAXON_PFAM                 unknown_pk         /)
->Table(qw/UnmappedGenesArchive        UNMAPPED_GENES_ARCHIVE         old_gene_oid       /)
->Table(qw/Viraltaxons                 VIRALTAXONS                    unknown_pk         /)
#->Table(qw/Yesnocv                     YESNOCV                        flag_cv            /)

## VIEWS
->Table(qw/Contact                     CONTACT                        unknown_pk         /)
# ->Table(qw/PpDatatype                  PP_DATATYPE                    unknown_pk         /)
->Table(qw/PpDataTypeView              PP_DATA_TYPE_VIEW              unknown_pk         /)
#->Table(qw/PpSubset                    PP_SUBSET                      unknown_pk         /)
->Table(qw/TaxonProdVw                 TAXON_PROD_VW                  unknown_pk         /)
->Table(qw/TaxonStatsProdVw            TAXON_STATS_PROD_VW            unknown_pk         /)
# ->Table(qw/VwGoldTaxon                 VW_GOLD_TAXON                  unknown_pk         /)
->Table(qw/VwTaxon                     VW_TAXON                       unknown_pk         /)
->Table(qw/VwTaxonSc                   VW_TAXON_SC                    unknown_pk         /)

## SYNONYMS
->Table(qw/Assertioncv                 ASSERTIONCV                    unknown_pk         /)
->Table(qw/BcExtLinks                  BC_EXT_LINKS                   unknown_pk         /)

## from img_sat

#
#	BIOCYC
#
->Table(qw/BiocycClass                BIOCYC_CLASS                  unique_id      /)
->Table(qw/BiocycClassParents         BIOCYC_CLASS_PARENTS              unknown_pk /)
->Table(qw/BiocycClassSynonyms        BIOCYC_CLASS_SYNONYMS             unknown_pk /)
->Table(qw/BiocycClassTypes           BIOCYC_CLASS_TYPES                unknown_pk /)

->Table(qw/BiocycComp                 BIOCYC_COMP                   unique_id      /)
->Table(qw/BiocycCompExtLinks         BIOCYC_COMP_EXT_LINKS             unknown_pk /)
->Table(qw/BiocycCompSynonyms         BIOCYC_COMP_SYNONYMS              unknown_pk /)
->Table(qw/BiocycCompTypes            BIOCYC_COMP_TYPES                 unknown_pk /)

->Table(qw/BiocycEnzrxn               BIOCYC_ENZRXN                 unique_id      /)
->Table(qw/BiocycEnzrxnExtLinks       BIOCYC_ENZRXN_EXT_LINKS           unknown_pk /)
->Table(qw/BiocycEnzrxnProsthGroups   BIOCYC_ENZRXN_PROSTH_GROUPS       unknown_pk /)
->Table(qw/BiocycEnzrxnSynonyms       BIOCYC_ENZRXN_SYNONYMS            unknown_pk /)

->Table(qw/BiocycPathway              BIOCYC_PATHWAY                unique_id      /)
->Table(qw/BiocycPathwayComments      BIOCYC_PATHWAY_COMMENTS           unknown_pk /)
->Table(qw/BiocycPathwayExtLinks      BIOCYC_PATHWAY_EXT_LINKS          unknown_pk /)
->Table(qw/BiocycPathwayInSpecies     BIOCYC_PATHWAY_IN_SPECIES         unknown_pk /)
->Table(qw/BiocycPathwayPwyLinks      BIOCYC_PATHWAY_PWY_LINKS          unknown_pk /)
->Table(qw/BiocycPathwaySubPwys       BIOCYC_PATHWAY_SUB_PWYS           unknown_pk /)
->Table(qw/BiocycPathwaySuperPwys     BIOCYC_PATHWAY_SUPER_PWYS         unknown_pk /)
->Table(qw/BiocycPathwayTaxonRange    BIOCYC_PATHWAY_TAXON_RANGE        unknown_pk /)
->Table(qw/BiocycPathwayTypes         BIOCYC_PATHWAY_TYPES              unknown_pk /)

->Table(qw/BiocycProtein              BIOCYC_PROTEIN                unique_id      /)
->Table(qw/BiocycProteinCatalyzes     BIOCYC_PROTEIN_CATALYZES          unknown_pk /)
->Table(qw/BiocycProteinExtLinks      BIOCYC_PROTEIN_EXT_LINKS          unknown_pk /)
->Table(qw/BiocycProteinInSpecies     BIOCYC_PROTEIN_IN_SPECIES         unknown_pk /)
->Table(qw/BiocycProteinSynonyms      BIOCYC_PROTEIN_SYNONYMS           unknown_pk /)
->Table(qw/BiocycProteinTypes         BIOCYC_PROTEIN_TYPES              unknown_pk /)

->Table(qw/BiocycReaction             BIOCYC_REACTION               unique_id      /)
->Table(qw/BiocycReactionExtLinks     BIOCYC_REACTION_EXT_LINKS         unknown_pk /)
->Table(qw/BiocycReactionInPwys       BIOCYC_REACTION_IN_PWYS           unknown_pk /)
->Table(qw/BiocycReactionLeftHand     BIOCYC_REACTION_LEFT_HAND         unknown_pk /)
->Table(qw/BiocycReactionRightHand    BIOCYC_REACTION_RIGHT_HAND        unknown_pk /)
->Table(qw/BiocycReactionSynonyms     BIOCYC_REACTION_SYNONYMS          unknown_pk /)
->Table(qw/BiocycReactionTypes        BIOCYC_REACTION_TYPES             unknown_pk /)
#
#	COG
#
->Table(qw/Cog                        COG                           cog_id         /)
->Table(qw/Cog2014                    COG2014                           unknown_pk /)
->Table(qw/CogFamilies                COG_FAMILIES                      unknown_pk /)
->Table(qw/Cogfunc2014                COGFUNC2014                       unknown_pk /)
->Table(qw/CogFunction                COG_FUNCTION                  function_code  /)
->Table(qw/CogFunctionObs             COG_FUNCTION_OBS                  unknown_pk /)
->Table(qw/CogFunctions               COG_FUNCTIONS                     unknown_pk /)
->Table(qw/CogFunctionsObs            COG_FUNCTIONS_OBS                 unknown_pk /)
->Table(qw/CogObs                     COG_OBS                           unknown_pk /)
->Table(qw/CogPathway                 COG_PATHWAY                   cog_pathway_oid/)
->Table(qw/CogPathwayCogMembers       COG_PATHWAY_COG_MEMBERS           unknown_pk /)
->Table(qw/CogSpecies                 COG_SPECIES                   species_code   /)

->Table(qw/Compound                   COMPOUND                      ext_accession  /)
->Table(qw/CompoundAliases            COMPOUND_ALIASES                  unknown_pk /)
->Table(qw/CompoundExtLinks           COMPOUND_EXT_LINKS                unknown_pk /)

->Table(qw/DbSource                   DB_SOURCE                     db_code        /)

->Table(qw/DtKoEcCogPfam              DT_KO_EC_COG_PFAM                 unknown_pk /)

->Table(qw/EggnogHierarchy            EGGNOG_HIERARCHY              eggnog_oid     /)
->Table(qw/EggnogMd52id2ont           EGGNOG_MD52ID2ONT                 unknown_pk /)
#
#	ENZYME
#
->Table(qw/Enzyme                     ENZYME                        ec_number      /)
->Table(qw/EnzymeEnzAliases           ENZYME_ENZ_ALIASES                unknown_pk /)
->Table(qw/EnzymeExtLinks             ENZYME_EXT_LINKS                  unknown_pk /)
->Table(qw/EnzymeProducts             ENZYME_PRODUCTS                   unknown_pk /)
->Table(qw/EnzymeSubstrates           ENZYME_SUBSTRATES                 unknown_pk /)

->Table(qw/GenomeProperty             GENOME_PROPERTY               prop_accession /)
->Table(qw/GenomePropertyParents      GENOME_PROPERTY_PARENTS           unknown_pk /)
#
#	GO
#
->Table(qw/GoGraphPath                GO_GRAPH_PATH                 graph_path_id  /)
->Table(qw/GoTerm                     GO_TERM                       go_id          /)
->Table(qw/GoTermParents              GO_TERM_PARENTS                   unknown_pk /)
->Table(qw/GoTermSynonyms             GO_TERM_SYNONYMS                  unknown_pk /)

->Table(qw/ImageRoi                   IMAGE_ROI                     roi_id         /)
->Table(qw/ImageRoiCompounds          IMAGE_ROI_COMPOUNDS               unknown_pk /)
->Table(qw/ImageRoiEnzymes            IMAGE_ROI_ENZYMES                 unknown_pk /)
->Table(qw/ImageRoiKoTerms            IMAGE_ROI_KO_TERMS                unknown_pk /)
->Table(qw/ImageRoiReactions          IMAGE_ROI_REACTIONS               unknown_pk /)

->Table(qw/ImgBuildHistory            IMG_BUILD_HISTORY             build_oid      /)
#
#	INTERPRO
#
->Table(qw/Interpro                   INTERPRO                      ext_accession  /)
->Table(qw/InterproGoTerms            INTERPRO_GO_TERMS                 unknown_pk /)
#
#	KEGG
#
->Table(qw/KeggGene                   KEGG_GENE                     kegg_gene_id   /)
->Table(qw/KeggGeneKoTerms            KEGG_GENE_KO_TERMS                unknown_pk /)
->Table(qw/KeggGeneNcbiGeneIds        KEGG_GENE_NCBI_GENE_IDS           unknown_pk /)
->Table(qw/KeggGeneNcbiGiNums         KEGG_GENE_NCBI_GI_NUMS            unknown_pk /)
->Table(qw/KeggGeneUniprotIds         KEGG_GENE_UNIPROT_IDS             unknown_pk /)

->Table(qw/KeggModule                 KEGG_MODULE                   module_id      /)
->Table(qw/KeggModuleCompounds        KEGG_MODULE_COMPOUNDS             unknown_pk /)
->Table(qw/KeggModuleKoTerms          KEGG_MODULE_KO_TERMS              unknown_pk /)
->Table(qw/KeggModuleReactions        KEGG_MODULE_REACTIONS             unknown_pk /)

->Table(qw/KeggPathway                KEGG_PATHWAY                  pathway_oid    /)
->Table(qw/KeggPathwayModules         KEGG_PATHWAY_MODULES              unknown_pk /)
->Table(qw/KeggPathwayRelatedPathways KEGG_PATHWAY_RELATED_PATHWAYS     unknown_pk /)

->Table(qw/KmImageRoi                 KM_IMAGE_ROI                      unknown_pk /)
->Table(qw/KmImageRoiKoTerms          KM_IMAGE_ROI_KO_TERMS             unknown_pk /)
#
#	KOG
#
->Table(qw/Kog                        KOG                           kog_id         /)
->Table(qw/KogFamilies                KOG_FAMILIES                      unknown_pk /)
->Table(qw/KogFunction                KOG_FUNCTION                  function_code  /)
->Table(qw/KogFunctions               KOG_FUNCTIONS                     unknown_pk /)
->Table(qw/KogPathway                 KOG_PATHWAY                   kog_pathway_oid/)
->Table(qw/KogPathwayKogMembers       KOG_PATHWAY_KOG_MEMBERS           unknown_pk /)
#
#	KEGG ORTHOLOGY
#
->Table(qw/KoTerm                     KO_TERM                       ko_id          /)
->Table(qw/KoTermClasses              KO_TERM_CLASSES                   unknown_pk /)
->Table(qw/KoTermCogs                 KO_TERM_COGS                      unknown_pk /)
->Table(qw/KoTermEnzymes              KO_TERM_ENZYMES                   unknown_pk /)
->Table(qw/KoTermGoIds                KO_TERM_GO_IDS                    unknown_pk /)
->Table(qw/KoTermModules              KO_TERM_MODULES                   unknown_pk /)
->Table(qw/KoTermPathways             KO_TERM_PATHWAYS                  unknown_pk /)
->Table(qw/KoTermReactions            KO_TERM_REACTIONS                 unknown_pk /)
->Table(qw/KoTermTcFamilies           KO_TERM_TC_FAMILIES               unknown_pk /)
#
#
#
->Table(qw/MpwPglCompound             MPW_PGL_COMPOUND                  unknown_pk /)
->Table(qw/MpwPglGeneGroup            MPW_PGL_GENE_GROUP                unknown_pk /)
->Table(qw/MpwPglPathway              MPW_PGL_PATHWAY                   unknown_pk /)
->Table(qw/MpwPglPathwayReaction      MPW_PGL_PATHWAY_REACTION          unknown_pk /)
->Table(qw/MpwPglProteinGroup         MPW_PGL_PROTEIN_GROUP             unknown_pk /)
->Table(qw/MpwPglReaction             MPW_PGL_REACTION                  unknown_pk /)
->Table(qw/MpwPglReactionCompounds    MPW_PGL_REACTION_COMPOUNDS        unknown_pk /)
->Table(qw/MpwPglTaxonomy             MPW_PGL_TAXONOMY                  unknown_pk /)
#
#	PFAM
#
->Table(qw/PfamClan                   PFAM_CLAN                     ext_accession  /)
->Table(qw/PfamClanPfamFamilies       PFAM_CLAN_PFAM_FAMILIES           unknown_pk /)
->Table(qw/PfamFamily                 PFAM_FAMILY                       unknown_pk /)
->Table(qw/PfamFamilyCogs             PFAM_FAMILY_COGS                  unknown_pk /)
->Table(qw/PfamFamilyExtLinks         PFAM_FAMILY_EXT_LINKS             unknown_pk /)
->Table(qw/PfamFamilyFamilies         PFAM_FAMILY_FAMILIES              unknown_pk /)
->Table(qw/PfamFamilyGenomeProperties PFAM_FAMILY_GENOME_PROPERTIES     unknown_pk /)
->Table(qw/PfamFamilyV28              PFAM_FAMILY_V28               ext_accession  /)

->Table(qw/PropertyStep               PROPERTY_STEP                 step_accession /)
->Table(qw/PropertyStepEvidences      PROPERTY_STEP_EVIDENCES           unknown_pk /)

->Table(qw/Reaction                   REACTION                      ext_accession  /)
->Table(qw/ReactionCompounds          REACTION_COMPOUNDS                unknown_pk /)
->Table(qw/ReactionEnzymes            REACTION_ENZYMES                  unknown_pk /)
->Table(qw/ReactionExtLinks           REACTION_EXT_LINKS                unknown_pk /)

->Table(qw/SeedFunctionalRole         SEED_FUNCTIONAL_ROLE          role_name      /)
#
#	TC
#
->Table(qw/TcFamily                   TC_FAMILY                     tc_family_num  /)
->Table(qw/TcFamilyCogs               TC_FAMILY_COGS                    unknown_pk /)
->Table(qw/TcFamilyGoTerms            TC_FAMILY_GO_TERMS                unknown_pk /)
->Table(qw/TcFamilyImgTerms           TC_FAMILY_IMG_TERMS               unknown_pk /)
->Table(qw/TcFamilyPfams              TC_FAMILY_PFAMS                   unknown_pk /)
->Table(qw/TcFamilyPfamsIain          TC_FAMILY_PFAMS_IAIN              unknown_pk /)
->Table(qw/TcFamilyTfams              TC_FAMILY_TFAMS                   unknown_pk /)
#
#	TIGRFAM
#
->Table(qw/Tigrfam                    TIGRFAM                       ext_accession  /)
->Table(qw/TigrfamEnzymes             TIGRFAM_ENZYMES                   unknown_pk /)
->Table(qw/TigrfamGenomeProperties    TIGRFAM_GENOME_PROPERTIES         unknown_pk /)
->Table(qw/TigrfamRoles               TIGRFAM_ROLES                     unknown_pk /)
->Table(qw/TigrRole                   TIGR_ROLE                     role_id        /)
->Table(qw/Yesnocv                    YESNOCV                       flag_cv        /)






->Table(qw/CellLocalization            CELL_LOCALIZATION              unknown_pk         /)
->Table(qw/Componentcv                 COMPONENTCV                    unknown_pk         /)
->Table(qw/ContactImgGroups            CONTACT_IMG_GROUPS             unknown_pk         /)
->Table(qw/ContactProtexpPermissions   CONTACT_PROTEXP_PERMISSIONS    unknown_pk         /)
->Table(qw/ContactRnaexpPermissions    CONTACT_RNAEXP_PERMISSIONS     unknown_pk         /)
->Table(qw/ContactRnaDataPermissions   CONTACT_RNA_DATA_PERMISSIONS   unknown_pk         /)
->Table(qw/ContactSnpExpPermissions    CONTACT_SNP_EXP_PERMISSIONS    unknown_pk         /)
->Table(qw/ContactTaxonPermissions     CONTACT_TAXON_PERMISSIONS      unknown_pk         /)
->Table(qw/DtAllPhyloTaxonStats        DT_ALL_PHYLO_TAXON_STATS       unknown_pk         /)
->Table(qw/DtPhyloTaxonStats           DT_PHYLO_TAXON_STATS           unknown_pk         /)
->Table(qw/EnvSample                   ENV_SAMPLE                     unknown_pk         /)
->Table(qw/EnvSampleEnergySource       ENV_SAMPLE_ENERGY_SOURCE       unknown_pk         /)
->Table(qw/EnvSampleGold               ENV_SAMPLE_GOLD                unknown_pk         /)
->Table(qw/EnvSampleSeqMethod          ENV_SAMPLE_SEQ_METHOD          unknown_pk         /)
->Table(qw/GeneImgFunctions            GENE_IMG_FUNCTIONS             unknown_pk         /)
->Table(qw/GeneMyimgEnzymes            GENE_MYIMG_ENZYMES             unknown_pk         /)
->Table(qw/GeneMyimgFunctions          GENE_MYIMG_FUNCTIONS           unknown_pk         /)
->Table(qw/GeneMyimgGroups             GENE_MYIMG_GROUPS              unknown_pk         /)
->Table(qw/GeneMyimgTerms              GENE_MYIMG_TERMS               unknown_pk         /)
->Table(qw/GeneSnp                     GENE_SNP                       unknown_pk         /)
->Table(qw/GoldAnalysisProject         GOLD_ANALYSIS_PROJECT          unknown_pk         /)
->Table(qw/GoldAnalysisProjectLookup2  GOLD_ANALYSIS_PROJECT_LOOKUP2  unknown_pk         /)
->Table(qw/GoldAnalysisProjectUsers    GOLD_ANALYSIS_PROJECT_USERS    unknown_pk         /)
->Table(qw/GoldSequencingProject       GOLD_SEQUENCING_PROJECT        unknown_pk         /)
->Table(qw/GoldSpCellArrangement       GOLD_SP_CELL_ARRANGEMENT       unknown_pk         /)
->Table(qw/GoldSpCollaborator          GOLD_SP_COLLABORATOR           unknown_pk         /)
->Table(qw/GoldSpDisease               GOLD_SP_DISEASE                unknown_pk         /)
->Table(qw/GoldSpEnergySource          GOLD_SP_ENERGY_SOURCE          unknown_pk         /)
->Table(qw/GoldSpGenomePublications    GOLD_SP_GENOME_PUBLICATIONS    unknown_pk         /)
->Table(qw/GoldSpHabitat               GOLD_SP_HABITAT                unknown_pk         /)
->Table(qw/GoldSpMetabolism            GOLD_SP_METABOLISM             unknown_pk         /)
->Table(qw/GoldSpPhenotype             GOLD_SP_PHENOTYPE              unknown_pk         /)
->Table(qw/GoldSpRelevance             GOLD_SP_RELEVANCE              unknown_pk         /)
->Table(qw/GoldSpSeqCenter             GOLD_SP_SEQ_CENTER             unknown_pk         /)
->Table(qw/GoldSpSeqMethod             GOLD_SP_SEQ_METHOD             unknown_pk         /)
->Table(qw/GoldSpStudyGoldId           GOLD_SP_STUDY_GOLD_ID          unknown_pk         /)
->Table(qw/Imgtermcv                   IMGTERMCV                      unknown_pk         /)
->Table(qw/ImgCompound                 IMG_COMPOUND                   unknown_pk         /)
->Table(qw/ImgCompoundActivity         IMG_COMPOUND_ACTIVITY          unknown_pk         /)
->Table(qw/ImgCompoundAliases          IMG_COMPOUND_ALIASES           unknown_pk         /)
->Table(qw/ImgCompoundExtLinks         IMG_COMPOUND_EXT_LINKS         unknown_pk         /)
->Table(qw/ImgCompoundKeggCompounds    IMG_COMPOUND_KEGG_COMPOUNDS    unknown_pk         /)
->Table(qw/ImgCompoundMeshdTree        IMG_COMPOUND_MESHD_TREE        unknown_pk         /)
->Table(qw/ImgGoldPhenotype            IMG_GOLD_PHENOTYPE             unknown_pk         /)
->Table(qw/ImgGroup                    IMG_GROUP                      unknown_pk         /)
->Table(qw/ImgGroupNews                IMG_GROUP_NEWS                 unknown_pk         /)
->Table(qw/ImgJobParamcv               IMG_JOB_PARAMCV                unknown_pk         /)
->Table(qw/ImgJobStatuscv              IMG_JOB_STATUSCV               unknown_pk         /)
->Table(qw/ImgJobTypecv                IMG_JOB_TYPECV                 unknown_pk         /)
->Table(qw/ImgPartsList                IMG_PARTS_LIST                 unknown_pk         /)
->Table(qw/ImgPartsListImgTerms        IMG_PARTS_LIST_IMG_TERMS       unknown_pk         /)
->Table(qw/ImgPathway                  IMG_PATHWAY                    unknown_pk         /)
->Table(qw/ImgPathwayAssertions        IMG_PATHWAY_ASSERTIONS         unknown_pk         /)
->Table(qw/ImgPathwayCComponents       IMG_PATHWAY_C_COMPONENTS       unknown_pk         /)
->Table(qw/ImgPathwayReactions         IMG_PATHWAY_REACTIONS          unknown_pk         /)
->Table(qw/ImgPathwayTaxons            IMG_PATHWAY_TAXONS             unknown_pk         /)
->Table(qw/ImgPathwayTComponents       IMG_PATHWAY_T_COMPONENTS       unknown_pk         /)
->Table(qw/ImgReaction                 IMG_REACTION                   unknown_pk         /)
->Table(qw/ImgReactionAssocNetworks    IMG_REACTION_ASSOC_NETWORKS    unknown_pk         /)
->Table(qw/ImgReactionAssocPaths       IMG_REACTION_ASSOC_PATHS       unknown_pk         /)
->Table(qw/ImgReactionAssocRxns        IMG_REACTION_ASSOC_RXNS        unknown_pk         /)
->Table(qw/ImgReactionCatalysts        IMG_REACTION_CATALYSTS         unknown_pk         /)
->Table(qw/ImgReactionCComponents      IMG_REACTION_C_COMPONENTS      unknown_pk         /)
->Table(qw/ImgReactionExtLinks         IMG_REACTION_EXT_LINKS         unknown_pk         /)
->Table(qw/ImgReactionTComponents      IMG_REACTION_T_COMPONENTS      unknown_pk         /)
->Table(qw/ImgTerm                     IMG_TERM                       unknown_pk         /)
->Table(qw/ImgTermChildren             IMG_TERM_CHILDREN              unknown_pk         /)
->Table(qw/ImgTermEnzymes              IMG_TERM_ENZYMES               unknown_pk         /)
->Table(qw/ImgTermGraphPath            IMG_TERM_GRAPH_PATH            unknown_pk         /)
->Table(qw/ImgTermSynonyms             IMG_TERM_SYNONYMS              unknown_pk         /)
->Table(qw/MeshDtree                   MESH_DTREE                     unknown_pk         /)
->Table(qw/MethExp                     METH_EXP                       unknown_pk         /)
->Table(qw/MethExperiment              METH_EXPERIMENT                unknown_pk         /)
->Table(qw/MethExperimentExtLinks      METH_EXPERIMENT_EXT_LINKS      unknown_pk         /)
->Table(qw/MethExperimentPublications  METH_EXPERIMENT_PUBLICATIONS   unknown_pk         /)
->Table(qw/MethFunctionCoverage        METH_FUNCTION_COVERAGE         unknown_pk         /)
->Table(qw/MethModification            METH_MODIFICATION              unknown_pk         /)
->Table(qw/MethMotif                   METH_MOTIF                     unknown_pk         /)
->Table(qw/MethMotifSummary            METH_MOTIF_SUMMARY             unknown_pk         /)
->Table(qw/MethSample                  METH_SAMPLE                    unknown_pk         /)
->Table(qw/MethStats                   METH_STATS                     unknown_pk         /)
->Table(qw/MsExperiment                MS_EXPERIMENT                  unknown_pk         /)
->Table(qw/MsExperimentExtLinks        MS_EXPERIMENT_EXT_LINKS        unknown_pk         /)
->Table(qw/MsExperimentPublications    MS_EXPERIMENT_PUBLICATIONS     unknown_pk         /)
->Table(qw/MsExperimentSop             MS_EXPERIMENT_SOP              unknown_pk         /)
->Table(qw/MsPeptide                   MS_PEPTIDE                     unknown_pk         /)
->Table(qw/MsPeptideOld                MS_PEPTIDE_OLD                 unknown_pk         /)
->Table(qw/MsProtein                   MS_PROTEIN                     unknown_pk         /)
->Table(qw/MsProteinImgGenes           MS_PROTEIN_IMG_GENES           unknown_pk         /)
->Table(qw/MsProteinImgGenesOld        MS_PROTEIN_IMG_GENES_OLD       unknown_pk         /)
->Table(qw/MsProteinOld                MS_PROTEIN_OLD                 unknown_pk         /)
->Table(qw/MsSample                    MS_SAMPLE                      unknown_pk         /)
->Table(qw/MsSampleExtLinks            MS_SAMPLE_EXT_LINKS            unknown_pk         /)
->Table(qw/MsSampleSop                 MS_SAMPLE_SOP                  unknown_pk         /)
->Table(qw/Mygene                      MYGENE                         unknown_pk         /)
->Table(qw/MygeneImgGroups             MYGENE_IMG_GROUPS              unknown_pk         /)
->Table(qw/MygeneTerms                 MYGENE_TERMS                   unknown_pk         /)
->Table(qw/MyimgBioClusterNp           MYIMG_BIO_CLUSTER_NP           unknown_pk         /)
->Table(qw/MyimgJob                    MYIMG_JOB                      unknown_pk         /)
->Table(qw/MyimgJobParameters          MYIMG_JOB_PARAMETERS           unknown_pk         /)
->Table(qw/MyimgJobUsers               MYIMG_JOB_USERS                unknown_pk         /)
->Table(qw/NaturalProduct              NATURAL_PRODUCT                unknown_pk         /)
->Table(qw/NpActivityCv                NP_ACTIVITY_CV                 unknown_pk         /)
->Table(qw/NpBiosynthesisSource        NP_BIOSYNTHESIS_SOURCE         unknown_pk         /)
->Table(qw/NpSimilarity                NP_SIMILARITY                  unknown_pk         /)
->Table(qw/PathwayNetwork              PATHWAY_NETWORK                unknown_pk         /)
->Table(qw/PathwayNetworkCComponents   PATHWAY_NETWORK_C_COMPONENTS   unknown_pk         /)
->Table(qw/PathwayNetworkImgPathways   PATHWAY_NETWORK_IMG_PATHWAYS   unknown_pk         /)
->Table(qw/PathwayNetworkParents       PATHWAY_NETWORK_PARENTS        unknown_pk         /)
->Table(qw/PathwayNetworkPartsLists    PATHWAY_NETWORK_PARTS_LISTS    unknown_pk         /)
->Table(qw/PathwayNetworkTaxons        PATHWAY_NETWORK_TAXONS         unknown_pk         /)
->Table(qw/PathwayNetworkTComponents   PATHWAY_NETWORK_T_COMPONENTS   unknown_pk         /)
->Table(qw/PhenotypeRule               PHENOTYPE_RULE                 unknown_pk         /)
->Table(qw/PhenotypeRuleTaxons         PHENOTYPE_RULE_TAXONS          unknown_pk         /)
->Table(qw/ProjectInfo                 PROJECT_INFO                   unknown_pk         /)
->Table(qw/ProjectInfoBodySites        PROJECT_INFO_BODY_SITES        unknown_pk         /)
->Table(qw/ProjectInfoDataLinks        PROJECT_INFO_DATA_LINKS        unknown_pk         /)
->Table(qw/ProjectInfoDiseases         PROJECT_INFO_DISEASES          unknown_pk         /)
->Table(qw/ProjectInfoEcotypes         PROJECT_INFO_ECOTYPES          unknown_pk         /)
->Table(qw/ProjectInfoGold             PROJECT_INFO_GOLD              unknown_pk         /)
->Table(qw/ProjectInfoPhenotypes       PROJECT_INFO_PHENOTYPES        unknown_pk         /)
->Table(qw/ProjectInfoProjectRelevance PROJECT_INFO_PROJECT_RELEVANCE unknown_pk         /)
->Table(qw/ProjectInfoRelevances       PROJECT_INFO_RELEVANCES        unknown_pk         /)
->Table(qw/PublicSet                   PUBLIC_SET                     unknown_pk         /)
->Table(qw/RnaseqDataset               RNASEQ_DATASET                 unknown_pk         /)
->Table(qw/RnaseqDatasetStats          RNASEQ_DATASET_STATS           unknown_pk         /)
->Table(qw/RnaseqExperiment            RNASEQ_EXPERIMENT              unknown_pk         /)
->Table(qw/RnaseqExperimentExtLinks    RNASEQ_EXPERIMENT_EXT_LINKS    unknown_pk         /)
->Table(qw/RnaseqExperimentPubs        RNASEQ_EXPERIMENT_PUBS         unknown_pk         /)
->Table(qw/RnaseqExperimentSop         RNASEQ_EXPERIMENT_SOP          unknown_pk         /)
->Table(qw/RnaseqExperimentStats       RNASEQ_EXPERIMENT_STATS        unknown_pk         /)
->Table(qw/RnaseqExpression            RNASEQ_EXPRESSION              unknown_pk         /)
->Table(qw/RnaseqExpressionNew         RNASEQ_EXPRESSION_NEW          unknown_pk         /)
->Table(qw/RnaseqSample                RNASEQ_SAMPLE                  unknown_pk         /)
->Table(qw/RnaseqSampleExtLinks        RNASEQ_SAMPLE_EXT_LINKS        unknown_pk         /)
->Table(qw/RnaseqSampleSop             RNASEQ_SAMPLE_SOP              unknown_pk         /)
->Table(qw/Statuscv                    STATUSCV                       unknown_pk         /)
->Table(qw/Submission                  SUBMISSION                     unknown_pk         /)
->Table(qw/SubmissionDataFiles         SUBMISSION_DATA_FILES          unknown_pk         /)
->Table(qw/SubmissionImgContacts       SUBMISSION_IMG_CONTACTS        unknown_pk         /)
->Table(qw/SubmissionSamples           SUBMISSION_SAMPLES             unknown_pk         /)
->Table(qw/SubmissionStatuscv          SUBMISSION_STATUSCV            unknown_pk         /)
->Table(qw/TaxonCogCount               TAXON_COG_COUNT                unknown_pk         /)
->Table(qw/TaxonEcCount                TAXON_EC_COUNT                 unknown_pk         /)
->Table(qw/TaxonKoCount                TAXON_KO_COUNT                 unknown_pk         /)
->Table(qw/TaxonPfamCount              TAXON_PFAM_COUNT               unknown_pk         /)
->Table(qw/TaxonTigrCount              TAXON_TIGR_COUNT               unknown_pk         /)
->Table(qw/TaxonUpdateRequest          TAXON_UPDATE_REQUEST           unknown_pk         /)

## views!
->Table(qw/AnnotBiocycPathway ANNOT_BIOCYC_PATHWAY  unknown_pk/)
->Association(
	[qw/Gene			gene					1	gene_oid /],
	[qw/AnnotBiocycPathway	annot_biocyc_pathways	*	gene_oid /])

->Table(qw/AnnotCog	ANNOT_COG	unknown_pk /)
->Association(
	[qw/Gene			gene		1	gene_oid /],
	[qw/AnnotCog		annot_cogs	*	gene_oid /])

->Table(qw/AnnotEnzyme	ANNOT_ENZYME	unknown_pk /)
->Association(
	[qw/Gene			gene			1	gene_oid /],
	[qw/AnnotEnzyme		annot_enzymes	*	gene_oid /])

->Table(qw/AnnotGo	ANNOT_GO	unknown_pk /)	# no scaff, taxon
->Association(
	[qw/Gene			gene		1	gene_oid /],
	[qw/AnnotGo			annot_go	*	gene_oid /])

->Table(qw/AnnotImgTerm	ANNOT_IMG_TERM	unknown_pk /)
->Association(
	[qw/Gene			gene			1	gene_oid /],
	[qw/AnnotImgTerm	annot_img_terms	*	gene_oid /])

->Table(qw/AnnotKeggModule	ANNOT_KEGG_MODULE	unknown_pk /)
->Association(
	[qw/Gene			gene				1	gene_oid /],
	[qw/AnnotKeggModule	annot_kegg_modules	*	gene_oid /])

->Table(qw/AnnotKeggPathway	ANNOT_KEGG_PATHWAY	unknown_pk /)
->Association(
	[qw/Gene			gene				1	gene_oid /],
	[qw/AnnotKeggPathway	annot_kegg_pathways	*	gene_oid /])

->Table(qw/AnnotKo	ANNOT_KO	unknown_pk /)
->Association(
	[qw/Gene			gene			1	gene_oid /],
	[qw/AnnotKo		annot_ko_terms	*	gene_oid /])

->Table(qw/AnnotKog		ANNOT_KOG	unknown_pk /)
->Association(
	[qw/Gene			gene		1	gene_oid /],
	[qw/AnnotKog		annot_kogs	*	gene_oid /])

->Table(qw/AnnotPdb		ANNOT_PDB	unknown_pk /)
->Association(
	[qw/Gene			gene		1	gene_oid /],
	[qw/AnnotPdb		annot_pdbs	*	gene_oid /])

->Table(qw/AnnotSeed	ANNOT_SEED	unknown_pk /)
->Association(
	[qw/Gene			gene		1	gene_oid /],
	[qw/AnnotSeed		annot_seeds	*	gene_oid /])

->Table(qw/AnnotTc		ANNOT_TC	unknown_pk /)
->Association(
	[qw/Gene			gene		1	gene_oid /],
	[qw/AnnotTc			annot_tcs	*	gene_oid /])

->Table(qw/AnnotTigrfam	ANNOT_TIGRFAM	unknown_pk /)
->Association(
	[qw/Gene			gene			1	gene_oid /],
	[qw/AnnotTigrfam	annot_tigrfams	*	gene_oid /])

->Table(qw/AnnotXref	ANNOT_XREF	unknown_pk /)
->Association(
	[qw/Gene			gene		1	gene_oid /],
	[qw/AnnotXref		annot_xrefs	*	gene_oid /])

#---------------------------------------------------------------------#
#                      ASSOCIATION DECLARATIONS                       #
#---------------------------------------------------------------------#
#     Class                       Role                             Mult Join
#     =====                       ====                             ==== ====
->Composition(
  [qw/Bin                         bin                              1    bin_oid              /],
  [qw/BinScaffolds                bin_scaffolds                    *    bin_oid              /])

->Association(
  [qw/BinMethod                   bin_method                       1    bin_method_oid       /],
  [qw/Bin                         bins                             *    bin_method           /])

->Association(
  [qw/DbSource                    db_source                        1    db_code              /],
  [qw/GeneExtLinks                gene_ext_links                   *    db_name              /])

->Association(
  [qw/DbSource                    db_source                        1    db_code              /],
  [qw/GenePdbXrefs                gene_pdb_xrefs                   *    db_name              /])

->Association(
  [qw/DbSource                    db_source                        1    db_code              /],
  [qw/GeneXrefFamilies            gene_xref_families               *    db_name              /])

->Association(
  [qw/DbSource                    db_source                        1    db_code              /],
  [qw/Scaffold                    scaffolds                        *    db_source            /])

->Association(
  [qw/DbSource                    db_source                        1    db_code              /],
  [qw/ScaffoldExtLinks            scaffold_ext_links               *    db_name              /])

->Association(
  [qw/DbSource                    db_source                        1    db_code              /],
  [qw/TaxonExtLinks               taxon_ext_links                  *    db_name              /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/AltTranscript               alt_transcripts                  *    gene                 /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/BbhClusterMemberGenes       bbh_cluster_member_genes         *    member_genes         /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneAliases                 gene_aliases                     *    gene_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneCassetteGenes           gene_cassette_genes              *    gene                 /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneCogGroups               gene_cog_groups                  *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneEggnogs                 gene_eggnogs                     *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneEnzymes                 gene_enzymes                     *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneEssentialGenes          gene_essential_genes             *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneExceptions              gene_exceptions                  *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneExtLinks                gene_ext_links                   *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneFeatureTags             gene_feature_tags                *    gene_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneFusionComponents        gene_fusion_components           *    component            /])

->Composition(
  [qw/Gene                        gene_2                           1    gene_oid             /],
  [qw/GeneFusionComponents        gene_fusion_components_2         *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneGoTerms                 gene_go_terms                    *    gene_oid             /])

->Composition(
  [qw/GeneGoTerms                 gene_go_terms                    1    go_id      /],
  [qw/GoTerm                      go_term                          *    go_id      /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneImgInterproHits         gene_img_interpro_hits           *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneKogGroups               gene_kog_groups                  *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneNotes                   gene_notes                       *    gene_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneOrthologs               gene_orthologs                   *    ortholog             /])

->Composition(
  [qw/Gene                        gene_2                           1    gene_oid             /],
  [qw/GeneOrthologs               gene_orthologs_2                 *    gene_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GenePangeneComposition      gene_pangene_compositions        *    pangene_composition  /])

->Composition(
  [qw/Gene                        gene_2                           1    gene_oid             /],
  [qw/GenePangeneComposition      gene_pangene_compositions_2      *    gene_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneParalogs                gene_paralogs                    *    paralog              /])

->Composition(
  [qw/Gene                        gene_2                           1    gene_oid             /],
  [qw/GeneParalogs                gene_paralogs_2                  *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GenePdbXrefs                gene_pdb_xrefs                   *    gene_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GenePrevVersions            gene_prev_versions               *    prev_version         /])

->Composition(
  [qw/Gene                        gene_2                           1    gene_oid             /],
  [qw/GenePrevVersions            gene_prev_versions_2             *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneReplacements            gene_replacements                *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneRnaClusters             gene_rna_clusters                *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneSeedNames               gene_seed_names                  *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneSigPeptides             gene_sig_peptides                *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneSwissprotNames          gene_swissprot_names             *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneTcFamilies              gene_tc_families                 *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneTigrfams                gene_tigrfams                    *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneTmhmmHits               gene_tmhmm_hits                  *    gene_oid             /])

->Composition(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/GeneXrefFamilies            gene_xref_families               *    gene_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/ImgClusterMemberGenes       img_cluster_member_genes         *    member_genes         /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/PangenomeCountGenes         pangenome_count_genes            *    gene                 /])

->Association(
  [qw/Gene                        gene_2                           1    gene_oid             /],
  [qw/PangenomeCountGenes         pangenome_count_genes_2          *    pangene              /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/ParalogGroupGenes           paralog_grp_genes              *    genes                /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/PositionalClusterGenes      positional_cluster_genes         *    genes                /])

->Association(
  [qw/Gene                        gene                             1    gene_oid             /],
  [qw/ScaffoldStats               scaffold_stats                   *    first_cds            /])

->Association(
  [qw/ImgOrfType                  orf_types                        1    orf_type             /],
  [qw/Gene                        genes                            *    img_orf_type         /])

->Association(
  [qw/Gene                        gene                             1    gene_oid  /],
  [qw/GeneFragCoords              gene_frag_coords                 *    gene_oid  /])

->Association(
  [qw/GeneCassette                gene_cassette                    1    cassette_oid             /],
  [qw/GeneCassetteGenes           gene_cassette_genes              *    cassette_oid             /])

->Association(
  [qw/Gene                        gene                             1    gene_oid  /],
  [qw/BioClusterFeaturesNew       bio_cluster_features_new         *    gene_oid  /])

->Composition(
  [qw/BioClusterNew               bio_cluster_new                  1    cluster_id  /],
  [qw/BioClusterFeaturesNew       bio_cluster_features_new         *    cluster_id  /])

->Composition(
  [qw/ParalogGroup                paralog_grp                    1    group_oid            /],
  [qw/ParalogGroupGenes           paralog_grp_genes              *    group_oid            /])

->Association(
  [qw/RnaCluster                  rna_cluster                      1    cluster_id           /],
  [qw/GeneRnaClusters             gene_rna_clusters                *    cluster_id           /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/BinScaffolds                bin_scaffolds                    *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/Gene                        genes                            *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneCassette                gene_cassettes                   *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneCassettePanfolds        gene_cassette_panfolds           *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneCogGroups               gene_cog_groups                  *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneImgInterproHits         gene_img_interpro_hits           *    taxon                /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneKogGroups               gene_kog_groups                  *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneSeedNames               gene_seed_names                  *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneTcFamilies              gene_tc_families                 *    scaffold             /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/GeneTigrfams                gene_tigrfams                    *    scaffold             /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldExtLinks            scaffold_ext_links               *    scaffold_oid         /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldIntergenic          scaffold_intergenics             *    scaffold_oid         /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldMiscBindings        scaffold_misc_bindings           *    scaffold_oid         /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldMiscFeatures        scaffold_misc_features           *    scaffold_oid         /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldNotes               scaffold_notes                   *    scaffold_oid         /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldNxFeature           scaffold_nx_features             *    scaffold_oid         /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldPanfoldComposition  scaffold_panfold_compositions    *    scaffold_oid         /])

->Association(
  [qw/Scaffold                    scaffold_2                       1    scaffold_oid         /],
  [qw/ScaffoldPanfoldComposition  scaffold_panfold_compositions_2  *    panfold_composition  /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldRepeats             scaffold_repeats                 *    scaffold_oid         /])

->Composition(
  [qw/Scaffold                    scaffold                         1    scaffold_oid         /],
  [qw/ScaffoldSigPeptides         scaffold_sig_peptides            *    scaffold_oid         /])

->Association(
  [qw/Scaffold                    scaffold                         1    scaffold_oid            /],
  [qw/ScaffoldStats               scaffold_stats                 0..1   scaffold_oid /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/Assembly                    assemblies                       *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/BinScaffolds                bin_scaffolds                    *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/BioCluster                  bio_clusters                     *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/CassetteBoxCassettesBbh     cassette_box_cassettes_bbhs      *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/CassetteBoxCassettesCog     cassette_box_cassettes_cogs      *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/CassetteBoxCassettesPfam    cassette_box_cassettes_pfams     *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/Gene                        genes                            *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneCassette                gene_cassettes                   *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneCassettePanfolds        gene_cassette_panfolds           *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneCogGroups               gene_cog_groups                  *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneFusionComponents        gene_fusion_components           *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneImgInterproHits         gene_img_interpro_hits           *    scaffold             /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneKogGroups               gene_kog_groups                  *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneOrthologs               gene_orthologs                   *    query_taxon          /])

->Association(
  [qw/Taxon                       taxon_2                          1    taxon_oid            /],
  [qw/GeneOrthologs               gene_orthologs_2                 *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneSeedNames               gene_seed_names                  *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneTcFamilies              gene_tc_families                 *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/GeneTigrfams                gene_tigrfams                    *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/PangenomeCount              pangenome_counts                 *    taxon_oid            /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/PangenomeCountGenes         pangenome_count_genes            *    taxon_oid            /])

->Association(
  [qw/Taxon                       taxon_2                          1    taxon_oid            /],
  [qw/PangenomeCountGenes         pangenome_count_genes_2          *    pangenome_taxon      /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/ParalogGroup                paralog_grps                   *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/Scaffold                    scaffolds                        *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/ScaffoldStats               scaffold_stats                   *    taxon                /])

->Composition(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/TaxonDistMatrix             taxon_dist_matrixes              *    taxon_oid            /])

->Association(
  [qw/Taxon                       taxon_2                          1    taxon_oid            /],
  [qw/TaxonDistMatrix             taxon_dist_matrixes_2            *    paired_taxon         /])

->Composition(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/TaxonExtLinks               taxon_ext_links                  *    taxon_oid            /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/TaxonNodeLite               taxon_node_lites                 *    taxon                /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/TaxonPangenomeComposition   taxon_pangenome_compositions     *    pangenome_composition/])

->Composition(
  [qw/Taxon                       taxon_2                          1    taxon_oid            /],
  [qw/TaxonPangenomeComposition   taxon_pangenome_compositions_2   *    taxon_oid            /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/TaxonRelatedTaxons          taxon_related_taxons             *    related_taxons       /])

->Composition(
  [qw/Taxon                       taxon_2                          1    taxon_oid            /],
  [qw/TaxonRelatedTaxons          taxon_related_taxons_2           *    taxon_oid            /])

->Composition(
  [qw/Taxon                       taxon                            1    taxon_oid            /],
  [qw/TaxonReplacements           taxon_replacements               *    taxon_oid            /])

->Association(
  [qw/Taxon                       taxon                            1    taxon_oid      /],
  [qw/TaxonStats                  taxon_stats                   0..1    taxon_oid      /])

->Association(
  [qw/TaxonNodeLite               taxon_node_lite                  1    node_oid             /],
  [qw/TaxonNodeLite               taxon_node_lites                 *    parent               /])

->Association(
  [qw/Yesnocv                     yesnocv                          1    flag_cv              /],
  [qw/Bin                         bins                             *    is_default           /])

->Association(
  [qw/Yesnocv                     yesnocv                          1    flag_cv              /],
  [qw/Gene                        genes                            *    is_pseudogene        /])

->Association(
  [qw/Yesnocv                     yesnocv_2                        1    flag_cv              /],
  [qw/Gene                        genes_2                          *    is_proxygene         /])

->Association(
  [qw/Yesnocv                     yesnocv_3                        1    flag_cv              /],
  [qw/Gene                        genes_3                          *    auto_translation     /])

->Association(
  [qw/Yesnocv                     yesnocv_4                        1    flag_cv              /],
  [qw/Gene                        genes_4                          *    is_pending           /])

->Association(
  [qw/Yesnocv                     yesnocv_5                        1    flag_cv              /],
  [qw/Gene                        genes_5                          *    is_low_quality       /])

->Association(
  [qw/Yesnocv                     yesnocv_6                        1    flag_cv              /],
  [qw/Gene                        genes_6                          *    obsolete_flag        /])

->Association(
  [qw/Yesnocv                     yesnocv_7                        1    flag_cv              /],
  [qw/Gene                        genes_7                          *    is_partial_w         /])

->Association(
  [qw/Yesnocv                     yesnocv                          1    flag_cv              /],
  [qw/GeneEnzymes                 gene_enzymes                     *    img_ec_flag          /])

->Association(
  [qw/Yesnocv                     yesnocv                          1    flag_cv              /],
  [qw/GeneEssentialGenes          gene_essential_genes             *    essentiality         /])

->Association(
  [qw/Yesnocv                     yesnocv                          1    flag_cv              /],
  [qw/RnaCluster                  rna_clusters                     *    obsolete_flag        /])

->Association(
  [qw/Yesnocv                     yesnocv                          1    flag_cv              /],
  [qw/Taxon                       taxons                           *    img_ec_flag          /])

->Association(
  [qw/Yesnocv                     yesnocv_2                        1    flag_cv              /],
  [qw/Taxon                       taxons_2                         *    img_product_flag     /])

->Association(
  [qw/Yesnocv                     yesnocv_3                        1    flag_cv              /],
  [qw/Taxon                       taxons_3                         *    is_std_reference     /])

->Association(
  [qw/Yesnocv                     yesnocv_4                        1    flag_cv              /],
  [qw/Taxon                       taxons_4                         *    is_proxygene_set     /])

->Association(
  [qw/Yesnocv                     yesnocv_5                        1    flag_cv              /],
  [qw/Taxon                       taxons_5                         *    is_public            /])

->Association(
  [qw/Yesnocv                     yesnocv_6                        1    flag_cv              /],
  [qw/Taxon                       taxons_6                         *    is_pangenome         /])

->Association(
  [qw/Yesnocv                     yesnocv_7                        1    flag_cv              /],
  [qw/Taxon                       taxons_7                         *    edit_flag            /])

->Association(
  [qw/Yesnocv                     yesnocv_8                        1    flag_cv              /],
  [qw/Taxon                       taxons_8                         *    is_low_quality       /])

->Association(
  [qw/Yesnocv                     yesnocv_9                        1    flag_cv              /],
  [qw/Taxon                       taxons_9                         *    in_file              /])

->Association(
  [qw/Yesnocv                     yesnocv_10                       1    flag_cv              /],
  [qw/Taxon                       taxons_10                        *    is_replaced          /])

->Association(
  [qw/Yesnocv                     yesnocv_11                       1    flag_cv              /],
  [qw/Taxon                       taxons_11                        *    is_big_euk           /])

->Association(
  [qw/Yesnocv                     yesnocv_12                       1    flag_cv         /],
  [qw/Taxon                       taxons_12                        *    obsolete_flag   /])

->Association(
  [qw/Cog                         cog                              1    cog_id          /],
  [qw/GeneCogGroups               gene_cog_groups                  *    cog_id        /])

->Association(
  [qw/Kog                         kog                              1    kog_id          /],
  [qw/GeneKogGroups               gene_kog_groups                  *    kog_id          /])
;

DataModel::IMG_Core->metadm->define_type(
	name     => 'Distance',
	handlers => {
		from_DB  => sub {
			my ($col_val, $obj, $col_name, $handler) = @_;
			if ($col_val) {
				my $nor_m = IMG::Model::UnitConverter::distance_in_m( $col_val );
				if ($nor_m) {
					$_[0] = $nor_m;
				}
				else {
					$obj->{ $col_name ."_string"} = $col_val;
					$_[0] = undef;
				}
			}
		},
#    to_DB    => sub { },
#    validate => sub {$_[0] =~ /1?\d?\d/}),
  });

DataModel::IMG_Core->metadm->define_type(
	name  => 'GenericClade',
	handlers => {
		from_DB => sub {
			my ($col_val, $obj, $col_name, $handler) = @_;
			if ($col_val) {
				log_debug { "args: col value: $col_val, col name: $col_name, handler: $handler, obj: " . Dumper $obj; };
				if ($col_name eq 'generic_clade') {
					$col_val = DataModel::IMG_Core::coerce_clade( $col_val );
				}
				$_[0] = $col_val;
			}
		},
	});

DataModel::IMG_Core->metadm->define_type(
	name => 'LatLng',
	handlers => {
		from_DB => sub { $_[0] = IMG::Model::UnitConverter::convertLatLong( $_[0] ) if $_[0]; },
	});

DataModel::IMG_Core->metadm->define_type(
	name => 'EcoNorm',
	handlers => {
		from_DB => sub { $_[0] = ucfirst( lc($_[0]) ) if $_[0] },
	});

DataModel::IMG_Core->metadm->define_type(
	name => 'Date',
	handlers => {
		fromDB => sub {
#			my $t = Time::Piece->strptime( shift, '%Y-%m-%d' );
			my $t = Time::Piece->strptime( shift, '%d-%b-%Y' );
			log_debug { 'col handler for date; t: ' . $t; };

			return $t->strftime('%d %b %Y');
		}
	});

# DataModel::IMG_Core->metadm->define_table(
# 	class       => 'GoTerms',
# 	db_name     => 'GENE_GO_TERMS INNER JOIN GO_TERM ON gene_go_terms.go_id = go_term.go_id',
# #	db_name     => 'GENE_GO_TERMS => go_term',
# 	where       => { 'go_term.go_type' => "molecular_function" },
# 	default_columns => 'gene_oid, go_evidence, reference, go_term.*',
# 	parents     => [ map { DataModel::IMG_Core->metadm->table($_) } qw( GeneGoTerms GoTerm ) ],
# );
#
# DataModel::IMG_Core->metadm->define_table(
# 	class       => 'CogTerms',
# 	db_name     => 'GENE_COG_GROUPS INNER JOIN COG ON gene_cog_groups.cog = cog.cog_id',
# 	default_columns => 'gene_oid, cog.*',
# 	parents     => [ map { DataModel::IMG_Core->metadm->table($_) } qw( GeneCogGroups Cog ) ],
# );
#
# DataModel::IMG_Core->metadm->define_table(
# 	class       => 'KogTerms',
# 	db_name     => 'GENE_KOG_GROUPS INNER JOIN KOG ON gene_kog_groups.kog = kog.kog_id',
# 	default_columns => 'gene_oid, kog.*',
# 	parents     => [ map { DataModel::IMG_Core->metadm->table($_) } qw( GeneKogGroups Kog ) ],
# );
#


# DataModel::IMG_Core->View(
# 	'GoTerms',
# 	'gene_oid, go_evidence, go_term.*',
# 	'GENE_GO_TERMS => go_term',
# 	{ 'go_term.go_type' => "molecular_function" },
# #	[ map { DataModel::IMG_Core->metadm->table($_) }
# 		qw( GeneGoTerms GoTerm )
# #	]
# 	);


# DataModel::IMG_Core->Composition(
#   [qw/Gene                        g                                1    gene_oid        /],
#   [qw/GoTerms                     go_terms                         *    gene_oid        /]);
#
# DataModel::IMG_Core->Composition(
#   [qw/Gene                        g                                1    gene_oid        /],
#   [qw/CogTerms                    cog_terms                        *    gene_oid        /]);
#
# DataModel::IMG_Core->Composition(
#   [qw/Gene                        g                                1    gene_oid        /],
#   [qw/KogTerms                    kog_terms                        *    gene_oid        /]);

=cut

DataModel::IMG_Core->metadm->define_table(
  class       => 'GoldApGenbank',
  db_name     => 'GOLD_AP_GENBANK',
  primary_key => 'id',
);

=cut

DataModel::IMG_Core->metadm->define_table(
	class       => 'VwGoldTaxon',
	db_name     => 'VW_GOLD_TAXON',
	primary_key => 'gold_id',
	column_types => {
#		GenericClade => [ qw( clade generic_clade ) ],
		Distance     => [ qw( altitude depth ) ],
		LatLng       => [ qw( latitude longitude )],
		EcoNorm      => [ qw( ecosystem_subtype )],
	},
);

=cut

# DataModel::IMG_Core->metadm->define_table(
# 	class       => 'ContactTaxonPermissions',
# 	db_name     => 'CONTACT_TAXON_PERMISSIONS',
# );

# DataModel::IMG_Core->metadm->define_table(
# 	class       => 'RnaSeqDataset',
# 	db_name     => 'RNASEQ_DATASET',
# );

=cut


DataModel::IMG_Core
#---------------------------------------------------------------------#
#                      ASSOCIATION DECLARATIONS                       #
#---------------------------------------------------------------------#
#     Class                      Role                         Mult Join
#     =====                      ====                         ==== ====

# gap.submission_type, gap.gold_analysis_project_type
# from gold_analysis_project gap
# where gap.gold_id = ?
->Association(
  [qw/GoldAnalysisProject        analysis_project            0..1 gold_id  /],
  [qw/GoldSequencingProject      sequencing_project          *    gold_id  /])

->Association(
  [qw/GoldAnalysisProject        reference_gold_ap            0..1 gold_analysis_project_id/],
  [qw/GoldAnalysisProject        gold_analysis_projects       *    reference_gold_ap_id    /])

->Association(
  [qw/GoldAnalysisProject        goldanaproj                  1    gold_analysis_project_id/],
  [qw/Taxon                      taxa                         *    analysis_project_id     /])

# ->Association(
#   [qw/GoldAnalysisProject        gold_analysis_project        0..1 gold_analysis_project_id/],
#   [qw/GoldApGenbank              gold_ap_genbanks             *    gold_analysis_project_id/])

->Association(
  [qw/GoldSequencingProject      goldseqproj                  1    gold_id             /],
  [qw/Taxon                      taxa                         *    sequencing_gold_id  /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpGenomePublications   gold_sp_genome_publications  *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpHabitat              gold_sp_habitats             *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpEnergySource         gold_sp_energy_sources       *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpPhenotype            gold_sp_phenotypes           *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpSeqCenter            gold_sp_seq_centers          *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpSeqMethod            gold_sp_seq_methods          *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpRelevance            gold_sp_relevances           *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpCellArrangement      gold_sp_cell_arrangements    *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpMetabolism           gold_sp_metabolisms          *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpStudyGoldId          gold_sp_study_gold_ids       *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpCollaborator         gold_sp_collaborators        *    gold_id                 /])

->Association(
  [qw/GoldSequencingProject      gold                         1    gold_id                 /],
  [qw/GoldSpDisease              gold_sp_diseases             *    gold_id                 /])

# add in links for the VwGoldTaxon table->Association(
->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpGenomePublications   gold_sp_genome_publications  *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpHabitat              gold_sp_habitats             *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpEnergySource         gold_sp_energy_sources       *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpPhenotype            gold_sp_phenotypes           *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpSeqCenter            gold_sp_seq_centers          *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpSeqMethod            gold_sp_seq_methods          *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpRelevance            gold_sp_relevances           *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpCellArrangement      gold_sp_cell_arrangements    *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpMetabolism           gold_sp_metabolisms          *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpStudyGoldId          gold_sp_study_gold_ids       *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpCollaborator         gold_sp_collaborators        *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    gold_id                 /],
  [qw/GoldSpDisease              gold_sp_diseases             *    gold_id                 /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    taxon_oid      /],
  [qw/TaxonExtLinks              taxon_ext_links              *    taxon_oid      /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    taxon_oid      /],
  [qw/Gene                       genes                        *    taxon          /])

->Association(
  [qw/VwGoldTaxon                gold_tax                     1    taxon_oid      /],
  [qw/Scaffold                   scaffold                     *    taxon          /])

->Association(
  [qw/PpDataTypeView             dataset_type                 1    taxon_oid      /],
  [qw/Taxon                      taxa                         1    taxon_oid      /])

->Association(
  [qw/PpDataTypeView             dataset_type                 1    taxon_oid      /],
  [qw/VwGoldTaxon                gold_tax                     1    taxon_oid      /])
;

# DataModel::IMG_Core->metadm->define_join(
# 	qw/GoldSequencingProject taxa taxon_ext_links/
# );
#
# DataModel::IMG_Core->metadm->define_join(
# 	qw/GoldSequencingProject taxa taxon_stats/
# );


#---------------------------------------------------------------------#
#                             COLUMN TYPES                            #
#---------------------------------------------------------------------#
# DataModel::IMG_Core->ColumnType(ColType_Example =>
#   fromDB => sub {...},
#   toDB   => sub {...});

# DataModel::IMG_Core::SomeTable->ColumnType(ColType_Example =>
#   qw/column1 column2 .../);

# latlng
#DataModel::IMG_Core->ColumnType(latlng =>
#  fromDB => sub {},   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
#DataModel::IMG_Core::GoldSequencingProject->ColumnType(latlng => qw/latitude longitude/);

# depth/altitude
#DataModel::IMG_Core->ColumnType(dist_m =>
#  fromDB => sub {  },   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
#DataModel::IMG_Core::GoldSequencingProject->ColumnType(dist_m => qw/depth altitude/);

# normalize case
#	fromDB => sub {  },

#=cut
#DataModel::IMG_Core::Taxon->metadm->define_column_type(Date => qw[
DataModel::IMG_Core::Taxon->metadm->define_column_type( Date => qw[
	RELEASE_DATE
	ADD_DATE
	MOD_DATE
	PHYLODIST_DATE
	LOCK_DATE
	DISTMATRIX_DATE
] );

DataModel::IMG_Core::GoldSequencingProject->metadm->define_column_type( Date => qw[
	ADD_DATE
	MOD_DATE
] );

## date_collected will be YYYY | YYYY-MM | YYYY-MM-DD

DataModel::IMG_Core::Scaffold->metadm->define_column_type( Date => qw[add_date last_update] );
DataModel::IMG_Core::ScaffoldStats->metadm->define_column_type( Date => qw[ mod_date ] );

package DataModel::IMG_Core::Gene;
use IMG::Util::Import 'LogErr';

sub pseudogene {
	my $self = shift;
	if ( ( $self->{is_pseudogene} && 'Yes' eq $self->{is_pseudogene} )
		|| ( $self->{img_orf_type} && 'pseudo' eq $self->{img_orf_type} ) ) {
		return 'Yes';
	}
	return 'No';
}

# coordinates: return a formatted coordinate string
# does the work of GeneUtil::getMultFragCoordsLine

sub coordinates {
	my $self = shift;

	return 'unknown' unless $self->{start_coord} && $self->{end_coord} && $self->{strand};

	$self->expand('gene_frag_coords', ( -order_by => 'frag_order' ));

	my $coord_str = $self->{start_coord} . '..' . $self->{end_coord};
	if ( scalar @{$self->{gene_frag_coords}} ) {
		$coord_str .= ', fragments '
		. join ", ", map {
			$_->{start_coord} . '..' . $_->{end_coord}
		} @{$self->{gene_frag_coords}};

	}
	elsif ( $self->{cds_frag_coord} && $self->{cds_frag_coord} =~ /,/ ) {
		my $cds_frag_coord = lc( $self->{cds_frag_coord} );
		$cds_frag_coord =~ s/complement|join//g;
		$cds_frag_coord =~ s/[<>\(\)]//g;
		$cds_frag_coord =~ s/,(\S)/, $1/g;

		$coord_str .= ', fragments (' . $cds_frag_coord . ')' if $cds_frag_coord =~ /\w/;
	}

	return $coord_str . ' (' . $self->{strand} . ')';
}

sub gene_length {
	my $self = shift;
	return $self->{dna_seq_length} . ' bp' if $self->{dna_seq_length};
	return 'unknown';
}

sub protein_length {
	my $self = shift;
	return $self->{aa_seq_length} . ' aa' if $self->{aa_seq_length};
	if ( $self->{locus_type} && $self->{locus_type} =~ /rna/i ) {
		return 'N/A';
	}
	return 'unknown';
}

sub gene_source {
	my $self = shift;

	if ( ! $self->{gene_pangene_compositions} ) {
		$self->expand( 'gene_pangene_compositions' );
	}
	return $self->{gene_pangene_compositions};
}

#bio_cluster_features_new
# sub versions {
# 	my $self = shift;
# 	my $which = shift;
# 	# which is either 'prev' or 'next'
#
# 	if ( 'prev' eq $which ) {
# 		$self->expand( 'gene_previous_versions', ( -cols => [ 'prev_version' ], -order_by => [ 'prev_version' ] );
# 		for ( @{$self->{gene_previous_versions}} ) {
# 			$_->expand( 'gene', ( -cols => [ qw[ start_coord end_coord strand dna_seq_length aa_seq_length ] ] ) );
# 		}
# 	}
#
# sub previous_versions {
# 	my $self = shift;
#
#
#
#
# sub is_replacement {
# 	my $self = shift;
#
# 	$
# # 	      select distinct gene_oid
# # 	      from gene_replacements
# # 	      where old_gene_oid = ?
#
#
# }
#
#
# ->Association(
#   [qw/Gene                        gene                             1    gene_oid             /],
#   [qw/GenePrevVersions            gene_prev_versions               *    prev_version         /])
#
# ->Composition(
#   [qw/Gene                        gene_2                           1    gene_oid             /],
#   [qw/GenePrevVersions            gene_prev_versions_2             *    gene_oid             /])
#
# ->Composition(
#   [qw/Gene                        gene                             1    gene_oid             /],
#   [qw/GeneReplacements            gene_replacements                *    gene_oid             /])
# ->Composition(
#   [qw/Gene                        gene                             1    gene_oid             /],
#   [qw/GeneReplacements            gene_replacements                *    old_gene_oid             /])
#
#

1;

package DataModel::IMG_Core::GoldSequencingProject;
use IMG::Util::Import 'LogErr';

sub longhurst {
	my $self = shift;
	if ( $self->{longhurst_code} || $self->{longhurst_description} ) {
		if ( $self->{longhurst_code} && $self->{longhurst_description} ) {
			return $self->{longhurst_code} . ', ' . $self->{longhurst_description};
		}
		return $self->{longhurst_code} || $self->{longhurst_description};
	}
	return;
}

sub latlong {
	my $self = shift;

#	log_debug { 'self: ' . Dumper $self };

	if ( defined $self->{latitude} && defined $self->{longitude} ) {
		return $self->{latitude} . "&#176;N, " . $self->{longitude} . "&#176;E";
	}
	return;
}

1;

package DataModel::IMG_Core::TaxonStats;
use IMG::Util::Import 'LogErr';

sub without_function {
	my $self = shift;
#	log_debug { 'self: ' . Dumper $self };
	if ( ! $self->{without_function} ) {
		$self->{without_function} = $self->{cds_genes} - $self->{genes_w_func_pred};
	}
	return $self->{without_function};
}

1;


package DataModel::IMG_Core::Enzyme;
use IMG::Util::Import 'LogErr';

sub xref {
	my $self = shift;
	if ( ! $self->{xref} ) {
		my $xref = $self->{ec_number};
		$xref =~ tr/A-Z/a-z/;
		$self->{xref} = $xref;
	}
	return $self->{xref};
}

sub name {
	my $self = shift;
	if ( ! $self->{name} ) {
		my $name = $self->{enzyme_name};
		$name =~ s/\.$//g;
		$self->{name} = $name;
	}
	return $self->{name};
}

1;



package DataModel::IMG_Core::GoldSequencingProject;
use IMG::Util::Import 'LogErr';

sub woa_measurements {
	return [
		'salinity',
		'temperature',
		'dissolved_oxygen',
		'nitrate',
		'phosphate',
		'silicate'
	];
}

sub has_woa_measurements {
	my $self = shift;
	my $woa_meas = $self->woa_measurements;

	for ( @$woa_meas ) {
		if ( defined $self->{'proport_woa_' . $_ } && $self->{'proport_woa_' . $_ } ne '' ) {
			return 1;
		}
	}
	return 0;
}

sub direct_measurements {
	return [
		'salinity',
		'oxygen_concentration',
		'temperature',
		'nitrate_concentration',
		'chlorophyll_concentration',
		'pressure'
	];
}

sub has_direct_measurements {
	my $self = shift;
	my $dir_meas = $self->direct_measurements;
	for ( @$dir_meas ) {
		if ( defined $self->{$_} && $self->{$_} ne '' ) {
			return 1;
		}
	}
	return 0;
}

sub generic_clade {
	my $self = shift;
	if ( ! $self->{generic_clade} ) {
		my $c = $self->{clade} || '';
		$c =~ s/^(\d\.\d[A-Z]?).*/$1/g;
		$self->{generic_clade} = $c;
	}
	return $self->{generic_clade};
}

1;

package DataModel::IMG_Core::Taxon;
use IMG::Util::Import 'LogErr';

sub class {
	my $self = shift;
	if ( ! $self->{class} ) {
		$self->{class} = $self->{ir_class};
	}
	return $self->{class} || undef;
}

sub order {
	my $self = shift;
	if ( ! $self->{order} ) {
		$self->{order} = $self->{ir_order};
	}
	return $self->{order} || undef;
}

1;

package DataModel::IMG_Core::VwGoldTaxon;
use IMG::Util::Import 'LogErr';

sub generic_clade {
	my $self = shift;
	if ( ! $self->{generic_clade} ) {
		my $c = $self->{clade} || '';
		$c =~ s/^(\d\.\d[A-Z]?).*/$1/g;
		$self->{generic_clade} = $c;
	}
	return $self->{generic_clade};
}

sub domain {
	my $self = shift;
	if ( ! $self->{domain} ) {
		$self->{domain} = $self->{img_domain};
	}
	return $self->{domain} || undef;
}

sub phylum {
	my $self = shift;
	if ( ! $self->{phylum} ) {
		$self->{phylum} = $self->{img_phylum};
	}
	return $self->{phylum} || undef;
}

sub family {
	my $self = shift;
	if ( ! $self->{family} ) {
		$self->{family} = $self->{img_family};
	}
	return $self->{family} || undef;
}

sub class {
	my $self = shift;
	if ( ! $self->{class} ) {
		$self->{class} = $self->{ir_class} || $self->{img_class};
	}
	return $self->{class} || undef;
}

sub order {
	my $self = shift;
	if ( ! $self->{order} ) {
		$self->{order} = $self->{ir_order} || $self->{img_order};
	}
	return $self->{order} || undef;
}

1;

=cut

DBIx::DataModel->Schema('HR') # Human Resources
->Table(Employee   => T_Employee   => qw/emp_id/);

HR->Type(Multival =>
  from_DB => sub {$_[0] = [split /;/, $_[0]]   if defined $_[0]},
  to_DB   => sub {$_[0] = join ";", @{$_[0]}   if defined $_[0]},
);

HR->Type(Upcase =>
  to_DB   => sub {$_[0] = uc($_[0])   if defined $_[0]},
);

my $meta_emp = HR->table('Employee')->metadm;

$meta_emp->define_column_type(Multival => qw/kids interests/);
$meta_emp->define_column_type(Upcase   => qw/interests/);

=cut

# latlng
#DataModel::IMG_Core->ColumnType(latlng =>
#  fromDB => sub {},   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
#DataModel::IMG_Core::GoldSequencingProject->ColumnType(latlng => qw/latitude longitude/);

# depth/altitude
# DataModel::IMG_Core->ColumnType(dist_m =>
#  fromDB => sub {  },   # SKELETON .. PLEASE FILL IN
#  toDB   => sub {});
# DataModel::IMG_Core::GoldSequencingProject->ColumnType(dist_m => qw/depth altitude/);


=cut
# lists of values, stored as scalars with a ';' separator
My::Schema->metadm->define_type(
  name     => 'StrToLower',
  handlers => {
   from_DB  => sub { $_[0] = [split /;/, $_[0] || ""]     },
   to_DB    => sub {$_[0] = join ";", @$_[0] if ref $_[0]},
  });


# adding SQL type information for the DBD handler
My::Schema->metadm->define_type(
  name     => 'XML',
  handlers => {
   to_DB    => sub {$_[0] = [{dbd_attrs => {ora_type => ORA_XMLTYPE}}, $_[0]]
                      if $_[0]},
  });

=cut

1;
