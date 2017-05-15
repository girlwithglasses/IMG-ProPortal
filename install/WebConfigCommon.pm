#
# NEW for 3.4  - Common WebConfig param between all sites
# Params can be overridden in the site's Webconfig.pm
#
# $Id: WebConfigCommon.pm 37057 2017-05-08 19:45:20Z klchu $
#
#
package WebConfigCommon;

use strict;
#use warnings;

use MIME::Base64;
use CGI qw( :standard );

##
# getEnv - Get environment
#     Customize this subroutine.
#
$ENV{ORACLE_HOME} = "/usr/common/jgi/oracle_client/11.2.0.3.0/client_1";
$ENV{TNS_ADMIN}   = "/usr/common/jgi/oracle_client/11.2.0.3.0/client_1/network/admin";

sub common {
	my $args = shift || {};
    my $e = {};

    $e->{use_img_gold} = 1;    # Use IMG GOLD metadata.

    # database config files
    # one db now 4.0 before we had different db's for each system.
    $e->{dbTag}             = "img_core_v400";                        # database config file to use
    $e->{oracle_config_dir} = "/webfs/projectdirs/microbial/img/img_rdbms/config/";

    $e->{dbLock_dir}        = '/webfs/projectdirs/microbial/img/dbLocks/';

    # Web UI data directory.
    $e->{web_data_dir}      = "/global/dna/projectdirs/microbial/img_web_data";
    $e->{sandbox_blast_data_dir} = "/global/projectb/sandbox/IMG/web-data/sandbox.blast.data";

    # location of static html pages on scratch
    # pages are created via nightly cronjobs
    $e->{webfs_data_dir} = "/webfs/projectdirs/microbial/img/web_data/";

    # BC/NP stats directory (for ANI, etc.)
    $e->{bcnp_stats_dir} = '/webfs/scratch/img/bcNp/';

    $e->{gold_cache_dir} = '/webfs/scratch/img/gold/';

    # Common tmp directory between Web UI and service.
    # For passing report files rather than funneling them
    # through http, which can be very slow.
    $e->{common_tmp_dir} = "/global/projectb/scratch/img/www-data/service/tmp";

    # version
    $e->{img_version}    = "4.570";
    $e->{copyright_year} = "2017";
    $e->{version_year}   = "Version " . $e->{img_version} . " Mar. " . $e->{copyright_year};

    # --------------------------------------------------------------------------------------------
    #
    # IMG systems URLs
    #
    # --------------------------------------------------------------------------------------------
    $e->{img_submit_url} = "https://img.jgi.doe.gov/submit/";

    # --------------------------------------------------------------------------------------------
    #
    # Location of 3rd party scripts or software
    #
    # --------------------------------------------------------------------------------------------
    $e->{img_tools_dir} = "/global/dna/projectdirs/microbial/img/tools/";
    #$e->{java_home}     = "/usr/common/usg/languages/java/jdk/oracle/1.7_64bit";

    $e->{java_home}     = "/usr/common/usg/languages/java/jdk/oracle/1.8.0_31_x86_64";

    #$e->{mummer_dir}    = $e->{img_tools_dir} . "MUMmer3.21";
    $e->{mummer_dir}    = "/usr/common/jgi/aligners/mummer/3.23/bin/";
    $e->{neighbor_bin}  = "/usr/common/jgi/phylogenetics/arb/5.5/bin/neighbor";
    $e->{protdist_bin}  = "/usr/common/jgi/phylogenetics/arb/5.5/bin/protdist";
    $e->{perl_bin}      = "/usr/common/usg/languages/perl/5.16.0/bin/perl";
    $e->{gs_bin}        = "/usr/bin/gs";
    $e->{ ma_bin }      = "/webfs/projectdirs/microbial/img/bin/multalin";

    # R  $ENV{LD_LIBRARY_PATH} = $ENV{LD_LIBRARY_PATH} .
    $e->{R_LD_LIBRARY_PATH} =
        ':/usr/common/usg/languages/R/3.1.2/lib64/R/lib'
      . ':/usr/common/usg/utilities/curl/7.37.1/lib'
      . ':/usr/common/usg/utility_libraries/boost/gnu4.8/1.50.0/lib';

    $e->{r_bin} = "/usr/common/usg/languages/R/3.1.2/bin/R";


#    $e->{R_LD_LIBRARY_PATH} =
#        ':/global/common/genepool/usg/languages/R/3.1.2/lib64/R/lib'
#      . ':/usr/common/usg/utilities/curl/7.37.1/lib'
#      . ':/usr/common/usg/utility_libraries/boost/gnu4.8/1.50.0/lib';
#
#    $e->{r_bin} = "/global/common/genepool/usg/languages/R/3.1.2/bin/R";


    $e->{clustalw_bin}    = "/usr/common/jgi/aligners/clustalw/2.1/bin/clustalw2";
    $e->{clustalo_bin}    = "/usr/common/jgi/aligners/clustal-omega/1.1.0/bin/clustalo";
    $e->{sendmail}        = "/usr/sbin/sendmail";
    $e->{psu_diagram_dir} = $e->{img_tools_dir} . "psu_diagram"; # Circular chromosome viewer package
    $e->{pepstats_bin} =
      '/usr/common/jgi/frameworks/EMBOSS/6.4.0/bin/pepstats';    #$e->{img_tools_dir} . 'EMBOSS/DEFAULT/bin/pepstats';
    $e->{sixpack_bin} =
      '/usr/common/jgi/frameworks/EMBOSS/6.4.0/bin/sixpack';     #$e->{img_tools_dir} . 'EMBOSS/DEFAULT/bin/sixpack';
    $e->{seqret_bin} =
      '/usr/common/jgi/frameworks/EMBOSS/6.4.0/bin/seqret';      #$e->{img_tools_dir} . 'EMBOSS/DEFAULT/bin/seqret';

    $e->{usearch_bin} = "/global/dna/projectdirs/microbial/img/webui/bin/x86_64-linux/usearch64";
    $e->{blastall_bin} = $e->{img_tools_dir} . "BLAST/ncbi-blast-2.2.26+";

    $e->{newick_all} = $e->{ web_data_dir } . "/newick/newick_all"; # distance tree

    # --------------------------------------------------------------------------------------------
    #
    # Environmental Blast databases.
    #
    # --------------------------------------------------------------------------------------------
    $e->{env_blast_dbs} = {
        "amd"              => "Acid Mine Drainage",
        "us_sludge"        => "Sludge/US",
        "oz_sludge"        => "Sludge/Australian",
        "all_sludge"       => "All Sludge",
        "soil"             => "Soil: Diversa Silage",
        "wf1"              => "Whalefall Sample #1",
        "wf2"              => "Whalefall Sample #2",
        "wf3"              => "Whalefall Sample #3",
        "all_env"          => "All Microbiome Sequences",
        "tgut"             => "Termite Gut (version 1)",
        "tgut2b"           => "Termite Gut (version 2)",
        "tgut3"            => "Termite Gut (version 3)",
        "saf1"             => "Clark Quay Air",
        "saf2"             => "Park Quay Air",
        "lwm1"             => "Lake Washington Combined Assembly",
        "gws2_d1"          => "O.algarvensis Delta1",
        "gws2_d4"          => "O.algarvensis Delta4",
        "gws2_g1"          => "O.algarvensis Gamma1",
        "gws2_g3"          => "O.algarvensis Gamma3",
        "tm7c32"           => "TM7Cell-1032",
        "tm7c33"           => "TM7Cell-1033",
        "mgutPt2"          => "Mouse Gut Community PT2",
        "mgutPt3"          => "Mouse Gut Community PT3",
        "mgutPt4"          => "Mouse Gut Community PT4",
        "mgutPt6"          => "Mouse Gut Community PT6",
        "mgutPt8"          => "Mouse Gut Community PT8",
        "hsmat01"          => "Hypersaline Mat 01",
        "hsmat02"          => "Hypersaline Mat 02",
        "hsmat03"          => "Hypersaline Mat 03",
        "hsmat04"          => "Hypersaline Mat 04",
        "hsmat05"          => "Hypersaline Mat 05",
        "hsmat06"          => "Hypersaline Mat 06",
        "hsmat07"          => "Hypersaline Mat 07",
        "hsmat08"          => "Hypersaline Mat 08",
        "hsmat09"          => "Hypersaline Mat 09",
        "hsmat10"          => "Hypersaline Mat 10",
        "biz"              => "Bison Pool",
        "saani"            => "Saanich Inlet",
        "ucgw2"            => "Uranium Contaminted Groundwater",
        "lwComb"           => "Lake Washington Combined",
        "lwMethane"        => "Lake Washington, Methane Enrichment",
        "lwMethanol"       => "Lake Washington, Methanol Enrichment",
        "lwMethylamine"    => "Lake Washington, Methylamine Enrichment",
        "lwFormaldehyde"   => "Lake Washington, Formaldehyde Enrichment",
        "lwFormate"        => "Lake Washington, Formate Enrichment",
        "taComm"           => "Thermophilic terepthalate-degrading community",
        "taComm3"          => "Thermophilic terepthalate-degrading community (v3)",
        "taCommComb"       => "Thermophilic terepthalate-degrading community (combined)",
        "taCommFgenes"     => "Thermophilic terepthalate-degrading community (fgenes)",
        "orpgw"            => "Oak Ridge Pristine Groundwater FRC FW301",
        "apWin"            => "Anarctic Marin Bacterioplankton, winter",
        "apSum"            => "Anarctic Marin Bacterioplankton, summer",
        "bisonPool14jan08" => "Bison Pool (14JAN08)",
    };

    # --------------------------------------------------------------------------------------------
    #
    # Robot patterns to block.
    #
    # --------------------------------------------------------------------------------------------
    $e->{bot_patterns} =
       [ "FirstGov", "Jeeves",    "BecomeBot",     "AI-Agent",  "ysearch", "crawler",
        "Slurp",    "accelobot", "NimbleCrawler", "Java",      "bot",     "slurp",
        "libwww",   "lwp",       "LWP",           "Mechanize", "Sphider", "Wget",
        "wget",     "Axel",      "Python",        "Darwin",    'curl', 'Ruby', 'Sogou' ];

    $e->{block_ip_address_file} = $e->{dbLock_dir} . "blockIps.txt";

    # --------------------------------------------------------------------------------------------
    #
    #
    #
    # --------------------------------------------------------------------------------------------
    $e->{env_blast_defaults} = {
        sludgePhrap      => 'us_sludge',
        sludgeOz         => 'oz_sludge',
        sludgeJazz       => 'us_sludge',
        amd              => 'amd',
        soil             => 'soil',
        wf1              => 'wf1',
        wf2              => 'wf2',
        wf3              => 'wf3',
        tgut             => 'tgut',
        tgut2b           => 'tgut2b',
        tgut3            => 'tgut3',
        saf1             => 'saf1',
        saf2             => 'saf2',
        lwm1             => 'lwm1',
        tm7c32           => 'tm7c32',
        tm7c33           => 'tm7c33',
        mgutPt2          => 'mgutPt2',
        mgutPt3          => 'mgutPt3',
        mgutPt4          => 'mgutPt4',
        mgutPt6          => 'mgutPt6',
        mgutPt8          => 'mgutPt8',
        hsmat01          => 'hsmat01',
        hsmat02          => 'hsmat02',
        hsmat03          => 'hsmat03',
        hsmat04          => 'hsmat04',
        hsmat05          => 'hsmat05',
        hsmat06          => 'hsmat06',
        hsmat07          => 'hsmat07',
        hsmat08          => 'hsmat08',
        hsmat09          => 'hsmat09',
        hsmat10          => 'hsmat10',
        biz              => 'biz',
        saani            => 'saani',
        ucgw2            => 'ucgw2',
        lwComb           => 'lwComb',
        lwMethane        => 'lwMethane',
        lwMethanol       => 'lwMethanol',
        lwMethylamine    => 'lwMethylamine',
        lwFormaldehyde   => 'lwFormaldehyde',
        lwFormate        => 'lwFormate',
        taComm           => 'taComm',
        taComm3          => 'taComm3',
        taCommComb       => 'taCommComb',
        taCommFgenes     => 'taCommFgenes',
        orpgwFw301       => 'orpgw',
        apWin            => 'apWin',
        apSum            => 'apSum',
        bisonPool14jan08 => 'bisonPool14jan08'
    };

    # --------------------------------------------------------------------------------------------
    #
    # Google
    #
    # --------------------------------------------------------------------------------------------
    ## Google Map Keys
    # deleted 'hmpdacc-resources.org' => 'ABQIAAAAoyF356P0_F8RJgEsRg73bBSvpfy4IrTf2S0Jpw1e1K8i8S6yrxSlI4YBFXgRBnDNPn81Jl5m4_Ki5w'
    $e->{google_map_keys} = {
        'jgi-psf.org'           => 'ABQIAAAAYxJnF8y-nhPss9h0Mp_SmBRudsuYU0E-IvTrpz0eeItbCuKkEBQYbqxO7d1kC-KDKb1JTl78SHX6Cg',
        'jgi.doe.gov'           => 'ABQIAAAAYxJnF8y-nhPss9h0Mp_SmBTg30WwySNRyLvcO7oFZfs2Agm6xRTuB05OZiGo4MATGpJmYVYP4vxVHQ',

    };

    # Google Analytics
    # key deleted -'hmpdacc-resources.org' => 'UA-15689341-5', - ken Jun 3 2015
    $e->{enable_google_analytics} = 1;
    $e->{google_analytics_keys} = {
        'jgi-psf.org'           => 'UA-15689341-3',
        'jgi.doe.gov'           => 'UA-15689341-4',
    };

    # Google Recaptcha
    #
    # http://www.google.com/recaptcha
    # http://code.google.com/apis/recaptcha/intro.html
    # deleted 'hmpdacc-resources.org' => '6LfRjr4SAAAAACHJ9oF3IAzpsQI69AJxbwJXiiyz',
    $e->{google_recaptcha_private_key} = {
        'jgi-psf.org'           => '6LfPjr4SAAAAAG6P8xA9VK0RTKgmAGrfk9A2c4i5',
        'jgi.doe.gov'           => '6LfQjr4SAAAAAI18Ydpv5Xb9Z-QOPl9x1MUc14Yl',

    };

    #   'hmpdacc-resources.org' => '6LfRjr4SAAAAAD1o2hZI5nbSPydG00pb1b7Mb92S',
    $e->{google_recaptcha_public_key} = {
        'jgi-psf.org'           => '6LfPjr4SAAAAAEcnSNPTE-GtiPYTdUqkYK07BzYC',
        'jgi.doe.gov'           => '6LfQjr4SAAAAAHKn-Yd-QR55idf73Pnnxt6avsBh',

    };

    # --------------------------------------------------------------------------------------------
    #
    # Yahoo UI
    #
    # --------------------------------------------------------------------------------------------
    $e->{yui_tables} = 1;

    # Yahoo UI directory.
    # 2.8
    $e->{yui_dir_28} = "/../yui282/yui";

    # --------------------------------------------------------------------------------------------
    #
    # JIRA - Question and Comments Form
    #
    # --------------------------------------------------------------------------------------------
    # bugmaster system to send email from questions and comments section
    #$e->{ bugmaster_email } = "rt-img\@cuba.jgi-psf.org";
    # JIRA - replaces bugmaster
    # url to where to submit the form
    #$e->{jira_submit_url} = "http://contact.jgi-psf.org/cgi-bin/support/contact_send.pl";

    # if jira form submit fails display error message with the following email
    $e->{jira_email_error} = 'jgi-imgsupp@lists.lbl.gov ';

    #'jgi-imgsupp@lists.lbl.gov'; #'jgi-imgsupp@lists.lbl.gov ';
    $e->{img_support_email} = 'jgi-imgsupp@lists.lbl.gov ';

    # the new cloud jira email
    $e->{jira_email}  = 'jgi-jira+imgsupp@lbl.gov';
    $e->{jira_email2} = 'jgi-imgsupp@lists.lbl.gov ';

    # --------------------------------------------------------------------------------------------
    #
    # external urls
    #
    # --------------------------------------------------------------------------------------------
    #
    #
    # er and mer submit urls
    #
    $e->{img_mer_submit_url} =
      "https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=MSubmission&page=displaySubmission&submission_id=";
    $e->{img_er_submit_url} =
      "https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ERSubmission&page=displaySubmission&submission_id=";
    $e->{img_er_submit_project_url} =
      "https://img.jgi.doe.gov/cgi-bin/submit/main.cgi?section=ProjectInfo&page=displayProject&project_oid=";

    $e->{regtransbase_check_base_url} = "http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=check_gene_exp&protein_id=";
    $e->{regtransbase_base_url}       = "http://regtransbase.lbl.gov/cgi-bin/regtransbase?page=geneinfo&protein_id=";
    $e->{swissprot_source_url}        = "http://www.uniprot.org/uniprot/";
    $e->{swiss_prot_base_url}         = $e->{swissprot_source_url};
    $e->{ncbi_entrez_base_url}        = "http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?val=";
    $e->{ncbi_mapview_base_url}       = "http://www.ncbi.nlm.nih.gov/mapview/map_search.cgi?" . "direct=on&idtype=gene&id=";
    $e->{ncbi_project_id_base_url}    =
      "http://www.ncbi.nlm.nih.gov/entrez/query.fcgi" . "?db=genomeprj&cmd=Retrieve&dopt=Overview&list_uids=";
    $e->{cmr_jcvi_ncbi_project_id_base_url} = "http://cmr.jcvi.org/cgi-bin/CMR/ncbiProjectId2CMR.cgi?ncbi_project_id=";
    $e->{pubmed_base_url}                   = "http://www.ncbi.nlm.nih.gov/entrez?db=PubMed&term=";
    $e->{geneid_base_url}                   =
      "http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?" . "db=gene&cmd=Retrieve&dopt=full_report&list_uids=";
    $e->{nice_prot_base_url} = $e->{swissprot_source_url};
    $e->{puma_base_url}      =
        "http://compbio.mcs.anl.gov/puma2/cgi-bin/search.cgi"
      . "?protein_id_type=NCBI_GI&search=Search&search_type=protein_id"
      . "&search_text=";
    $e->{puma_redirect_base_url}  = "http://compbio.mcs.anl.gov/puma2/cgi-bin/puma2_url.cgi?gi=";
    $e->{ko_base_url}             = "http://www.genome.ad.jp/dbget-bin/www_bget?ko+";
    $e->{vimss_redirect_base_url} = "http://www.microbesonline.org/cgi-bin/gi2vimss.cgi?gi=";
    $e->{enzyme_base_url}         = "http://www.genome.jp/dbget-bin/www_bget?";
    $e->{pfam_base_url}           = "http://pfam.xfam.org/family/";
    $e->{pfam_clan_base_url}      = "http://pfam.sanger.ac.uk/clan?acc=";

    # interpro urls
    # IPR: http://www.ebi.ac.uk/interpro/entry/IPR006683
    # PANTHER: ???
    # SUPERFAMILY:   http://supfam.cs.bris.ac.uk/SUPERFAMILY/cgi-bin/scop.cgi?ipid=SSF51690
    # ProSiteProfiles:  http://prosite.expasy.org/PS50931
    # SMART:  http://smart.embl-heidelberg.de/smart/do_annotation.pl?ACC=SM00382
    #
    $e->{ipr_base_url}  = "http://www.ebi.ac.uk/interpro/entry/";
    $e->{ipr_base_url2} = "http://supfam.cs.bris.ac.uk/SUPERFAMILY/cgi-bin/scop.cgi?ipid=";
    $e->{ipr_base_url3} = "http://prosite.expasy.org/";
    $e->{ipr_base_url4} = "http://smart.embl-heidelberg.de/smart/do_annotation.pl?ACC=";

    $e->{ncbi_blast_url} =
        "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?"
      . "PAGE=Proteins&PROGRAM=blastp&BLAST_PROGRAMS=blastp"
      . "&PAGE_TYPE=BlastSearch&SHOW_DEFAULTS=on";
    $e->{taxonomy_base_url}    = "http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=";

    $e->{gold_base_url}        = "http://genomesonline.org/"; # old url to be replace by the next 3 gold urls

    # new gold Nov 2014
    $e->{gold_base_url_analysis} = "https://gold.jgi.doe.gov/analysis_projects?id=";
    $e->{gold_base_url_project}  = "https://gold.jgi.doe.gov/projects?id="; # Gp...
    $e->{gold_base_url_study}    = "https://gold.jgi.doe.gov/study?id=";    # Gs...

    $e->{aclame_base_url}      = "http://aclame.ulb.ac.be/perl/Aclame/Genomes/" . "prot_view.cgi?mode=genome&id=";
    $e->{artemis_url}          = "http://www.sanger.ac.uk/Software/Artemis/";
    $e->{pirsf_base_url}       = "http://pir.georgetown.edu/cgi-bin/ipcSF?id=";
    $e->{tigrfam_base_url}     = "http://www.jcvi.org/cgi-bin/tigrfams/HmmReportPage.cgi?acc=";
    $e->{rfam_base_url}        = "http://rfam.sanger.ac.uk/family/";
    $e->{unigene_base_url}     = "http://www.ncbi.nlm.nih.gov/UniGene/clust.cgi";
    $e->{tair_base_url}        = "http://www.arabidopsis.org/servlets/TairObject?type=locus&name=";
    $e->{wormbase_base_url}    = "http://www.wormbase.org/db/gene/gene?name=";
    $e->{zfin_base_url}        = "http://zfin.org/cgi-bin/webdriver?MIval=aa-markerview.apg&OID=";
    $e->{flybase_base_url}     = "http://flybase.bio.indiana.edu/reports/";
    $e->{hgnc_base_url}        = "http://www.gene.ucl.ac.uk/nomenclature/data/get_data.php?hgnc_id=";
    $e->{mgi_base_url}         = "http://www.informatics.jax.org/searches/accession_report.cgi?" . "id=MGI:";
    $e->{rgd_base_url}         = "http://rgd.mcw.edu/tools/genes/genes_view.cgi?id=";
    $e->{ebi_iprscan_url}      = "http://www.ebi.ac.uk/Tools/pfa/iprscan/";
    $e->{greengenes_blast_url} = "http://greengenes.lbl.gov/cgi-bin/nph-blast_interface.cgi";
    $e->{greengenes_base_url}  = "http://greengenes.lbl.gov/cgi-bin/show_one_record_v2.pl" . "?prokMSA_id=";
    $e->{gcat_base_url}        = "http://darwin.nox.ac.uk/gsc/gcat/report/";
    $e->{pdb_blast_url}        = "http://www.rcsb.org/pdb/search/" . "searchSequence.do";
    $e->{pdb_base_url}         = "http://www.rcsb.org/pdb/explore.do?structureId=";
    $e->{cog_base_url} = "http://www.ncbi.nlm.nih.gov/Structure/cdd/cddsrv.cgi?uid=";  #= "http://www.ncbi.nlm.nih.gov/COG/grace/wiew.cgi?";
    $e->{kog_base_url} = "http://www.ncbi.nlm.nih.gov/Structure/cdd/cddsrv.cgi?uid=";  #"http://www.ncbi.nlm.nih.gov/COG/grace/shokog.cgi?";
    $e->{go_base_url}  = "http://www.ebi.ac.uk/ego/DisplayGoTerm?id=";
    $e->{go_evidence_url}         = "http://www.geneontology.org/GO.evidence.shtml";
    $e->{metacyc_url}             = "http://biocyc.org/META/NEW-IMAGE?object=";
    $e->{kegg_reaction_url}       = "http://www.genome.jp/dbget-bin/www_bget?rn+";
    $e->{kegg_orthology_url}      = "http://www.genome.jp/dbget-bin/www_bget?ko+";
    $e->{kegg_module_url}         = "http://www.genome.jp/dbget-bin/www_bget?md+";
    $e->{jgi_project_qa_base_url} = "http://cayman.jgi-psf.org/prod/data/QA/Reports/QD/";

    # --------------------------------------------------------------------------------------------
    #
    # url that is emailed to user
    #
    # --------------------------------------------------------------------------------------------

    # /ifs/scratch/img-tmp
    $e->{ifs_tmp_dir}        = "/webfs/scratch/img/tmp/img-tmp";

    # --------------------------------------------------------------------------------------------
    #
    # workspace for img/er and img/mer systems v3.3 - ken
    #
    # --------------------------------------------------------------------------------------------
    $e->{workspace_dir} = "/webfs/projectdirs/microbial/img/web_data/workspace";

    # temp workspace directory for the message system on dna drive
    $e->{workspace_sandbox_dir} = "/global/projectb/sandbox/IMG_web/workspace_temp/workspace";

    # job support feature
    $e->{client_path}   = "/global/projectb/sandbox/IMG_web/messageSystem";
    $e->{client_py_exe} = $e->{client_path} . "/client_wrapper.sh";

    # new queue
    #$e->{workspace_pid_dir}   = '/global/projectb/sandbox/IMG_web/messageSystem/PID/';
    #$e->{workspace_queue_dir} = '/global/projectb/sandbox/IMG_web/messageSystem/QUEUE/';
    $e->{workspace_messageSystem_dir} = '/global/projectb/sandbox/IMG_web/messageSystem/';

    $e->{enable_carts} = 1;
    $e->{cart_max_szie} = 20000; # no login max 1000
    $e->{enable_download} = 1; # public site no download

    # --------------------------------------------------------------------------------------------
    #
    # message to UI - this is not the db lock file feature
    #
    # --------------------------------------------------------------------------------------------
    #
    # messages to all UI's
    # to put a special message in the message area below the menu
    # leave it blank to display no message
    #$e->{message} = "Downtime tuesday, May 3, 2011.";
    $e->{message} = "";

    # new 3.4 message_file - /home/ken/message_file.txt
    $e->{message_file} = $e->{dbLock_dir} . "message_file.txt";

    # recplot url - for metagenome rec. plots
    #$e->{ recplot_url } = "http://img.jgi.doe.gov/viewers/recplot";

    # --------------------------------------------------------------------------------------------
    #
    # OMICS - studies
    #
    # --------------------------------------------------------------------------------------------

    # gbrowse url
    $e->{gbrowse_base_url} = "http://gpweb07.nersc.gov/";
    $e->{rnaseq}           = 1;
    $e->{methylomics}      = 1;

    # --------------------------------------------------------------------------------------------
    #
    # max params
    #
    # --------------------------------------------------------------------------------------------

    # timeout in minutes
    $e->{default_timeout_mins} = 15;

    #$e->{scaffold_page_size} = 1000000; # Page size (aa) for one section of a scaffold.
    $e->{scaffold_page_size} = 500000;

    $e->{max_blast_jobs} = 20;    # Maximum BLAST jobs for the system.

    $e->{top_annotations_to_show} = 100;    # Top annotations to show if list is too long.

    $e->{max_cgi_procs} = 200;               # Maximum CGI processes allowed.

    # Maximum time in seconds a state file can live.
    # (Set this lower if you want the UI to run faster
    #  since it doesn't have to do purgeTmpDir()  for
    #  a large list of files.)
    # purge in main.pl is to run by default - ken
    # but for production systems do not do purge
    # hence in WebConfig-img-prod_w.pm file this flag is set to 0
    #$e->{enable_purge} = 1;

    #
    # old flag that are now common in all systems
    #
    $e->{img_lite}             = 1;
    $e->{content_list}         = 1;    # Use tab panel in details page.
    $e->{proteomics}           = 1;    # all sites for now - ken
    $e->{use_func_cart}        = 1;    # Use generic function cart instead of individual carts (COG, Pfam, ...)
    $e->{scaffold_cart}        = 1;
    $e->{full_phylo_profiler}  = 1;    # full phylogenetic profiler
    $e->{include_plasmids}     = 1;    # Include plasmids.
    $e->{include_img_term_bbh} = 1;
    $e->{include_tigrfams}     = 1;
    $e->{include_img_terms}    = 1;

    $e->{img_term_overlay}     = 1;    # IMG term overlay.
    $e->{img_pheno_rule}       = 1;    # IMG Phenotype Rules
    $e->{img_pheno_rule_saved} = 1;    # IMG Phenotype Rules -- use saved results

    $e->{use_img_clusters}        = 0;                                              # Peter's stuff
    $e->{taxonCluster_zfiles_dir} = $e->{web_data_dir} . "/taxon.cluster.zfiles";

    # --------------------------------------------------------------------------------------------
    #
    # BLAST and usearch urls
    #
    # optional precomputed homologs server with -m 0 output
    $e->{worker_base_url}       = 'https://img-worker-crt.services.nersc.gov';

    #$e->{blastallm0_server_url} = $e->{worker_base_url} . "/cgi-bin/blast/generic/blastallServer2.cgi";
    $e->{blastallm0_server_url} = $e->{worker_base_url} . "/cgi-bin/blast/generic/blastQueue.cgi";
    #$e->{blast_server_url}      = $e->{worker_base_url} . "/cgi-bin/usearch/generic/hopsServer.cgi";
    $e->{blast_server_url}      = $e->{worker_base_url} . "/cgi-bin/last/hopsServer.cgi";
    $e->{rna_server_url}        = $e->{worker_base_url} . "/cgi-bin/blast/generic/rnaServer.cgi";

    # Queue directory for BLAST jobs.
    $e->{blast_q_dir} = "/global/projectb/scratch/img/www-data/blast.q";

    # min genome selection to do blast all instead of individual blasts
    $e->{blast_max_genome} = 100;

    # all common BLAST DB
    #
    # mblast tmp and reports directory
    $e->{mblast_reports_dir}       = $e->{web_data_dir} . "/mblast/reports";
    $e->{mblast_tmp_dir}           = $e->{web_data_dir} . "/mblast/tmp";
    $e->{genes_dir}                = $e->{web_data_dir} . "/tab.files/genes";
    $e->{snp_blast_data_dir}       = $e->{web_data_dir} . "/snp.blast.data";
    $e->{blast_data_dir}           = $e->{web_data_dir} . "/blast.data";
    $e->{gene_hits_zfiles_dir}     = $e->{web_data_dir} . "/gene.hits.zfiles";
    $e->{bbh_zfiles_dir}           = $e->{web_data_dir} . "/bbh.zfiles";
    $e->{ram_blast_data_dir}       = "/dev/shm/blast.data";
    $e->{ava_batch_dir}            = $e->{web_data_dir} . "/avaNewOldBatches.out";
    $e->{genomePair_zfiles_dir}    = $e->{web_data_dir} . "/genomePair.zfiles";
    $e->{bbh_ava_dir}              = $e->{web_data_dir} . "/bbh.ava.out";
    $e->{ava_taxon_dir}            = $e->{web_data_dir} . "/ava.taxon.tabs";
    $e->{ava_index_dir}            = $e->{web_data_dir} . "/ava.indexes";
    $e->{taxon_faa_dir}            = $e->{web_data_dir} . "/taxon.faa";
    $e->{taxon_fna_dir}            = $e->{web_data_dir} . "/taxon.fna";
    $e->{taxon_reads_fna_dir}      = $e->{web_data_dir} . "/taxon.reads.fna";
    $e->{taxon_lin_fna_dir}        = $e->{web_data_dir} . "/taxon.lin.fna";
    $e->{cogs_dir}                 = $e->{web_data_dir} . "/tab.files/cogs";
    $e->{pfams_dir}                = $e->{web_data_dir} . "/tab.files/pfams";
    $e->{enzymes_dir}              = $e->{web_data_dir} . "/tab.files/enzymes";
    $e->{nrhits_dir}               = $e->{web_data_dir} . "/nrhits";
    $e->{orthologGroups_dir}       = $e->{web_data_dir} . "/tab.files/orthologGroups";
    $e->{homologGroups_dir}        = $e->{web_data_dir} . "/tab.files/homologGroups";
    $e->{superClusters_dir}        = $e->{web_data_dir} . "/tab.files/superClusters";
    $e->{all_fna_files_dir}        = $e->{web_data_dir} . "/all.fna.files";
    $e->{taxon_genes_fna_dir}      = $e->{web_data_dir} . "/taxon.genes.fna";
    $e->{taxon_intergenic_fna_dir} = $e->{web_data_dir} . "/taxon.intergenic.fna";
    $e->{mgtrees_dir}              = $e->{web_data_dir} . "/mgtrees";
    $e->{fna_files_dir}            = $e->{web_data_dir} . "/all.fna.files";
    $e->{taxon_positions_file}     = $e->{web_data_dir} . "/taxonPositions.txt";
    $e->{gene_clusters_dir}        = $e->{web_data_dir} . "/geneClusters";

    # --------------------------------------------------------------------------------------------
    #
    # CVS location of the java lib directory
    # /global/homes/k/klchu/Dev/img_dev/v2/java
    #
    # --------------------------------------------------------------------------------------------

    #$e->{chart_lib} = '/global/u1/k/klchu/Dev/svn/java/lib';    #"/global/homes/k/klchu/Dev/img_dev/v2/java/lib";
    # for gpwweb36
    $e->{chart_lib} = '/global/homes/k/klchu/v2/java/lib';    #"/global/homes/k/klchu/Dev/img_dev/v2/java/lib";

    # --------------------------------------------------------------------------------------------
    #
    # cassettes
    #
    # using files for x_coeff operon data
    #
    # --------------------------------------------------------------------------------------------
    $e->{operon_data_dir} = "";

    # fastbit
    #    $e->{fastbit_LD_LIBRARY_PATH} =
    #        ':/usr/common/usg/languages/gcc/4.6.3_1/lib64'
    #      . ':/usr/common/usg/languages/gcc/4.6.3_1/lib'
    #      . ':/usr/common/usg/utility_libraries/boost/1.50.0/lib'
    #      . ':/usr/common/jgi/utilities/fastbit/1.3.4/lib';
    $e->{fastbit_dir} = '/global/homes/k/klchu/Dev/cassettes/v4/genome/';

    $e->{fastbit_LD_LIBRARY_PATH} =
        ':/usr/common/usg/languages/gcc/4.6.4/lib64'
      . ':/usr/common/usg/languages/gcc/4.6.4/lib'
      . ':/usr/common/usg/utility_libraries/boost/gnu4.6/1.50.0/lib'
      . ':/usr/common/jgi/utilities/fastbit/1.3.9/lib';

    # --------------------------------------------------------------------------------------------
    #
    # KEGG for IMG 4.0
    #
    # --------------------------------------------------------------------------------------------
    # /global/dna/projectdirs/microbial/img_web_data
    $e->{kegg_root_dir}        = $e->{web_data_dir}  . "/kegg.maps.7.7";
    $e->{kegg_data_dir}        = $e->{kegg_root_dir} . "/png.files";
    $e->{kegg_tree_file}       = $e->{kegg_root_dir} . "/kegg_tree.txt";
    $e->{kegg_brite_tree_file} = $e->{kegg_root_dir} . "/kegg_brite_tree.txt";
    $e->{kegg_cat_file}        = $e->{kegg_root_dir} . "/kegg_cat.txt";

    # login logs
    $e->{login_log_file}      = "/webfs/scratch/img/imgLogins.log";
    $e->{enable_autocomplete} = 1;

    # public taxon list / tree json files
    my $webfs_data_dir = $e->{webfs_data_dir};
    my $taxon_json_dir = $webfs_data_dir . 'taxon_json';
    $e->{taxon_json_dir}      = $taxon_json_dir;
    $e->{taxon_json_bac}      = "$taxon_json_dir/taxonArrayBac.js";
    $e->{taxon_json_arc}      = "$taxon_json_dir/taxonArrayArc.js";
    $e->{taxon_json_euk}      = "$taxon_json_dir/taxonArrayEuk.js";
    $e->{taxon_json_gfr}      = "$taxon_json_dir/taxonArrayGFr.js";
    $e->{taxon_json_pla}      = "$taxon_json_dir/taxonArrayPla.js";
    $e->{taxon_json_vir}      = "$taxon_json_dir/taxonArrayVir.js";
    $e->{taxon_json_met}      = "$taxon_json_dir/taxonArrayMet.js";
    $e->{taxon_json_allw}     = "$taxon_json_dir/taxonArrayAllW.js";        # for tree
    $e->{taxon_json_allm}     = "$taxon_json_dir/taxonArrayAllM.js";        # for tree
    $e->{taxon_json_allwlist} = "$taxon_json_dir/taxonArrayAllWList.js";    # for list
    $e->{taxon_json_allmlist} = "$taxon_json_dir/taxonArrayAllMList.js";    # for list
        # for login sites / users get custom js files created during login - all above taxon_json_* should be null or blank
        # files location in the temp tmp area
        # "$cgi_tmp_dir/$sessionId/$subDir" where $subDir = 'taxon_json' or GenomeListJSON see  InnerTable_yui.pm for example
        #  - ken
    $e->{enable_genomelistJson} = 1;

    $e->{enable_interpro} = 1;

    $e->{enable_biocluster} = 1;

    $e->{enable_ani} = 1;

    # yui export table tracker log file
    $e->{yui_export_tracker_log} = "/webfs/scratch/img/yuiExportLog.log";

    # GOLD web service
    #
    $e->{gold_api_base_url} = 'https://gpweb08.nersc.gov:8443/';
    $e->{gold_auth_code}    = encode_base64('jgi_img:&@f8&dJ');

    # GOLD AP metadata saved as perl array objects
    $e->{isolateApDataFile}    = $e->{gold_cache_dir} . 'isolateAp.bin';
    $e->{metagenomeApDataFile} = $e->{gold_cache_dir} . 'metagenomeAp.bin';

    $e->{merfs_timeout_mins} = 40;    # 40 mins

    $e->{ko_module_dir}        = $e->{web_data_dir} . "/km.png.7.7";

    # cgi cache
    # new for 3.1 cgi caching
    # enable cgi cache 0 to disable
    $e->{ cgi_cache_enable } = 1;

    # location of cache directory - this should be a unique directory
    # for each web site
    # to be defined in each individual sites config
    # $e->{ cgi_cache_dir } =  $e->{ cgi_tmp_dir } . "/CGI_Cache";

    # cache expire time in seconds 1 hour = 60 * 60
    # should be less the purge tmp and cgi_tmp times
    $e->{ cgi_cache_default_expires_in } = 3600;
    # max cache size in bytes 20 MB
    # changed max cache to 10 GB - ken
    $e->{cgi_cache_size} = 10000 * 1024 * 1024;

    # for 3.3 test to see if we can cache blast output for public sites
    # for it to work both cgi_cache_enable must be 1
    #     AND cgi_blast_cache_enable = 1
    # this should help during the workshops - Ken
    $e->{ cgi_blast_cache_enable } = 1;

    # see https_cgi_url
    $e->{ssl_enabled} = 1;

    # sso
    # caliban sso
    # if null do not use sso
    #
    # for stage web farm MUST change url to .jgi-psf.org
    #
    $e->{sso_enabled} = 1;
    $e->{sso_domain} = ".jgi.doe.gov";
    $e->{sso_url} = "https://signon" . $e->{sso_domain};
    $e->{sso_cookie_name} = "jgi_return";
    $e->{sso_session_cookie_name} = "jgi_session"; # cookie that stores the caliban session id is has the format of "/api/sessions/30a6fa0dc58d3708"
    $e->{sso_api_url} =  $e->{sso_url} . "/api/sessions/"; # "https://signon.jgi-psf.org/api/sessions/"; # session id from cookie jgi_session
    $e->{sso_user_info_url} = $e->{sso_url} . '/api/users/';

    return $e;
}

# some post fixing after the WebConfig has been loaded
sub postFix {
    my ($e) = @_;

    my $https = CGI::https();
    if ( $https || $e->{ssl_enabled} ) {
        $e->{http}         = "https://";
        $e->{ssl_enabled}  = 1;
        $e->{top_base_url} = $e->{http} . $e->{domain_name} . "/";
        $e->{base_url} =~ s/http:/https:/;
        $e->{cgi_url}  =~ s/http:/https:/;
        $e->{tmp_url}  =~ s/http:/https:/;
    }
}

1;
