package ProPortal::Controller::Home;

use IMG::Util::Base 'MooRole';

use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/proportal/home.tt',
			tmpl_includes => {
				tt_scripts => qw( data_type )
			},
		};
	}
);

=head3 stats



=cut

sub render {
	my $self = shift;
	my $data;

	# news query (only for logged-in users...)
	local $@;
	my $news = eval { $self->run_query({ query => 'news' }); };

	my $stats;

	# counts, grouped by proportal subset
	$stats->{subsets} = $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns => [ 'proportal_subset', 'count(taxon_oid)|count' ],
			-group_by => 'proportal_subset',
			-where => {
				proportal_subset => { '!=', undef }
			}
		);

	# counts, grouped by longhurst code
	$stats->{by_longhurst} = $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ 'count(taxon_oid)|count', qw( longhurst_code longhurst_description ) ],
			-group_by => [ qw( longhurst_code longhurst_description ) ],
			-where => {
				proportal_subset => { '!=', undef }
			},
		);

	# metagenome counts, grouped by ecosystem

	$stats->{metagenomes_by_eco} = $self->schema('img_core')->table('GoldTaxonVw')
		->select(
			-columns  => [ 'count(taxon_oid)|count', qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype specific_ecosystem ) ],
			-group_by => [ qw( ecosystem ecosystem_category ecosystem_type ecosystem_subtype ) ],
			-where => {
				proportal_subset => 'metagenome'
			},
		);

	my $res = $self->get_data;

	# arrange by genome type and then by ecosystem subtype
	for (@$res) {
		push @{$data->{ $_->{genome_type} }{ $_->{ecosystem_subtype} || 'Unclassified' }}, $_;
	}

	return $self->add_defaults_and_render({
		sorted_data => $data,
		news => $news // undef,
		stats => $stats
	});
}


sub get_data {
	my $self = shift;

	# run taxon_oid_display_name for each of the members
	return $self->run_query({
		query => 'taxon_oid_display_name',
		filters => $self->filters,
	});
}

1;
