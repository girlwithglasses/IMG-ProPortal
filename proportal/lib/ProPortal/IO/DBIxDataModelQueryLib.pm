package ProPortal::IO::DBIxDataModelQueryLib;

use IMG::Util::Import 'MooRole';

use Time::HiRes;
use IMG::Model::UnitConverter;

use DBIx::DataModel;
use DataModel::IMG_Core;
use DataModel::IMG_Gold;

# has _core => (
# 	is => 'ro',
# 	weak_ref => 1,
# 	required => 1
# );

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
		table  => 'GoldTaxonVw',
		-columns  => [ qw( taxon_display_name taxon_oid genome_type domain phylum ir_class ir_order family genus clade clade|generic_clade ) ],
		-where    => {
			clade => { '!=', undef },
		},
		-order_by => [ qw( taxon_display_name ) ],
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
		table  => 'GoldTaxonVw',
		-columns => [ qw( clade clade|generic_clade genus ) ],
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
# Queries the GoldTaxonVw table, which is restricted to public taxa
#
# =cut

$select_queries->{location} = sub {

	return {
		schema => 'img_core',
		table  => 'GoldTaxonVw',
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
		table  => 'GoldTaxonVw',
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
		table  => 'GoldTaxonVw',
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
		table  => 'GoldTaxonVw',
		-columns  => [ qw( taxon_display_name taxon_oid genome_type domain genus ), map { 'coalesce(' . $_ . ", 'Unclassified') \"$_\""  } qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ecotype geo_location ) ],
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
		table  => 'GoldTaxonVw',
		-columns  => [ qw( taxon_display_name taxon_oid clade clade|generic_clade ecotype ) ],
		-where => {
			ecotype => { '!=' => undef },
			clade => { '!=' => undef },
		},
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
		table  => 'GoldTaxonVw',
		-columns  => [ qw( genome_type taxon_oid taxon_display_name ncbi_taxon_id domain phylum ir_class ir_order family clade ncbi_kingdom ncbi_phylum ncbi_class ncbi_order ncbi_family ncbi_genus ncbi_species pp_subset ) ],
		-order_by => [ qw( genome_type domain phylum ir_class ir_order family clade taxon_display_name ) ],
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
		-order_by => [ qw( dataset_type genome_type pp_subset taxon_display_name ) ],
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
		table  => 'GoldTaxonVw',
		-columns => [ 'pp_subset', 'count(distinct taxon_oid)|count' ],
		-group_by => 'pp_subset',
	};
};



$select_queries->{metagenomes_by_ecosystem} = sub {

	return {
		schema => 'img_core',
		table  => 'GoldTaxonVw',
		-columns  => [ 'count(distinct taxon_oid)|count', qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
		-group_by => [ qw( ecosystem ecosystem_category ) ],
		-where => {
			pp_subset => 'metagenome'
		}
	};
};


# =head3 taxon_metadata
#
# Given an array of taxon IDs (or other 'where' statement to identify
# taxa), retrieve all associated metadata
#
# @param  args->{where} should be in the form
#
# 	taxon_oid => [ arrayref of taxon IDs ]
#
# @return $resultset, with fields:
#
# genome_type
# taxon_oid
# taxon_display_name
# ncbi_taxon_id
# domain
# phylum
# ir_class
# ir_order
# family
# clade
# ncbi_kingdom
# ncbi_phylum
# ncbi_class
# ncbi_order
# ncbi_family
# ncbi_genus
# ncbi_species
# isolation
# oxygen_req
# cell_shape
# motility
# sporulation
# temp_range
# salinity
# geo_location
# latitude
# longitude
# altitude
# depth
# culture_type
# gram_stain
# biotic_rel
# ecotype
# longhurst_code
# longhurst_description
# ecosystem
# ecosystem_category
# ecosystem_type
# ecosystem_subtype
# specific_ecosystem
# pp_subset
#
# =cut

$select_queries->{taxon_metadata} = sub {
	return {
		schema => 'img_core',
		table  => 'GoldTaxonVw',
		-columns  => [ '*' ],
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

	return {
		schema => 'img_core',
		join  => [ qw[ Gene <=> scaffold <=> gold_tax ] ],
		-columns => [ qw(
			gene_oid
			gene_symbol
			gene_display_name
			product_name
			description
			taxon_oid
			taxon_display_name
			pp_subset
			scaffold|scaffold_oid
			scaffold_name
		) ],
		-where   => { 'gene.obsolete_flag' => 'No' },
	};
};

# =head3 gene_list_by_scaffold
#
# Get all genes (or a subset of genes) on a scaffold

$select_queries->{gene_list_by_scaffold} = sub {
	my $self = shift;

	my $arr = $self->run_query({
		query => 'scaffold_list',
		-columns => [ qw(
			scaffold_oid
			scaffold_name
			taxon_oid
			taxon_display_name
		 )],
		-where => { 'scaffold_oid' => $self->filters->{scaffold_oid} }
	});

	log_debug { 'stt: ' . Dumper $arr };

	if ( scalar @$arr != 1 ) {
		# Crap! an error!
		log_error { 'row count: ' . scalar @$arr };
	}
	my $scaf = $arr->[0];
	# get the sth for retrieving the gene list
	my $sth = $scaf->expand( 'genes', ( -result_as => 'statement' ) );

	log_debug { 'statement: ' . Dumper $sth };
	log_debug { 'n results: ' . $sth->row_count };

	return $sth;
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
	return $sth;

};


$select_queries->{gene_list_count} = sub {

	return {
		schema => 'img_core',
		join => [ qw[ Gene <=> gold_tax ] ],
		-columns => [ 'count( gene_oid )' ],
		-where   => { 'gene.obsolete_flag' => 'No' },
	};
};

# =head3 cycog_list
#
# CyCOG table only
#
# =cut

$select_queries->{cycog_list} = sub {
	return {
		schema => 'img_cycog',
		table  => 'Cycog',
		-columns => '*'
	};
};

$select_queries->{cycog_details} = sub {

	return {
		schema => 'img_cycog',
		table  => 'Cycog',
		-columns => '*'
#		-where => $args->{where},
	};
};

# =head3 cycogs_by_annotation_criteria
#
# CyCOG data, based on some annotation property
#
# =cut

$select_queries->{cycog_by_annotation} = sub {

	return {
		schema => 'img_cycog',
		join => [ qw[ GeneCycogGroups <=> cycog ] ],
		-columns => [ 'cycog.*, gene_cycog_groups.version, gene_cycog_groups.paralogs' ],
	};
};

# =head3 cycog_version
#
# =cut

$select_queries->{cycog_version} = sub {

	return {
		schema => 'img_cycog',
		table => 'CycogRelease',
		-columns => [ '*' ],
	};
};

# =head3 cycog_version_latest
#
# The most recent CyCOG release
#
# =cut

$select_queries->{cycog_version_latest} = sub {

	return {
		schema => 'img_cycog',
		join => [ qw[ CycogRelease <=> current ] ],
		-columns => [ 'cycog_release.*' ],
	};
};


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

	# check for deleted genes
	my $stt = $self->_core->run_query({
		query => 'unmapped_gene',
		-columns => [ qw[ gene_oid gene_display_name taxon_name locus_tag img_version ] ],
		-where => { old_gene_oid => $args->{gene_oid} }
	});

	if ( $stt->row_count > 0 ) {
		return $stt->all;
	}

	# check for replaced genes
	$stt = $self->_core->run_query({
		query => 'replaced_gene',
		-where => { old_gene_oid => $args->{gene_oid} },
		-columns => [ qw[ gene_oid ] ]
	});

	if ( $stt->row_count > 0 ) {
		# get the replacement gene
		my $res = $stt->all;
		log_debug { 'replacement: ' . Dumper $res };
		# redirect to replacement
	}

	# check for metagenome genes
	$stt = $self->_core->run_query({
		query => 'old_metagenome_gene',
		-where => { gene_oid => $args->{gene_oid} }
	});

	if ( $stt->row_count > 0 ) {
		# redirect to metagenome gene

	}

	# we have a 'normal' gene!
	return $self->default_select( $select_queries->{gene_details}->( $self, $args ) );

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
			ext_accession
			db_source
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
		-where   => { taxon_oid => $args->{where}{taxon_oid} },
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

	#	in the query library
#	if ( $select_queries->{ $args->{query} } ) {

		my $sel_args = $select_queries->{ $query }->( $self, $args );
		my $stt = $self->default_select({
			%$sel_args,
			%extras
		});

		if ( $args->{where} ) {
			$stt->refine( -where => $args->{where} );
		}

		return $stt;
#	}

	# is it a subroutine query?
#	return $self->$query( $args );
}

1;
