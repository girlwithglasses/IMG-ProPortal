package ProPortal::IO::DBIxDataModelQueryLib;

use IMG::Util::Import 'Class';

use Time::HiRes;
use IMG::Model::UnitConverter;

use DBIx::DataModel;
use DataModel::IMG_Core;
use DataModel::IMG_Gold;

has _core => (
	is => 'ro',
	weak_ref => 1,
	required => 1
);

=head3 clade

Search for spp with a clade defined

No additional arguments

=cut

sub clade {
	my $self = shift;

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
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

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
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

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
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

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
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

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
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

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
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

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns => [ 'proportal_subset', 'count(distinct taxon_oid)|count' ],
			-group_by => 'proportal_subset',
			-result_as => 'statement'
		);
}



sub metagenomes_by_ecosystem {
	my $self = shift;

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
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

	return $self->_core->schema('img_core')->table('GoldTaxonVw')
	->select(
		-columns  => [ '*' ],
		-where    => $args->{where},
		-result_as => 'statement',
	);
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
	return $self->_core->schema('img_core')->join( qw[ GoldSequencingProject => taxa => taxon_stats ] )

		->select(
			-columns => [ '*' ],
			-where => { 'taxon.taxon_oid' => $args->{taxon_oid} },
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

	return $self->_core->schema('img_core')->table('Gene')
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

	return $self->_core->schema('img_core')->table('Gene')
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

	return $self->_core->schema('img_core')->table('Taxon')
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

	return $self->_core->schema('img_core')->table('ContactTaxonPermissions')
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

	return $self->_core->schema('img_core')->table('Contact')
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

	return $self->_core->schema('img_gold')->table('CancelledUser')
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

	return unless $self->_core->can('user') && defined $self->_core->user;
#	die unless $self->can('user') && defined $self->user;
	say 'user: ' . Dumper $self->_core->user;

	my $c_id = $self->_core->user->contact_oid;
	die unless $c_id;

#	my $sql = "select role from contact_img_groups\@imgsg_dev where contact_oid = ? and img_group = ? ";



	my $role = $self->_core->schema('img_core')->table('ContactImgGroups')
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

	if (! $role && ! $self->_core->user->is_superuser) {
		$where->{is_public} = 'Yes';
	}

	return $self->_core->schema('img_core')->table('ImgGroupNews')
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

=cut

** For Transcriptome:

->('RnaseqDataset')
->select(
	-columns =>
	-where => { dataset_type => [ 'Transcriptome', 'Metatranscriptome' ] }
)

Name                Null     Type
------------------- -------- --------------
DATASET_OID         NOT NULL NUMBER(38)
SAMPLE_OID                   VARCHAR2(100)
REFERENCE_TAXON_OID NOT NULL NUMBER(38)
NOTES                        VARCHAR2(1000)
GOLD_ID                      VARCHAR2(20)
ER_PROJECT_ID                NUMBER(38)
ER_SAMPLE_ID                 NUMBER(38)
ANALYSIS_PROJECT_ID          VARCHAR2(20)
ADD_DATE                     DATE
IS_PUBLIC                    VARCHAR2(10)
SUBMISSION_ID                NUMBER(38)
IN_FILE                      VARCHAR2(10)
OBSOLETE_FLAG                VARCHAR2(10)
DATASET_TYPE                 VARCHAR2(20)
RELEASE_DATE                 DATE




select dataset_oid from rnaseq_dataset where dataset_type = 'Transcriptome';

The detailed expression data is in the rnaseq_expression table (join by dataset_oid).

** For Metatranscriptome, we have 2 types of data.

(1) The same as above, but dataset_type = 'Metatranscriptome'.

(2) select t.taxon_oid from taxon t, gold_sequencing_project s where t.sequencing_gold_id = s.gold_id and t.obsolete_flag = 'No' and s.sequencing_strategy = 'Metatranscriptome';

->('Taxon')

single cells:

select sp.uncultured_type from taxon t, gold_sequencing_project sp
  2  where t.sequencing_gold_id = sp.gold_id
  3  and t.taxon_oid = 2645728132;

=cut

1;
