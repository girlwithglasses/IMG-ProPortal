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

=head3 clade

Search for spp with a clade defined

No additional arguments

=cut

sub clade {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid genome_type domain phylum ir_class ir_order family genus clade clade|generic_clade ) ],
			-where    => {
				clade => { '!=', undef },
			},
			-order_by => [ qw( taxon_display_name ) ],
			-result_as => 'statement',
		);

}

=head3 distinct_clade

Collect all clades from the ProPortal set

=cut

sub distinct_clade {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns => [ qw( clade clade|generic_clade genus ) ],
			-where    => {
				clade => { '!=' => undef },
			},
			-group_by => [ qw( clade genus ) ],
			-result_as => 'statement'
		);
}

=head3 location

Search for latitude/longitude

No additional arguments

Queries the GoldTaxonVw table, which is restricted to public taxa

=cut

sub location {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid genome_type ecosystem_subtype geo_location latitude longitude altitude depth ecotype pp_subset ) ],
			-where    => {
				latitude  => { '!=' => undef },
				longitude => { '!=' => undef },
			},
			-order_by => [ qw( latitude longitude genome_type taxon_display_name ) ],
			-result_as => 'statement',
		);
}


=head3 longhurst_counts



=cut

sub longhurst_counts {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
	->select(
		-columns  => [ 'count(taxon_oid)|count', map { 'coalesce(' . $_ . ", 'Unclassified') \"$_\""  } qw( longhurst_code longhurst_description ) ],
		-group_by => [ qw( longhurst_code longhurst_description ) ],
		-order_by => [ 'longhurst_description' ],
		-where => {
			pp_subset => { '!=', undef },
#				is_public => 'Yes'
		},
		-result_as => 'statement'
#		-result_as => ['hashref' => 'longhurst_description' ]
	);

}

=head3 longhurst



=cut

sub longhurst {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
	->select(
		-columns  => [ 'taxon_oid', 'taxon_display_name', map { 'coalesce(' . $_ . ", 'Unclassified') \"$_\""  } qw( longhurst_code longhurst_description ) ],
#		-group_by => [ qw( longhurst_code longhurst_description ) ],
		-order_by => [ 'longhurst_description', 'taxon_display_name' ],
		-where => {
			pp_subset => { '!=', undef },
#				is_public => 'Yes'
		},
		-result_as => 'statement'
#		-result_as => ['hashref' => 'longhurst_description' ]
	);

}


=head3 ecosystem

Query for ecosystem

No additional arguments

=cut

sub ecosystem {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid genome_type domain genus ), map { 'coalesce(' . $_ . ", 'Unclassified') \"$_\""  } qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ecotype geo_location ) ],
			-order_by => [ qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem taxon_display_name ) ],
			-result_as => 'statement',
		);
}

=head3 ecotype

Query for ecotype

=cut

sub ecotype {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid clade clade|generic_clade ecotype ) ],
			-where => {
				ecotype => { '!=' => undef },
				clade => { '!=' => undef },
			},
			-result_as => 'statement',
		);
}

=head3 taxon_oid_display_name

Pulls in data from VW_GOLD_TAXON table

@param  $args   -

@return $resultset, with fields:

genome_type
taxon_oid
taxon_display_name
ncbi_taxon_id
domain
phylum
ir_class
ir_order
family
clade
ncbi_kingdom
ncbi_phylum
ncbi_class
ncbi_order
ncbi_family
ncbi_genus
ncbi_species
isolation
oxygen_req
cell_shape
motility
sporulation
temp_range
salinity
geo_location
latitude
longitude
altitude
depth
culture_type
gram_stain
biotic_rel
ecotype
longhurst_code
longhurst_description
ecosystem
ecosystem_category
ecosystem_type
ecosystem_subtype
specific_ecosystem
pp_subset

=cut

sub taxon_oid_display_name {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ '*' ],
			-order_by => [ qw( genome_type domain phylum ir_class ir_order family clade taxon_display_name ) ],
			-result_as => 'statement',
		);
}


sub taxon_dataset_type {
	my $self = shift;

	# fetch

	return $self->schema('img_core')->table('GoldDataTypeVw')
		->select(
			-columns  => [ '*' ],
			-order_by => [ qw( dataset_type genome_type pp_subset taxon_display_name ) ],
			-result_as => 'statement',
		);
}

=head3 subset_stats

Count of number of genomes in each of the proportal subset types

@param  [none]

@return $resultset, with fields:

pp_subset => ..., count => ...

=cut

sub subset_stats {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns => [ 'pp_subset', 'count(distinct taxon_oid)|count' ],
			-group_by => 'pp_subset',
			-result_as => 'statement'
		);
}



sub metagenomes_by_ecosystem {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ 'count(distinct taxon_oid)|count', qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
			-group_by => [ qw( ecosystem ecosystem_category ) ],
			-where => {
				pp_subset => 'metagenome'
			},
			-result_as => 'statement',
		);
}


=head3 taxon_metadata

Given an array of taxon IDs (or other 'where' statement to identify
taxa), retrieve all associated metadata

@param  args->{where} should be in the form

	taxon_oid => [ arrayref of taxon IDs ]

=cut

sub taxon_metadata {
	my $self = shift;
	my $args = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
	->select(
		-columns  => [ '*' ],
		-where    => $args->{where},
		-result_as => 'statement',
	);
}


=head3 gene_oid_taxon_oid

Given an array of gene IDs, get the taxon_oid

@param  args->{where} should be in the form

	gene_oid => [ arrayref of gene IDs ] (or a single gene_oid)

@return arrayref of results in the format

	{ gene_oid => #####, taxon_oid => ##### }

=cut

sub gene_oid_taxon_oid {

	my $self = shift;
	my $args = shift;

	return $self->schema('img_core')->table('Gene')
		->select(
			-columns => [ qw( gene_oid taxon|taxon_oid ) ],
			-where   => $args->{where},
			-result_as => 'statement'
		);
}

=head3 gene_list

Get all genes by taxon_oid (or other criterion)

@param taxon_oid => nnnnnnnnn

@return arrayref of gene objects

=cut

sub gene_list {
	my $self = shift;
	my $args = shift;

	$args->{where}{'gene.obsolete_flag'} = 'No';

	return $self->schema('img_core')->join( qw[ Gene <=> gold_tax ] )
		->select(
			-columns => [ qw(
				gene_oid
				gene_symbol
				gene_display_name
				product_name
				description
				taxon_oid
				taxon_display_name
				pp_subset
			) ],
			-where   => $args->{where},
			-result_as => 'statement'
		);
}

=head3 gene_details

Given an array of gene IDs, get the gene data

@param  args->{where} should be in the form

	gene_oid => [ arrayref of gene IDs ] (or a single gene_oid)

@return arrayref of results in the format

	{ gene => #####, taxon => ##### }

=cut

sub gene_details {

	my $self = shift;
	my $args = shift;

#	my $gene = $self->schema('img_core')->table('PPGeneDetails')
	my $gene = $self->schema('img_core')->join( qw[ Gene <=> taxon ] )
		->select(
			-columns => [ 'gene.*', 'taxon.taxon_oid', 'taxon.taxon_display_name' ],
			-where   => {
				%{$args->{where}},
				'taxon.is_public' => 'Yes'
			},
			-result_as => 'statement'
		)->all;

	my %tax_h;
	if ( scalar @$gene > 0 ) {
		# make sure that we have permission to view the gene
		for ( @$gene ) {
			$tax_h{ taxon_oid } = $_->{taxon};
		}
	}

	my $results = $self->taxon_name_public({ where => \%tax_h })->all;

	if ( scalar @$results > 0) {
		if ( $results->[0]->{viewable} eq 'private' ) {
			# dies if there is a permissions error
			$self->choke({
				err => 'private_data'
			});
		}
	}

	return { gene => $gene->[0] // undef, taxon => $results->[0] // undef };
}

=head3 taxon_details

Taxon details from taxon and gold_sequencing_project tables

=cut

sub taxon_details {

	my $self = shift;
	my $args = shift;

	my $results = $self->taxon_name_public( $args )->all;

	if ( scalar @$results > 0) {
		if ( $results->[0]->{viewable} eq 'private' ) {
			# dies if there is a permissions error
			$self->choke({
				err => 'private_data'
			});
		}

		# otherwise, return taxonomic info
		return $self->schema('img_core')->join( qw[ GoldSequencingProject <=> taxa ] )
		->select(
			-columns => [ '*' ],
			-where => { 'taxon.taxon_oid' => $args->{where}{taxon_oid} },
			-result_as => 'statement',
		);
	}

	$self->choke({
		err => 'invalid',
		subject => $args->{where}{taxon_oid},
		type => 'taxon_oid'
	});

}



=head3 taxon_name_public

@param  args->{where} should be in the form

	taxon_oid   => ######

@return arrayref of results in the format

	{	taxon_oid => #####,
		taxon_display_name => #####,
		is_public => 'Yes|No',
		viewable => 'public|private|accessible'
	}

=cut

sub taxon_name_public {
	my $self = shift;
	my $args = shift;

	my $case_sql;

	if ( $self->can('user') && defined $self->user && defined $self->user->contact_oid ) {
		my $u_id = "= $self->user->contact_oid";
		my $tax_str = '= taxon.taxon_oid';

		$case_sql = 'WHEN EXISTS (' .
			$self->schema('img_core')->table('ContactTaxonPermissions')
				->select(
					-columns => [ '1' ],
					-where => {
						taxon_permissions => \ '= taxon.taxon_oid',
						contact_oid => \$u_id
					},
					-result_as => 'sql'
				)
			. ") THEN 'accessible' ";
	}

	my $case = q!CASE
  WHEN taxon.is_public = 'Yes' THEN 'public'
! . ( $case_sql || '' ) . q!
  ELSE 'private'
  END
AS viewable!;

	return $self->schema('img_core')->table('Taxon')
	->select(
		-columns => [ $case, qw( taxon_oid taxon_display_name is_public ) ],
		-where   => { taxon_oid => $args->{where}{taxon_oid} },
		-result_as => 'statement'
	);

}


=head3 taxon_permissions_by_contact_oid

Given a user's contact ID and a taxon ID, see if the user is permitted
to access the taxon.

@param  args->{where} should be in the form

	taxon_permissions   => ######
	contact_oid => ######

@return arrayref of results in the format

	{ contact_oid => #####, taxon_permissions => ##### }

=cut

sub taxon_permissions_by_contact_oid {
	my $self = shift;
	my $args = shift;

	$args->{where}{taxon_permissions} = delete $args->{where}{taxon_oid} if $args->{where}{taxon_oid};

	return $self->schema('img_core')->table('ContactTaxonPermissions')
		->select(
			-columns => [ qw( contact_oid taxon_permissions ) ],
			-where   => $args->{where},
			-result_as => 'statement'
		);
}

=head3 user_data

Get the data for a user or set of users.

@param  args->{where} should be in the form

	contact_oid => # IMG user ID  OR
	caliban_id  => # user ID on the JGI Caliban system  OR
	email       => # email addr

	# or other distinguishing feature(s)

=cut

sub user_data {
	my $self = shift;
	my $args = shift;

	my @cols = qw( contact_oid username name super_user email img_editor img_group img_editing_level );

	return $self->schema('img_core')->table('Contact')
		->select(
			-columns  => [ @cols ],
			-where    => $args->{where},
			-result_as => 'statement'
		);
}

=head3

Check for banned users

@param   args->{where} featuring either

	username => ... OR
	email    => ...

=cut

sub banned_users {
	my $self = shift;
	my $args = shift;

	return $self->schema('img_gold')->table('CancelledUser')
		->select(
			-where => $args->{where},
			-columns => [ qw( username email ) ],
			-result_as => 'statement'
		);
}



=head3 news

Get the ProPortal news!

=cut

sub news {
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

	return $self->schema('img_core')->table('ImgGroupNews')
		->select(
			-columns   => [ qw( news_id title add_date ) ],
			-where     => $where,
			-order_by  => [ 'add_date' ],
			-result_as => 'statement',
		);

}

1;
