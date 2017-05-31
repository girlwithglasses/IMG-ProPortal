package ProPortal::IO::DBIxDataModelQueryLib;

use IMG::Util::Import 'MooRole';

use Time::HiRes;
use IMG::Model::UnitConverter;

use DBIx::DataModel;
use DataModel::IMG_Core;
use DataModel::IMG_Gold;

my $gt_zero = '> 0';

# extra 'case' statements to add to a query
my $case_stts = {

#	adds a query to check whether the taxon is public or private
#	see taxon_name_public for an example of use

#	taxon_table_name may refer to a view that includes taxon.is_public
#	note that vw_gold_taxon *only* contains public genomes

	taxon_public => sub {
		my $self = shift;
		my $args = shift // {};

		my $taxon_table_name = $args->{taxon_table_name} || 'taxon';
		my $case_sql = '';

		if ( $self->can('user') && defined $self->user && defined $self->user->contact_oid ) {
			my $u_id = "= " . $self->user->contact_oid;
			my $taxt = '= ' . $taxon_table_name . '.taxon_oid';

			$case_sql = 'WHEN EXISTS (' .
				$self->schema('img_core')->table('ContactTaxonPermissions')
					->select(
						-columns => [ '1' ],
						-where => {
							taxon_permissions => \ $taxt,
							contact_oid => \ $u_id
						},
						-result_as => 'sql'
					)
				. ") THEN 'accessible' ";
		}

		my $case = "CASE WHEN "
		. $taxon_table_name . ".is_public = 'Yes' THEN 'public' "
		. $case_sql
		. " ELSE 'private'"
		. " END AS viewable";
		return $case;
	}

};

=head2 default_select

Assembles the parts of a standard 'select' query from the query library

=cut

sub default_select {
	my $self = shift;
	my $args = shift;

	if ( $args->{table} ) {
		return $self->schema( delete $args->{schema} )->table( delete $args->{table} )
		->select(
			%$args,
			-result_as => 'statement'
		);
	}
	if ( $args->{join} ) {
		my $j = delete $args->{join};
		return $self->schema( delete $args->{schema} )->join( @$j )
		->select(
			%$args,
			-result_as => 'statement'
		);
	}
}

my $select_queries = {};

# =head3 clade
#
# Search for spp with a clade defined
#
# No additional arguments
#
# =cut

$select_queries->{clade} = sub {
	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ qw( taxon_display_name taxon_oid clade ecotype pp_subset ) ],
		-where    => {
			clade => { '!=', undef },
			'length(clade)' => \$gt_zero
		},
		-order_by => [ qw( clade taxon_display_name ) ],
	};

};

# =head3 distinct_clade
#
# Collect all clades from the ProPortal set
#
# =cut

$select_queries->{distinct_clade} = sub {
	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns => [ qw( clade genus ) ],
		-where    => {
			clade => { '!=' => undef },
		},
		-group_by => [ qw( clade genus ) ],
	};
};

# =head3 location
#
# Search for latitude/longitude
#
# No additional arguments
#
# Queries the VwGoldTaxon table, which is restricted to public taxa
#
# =cut

$select_queries->{location} = sub {

	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ qw( taxon_display_name taxon_oid genome_type ecosystem_subtype geo_location latitude longitude altitude depth ecotype pp_subset ) ],
		-where    => {
			latitude  => { '!=' => undef },
			longitude => { '!=' => undef },
		},
		-order_by => [ qw( latitude longitude genome_type taxon_display_name ) ],
	};
};


# =head3 longhurst_counts
#
#
#
# =cut

$select_queries->{longhurst_counts} = sub {

	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ 'count(taxon_oid)|count', map { 'coalesce(' . $_ . ", 'Unclassified') \"$_\""  } qw( longhurst_code longhurst_description ) ],
		-group_by => [ qw( longhurst_code longhurst_description ) ],
		-order_by => [ 'longhurst_description' ],
		-where => {
			pp_subset => { '!=', undef },
#				is_public => 'Yes'
		},
	};

};

# =head3 longhurst
#
#
#
# =cut

$select_queries->{longhurst} = sub {

	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ 'taxon_oid', 'taxon_display_name', map { 'coalesce(' . $_ . ", 'Unclassified') \"$_\""  } qw( longhurst_code longhurst_description ) ],
#		-group_by => [ qw( longhurst_code longhurst_description ) ],
		-order_by => [ 'longhurst_description', 'taxon_display_name' ],
		-where => {
			pp_subset => { '!=', undef },
#				is_public => 'Yes'
		},
	};

};


# =head3 ecosystem
#
# Query for ecosystem
#
# No additional arguments
#
# =cut

$select_queries->{ecosystem} = sub {

	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ qw( taxon_display_name taxon_oid pp_subset ), map { 'coalesce(' . $_ . ", 'unspecified') \"$_\""  } qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
		-order_by => [ qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem taxon_display_name ) ],
	};
};

# =head3 ecotype
#
# Query for ecotype
#
# =cut

$select_queries->{ecotype} = sub {
	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ qw( taxon_display_name taxon_oid clade ecotype pp_subset ) ],
		-where => {
			'length(ecotype)' => \$gt_zero,
			'length(clade)' => \$gt_zero,
		},
		-order_by => [ qw( ecotype clade taxon_display_name ) ]
	};
};

# =head3 phylogram
#
# NCBI + IMG taxonomy
#
# =cut

$select_queries->{phylogram} = sub {
	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ qw( genome_type taxon_oid taxon_display_name ncbi_taxon_id img_domain img_phylum img_class img_order img_family clade ncbi_kingdom ncbi_phylum ncbi_class ncbi_order ncbi_family ncbi_genus ncbi_species pp_subset ) ],
		-order_by => [ qw( genome_type img_domain img_phylum img_class img_order img_family clade taxon_display_name ) ],
	};

};

# =head3 taxon_oid_display_name
#
# Simple tax ID / name query
#
# =cut

$select_queries->{taxon_oid_display_name} = sub {

	return {
		schema => 'img_core',
		table  => 'Taxon',
		-columns  => [ 'taxon_oid', 'taxon_display_name' ],
	};
};

# =head3 taxon_dataset_type
#
# dataset type view query
#
# =cut

$select_queries->{taxon_dataset_type} = sub {

	return {
		schema => 'img_core',
		table  => 'PpDataTypeView',
		-columns  => [ '*' ],
		-order_by => [ qw( dataset_type pp_subset taxon_display_name ) ],
	};
};

# =head3 subset_stats
#
# Count of number of genomes in each of the proportal subset types
#
# @param  [none]
#
# @return $resultset, with fields:
#
# pp_subset => ..., count => ...
#
# =cut

$select_queries->{subset_stats} = sub {

	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns => [ 'pp_subset', 'count(distinct taxon_oid)|count' ],
		-group_by => 'pp_subset',
	};
};



$select_queries->{metagenomes_by_ecosystem} = sub {

	return {
		schema => 'img_core',
		table  => 'VwGoldTaxon',
		-columns  => [ 'count(distinct taxon_oid)|count', qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
		-group_by => [ qw( ecosystem ecosystem_category ) ],
		-where => {
			pp_subset => 'metagenome'
		}
	};
};


=head3 taxon_metadata

Given an array of taxon IDs (or other 'where' statement to identify
taxa), retrieve all associated metadata

@param  args->{where} should be in the form

	taxon_oid => [ arrayref of taxon IDs ]

@return $resultset, with fields:

=cut

$select_queries->{taxon_metadata} = sub {
	my $self = shift;
	return {
		schema => 'img_core',
		join => [ qw[ GoldSequencingProject <=> taxa <=> dataset_type ] ],
#		table  => 'VwGoldTaxon',
		-columns  => [ 'pp_data_type_view.dataset_type|dataset_type', 'pp_data_type_view.pp_subset|pp_subset', 'taxon.taxon_oid|taxon_oid', 'gold_sequencing_project.*', 'taxon.*' ],
		-order_by => 'taxon.taxon_oid',
		-where => {
			'taxon.is_public' => 'Yes'
		}
	};
};

$select_queries->{extended_taxon_metadata} = sub {
	my $self = shift;
	my @tables = ( qw[ Gold_Sequencing_Project Taxon Taxon_Stats ] );
	my $col_h = {
		# Pp_Data_Type_View - only want dataset_type and pp_subset
		pp_data_type_view => [ qw( dataset_type pp_subset ) ]
	};
	for ( @tables ) {
		my $t = $_;
		$t =~ s/_//g;
		my $sth = $self->schema('img_core')->table( $t )->select( -result_as => 'sth' );
		$col_h->{ $t } = $sth->{NAME_lc};
	}

	log_debug { 'col_h: ' . Dumper $col_h };

	# remove known dupes?


	return {
		schema => 'img_core',
		join => [ qw[ GoldSequencingProject <=> taxa <=> dataset_type taxon_stats ] ],
#		table  => 'VwGoldTaxon',
		-columns  => [ 'pp_data_type_view.dataset_type', 'pp_data_type_view.pp_subset', 'taxon.taxon_oid', map { "$_.*" } @tables ],
		-order_by => 'taxon.taxon_oid',
		-where => {
			'taxon.is_public' => 'Yes'
		}
	};
};



# =head3 gene_oid_taxon_oid
#
# Given an array of gene IDs, get the taxon_oid
#
# @param  args->{where} should be in the form
#
# 	gene_oid => [ arrayref of gene IDs ] (or a single gene_oid)
#
# @return arrayref of results in the format
#
# 	{ gene_oid => #####, taxon_oid => ##### }
#
# =cut

$select_queries->{gene_oid_taxon_oid} = sub {

	return {
		schema => 'img_core',
		table  => 'Gene',
		-columns => [ qw( gene_oid taxon|taxon_oid ) ],
	};
};

# =head3 gene_list
#
# Get all genes by taxon_oid (or other criterion)
#
# @param taxon_oid => nnnnnnnnn
#
# @return arrayref of gene objects
#
# =cut

$select_queries->{gene_list} = sub {
	my $self = shift;
	my $args = shift;
	if ( $args->{filters}{category} ) {
		if ( grep { $_ eq $args->{filters}{category} } qw( transmembrane signalp fused biosynthetic_cluster cassette ) ) {
			return $select_queries->{ 'gene_list_' . $args->{filters}{category} }->( $self, $args );
		}
	}

	return {
		schema => 'img_core',
		join  => [ qw[ Gene <=> scaffold <=> gold_tax ] ],
		-columns => [ qw(
			gene_oid
			gene_symbol
			gene_display_name
			product_name
			description
			gene.taxon|taxon_oid
			taxon_display_name
			pp_subset
			gene.scaffold|scaffold_oid
			scaffold_name
		) ],
		-where   => { 'gene.obsolete_flag' => 'No' },
	};
};

# 	biosynthetic_genes

# 	select distinct bcf.feature_id
# 	from bio_cluster_features_new bcf, bio_cluster_new g
# 	where bcf.feature_type = 'gene'
# 	and bcf.cluster_id = g.cluster_id
# 	and g.taxon = $taxon_oid
# 	$rclause
# 	$imgClause

$select_queries->{gene_list_biosynthetic_cluster} = sub {
	my $self = shift;
	my @cols = qw( gene_oid gene_symbol gene_display_name product_name taxon );
	my $h = {
		schema => 'img_core',
		join  => [ qw[ Gene <=> bio_cluster_features_new ] ],
		-columns => [
			map { "gene.$_" } @cols
		],
		-where => {
			'gene.obsolete_flag' => 'No',
			'bio_cluster_features_new.feature_type' => 'gene'
		},
		-group_by => [
			map { "gene.$_" } @cols
		],
		-order_by => 'gene.gene_oid'
	};
	$h->{-columns}[-1] .= '|taxon_oid';
	return $h;
};

# 	fusedGenes

# 	select g.gene_oid, g.gene_display_name, count( gfc.component )
# 	from gene g, gene_fusion_components gfc
# 	where g.gene_oid = gfc.gene_oid
# 	and g.obsolete_flag = 'No'
# 	and g.taxon = ?
# 	$rclause
# 	$imgClause
# 	group by g.gene_oid, g.gene_display_name
# 	order by g.gene_oid, g.gene_display_name

$select_queries->{gene_list_fused} = sub {
	my $self = shift;

	my @cols = qw( gene_oid gene_symbol gene_display_name product_name taxon );
	my $h = {
		schema => 'img_core',
		join  => [ qw[ GeneFusionComponents <=> gene <=> taxon ] ],
		-columns => [
			'taxon_display_name', ( map { "gene.$_" } @cols )
		],
		-where => {
			'gene.obsolete_flag' => 'No'
		},
		-group_by => [
			( map { "gene.$_" } @cols ), 'taxon_display_name'
		],
		-order_by => 'gene.gene_oid'
	};
	$h->{-columns}[-1] .= '|taxon_oid';

#	log_debug { 'h: ' . Dumper $h };

	return $h;
};

# 	signalpGeneList
#
# 	select distinct g.gene_oid
# 	from gene g, gene_sig_peptides gsp
# 	where g.gene_oid = gsp.gene_oid
# 	and g.obsolete_flag = 'No'
# 	and g.locus_type = 'CDS'
# 	and g.taxon = ?
#

$select_queries->{gene_list_signalp} = sub {
	my $self = shift;

	my @cols = qw( gene_oid gene_symbol gene_display_name product_name taxon );
	my $h = {
		schema => 'img_core',
		join  => [ qw[ GeneSigPeptides <=> gene <=> taxon ] ],
		-columns => [
			'taxon_display_name', ( map { "gene.$_" } @cols )
		],
		-where => {
			'gene.obsolete_flag' => 'No',
			'gene.locus_type' => 'CDS'
		},
		-group_by => [
			( map { "gene.$_" } @cols ), 'taxon_display_name'
		],
		-order_by => 'gene.gene_oid'
	};
	$h->{-columns}[-1] .= '|taxon_oid';
	return $h;
};

# 	transmembraneGeneList
#
# 		select distinct g.gene_oid
# 		from gene g, gene_tmhmm_hits gth
# 		where g.taxon = ?
# 		and g.obsolete_flag = 'No'
# 		and g.locus_type = 'CDS'
# 		and g.gene_oid = gth.gene_oid
# 		and gth.feature_type = 'TMhelix'
#		{ locus_type => 'CDS',  }

$select_queries->{gene_list_transmembrane} = sub {
	my $self = shift;

	my @cols = qw( gene_oid gene_symbol gene_display_name product_name taxon );
	my $h = {
		schema => 'img_core',
		join  => [ qw[ GeneTmhmmHits <=> gene <=> gold_tax ] ],
		-columns => [
			'taxon_display_name', ( map { "gene.$_|$_" } @cols ),
		],
		-where => {
			'gene.obsolete_flag' => 'No',
			'gene.locus_type' => 'CDS',
			'gene_tmhmm_hits.feature_type' => 'TMhelix'
		},
		-group_by => [
			( map { "gene.$_" } @cols ), 'taxon_display_name'
		],
		-order_by => 'gene.gene_oid'
	};
	$h->{-columns}[-1] = 'gene.taxon|taxon_oid';
	return $h;
};

## TO CHECK!

$select_queries->{gene_list_cassette} = sub {
	my $self = shift;
	my @cols = qw( gene_oid gene_symbol gene_display_name product_name taxon );

#	gene_cassette has taxon
#	gc.cassette_oid=gcg.cassette_oid

	my $h = {
		schema => 'img_core',
		join  => [ qw[ GeneCassette <=> gene_cassette_genes <=> gene <=> gold_tax ] ],
		-columns => [
			'taxon_display_name', ( map { "gene.$_|$_" } @cols ),
		],
		-where => {
			'gene.obsolete_flag' => 'No',
			'gene.locus_type' => 'CDS',
		},
		-group_by => [
			( map { "gene.$_" } @cols ), 'taxon_display_name'
		],
		-order_by => 'gene.gene_oid'
	};
	$h->{-columns}[-1] = 'gene.taxon|taxon_oid';
	return $h;
};


$select_queries->{gene_list_by_taxon} = sub {
	my $self = shift;

	my $arr = $self->run_query({
		query => 'taxon_name_public',
		-where => { 'taxon_oid' => $self->filters->{taxon_oid} },
	});

	if ( scalar @$arr != 1 ) {
		# Crap! an error!
		log_error { 'row count: ' . scalar @$arr };
	}
	my $tax = $arr->[0];
	# get the sth for retrieving the gene list
	my $sth = $tax->expand( 'genes', ( -result_as => 'statement' ) );

	log_debug { 'sth now: ' . $sth };

	return $sth;

};

# =head3 cycog_list
#
# CyCOG table only
#
# =cut

$select_queries->{cycog_list} = sub {
	return {
		schema => 'cycog',
		table  => 'Cycog',
	};
};

$select_queries->{fn_list_cycog} = sub {
	return {
		schema => 'cycog',
		table  => 'Cycog',
		-columns => [ qw( 'CyCOG'|db id|xref description|name cluster_size unique_taxa duplication_events ) ],
	};
};


$select_queries->{cycog_details} = sub {

	return {
		schema => 'cycog',
		table  => 'Cycog',
	};
};

# =head3 cycogs_by_annotation_criteria
#
# CyCOG data, based on some annotation property
#
# =cut

$select_queries->{cycog_by_annotation} = sub {

	return {
		schema => 'cycog',
		join => [ qw[ GeneCycogGroups <=> cycog ] ],
		-columns => [ 'cycog.*, gene_cycog_groups.version, gene_cycog_groups.paralogs' ],
	};
};

# =head3 cycog_version
#
# =cut

$select_queries->{cycog_version} = sub {

	return {
		schema => 'cycog',
		table => 'CycogRelease',
	};
};

# =head3 cycog_version_latest
#
# The most recent CyCOG release
#
# =cut

$select_queries->{cycog_version_latest} = sub {

	return {
		schema => 'cycog',
		join => [ qw[ CycogRelease <=> current ] ],
		-columns => [ 'cycog_release.*' ],
	};
};

my $db_hash = {
	biocyc => 'AnnotBiocycPathway',
	cog => 'AnnotCog', # COG cluster? func? pway?
	ec => 'AnnotEnzyme',
	go => 'AnnotGo',
	img_term => 'AnnotImgTerm',
	kegg_module => 'AnnotKeggModule',
	kegg_pathway => 'AnnotKeggPathway',
	ko => 'AnnotKo',
	kog => 'AnnotKog', # absent,
	pfam => 'AnnotPfam', # check the db is correct -- should it be PFXXXXX?
	pdb => 'AnnotPdb',
	seed => 'AnnotSeed',
	tc => 'AnnotTc',
	tigrfam => 'AnnotTigrfam',
#	other => 'AnnotXref'

};

=cut

coils
gene3d
hamap
interpro
panther
pfam
prints
prositepatterns # check!
prositeprofiles # check these
smart # ??
superfamily
tigrfam
uniprot

=cut

for ( keys %$db_hash ) {
	$select_queries->{ $_ } = sub {
		return {
			table => $db_hash->{$_}
		};
	};
}



# =head3 gene_details
#
# Given an array of gene IDs, get the gene data
#
# @param  args->{where} should be in the form
#
# 	gene_oid => [ arrayref of gene IDs ] (or a single gene_oid)
#
# @return arrayref of results in the format
#
# 	{ gene => #####, taxon => ##### }
#
# =cut

$select_queries->{gene_details} = sub {

	return {
		schema => 'img_core',
		join => [ qw[ Gene <=> scaffold <=> gold_tax ] ],
		-columns => [ 'gene.*', 'taxon_oid', 'taxon_display_name', 'scaffold_oid', 'scaffold_name' ],
	};

};

# replaced genes
$select_queries->{replaced_gene} = sub {
	return {
		schema => 'img_core',
		table  => 'GeneReplacements',
	};
};

# unmapped (no longer valid)
$select_queries->{unmapped_gene} = sub {
	return {
		schema => 'img_core',
		table  => 'UnmappedGenesArchive',
	};
};

# old metagenome ID
$select_queries->{old_metagenome_gene} = sub {

	# gene_oid, merfs_gene_id, locus_tag, taxon
	return {
		schema => 'img_core',
		table => 'MerfsGeneMapping'
	};
};

$select_queries->{gene_details_with_checks} = sub {
	my $self = shift;
	my $args = shift;




	# we have a 'normal' gene!
	return $select_queries->{gene_details}->( $self, $args );

};

# =head3 taxon_details
#
# Taxon details from taxon and gold_sequencing_project tables
#
# =cut

$select_queries->{taxon_details} = sub {

	my $self = shift;
	my $args = shift;

	my $results = $self->default_select( $select_queries->{taxon_name_public}->( $self, $args ) )->all;

	if ( scalar @$results > 0) {
		if ( $results->[0]->{viewable} eq 'private' ) {
			# dies if there is a permissions error
			$self->choke({
				err => 'private_data'
			});
		}

		# otherwise, return taxonomic info
		return {
			schema => 'img_core',
			join => [ qw[ GoldSequencingProject <=> taxa ] ],
			-columns => [ '*' ],
			-where => { 'taxon.taxon_oid' => $args->{where}{taxon_oid} },
		};
	}

	$self->choke({
		err => 'invalid',
		subject => $args->{where}{taxon_oid},
		type => 'taxon_oid'
	});

};

# =head3 scaffold_details
#
# Given an array of scaffold IDs, retrieve the scaffold data plus taxon ID and name
#
# Uses table gold_tax, so implicitly only selects public genomes
#
# @param  args->{where} should be in the form
#
# 	scaffold_oid => [ arrayref of scaffold IDs ] (or a single scaffold_oid)
#
# @return arrayref of scaffold objects
#
# =cut



$select_queries->{scaffold_details} = sub {

	return {
		schema => 'img_core',
		table => 'Scaffold'
	};

};

$select_queries->{scaffold_with_taxon} = sub {
	return {
		schema => 'img_core',
		join => [ qw[ Scaffold <=> taxa ] ],
		-columns => [ qw(
			scaffold_oid
			scaffold_name
			taxon_oid
			taxon_display_name
			is_public
			obsolete_flag
		) ],
	};
};



# =head3 scaffold_list
#
# Given search criteria, retrieve the scaffold data plus taxon ID and name
#
# Uses table gold_tax, so implicitly only selects public genomes
#
# @param  args->{where} encodes filter data
#
# @return arrayref of scaffold objects
#
# =cut


$select_queries->{scaffold_list} = sub {
	return {
		schema => 'img_core',
		join => [ qw[ Scaffold <=> gold_tax ] ],
		-columns => [ qw(
			scaffold_oid
			scaffold_name
			mol_type
			mol_topology
			db_source
			ext_accession
			taxon_oid
			taxon_display_name
			pp_subset
		) ],
	};
};

# =head3 taxon_name_public
#
# @param  args->{where} should be in the form
#
# 	taxon_oid   => ######
#
# @return arrayref of results in the format
#
# 	{	taxon_oid => #####,
# 		taxon_display_name => #####,
# 		is_public => 'Yes|No',
# 		viewable => 'public|private|accessible'
# 	}
#
# =cut

$select_queries->{taxon_name_public} = sub {
	my $self = shift;
	my $args = shift;

	my $tax_stt = $case_stts->{taxon_public}->( $self );
	log_debug { $tax_stt };

	return {
		schema => 'img_core',
		table => 'Taxon',
		-columns => [ $tax_stt, qw( taxon_oid taxon_display_name is_public ) ],
		-where   => $args->{-where},
	};

};


# =head3 taxon_permissions_by_contact_oid
#
# Given a user's contact ID and a taxon ID, see if the user is permitted
# to access the taxon.
#
# @param  args->{where} should be in the form
#
# 	taxon_permissions   => ######
# 	contact_oid => ######
#
# @return arrayref of results in the format
#
# 	{ contact_oid => #####, taxon_permissions => ##### }
#
# =cut

$select_queries->{taxon_permissions_by_contact_oid} = sub {
	my $self = shift;
	my $args = shift;

	$args->{where}{taxon_permissions} = delete $args->{where}{taxon_oid} if $args->{where}{taxon_oid};

	return {
		schema => 'img_core',
		table => 'ContactTaxonPermissions',
		-columns => [ qw( contact_oid taxon_permissions ) ],
		-where   => $args->{where},
	};
};

# =head3 user_data
#
# Get the data for a user or set of users.
#
# @param  args->{where} should be in the form
#
# 	contact_oid => # IMG user ID  OR
# 	caliban_id  => # user ID on the JGI Caliban system  OR
# 	email       => # email addr
#
# 	# or other distinguishing feature(s)
#
# =cut

$select_queries->{user_data} = sub {

	my @cols = qw( contact_oid username name super_user email img_editor img_group img_editing_level );

	return {
		schema => 'img_core',
		table => 'Contact',
		-columns  => [ @cols ],
	};
};

# =head3
#
# Check for banned users
#
# @param   args->{where} featuring either
#
# 	username => ... OR
# 	email    => ...
#
# =cut

$select_queries->{banned_users} = sub {

	return {
		schema => 'img_core',
		table => 'CancelledUser',
		-columns => [ qw( username email ) ],
	};
};



# =head3 news
#
# Get the ProPortal news!
#
# NO LONGER USED
#
# =cut

$select_queries->{news} = sub {
	my $self = shift;

	my $g_id = 26;

	my $where = { group_id => $g_id };

# select * from img_group_news where group_id = 26 AND
# ( is_public = 'Yes' OR exists (select 1 from contact_img_groups WHERE img_group = 26 AND contact_oid = 4 ) );

	if ( $self->can('user') && defined $self->user && defined $self->user->contact_oid ) {

		if ( ! $self->user->is_superuser ) {
			my $exists_stt =
				'( ' .
				$self->schema('img_core')->table('ContactImgGroups')
					->select(
						-columns => [ '1' ],
						-where => {
							contact_oid => \ "= $self->user->contact_oid",
#							contact_oid => \ '= 110602',
							img_group   => \ "= $g_id",
						},
						-result_as => 'sql' ) . ' )';

			$where = { '-and' => {
				group_id => $g_id,
				'-or' => [ { is_public => 'Yes' }, { 'exists' => \$exists_stt } ]
			} };
		}
	}
	else {
		$where->{is_public} = 'Yes';
	}

	return {
		schema => 'img_core',
		table => 'ImgGroupNews',
		-columns   => [ qw( news_id title add_date ) ],
		-where     => $where,
		-order_by  => [ 'add_date' ],
	};

};




sub get_query {
	my $self = shift;
	my $args = shift;

	my $query = $args->{query}
		# no query specified
		or $self->choke({
			err => 'missing',
			subject => 'database query'
		});

	# die if it isn't in the query hash or defined as a sub
	if ( ! $select_queries->{ $query } ) { #&& ! $self->can($query) ) {
		$self->choke({
			err => 'invalid',
			subject => $query,
			type => 'database query'
		});
	}

=cut

   -columns       => \@columns,
     # OR : -columns => [-DISTINCT => @columns],
   -where         => \%where_criteria,
     # OR : -fetch => $key,
     # OR : -fetch => \@key,
   -where_on      => \%where_on_criteria,
   -group_by      => \@groupings,
   -having        => \%having_criteria,
   -order_by      => \@order,
   -for           => $purpose,
   -post_SQL      => sub {...},
   -pre_exec      => sub {...},
   -post_exec     => sub {...},
   -post_bless    => sub {...},
   -prepare_attrs => \%attrs,
   -limit         => $limit,
   -offset        => $offset,
   -page_size     => $page_size,
   -page_index    => $page_index,
   -column_types  => \%column_types,
   -result_as     => 'rows'      || 'firstrow'
                  || 'hashref'   || [hashref => @cols]
                  || 'sth'       || 'sql'
                  || 'subquery'  || 'flat_arrayref'
                  || 'statement' || 'fast_statement'

=cut
	# these get sent directly to the statement creator
	my %extras;
	for ( keys %$args ) {
		$extras{ $_ } = $args->{$_} if /^-/;
	}
	if ( $args->{where} ) {
		log_warn { 'remove WHERE args: ' . Dumper $args->{where} };
		$extras{-where} = { %{ $extras{-where} || {} }, %{$args->{where}} };
	}

	my $sel_args = $select_queries->{ $query }->( $self, $args );
	$sel_args->{schema} ||= 'img_core';

	my $stt = $self->default_select({
		%$sel_args,
		%extras
	});

	# add filters
	if ($args->{filters}) {

		## This is implemented by ProPortal::IO::ProPortalFilters
		my $f = $self->filter_sqlize({
			filters => $args->{filters},
			query => $query
		});
		$stt->refine( -where => $f );
	}

	return $stt;
}

1;
