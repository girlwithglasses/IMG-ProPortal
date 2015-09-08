package ProPortal::IO::DBIC;

require 5.010_000;
use strict;
use warnings;
use feature ':5.10';

use Carp;
use Moo;

use Types::Standard qw( Int Str Bool InstanceOf HashRef Map );
use Data::Dumper;
use POSIX qw( ceil floor );

has 'verbose' => (
	is => 'rw',
	isa => Int,
	predicate => 1,
	clearer => 1,
);

has 'config' => (
	is => 'rw',
	required => 1,
	isa => HashRef,
	clearer => 1,
);

has 'schema' => (
	is => 'rw',
	isa => InstanceOf['DBIx::Class::Schema'],
	required => 1,
	predicate => 1,
	clearer => 1,
	writer => 'set_schema',
);


sub BUILDARGS {
	my $class = shift;
	my $args;
	if ( @_ && 1 < scalar( @_ ) ) {
		$args = { @_ } ;
	}
	else {
		$args = shift;
	}

	if ( ! $args->{schema} ) {
		croak "Arguments to " . __PACKAGE__ . " must be a hashref with keys 'config' and 'schema'";
	}

	return {
		schema => delete $args->{schema},
		verbose => delete $args->{verbose} // 0,
		config => $args->{config} || $args,
	};
}

=head2 schema_init

Create the DBIx schema object

@param $hash connection params with keys
             schema_class, dsn, user*, password*, options*

=cut

sub schema_init {
	my $self = shift;
	my $args = shift || $self->config->{plugins}{DBIC}{default};

	say "Running schema init";

	if (! $args->{schema_class} || ! $args->{dsn}) {
		croak "schema_init requires parameters schema_class and dsn"
	}

	if ( try_load_class $args->{schema_class} ) {

		my $class = $args->{schema_class};

		my $schema = $class->connect(
			$args->{dsn},
			$args->{user} || undef,
			$args->{password} || undef,
			$args->{options} // { RaiseError => 1 }
		) or croak $DBI::errstr;
		$self->set_schema($schema);
		return $self;
	}
	croak "schema object creation failed";
}

=head3 run_query

Run a database query

If there is no database handle set, takes care of doing the login first

@param  hash with keys

@param  query  => the name of the query to be run
	(a.k.a. the name of the method in this package)

@param  input  => extra query param to be filled in using $self->proportal_filters

@return $output - raw output from the query


sub run_query {
	my $self = shift;
	my %args = @_;

#	say "self: " . Dumper $self;

	my $query = $args{query}
		# no query specified
		or croak __PACKAGE__ . ' ' . (caller(0))[3]
		. ': no query specified!';

	if ( ! $self->has_schema ) {
		if ( __PACKAGE__->can( 'schema' ) ) {
			eval {
				$self->schema_init( schema );
			};
			if ($@) {
				croak $@;
			}
		}
		else {
			croak __PACKAGE__ . ' ' . (caller(0))[3]
			. ': no schema configured!';
		}
	}

	# run the query...
	if ($self->can($query)) {
	#	say "query: " . Dumper $self->$query->as_query;
		my $res = $self->$query( \%args );

		return $res;
	}
}
=cut

=head2 proportal_filters

Get the filters for the ProPortal-specific species

=cut

sub proportal_filters {
	my $self = shift;

	return {
		'prochlorococcus' => qq{ lower(t.GENUS) LIKE '%prochlorococcus%' AND t.sequencing_gold_id IN (SELECT gold_id FROM gold_sequencing_project\@imgsg_dev WHERE ecosystem_type = 'Marine') },

		'synechococcus' => qq{ lower(t.GENUS) LIKE '%synechococcus%' AND t.sequencing_gold_id IN (select gold_id FROM gold_sequencing_project\@imgsg_dev WHERE ecosystem_type = 'Marine') },

		'cyanophage' => qq{
lower(t.taxon_display_name) LIKE '%cyanophage%' OR
lower(t.taxon_display_name) LIKE '%prochlorococcus phage%' OR
lower(t.taxon_display_name) LIKE '%synechococcus phage%'
},
	};

}



sub taxon_details {

	my $self = shift;
	my $args = shift;
	my $data;

	# taxonomic info
	my @res = $self->schema->resultset('Taxon')->search({
		'me.taxon_oid' => $args
	},{
		prefetch => 'goldseqproj',
		collapse => 1,
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
	})->all;

	if (scalar @res > 1) {
		carp "More than one result found... using first result";
	}

	%$data = %{$res[0], %{ delete $res[0]->{goldseqproj} } };


#	sequencing_gold_id
	if (! $data->{sequencing_gold_id}) {
		carp "No GOLD ID found.";
		return $data;
	}

	# get the gold id
	my $rs = $self->schema->resultset('GoldSequencingProject')->result_source;
	# get the related data
	my %r_hash;
	my @r_tables = map {
		my $rh = $rs->relationship_info($_);
		( my $c = $rh->{class} ) =~ s/DbSchema::IMG_Core::Result:://;
		( $_, $c );
	 } $rs->relationships;

	my %rel_h = ( @r_tables );

	for my $r (keys %rel_h) {
		next if $r =~ /taxa/;
		$data->{$r} = [ $self->schema->resultset( $rel_h{$r} )->search({
			'me.gold_id' => $data->{sequencing_gold_id}
		},{
		#	prefetch => $related,
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		})->all ];
	}

	return $data;

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

	my @res = $self->schema->resultset('GoldSequencingProject')->search({
		'me.gold_id' => $args->{input}
	},{
	#	prefetch => $related,
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
	})->all;

	if (scalar @res != 1) {
		die "No data found for GOLD ID " . $args->{input};
	}
	$data = $res[0];

	my $rs = $self->schema->resultset('GoldSequencingProject')->result_source;
	# get the related data
	my %r_hash;
	my @r_tables = map {
		my $rh = $rs->relationship_info($_);
		( my $c = $rh->{class} ) =~ s/DbSchema::IMG_Core::Result:://;
		( $_, $c );
	 } $rs->relationships;

	my %rel_h = ( @r_tables );

	# taxonomic info
	$data->{taxa} = [ $self->schema->resultset('Taxon')->search({
		'me.sequencing_gold_id' => $args->{input}
	},{
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
	})->all ];

	for my $r (keys %rel_h) {
		next if $r =~ /taxa/;
		$data->{$r} = [ $self->schema->resultset( $rel_h{$r} )->search({
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

produces a list of taxon names and IDs

@return $resultset

=cut

sub taxon_oid_display_name {
	my $self = shift;

=cut
	return [ $self->schema->resultset('GoldSequencingProject')
			->marine_eco
			->public_extant

	my $q = $self->schema->resultset('Taxon')
		->public_extant
		->
		->search({
			'goldseqproj.latitude' => { '!=' => undef },
			'goldseqproj.longitude' => { '!=' => undef },
			'goldseqproj.ecosystem_type' => 'Marine',
		},{
			join => 'goldseqproj',
			columns => [ qw( taxon_oid taxon_display_name genome_type ), map { "goldseqproj.$_" } qw ( gold_id geo_location latitude longitude altitude depth ecotype clade ) ],
			collapse => 1,
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		});



		->search({
			'me.ir_order' => 'Marine',
		},{
		})
		->search_related('goldseqproj')
			->search(undef, {
		columns  => [ qw( taxon_oid taxon_display_name genome_type genus
			geo_location latitude longitude altitude depth ecotype ) ]
		});

		->search_related('GoldSequencingProject'
		->search(undef,{
		columns  => [ qw( taxon_display_name taxon_oid genus ) ],
		order_by => [ qw( taxon_display_name taxon_oid ) ],
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
	})->all ];

	#	group_by => [ qw( something something_else ) ],

=cut

=cut
	}
	elsif ($args->{input} =~ /((proc(hlor)?|syn(ech)?)(ococcus)?)/ ) {
		return [ $self->schema->resultset('Taxon')
			->public_extant
			->genus($args->{input})
			->search({
				sequencing_gold_id => {
					in => $self->schema->resultset('GoldSequencingProject')->marine_eco_ids
				},
			},{
			columns  => [ qw( taxon_display_name taxon_oid genus ) ],
			order_by => [ qw( taxon_display_name taxon_oid ) ],
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		})->all ];
	}
	elsif ($args->{input} eq 'all') {

		return [ $self->schema->resultset('Taxon')
			->public_extant
			->all_spp
			->search({
				sequencing_gold_id => {
					in => $self->schema->resultset('GoldSequencingProject')->marine_eco_ids
				},
			},{
			columns  => [ qw( taxon_display_name taxon_oid genus ) ],
			order_by => [ qw( taxon_display_name taxon_oid ) ],
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		})->all ];
	}
=cut
	croak "Did not understand input arguments";
}

=head3 taxon_marine_metagenome

Marine metagenome taxon query

=cut

sub taxon_marine_metagenome {

	my $self = shift;

	return [ $self->schema->resultset('Taxon')
		->public_extant
		->marine_metagenome
		->search(undef, {
			columns => [ qw( taxon_display_name family taxon_oid ) ],
			order_by => [ qw( family taxon_display_name taxon_oid ) ],
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		}
	)->all ];


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
	return $self->schema->resultset('Taxon')
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
	return $c;
}

sub get_genus {
	my $self = shift;
	my $obj = shift;
	if ($obj->{taxon_display_name} =~ m/((prochlor|synech)ococcus)/i) {
		return $1;
	}
	return "";
}


sub clade_graph {
	my $self = shift;

	my @res = $self->schema->resultset('Taxon')
		->public_extant
		->genus_like('%prochlorococcus%', '%synechococcus%')
		->search_related('goldseqproj')
			->marine_eco
			->not_null('clade')
			->search({
				clade => { '!=', undef },
			},{
				columns => [ qw( me.taxon_oid me.taxon_display_name me.genome_type goldseqproj.clade ) ],
				result_class => 'DBIx::Class::ResultClass::HashRefInflator',
				collapse => 1,

		})->all;

	return [ @res ];

	return 'select t.taxon_oid, t.taxon_display_name, t.genome_type, '
	. 'p.geo_location, p.latitude, p.longitude, p.altitude, p.depth, p.clade '
	. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
	. 'where t.sequencing_gold_id = p.gold_id '
	. "and (lower(t.genus) like '%prochlorococcus%' or lower(t.genus) like '%synechococcus%') "
	. "and p.ecosystem_type = 'Marine' AND p.clade is not null "
	. "and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. 'ORDER BY 4, 5, 2';

}

sub coerce_for_clade_graph {

	my $self = shift;

	my $res = shift // return;

	# convert messy nested hashes into flat hashes

	my $data;
	# map by clade
	for (@$res) {
		next unless $_->{clade};
		push @{$data->{ $self->coerce_clade($_->{clade}) }}, { %{$_->{me}}, clade => $_->{clade} };
	}

#	say "Clades: " . join ", ", sort keys %$data;

	# remap so we have id: ..., genus: ..., count: ... , genomes: ...
	my $max_val = 1;
	my @rtn = sort { $a->{id} cmp $b->{id} } map {
		$max_val = @{$data->{$_}} if @{$data->{$_}} > $max_val;
		$_ = { id => $_, genus => $self->get_genus( $data->{$_}[0] ), count => scalar @{$data->{$_}}, genomes => $data->{$_} };
	} keys %$data;

	unshift @rtn, { id => undef, count => 0 };

	say Dumper [ @rtn ];


    $max_val = ceil($max_val / 5) * 5 + 10;

	return {
		data => \@rtn,
		settings => {
			max_val => $max_val,
			max_width => $max_val*6,
			taxon_url => '/taxon',
			genome_list => '/genome_list',
		}
	};


}



sub depth_clade {
	my $self = shift;
	my $args = shift;

	return $self->schema->resultset('Taxon')
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

	return $self->schema->resultset('Taxon')
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

=head3 location

Search for latitude/longitude

=cut

sub location {
	my $self = shift;
	my $args = shift;

	my $q = $self->schema->resultset('Taxon')
		->public_extant
		->search({
			'goldseqproj.latitude' => { '!=' => undef },
			'goldseqproj.longitude' => { '!=' => undef },
			'goldseqproj.ecosystem_type' => 'Marine',
		},{
			join => 'goldseqproj',
			columns => [ qw( taxon_oid taxon_display_name genome_type ), map { "goldseqproj.$_" } qw ( gold_id geo_location latitude longitude altitude depth ecotype clade ) ],
			collapse => 1,
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		});

	# flatten out hashes
	my @res = map {
		%$_ = ( %$_, %{ delete $_->{goldseqproj} } );
	#	delete $_->{goldseqproj};
		$_->{depth} = ProPortal::Model::UnitConverter::convert_depth( $_->{depth} );
		$_;
	} $q->all;

	say "Found " . @res . " results!";

	return \@res;

=cut

#	return $self->schema->resultset('GoldSequencingProject')
#		->not_null('latitude')
#		->not_null('longitude')
#		->marine_eco

	my $sql = 'select t.taxon_oid, t.taxon_display_name, '
		. 'p.geo_location, p.latitude, p.longitude, '
		. 'p.altitude, p.depth, t.domain, p.clade '
		. 'from taxon t, gold_sequencing_project\@imgsg_dev p '
		. 'where t.sequencing_gold_id = p.gold_id '
		. 'and p.latitude is not null and p.longitude is not null ';

	$sql = $self->add_proportal_filters($sql) if $args;

	return $sql
	. " and t.obsolete_flag = 'No' and t.is_public = 'Yes' "
	. " ORDER BY 4, 5, 2";
=cut

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

	my $rset = $self->schema->resultset('Taxon')
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

		return $self->schema->resultset('Taxon')
			->public_extant
			->phage
			->search(undef,{
			columns  => [ qw( taxon_display_name taxon_oid ) ],
			order_by => [ qw( taxon_display_name taxon_oid ) ],
			result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		});

	}
	else {

		return $self->schema->resultset('Taxon')
			->public_extant
			->genus($args)
			->search({
				sequencing_gold_id => {
					in => $self->schema->resultset('GoldSequencingProject')->marine_eco_ids
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
