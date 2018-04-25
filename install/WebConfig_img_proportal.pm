#
# $Id: WebConfig_img_proportal.pm 36822 2017-03-23 20:44:59Z aireland $
#
#	configuration for a production instance of the ProPortal code
#

package WebConfig_img_proportal;

our ( @ISA, @EXPORT_OK );

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( getEnv );
}

use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;
use File::Spec::Functions qw( catdir catfile );

use URI;
use WebConfigCommon;

sub make_config {

	return make_derivatives( get_env_tmpl( shift ) );

# 	{
# 		domain_name => 'img-proportal.jgi.doe.gov',
# 		pp_app => "https://img-proportal.jgi.doe.gov/",
#
# 		# home of css, js, images folders. Should end with "/"
# 		pp_assets => "https://img-proportal.jgi.doe.gov/",
#
# 		# main.cgi location
# 		main_cgi_url => 'https://img-proportal.jgi.doe.gov/cgi-bin/main.cgi',
# 		base_url => 'https://img-proportal.jgi.doe.gov',
#
# 		jbrowse => {
# 			main   => 'https://img-jbrowse.jgi.doe.gov',
# 			assets => 'https://img-jbrowse.jgi.doe.gov/jbrowse_assets/'
# 		},
# 	};

#	$args->{schema} = schema();

#	schema stuff
# 	if ( $args->{img_core_db} ) {
# 		$args->{schema}{img_core}{db} = delete $args->{img_core_db};
# 	}
# 	if ( $args->{img_gold_db} ) {
# 		$args->{schema}{img_gold}{db} = delete $args->{img_gold_db};
# 	}
}

sub make_derivatives {

	my $args = shift;
	die 'No arguments supplied' unless defined $args && 'HASH' eq ref $args;

	$args->{pp_app} = $args->{top_base_url};
	$args->{pp_assets} = $args->{top_base_url};

	return $args;
}


sub get_env_tmpl {  ## COPIED FROM WebConfig-img-dev-mer
	my $args = shift;

# 	domain_name => 'img-proportal.test',
# 	jbrowse => 'https://img-jbrowse.test',
# 	galaxy => 'https://img-galaxy.test',
# 	in_place => 1,
# 	webUI_dir => '/global/homes/a/aireland/webUI',
# 	scratch_dir => '/tmp/jbrowse',
# 	web_data_dir => '/Users/gwg/webUI/proportal/t/files/img_web_data',

    my $e = WebConfigCommon::common( $args );

	# copy over jbrowse and galaxy URLs
	$e->{jbrowse} = {
		main => $args->{jbrowse},
		assets => $args->{jbrowse} . '/jbrowse_assets/'
	};

	for ( qw( galaxy scratch_dir message message_html ) ) {
		$e->{$_} = $args->{$_} if $args->{$_};
	}

    my $urlTag         = $args->{urlTag} || "";
    my $dbTag          = $e->{dbTag};
    my $webfsVhostDir  = '/webfs/projectdirs/microbial/img/public-web/vhosts/';
    my $apacheVhostDir = '/global/homes/w/wwwimg/apache/content/vhosts/';
    my $log_dir        = '/webfs/scratch/img/logs';
    my $cgi_tmp_dir    = '/opt/img/temp/';

    $e->{main_cgi}     = 'main.cgi';
    $e->{inner_cgi}    = 'inner.cgi';
    $e->{http}         = 'https://';
    $e->{arch}         = 'x86_64-linux';
    $e->{urlTag}       = $urlTag;

	$e->{sso_url_prefix} = 'https://signon';

	# remove trailing slash
    $args->{domain_name} =~ s!/$!!;

    $e->{domain_name}  = $args->{domain_name};

    $e->{top_base_url} = $e->{http} . $e->{domain_name} . "/";

#	$e->{base_url} = $e->{http} . $e->{domain_name} . "/$urlTag";
#	$e->{cgi_url}  = $e->{http} . $e->{domain_name} . "/cgi-bin/$urlTag";

	$e->{base_url} = 'https://' . $e->{domain_name};
	$e->{cgi_url}  = 'https://' . $e->{domain_name} . '/cgi-bin';

	if ( $urlTag ) {
		for ( qw( base_url cgi_url ) ) {
			$e->{$_} .= "/$urlTag";
		}
	}

	# see ssl_enabled
#	$e->{https_cgi_url} = "https://" . $e->{domain_name} . "/cgi-bin/$urlTag/" . $e->{main_cgi};

	$e->{main_cgi_url} = $e->{cgi_url} . '/' . $e->{main_cgi};
	$e->{https_cgi_url} = $e->{main_cgi_url};

    #
    # DO NOT update base_dir base_dir_stage cgi_url cgi_dir cgi_dir_stage
    # - ken
    #

	if ( $args->{in_place} ) {
		$e->{top_base_dir}   = $args->{webUI_dir};

		$e->{base_dir}       = catdir( $args->{webUI_dir}, 'webui.htd' );
		$e->{cgi_dir}        = catdir( $args->{webUI_dir}, 'webui.cgi' );
		$e->{base_dir_stage} = catdir( $args->{webUI_dir}, 'webui.htd' );
		$e->{cgi_dir_stage}  = catdir( $args->{webUI_dir}, 'webui.cgi' );
	}
	else {

		$e->{top_base_dir}   = catdir( $apacheVhostDir, $e->{domain_name}, "htdocs" ) . '/';

		$e->{base_dir}       = catdir( $apacheVhostDir, $e->{domain_name}, "htdocs" );
		$e->{cgi_dir}        = catdir( $apacheVhostDir, $e->{domain_name}, "cgi-bin" );

		$e->{base_dir_stage} = catdir( $webfsVhostDir, $e->{domain_name}, "htdocs" );
		$e->{cgi_dir_stage}  = catdir( $webfsVhostDir, $e->{domain_name}, "cgi-bin" );
	}

	if ( $urlTag ) {
		for ( qw( base_dir cgi_dir cgi_dir_stage base_dir_stage ) ) {
			$e->{ $_ } .= "/$urlTag";
		}
	}

	$e->{tmp_url}       = $e->{base_url} . "/tmp";
	$e->{tmp_dir}       = $e->{base_dir} . "/tmp";

	$e->{log_dir}       = $log_dir;
	$e->{web_log_file}  = "$log_dir/" . $e->{domain_name}
	. ( $urlTag ? $dbTag . "_" . $urlTag : '' )
	. ".log";
	$e->{err_log_file}  = "$log_dir/" . $e->{domain_name}
	. ( $urlTag
		? $dbTag . "_" . $urlTag
		: '' )
	. ".err.log";

	#$e->{cgi_tmp_dir} = "/webfs/scratch/img/opt_img_shared/temp/" . $e->{domain_name} . "_" . $urlTag;
	$e->{cgi_tmp_dir} = $cgi_tmp_dir . $e->{domain_name} . ( $urlTag ? "_" . $urlTag : '' );

	# location of cache directory - this should be a unique directory
	# for each web site
	$e->{cgi_cache_dir} = $e->{cgi_tmp_dir} . "/CGI_Cache";

	#	return $e;

	# optional precomputed homologs server with -m 0 output
	$e->{img_lid_blastdb} = "${dbTag}_lid";

	# IMG long ID (<gene_oid>_<taxon>_<aa_seq_length>)
	# BLAST database.
	$e->{img_iso_blastdb} = "${dbTag}_iso";

	# IMG long ID (<gene_oid>_<taxon>_<aa_seq_length>)
	# Isolate BLAST database.
	$e->{img_rna_blastdb} = "${dbTag}_rna.fna";

	# IMG long ID (<gene_oid>_<taxon>_<aa_seq_length>_<geneSymbol>)
	# Meta RNA BLAST database.
	$e->{img_meta_rna_blastdb} = "metag_rna.fna";

	# IMG long ID (<taxon>.a:<gene_oid>_<aa_seq_length>)
	# BLAST database.
	$e->{ncbi_blast_server_url} = $e->{cgi_url} . "/ncbiBlastServer.cgi";

	# Client web server to NCBI BLAST.

	$e->{vista_url_map_file} = $e->{cgi_dir} . "/vista.tab.txt";
	$e->{vista_sets_file}    = $e->{cgi_dir} . "/vista.sets.txt";

	$e->{otf_phyloProfiler_method} = "usearch";

	# On the fly usearch

	$e->{include_metagenomes} = 1;

	# Include metagenome configuration.

	$e->{enable_workspace} = 1;
	$e->{img_group_share}  = 1;

	# kog is for 3.4 not 3.3
	$e->{include_kog}      = 1;
	$e->{include_bbh_lite} = 0;    # Include BBH lite files.

	$e->{img_internal} = 0;

	# Add internal for IMG/I.

	# added cassette bbh selection to the ui
	$e->{enable_cassette}         = 1;    # new for 3.4
	$e->{include_cassette_bbh}    = 0;
	$e->{include_cassette_pfam}   = 1;    # used by profiler for now - ken
	$e->{enable_cassette_fastbit} = 1;

	$e->{img_geba} = 1;

	# show GEBA genomes and stats

	$e->{img_er} = 1;

	# IMG/ER isolate specific features.

	$e->{include_ht_homologs} = 1;

	# Mark horizontal transfers in gene page homologs.
	$e->{include_ht_stats} = 2;

	# Show horizontal transfers in genome details page.
	# MENUS
	$e->{show_myimg_login} = 0;

	# Show login for MyIMG.

	$e->{show_mygene} = 1;

	# Show mygene setup.

	$e->{show_mgdist_v2} = 1;

	# Show version 2 of metagenome distribution.
	## NO LOGINS!
	$e->{user_restricted_site} = 0;

	# Restrict site requiring individual permissions.

	# not for 3.3
	$e->{snp_enabled} = 0;    # SNP

	# mpw - ken
	$e->{mpw_pathway} = 1;

	$e->{oracle_config}             = $e->{oracle_config_dir} . "web.$dbTag.config";
	$e->{img_er_oracle_config}      = $e->{oracle_config_dir} . "web.$dbTag.config";
	$e->{img_gold_oracle_config}    = $e->{oracle_config_dir} . "web.imgsg_dev.config";
	$e->{img_i_taxon_oracle_config} = $e->{oracle_config_dir} . "web.img_i_taxon.config";

	$e->{myimg_job}      = 1;
	$e->{myimg_jobs_dir} = $e->{web_data_dir} . "/myimg.jobs";

	# Results of job submissions

	$e->{all_faa_blastdb} = $e->{web_data_dir} . "/all.faa.blastdbs/all_$dbTag";
	$e->{all_fna_blastdb} = $e->{web_data_dir} . "/all.fna.blastdbs/all_$dbTag";

	# Name of all protein and nucleic acid BLAST databases.
	# Need to customize for subset.

	$e->{phyloProfile_file} = $e->{web_data_dir} . "/phyloProfile.$dbTag.txt";

	# Phylogenetic profile file.

	$e->{include_taxon_phyloProfiler} = 1;

	# Phylo profiler at taxon level.

	$e->{taxon_stats_dir} = $e->{web_data_dir} . "/taxon.stats.$dbTag";

	##################
	$e->{bin_dir}          = $e->{cgi_dir} . "/bin/" . $e->{arch};

	for my $bin ( qw(
		bl2seq
		fastacmd
		formatdb
		megablast
		clustalw
		snpCount
		grep
		findHit
		phyloSim
		wsimHomologs
		cluster
		raxml
	) ) {
		$e->{ $bin . '_bin' } = catfile( $e->{bin_dir}, $bin );
	}

	$e->{small_color_array_file} = $e->{cgi_dir} . "/color_array.txt";
	$e->{large_color_array_file} = $e->{cgi_dir} . "/rgb.scrambled.txt";
	$e->{dark_color_array_file}  = $e->{cgi_dir} . "/dark_color.txt";
	$e->{green2red_array_file}   = $e->{cgi_dir} . "/green2red_array.txt";

	$e->{verbose} = 1;

	# General verbosity level. 0 - very little, 1 - normal,
	#   >1 more verbose.
	# -1 to turn off webLog - ken

	$e->{show_sql_verbosity_level} = 1;

	# Minimum verbosity level before SQL is logged.
	# Set to 2 or above to avoid getting most SQL queries logged,
	# for e.g., in production systems.

	## Charting parameters

	# location of the runchart.sh script
	# IF blank "" the charting feature will be DISABLED
	$e->{chart_exe} = $e->{cgi_dir} . "/bin/runchart.sh";

	# chart script logging feature - used only of debugging
	# best to leave it blank "" or "/dev/null"
	$e->{chart_log} = "";

	# new for 3.2
	# decorator.sh
	#
	$e->{decorator_exe} = $e->{cgi_dir} . "/bin/decorator.sh";

	# location of jar files
	$e->{decorator_lib} = $e->{base_dir};

	# decorator script logging feature - used only of debugging
	# best to leave it blank "" or "/dev/null"
	$e->{decorator_log} = "";

	# new for 3.3 - ken
	# if blank it will run the old way as in 3.2
	$e->{blast_wrapper_script} = $e->{cgi_dir} . "/bin/blastwrapper.sh";

	# new for 3.3 - ken
	$e->{dblock_file} = $e->{dbLock_dir} . $dbTag;

	# My bins
	$e->{enable_mybin}    = 0;
	$e->{mybin_blast_dir} = $e->{workspace_dir} . "/blast_mer";

	# MER-FS
	$e->{mer_data_dir} = "/global/dna/projectdirs/microbial/img_web_data_merfs";
	$e->{in_file}      = "in_file";
	## use new taxon function count tables for MER-FS
	$e->{new_func_count} = 1;

	$e->{rnaseq} = 1;    # only er - ken

	# find function static pages

	for my $static ( qw( cog enzyme kog ko pfam ) ) {
		$e->{ $static . '_data_file' } = catfile( $e->{ webfs_data_dir }, 'functions', $static . 'Stats.txt' );
	}
#	$e->{cog_data_file}     = $e->{ webfs_data_dir } ."functions/cogStats.txt";
#	$e->{enzyme_data_file}  = $e->{ webfs_data_dir } ."functions/enzymeStats.txt";
#	$e->{kog_data_file}     = $e->{ webfs_data_dir } ."functions/kogStats.txt";
#	$e->{ko_data_file}      = $e->{ webfs_data_dir } ."functions/koStats.txt";
#	$e->{pfam_data_file}    = $e->{ webfs_data_dir } ."functions/pfamStats.txt";

	$e->{kegg_data_file}    = $e->{ webfs_data_dir } ."functions/keggModStats.txt";
	$e->{tigrfam_data_file} = $e->{ webfs_data_dir } ."functions/tfamStats.txt";


	# domain_stats_file
	$e->{domain_stats_file} = $e->{webfs_data_dir} . "ui/prod/domain_stats_mer_v400.txt";

	WebConfigCommon::postFix($e);
	return $e;
}

1;
