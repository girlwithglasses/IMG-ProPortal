package ProPortal::IO::DBIxDataModel;

use IMG::Util::Base 'MooRole';

use Time::HiRes;
use IMG::Model::UnitConverter;

use DBIx::DataModel;
use DataModel::IMG_Core;
use DataModel::IMG_Gold;  # for the future!

requires 'schema', 'user';

has 't0' => (
	is => 'lazy',
);

sub _build_t0 {
	my $self = shift;
	return [ Time::HiRes::gettimeofday ];
#	$self->set_t0( [ Time::HiRes::gettimeofday ] );
}


=head3 run_query

Run a database query

If there is no database handle set, takes care of doing the login first

@param  hash with keys

@param  query  => the name of the query to be run
	(a.k.a. the name of the method in this package)

@param  input  => extra query param to be filled in using $self->proportal_filters

@return $output - raw output from the query

=cut

sub run_query {
	my $self = shift;

	$self->t0;
#	$self->set_t0( [ Time::HiRes::gettimeofday ] );

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
		or croak __PACKAGE__ . ' ' . (caller(0))[3]
		. ': no query specified!';

	if (! $self->can($query)) {
		croak __PACKAGE__ . ' ' . (caller(0))[3]
		. ': no query named $query exists!';
	}

	# get the query as a statement
	my $stt = $self->$query({ result_as => 'statement' });

	# add filters
	if ($args->{filters}) {
		$stt = $self->add_filters( $stt, $args->{filters} );
	}

	say 'Returning data... time elapsed since query init: ' . Time::HiRes::tv_interval( $self->t0, [ Time::HiRes::gettimeofday ] );

	return $stt->all;

}

=head2 filter_sql

Get the filters for the ProPortal-specific species

=cut

sub filter_sql {
	my $self = shift;
	my $f_name = shift // croak "No filter name supplied!";

	my $filters = {
		# all
#		'datamart' => { ecosystem_type => 'Marine' },

		'marginal' => { ecosystem_subtype => 'Marginal Sea' },

		'neritic'  => { 'lower(ecosystem_subtype)' => 'neritic zone' },

		'pelagic'  => { ecosystem_subtype => 'Pelagic' }
	};

	return { -where => $filters->{$f_name} } || croak "No filter for $f_name";

}


sub add_filters {

	my $self = shift;
	my $stt = shift // croak "No statement supplied";
	my $filters = shift // return $stt;

	my $f;

	if ($filters->{ecosystem_subtype}) {
		$f = $self->filter_sql( $filters->{ecosystem_subtype} );
	}

	## other filters
	if ($filters->{taxon_oid}) {
		$f = { -where => $filters->{taxon_oid} };
	}

	$stt->refine( %$f );

	return $stt;

}

=cut

=head2 schema_init

Create the DBIx::Lite schema object

@param $hash connection params
@param dsn, user, password, options

=cut

sub schema_init {
	my $self = shift;
	my $args = shift;

	say "Running schema init";

	DataModel::IMG_Core->dbh( $self->dbh );

	return $self;
}

=head3 clade

Search for spp with a clade defined

=cut

sub clade {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxon')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid genome_type ecosystem_subtype genus clade clade|generic_clade ) ],
			-where    => {
				clade => { '!=', undef },
			},
			-order_by => [ qw( genome_type clade taxon_display_name ) ],
			-result_as => 'statement',
		);

}


=head3 location

Search for latitude/longitude

=cut

sub location {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxon')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid genome_type ecosystem_subtype geo_location latitude longitude altitude depth ecotype ) ],
			-where    => {
				latitude  => { '!=' => undef },
				longitude => { '!=' => undef },
			},
			-order_by => [ qw( latitude longitude genome_type taxon_display_name ) ],
			-result_as => 'statement',
		);
}

=head3 news

Get the ProPortal news!

=cut

sub news {
	my $self = shift;

	my $g_id = 26;

	say 'user: ' . Dumper $self;

	my $c_id = $self->user->contact_oid;
#    my $contact_oid = WebUtil::getContactOid();
	return unless $c_id;

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

	my $stt = $self->schema('img_core')->table('ImgGroupNews')
		->select(
			-columns => [ qw( news_id title add_date ) ],
			-where   => {
				group_id => $g_id,
			},
			-order_by => [ 'add_date' ],
			-result_as => 'statement',
		);

	if (! $role && ! $self->user->is_superuser) {
		$stt->refine(
			-where => {
				is_public => 'Yes'
			}
		);
	}
	return $stt;

#    my $cond = "and n.is_public = 'Yes'" if ! $role || $super_user_flag eq 'No';
#    $sql = "select n.news_id, n.title, n.add_date " .
#	"from img_group_news\@imgsg_dev n " .
#	"where n.group_id = ? " . $cond .
#	" order by 3 desc ";

#	my $news_url = "main.cgi?section=ImgGroup" .
#	    "&page=showNewsDetail" .
#            "&group_id=$group_id&news_id=$news_id";
}



sub taxon_details {

	my $self = shift;
	my $args = shift;
	my $data;

	# taxonomic info
	my $res = $self->schema('img_core')->table('GoldTaxon')
		->select(
			-columns => [ qw( taxon.* gold_sequencing_project.* ) ],
			-where => { taxon_oid => $args }
		);

	say "results: " . Dumper $res;

	if (scalar @$res != 1) {
		croak "Found " . scalar(@$res) . " results for taxon query";
	}
	$res = $res->[0];

	my @associated = qw(
		gsp_genome_publications
		gsp_habitats
		gsp_energy_sources
		gsp_phenotypes
		goldanaproj
		gsp_seq_centers
		gsp_seq_methods
		gsp_relevances
		gsp_cell_arrangements
		gsp_metabolisms
		gsp_study_gold_ids
		gsp_collaborators
		gsp_diseases
	);

	for my $assoc (@associated) {
		my $r = $res->$assoc;
		if ($r && scalar @$r) {
			$res->{$assoc} = $r;
		}
	}

	return $res;
}

=head3 gold_project_details


=cut

sub gold_project_details {
	my $self = shift;
	my $args = shift;


	my $related = [ qw(
		 GoldSpCellArrangement GoldSpCollaborator GoldSpDisease GoldSpEnergySource GoldSpGenomePublication GoldSpHabitat GoldSpMetabolism GoldSpPhenotype GoldSpRelevance GoldSpSeqCenter GoldSpSeqMethod GoldSpStudyGoldId
	)];

	my $data;

	my @res = $self->dbic_schema->resultset('GoldSequencingProject')->search({
		'me.gold_id' => $args->{input}
	},{
	#	prefetch => $related,
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
	})->all;

	if (scalar @res != 1) {
		die "No data found for GOLD ID " . $args->{input};
	}
	$data = $res[0];

	my $rs = $self->dbic_schema->resultset('GoldSequencingProject')->result_source;
	# get the related data
	my %r_hash;
	my @r_tables = map {
		my $rh = $rs->relationship_info($_);
		( my $c = $rh->{class} ) =~ s/DbSchema::IMG_Core::Result:://;
		( $_, $c );
	 } $rs->relationships;

	my %rel_h = ( @r_tables );

	# taxonomic info
	$data->{taxa} = [ $self->dbic_schema->resultset('Taxon')->search({
		'me.sequencing_gold_id' => $args->{input}
	},{
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
	})->all ];

	for my $r (keys %rel_h) {
		next if $r =~ /taxa/;
		$data->{$r} = [ $self->dbic_schema->resultset( $rel_h{$r} )->search({
			'me.gold_id' => $args->{input}
		},{
		#	prefetch => $related,
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		})->all ];
	}

	return $data;
}


=head3 taxon_oid_display_name

Query from data_type_graph

@param  $args   -

@return $resultset

=cut

sub taxon_oid_display_name {
	my $self = shift;

	return $self->schema('img_core')->table('GoldTaxon')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid ecosystem_subtype genome_type ) ],
			-order_by => [ qw( genome_type ecosystem_subtype taxon_display_name ) ],
			-result_as => 'statement',
		);
}

=head3 taxon_marine_metagenome

Marine metagenome taxon query

=cut

sub taxon_marine_metagenome {

	my $self = shift;

	return $self->schema('img_core')->table('Taxon')
		->select(
			-columns  => [ qw( taxon_display_name taxon_oid ) ],
			-where    => {
				%{$self->public_extant},
				%{$self->marine_metagenome},
			},
			-order_by => [ qw( family taxon_display_name taxon_oid ) ],
		);

	return "select t.taxon_oid, t.taxon_display_name, t.family "
	. "from taxon t "
	. "where t.genome_type = 'metagenome' "
	. "and t.ir_order = 'Marine' "
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. "and (t.combined_sample_flag is null or t.combined_sample_flag = 'No') "
	. "order by t.taxon_display_name";

}

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

	return 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, t.genus '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. "and p.ecosystem_type = 'Marine' AND p.depth is not null "
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. 'ORDER BY 4, 5, 2';

}

sub coerce_clade {
	my $self = shift;
	my $c = shift // return;
	$c =~ s/^(\d\.\d[A-Z]?).*/$1/g;
	# remove non-\w and replace with underscores
	(my $web_safe_c = $c) =~ s/[^\w]/_/g;
	return ($c, $web_safe_c);
}

sub get_genus {
	my $self = shift;
	my $obj = shift;
	if ($obj->{taxon_display_name} =~ m/((prochlor|synech)ococcus)/i) {
		return $1;
	}
	return "";
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


sub tax_count {
	my $self = shift;
	my $args = shift;

	my $sql = 'select count(*) from taxon t '
		. "where t.obsolete_flag = 'No' and t.is_public = 'Yes' ";

	return $sql if ! $args;

	return $self->add_proportal_filters($sql);
}


=head3 stats

database stats

=cut

sub stats {
	my $self = shift;
	my $f = $self->proportal_filters;

	return join(" UNION ", map {
		"select '"
		. $_
		. "', t.taxon_oid, t.domain, t.taxon_display_name "
		. 'from taxon t '
		. 'where (' . $f->{$_} . ') '
		. "and t.obsolete_flag = 'No' and t.is_public = 'Yes'";
	 } keys %$f)
	 . " ORDER BY 4, 5, 2";
}



=cut

sub role {

#	select($source, $fields, $where, $order)

		{
		contact_oid =>

	schema->resultset('ContactImgGroups@imgsg_dev')->search(
		{ contact_oid => { '=' => ... } }
		{ img_group   => { '=' => ... } }


	return qq{select role from contact_img_groups\@imgsg_dev where contact_oid = ? and img_group = ? };
	my $schema;
	# role

	my $role = $schema->resultset('ContactImgGroups@imgsg_dev')->search(

	select( 'contact_img_groups@imgsg_dev', 'role',
	[
		contact_oid => $contact_oid ,
		img_group   => $g_id,
	},

	);

	my @search_cond = (
		{ group_id => $g_id },
		{ rows => 3, order_by => { -desc => 'add_date' } }
	);

	if (! $role || $super_user_flag ne 'Yes' ) {
		unshift @search_cond, { is_public => 'Yes' };
	}


	my @news = $schema->resultset( 'ImgGroupNews@imgsg_dev' )->search(@search_cond);









}

=head3 news

@param $args - exists if the user is a super-user or a member of the group


sub news {
	my $self = shift;
	my $args = shift;

	my %where = (
		group_id => $g_id,
		is_public => 'Yes'
	);
	if ( $args ) {
		delete $where{is_public};
	}

	select(
		'img_group_news@imgsg_dev'
		[ qw( news_id title add_date ) ],
		{
			group_id  => $g_id
			is_public => 'Yes'
		},
		{ -desc => 'add_date' }
	);


	return 'select n.news_id, n.title as title, n.add_date '
	. 'from img_group_news\@imgsg_dev n '
	. 'where n.group_id = ? '
	. $args ? "and n.is_public = 'Yes'" : ''
	. 'order by 3 desc';
}

=head3

Append a filter string corresponding to the three taxa sets

=cut

sub add_proportal_filters {
	my $self = shift;
	my $sql  = shift;

	return $sql . ' AND ( '
		. join( " OR ", values %{$self->proportal_filters} )
		. ' )';
}


sub data_type_graph {
	my $self    = shift;

	## TEMPLATE: data_type_graph

	my $e = $self->get_datamart_env();

	my $data = $self->show_data_set_selection_section( 'data_type_graph' );

	my $rset = $self->dbic_schema->resultset('Taxon')
		->public_extant
		->search_related('goldseqproj')
			->marine_eco
			->not_null('clade')
			->search(undef, {
		columns  => [ map { "me.$_" } qw( taxon_oid taxon_display_name genome_type genus ),
			map { "goldseqproj.$_"} qw( geo_location latitude longitude altitude depth ecotype ) ]
		});

# sub taxon_oid_display_name {
	my $args = shift;

	if ($args =~ /phage/) {

		return $self->dbic_schema->resultset('Taxon')
			->public_extant
			->phage
			->search(undef,{
			columns  => [ qw( taxon_display_name taxon_oid ) ],
			order_by => [ qw( taxon_display_name taxon_oid ) ],
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		});

	}
	else {

		return $self->dbic_schema->resultset('Taxon')
			->public_extant
			->genus($args)
			->search({
				sequencing_gold_id => {
					in => $self->dbic_schema->resultset('GoldSequencingProject')->marine_eco_ids
				},
			},{
			columns  => [ qw( taxon_display_name taxon_oid ) ],
			order_by => [ qw( taxon_display_name taxon_oid ) ],
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		});
	}



	# run taxon_oid_display_name for each of the members
	for my $x ( @{$e->{tax_groups}} ) {
		$data->{genomes}{$x} = $self->dbi->run_query(
			query => 'taxon_oid_display_name',
			input => $x,
			output => 'fetchall_aoh'
		);
	}

	## metagenomes
	my $mgq = $self->dbi->run_query(
		query  => 'taxon_marine_metagenome',
		output => 'fetchall_aoh'
	);

	for my $m ( @$mgq ) {
		push @{ $data->{metagen}{ $m->[2] || 'Unclassified' } }, $m;
	}

	return $data;

}


1;
