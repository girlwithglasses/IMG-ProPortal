package ProPortal::Controller::Home;

use IMG::Util::Import 'Class'; #'MooRole';

#use Template::Plugin::JSON::Escape;

extends 'ProPortal::Controller::Filtered';

# has 'controller_args' => (
# 	is => 'lazy',
# 	default => sub {
# 		return {
# 			class => 'ProPortal::Controller::Base',
# 			page_id => 'proportal',
# 			tmpl => 'pages/proportal/home.tt',
# 			page_wrapper => 'layouts/default_wide.tt',
# 			tmpl_includes => {
# 				tt_scripts => qw( data_type )
# 			},
# 		};
# 	}
# );

has '+valid_filters' => (
	default => sub {
		return {
			pp_subset => {
				enum => [ qw( pro syn pro_phage syn_phage other other_phage isolate ) ],
			}
		};
	}
);

has '+page_id' => (
	default => 'proportal'
);

has '+tmpl' => (
	default => 'pages/proportal/home.tt'
);

has '+page_wrapper' => (
	default => 'layouts/default_wide.tt'
);

=head3 stats



=cut

sub _render {
	my $self = shift;
	my $data;

	my $stats;

	# counts, grouped by proportal pp_subset
	$stats->{pp_subsets} = $self->_core->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns => [ 'pp_subset', 'count(taxon_oid)|count' ],
			-group_by => 'pp_subset',
			-where => {
				pp_subset => { '!=', undef },
#				is_public => 'Yes'
			},
			-result_as => ['hashref' => 'pp_subset' ]
		);

	# counts, grouped by proportal pp_subset and data types
# 	$stats->{data_types_all} = $self->_core->schema('img_core')->table('TaxonTypeVw')
# 		->select(
# 			-columns => [ 'pp_subset', 'lower(data_type)|data_type', 'count(taxon_oid)|count' ],
# 			-group_by => ['pp_subset', 'data_type' ],
# 			-where => {
# 				pp_subset => { '!=', undef }
# 			},
# 		);
#
# 	for ( @{$stats->{data_types_all}} ) {
# 		$stats->{data_types}{ $_->{data_type} .'\0'. $_->{pp_subset} } = $_;
# 	}
#
# 	$stats->{data_types_public} = $self->_core->schema('img_core')->table('TaxonTypeVw')
# 		->select(
# 			-columns => [ 'pp_subset', 'lower(data_type)|data_type', 'count(taxon_oid)|public_count' ],
# 			-group_by => ['pp_subset', 'data_type' ],
# 			-where => {
# 				pp_subset => { '!=', undef },
# 				is_public => 'Yes'
# 			},
# 		);
#
# 	$stats->{data_types} = {};
# 	for ( @{$stats->{data_types_all}}, @{$stats->{data_types_public}} ) {
# 		my $key = $_->{data_type} ."\0". $_->{pp_subset};
# 		if ( $stats->{data_types}{ $key } ) {
# 			$stats->{data_types}{ $key }{public_count} = $_->{public_count};
# 		}
# 		else {
# 			$stats->{data_types}{ $key } = $_;
# 		}
# 	}

	# counts, grouped by longhurst code
	$stats->{by_longhurst} = $self->_core->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ 'count(taxon_oid)|count', map { 'coalesce(' . $_ . ", 'Unclassified') \"$_\""  } qw( longhurst_code longhurst_description ) ],
			-group_by => [ qw( longhurst_code longhurst_description ) ],
			-order_by => [ 'longhurst_description' ],
			-where => {
				pp_subset => { '!=', undef },
#				is_public => 'Yes'
			},
			-result_as => ['hashref' => 'longhurst_description' ]
		);
	if ( $stats->{by_longhurst}{''} ) {
		$stats->{by_longhurst}{zzzzz} = delete $stats->{by_longhurst}{''};
	}

	# metagenome counts, grouped by ecosystem
	$stats->{metagenomes_by_eco} = $self->_core->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ 'count(taxon_oid)|count', qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
			-group_by => [ qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
			-order_by => [ qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
			-where => {
				pp_subset => 'metagenome',
#				is_public => 'Yes'
			},
		);

	$stats->{metagenomes_by_subtype} = $self->_core->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ 'count(taxon_oid)|count', qw( ecosystem_type ecosystem_subtype ) ],
			-group_by => [ qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype ) ],
			-order_by => [ qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype ) ],
			-where => {
				pp_subset => 'metagenome',
#				is_public => 'Yes'
			},
		);

	# metagenome count for all Marine metagenomes
	$stats ->{metagenomes_marine} = $self->_core->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ 'count(taxon_oid)|count', qw( ecosystem_type ) ],
			-group_by => [ qw( ecosystem_type ) ],
			-order_by => [ qw( ecosystem_type ) ],
			-where => {
				ecosystem_type => 'Marine',
				pp_subset => 'metagenome',
			},
		);

	return { results => {
		stats => $stats
	} };
}

1;
