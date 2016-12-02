package ProPortal::IO::DBIxDataModel;

use IMG::Util::Base 'MooRole';

use Time::HiRes;
use IMG::Model::UnitConverter;

use DBIx::DataModel;
use DataModel::IMG_Core;
use DataModel::IMG_Gold;

requires 'schema', 'choke';

has 't0' => (
	is => 'lazy',
);

sub _build_t0 {
	my $self = shift;
	return [ Time::HiRes::gettimeofday ];
}


=head3 run_query

Run a database query

If there is no database handle set, takes care of doing the login first

This is a thin wrapper around DBIx::DataModel; see that module for
specifics on how to specific SQL.

https://metacpan.org/pod/DBIx::DataModel

@param $args    hashref with keys

    query     the name of the query to be run
              (i.e. the name of the method in this package)

    where     the query parameter(s), e.g.
              { taxon_oid => [ 123, 456, 789 ] }

    filters       (optional) hashref of standardised filters,
                  e.g. implemented by ProPortalFilters

    return_as     (optional) return the statement object in a specific
                  format, e.g. result_as => 'flat_arrayref'
                  see DBIx::DataModel for options

    check_results (optional) run check_results on the db results
                  specify params for check_results as hashref, i.e.

                  check_results => {
                  	param => 'taxon_oid',
                  	query => [ 123, 456, 789 ],
                  	subject => 'taxon_oids'
                  }

	TODO: count results, return paged results

@return $output - returns $statement->all unless return_as is specified

=cut

sub run_query {
	my $self = shift;

	# set the timer
	$self->t0;

	my $args;
	if ( @_ && 1 < scalar( @_ ) ) {
		$args = { @_ } ;
	}
	else {
		$args = shift;
	}

	#	query is the name of the method to run
	#	args->{params} will contain filter params

	my $query = $args->{query}
		# no query specified
		or $self->choke({
			err => 'missing',
			subject => 'database query'
		});

	if (! $self->can($query)) {
		$self->choke({
			err => 'invalid',
			subject => $query,
			type => 'database query'
		});
	}

	# get the query as a statement
	my $stt = $self->$query( $args );

#	say 'statement: ' . Dumper $stt;

	# add filters
	if ($args->{filters}) {
		$stt = $self->add_filters({
			statement => $stt,
			filters => $args->{filters}
		});
	}

#	say 'Returning data... time elapsed since query init: ' . Time::HiRes::tv_interval( $self->t0, [ Time::HiRes::gettimeofday ] );

	# TODO: set the output format
# 	-result_as      => 'rows'      || 'firstrow'
#                   || 'hashref'   || [hashref => @cols]
#                   || 'sth'       || 'sql'
#                   || 'subquery'  || 'flat_arrayref'
#                   || 'statement' || 'fast_statement'

	if ( $args->{result_as} ) {
		return $stt->refine( -result_as => $args->{result_as} );
	}

	if ( $args->{check_results} ) {
		return $self->check_results({
			results => $stt->all,
			%{$args->{check_results}}
		});
	}

#	say 'statement: ' . Dumper $stt;

	return $stt->all;

}


=head2 check_results

Make sure that we got all the results we were hoping for!

@param $args    hashref with keys

	param    - parameter of the result objects to examine
	query    - arrayref containing the original query
	results  - arrayref of results (from run_query or elsewhere)
	subject  - human-readable string representing param
	           (for the error message)

@return     dies on failure with an error message

=cut

sub check_results {
	my $self = shift;
	my $args = shift;

	for ( qw( param query results subject ) ) {
		if ( ! defined $args->{$_} ) {
			$self->choke({
				err => 'missing',
				subject => 'check_results parameter "' . $_ . '"'
			});
		}
	}

	if ( ! scalar @{$args->{results}} ) {
		$self->choke({
			err => 'no_results',
			subject => $args->{subject}
		});
	}
	my $results = $args->{results};
	my %all;

	@all{ @{$args->{ query } } } = ( 1 ) x scalar @{ $args->{query} };

	for ( @$results ) {
		delete $all{ $_->{ $args->{param} } };
	}

	if ( keys %all ) {
		$self->choke({
			err => 'missing_results',
			subject => $args->{subject},
			ids => [ keys %all ]
		});
	}
	return $results;
}


=head2 add_filters

Add the filters for the ProPortal-specific subset

@param $args    hashref with keys

	statement   - the DBIx::DataModel statement object
	filters     - whatever filters are to be applied
	              (see ProPortal::IO::ProPortalFilters for examples)

@return  $stt   modified statement object

=cut

sub add_filters {

	my $self = shift;
	my $args = shift;

	if ( ! $args->{statement} ) {
		$self->choke({
			err => 'missing',
			subject => 'DBIxDataModel statement object'
		});
	}

	if ( ! $args->{filters} ) {
		return $args->{statement};
	}

	my $f;

	## This is implemented by ProPortal::IO::ProPortalFilters
	## Not sure this is an ideal way to do this...
	if ( $args->{filters}{subset} ) {
		$f = $self->subset_filter( $args->{filters}{subset} );
	}

	## other filters
	if ( $args->{filters}{taxon_oid} ) {
		$f = { -where => $args->{filters}{taxon_oid} };
	}

	$args->{statement}->refine( %$f );

	return $args->{statement};

}

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
			-columns => [ 'distinct genus || clade', 'clade', 'clade|generic_clade', 'genus' ],
			-where    => {
				clade => { '!=', undef },
			},
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
			-columns  => [ qw( taxon_display_name taxon_oid genome_type ecosystem_subtype geo_location latitude longitude altitude depth ecotype proportal_subset ) ],
			-where    => {
				latitude  => { '!=' => undef },
				longitude => { '!=' => undef },
			},
			-order_by => [ qw( latitude longitude genome_type taxon_display_name ) ],
			-result_as => 'statement',
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
			-columns  => [ qw( taxon_display_name taxon_oid clade ecotype ) ],
			-where => {
#				'length(ecotype)'  => { '>' => 1 },
				ecotype => { '!=' => undef },
				clade => { '!=' => undef },
			},
			-result_as => 'statement',
		);
}

=head3 taxon_oid_display_name

Query from data_type_graph

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
proportal_subset

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

=head3 subset_stats

Count of number of genomes in each of the proportal subset types

@param  [none]

@return $resultset, with fields:

proportal_subset => ..., count => ...

=cut

sub subset_stats {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns => [ 'proportal_subset', 'count(distinct taxon_oid)|count' ],
			-group_by => 'proportal_subset',
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
				proportal_subset => 'metagenome'
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


=head3 depth_graph query

Legacy, from DBIx::Class days


sub depth_graph {
	my $self = shift;
	return $self->dbic_schema->resultset('Taxon')
		->public_extant
		->search_related('goldseqproj')
			->marine_eco
			->not_null('depth')
			->search(undef, {
		columns  => [ qw( taxon_oid taxon_display_name genome_type genus
			geo_location latitude longitude altitude depth ecotype ) ]
		});

# 	return 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
# 	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, t.genus '
# 	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
# 	. 'where t.sequencing_gold_id = p.gold_id '
# 	. "and p.ecosystem_type = 'Marine' AND p.depth is not null "
# 	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
# 	. 'ORDER BY 4, 5, 2';

}

sub depth_clade {
	my $self = shift;
	my $args = shift;

	return $self->dbic_schema->resultset('Taxon')
		->public_extant
		->search_related('goldseqproj')
			->marine_eco
			->not_null('clade')
			->not_null('depth')
			->search(undef, {
		columns  => [ qw( taxon_oid taxon_display_name genome_type genus
			geo_location latitude longitude altitude depth ecotype ) ]
		});

	my $sql = 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, p.clade '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. 'and p.depth is not null ';

	$sql = $self->add_proportal_filters($sql) if $args;

	return $sql
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. 'ORDER BY 4, 5, 2';
}

# note: almost identical to depth_clade

sub depth_ecotype {
	my $self = shift;
	my $args = shift;

	return $self->dbic_schema->resultset('Taxon')
		->public_extant
		->search_related('goldseqproj')
			->marine_eco
			->not_null('depth')
			->search(undef, {
		columns  => [ qw( taxon_oid taxon_display_name genome_type genus domain
			geo_location latitude longitude altitude depth ecotype clade ) ]
		});

	my $sql = 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, p.ecotype '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. 'and p.depth is not null ';

	$sql = $self->add_proportal_filters($sql) if $args;

	return $sql
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. 'ORDER BY 4, 5, 2';

}

=cut

=head3 taxon_details

Taxon details from taxon and gold_sequencing_project tables

=cut

sub taxon_details {

	my $self = shift;
	my $args = shift;
	my $data;

	# taxonomic info
	my $res = $self->schema('img_core')->join( qw[ GoldSequencingProject => taxa => taxon_stats ] )

		->select(
			-columns => [ '*' ],
			-where => { 'taxon.taxon_oid' => $args->{taxon_oid} },
			-result_as => 'statement',
		);

	return $res;
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

=head3 gene_details

Given an array of gene IDs, get the gene data

@param  args->{where} should be in the form

	gene_oid => [ arrayref of gene IDs ] (or a single gene_oid)

@return arrayref of results in the format

	{ gene_oid => #####, taxon_oid => ##### }

=cut

sub gene_details {

	my $self = shift;
	my $args = shift;

	return $self->schema('img_core')->table('Gene')
		->select(
			-columns => [ qw( gene_oid gene_symbol gene_display_name product_name locus_tag locus_type scaffold description taxon|taxon_oid obsolete_flag ) ],
			-where   => $args->{where},
			-result_as => 'statement'
		);
}

=head3 taxon_name_public

@param  args->{where} should be in the form

	taxon_oid   => ######

@return arrayref of results in the format

	{ taxon_oid => #####, taxon_display_name => #####, is_public => 'Yes|No' }

=cut

sub taxon_name_public {
	my $self = shift;
	my $args = shift;

	return $self->schema('img_core')->table('Taxon')
	->select(
		-columns => [ qw( taxon_oid taxon_display_name is_public ) ],
		-where   => $args->{where},
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

	# TODO: fail more nicely!

	die unless $self->can('user') && defined $self->user;
	say 'user: ' . Dumper $self->user;

	my $c_id = $self->user->contact_oid;
	die unless $c_id;

#	my $sql = "select role from contact_img_groups\@imgsg_dev where contact_oid = ? and img_group = ? ";

	my $role = $self->schema('img_core')->table('ContactImgGroups')
		->select(
			-columns => [ 'role' ],
			-where => {
				contact_oid => $c_id,
				img_group   => $g_id,
			},
			-result_as => 'firstrow',
		);

	say 'role: ' . Dumper $role;

	my $where = { group_id => $g_id };

	if (! $role && ! $self->user->is_superuser) {
		$where->{is_public} = 'Yes';
	}

	return $self->schema('img_core')->table('ImgGroupNews')
		->select(
			-columns   => [ qw( news_id title add_date ) ],
			-where     => $where,
			-order_by  => [ 'add_date' ],
			-result_as => 'statement',
		);

#    my $cond = "and n.is_public = 'Yes'" if ! $role || $super_user_flag eq 'No';
#    $sql = "select n.news_id, n.title, n.add_date " .
#	"from img_group_news\@imgsg_dev n " .
#	"where n.group_id = ? " . $cond .
#	" order by 3 desc ";

#	my $news_url = "main.cgi?section=ImgGroup" .
#	    "&page=showNewsDetail" .
#            "&group_id=$group_id&news_id=$news_id";
}



1;
