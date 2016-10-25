package ProPortal::Controller::Location;

use IMG::Util::Base 'MooRole';
use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/proportal/location.tt',
			tmpl_includes => {
				tt_scripts => qw( location ),
			}
		};
	},
);

=head3 render

Requires JSON plugin for rendering data set on a Google map

=cut

sub render {
	my $self = shift;

	my $res = $self->get_data;

	my $data;
	for (@$res) {
		# only required for badly-populated dbs
		next unless $_->{latitude} && $_->{longitude};

		# group by lat/long
		if (! $data->{ $_->{latitude} ."_". $_->{longitude} } ) {
			$data->{ $_->{latitude} ."_". $_->{longitude} } = {
				latitude => $_->{latitude},
				longitude => $_->{longitude},
				geo_location => $_->{geo_location},
				genomes => [ $_ ], #[ damn $_ ],
			};
		}
		else {
			push @{$data->{ $_->{latitude} ."_". $_->{longitude}}{genomes}}, $_; #damn $_;
		}

	}

	return $self->add_defaults_and_render([ values %$data ]);

}

sub get_data {
	my $self = shift;
	return $self->run_query({
		query => 'location',
		filters => $self->filters,
	});
}

1;
