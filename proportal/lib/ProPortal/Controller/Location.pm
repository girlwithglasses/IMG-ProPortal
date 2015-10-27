package ProPortal::Controller::Location;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( location ),
		};
	},
);

=head3 render

Requires JSON plugin for rendering data set on a Google map

=cut

sub render {
	my $self = shift;

	my $data = $self->coerce_for_location_map(
			$self->run_query({
			query => 'location',
			filters => $self->filters,
		})
	);

#	my $data = $self->dao->location;

	return $self->add_defaults_and_render( $data );

}


=head3 coerce_for_location_map

collect the data by lat/long

=cut

sub coerce_for_location_map {
	my $self = shift;
	my $res = shift;

	my $data;
	for (@$res) {
		# only required for badly-populated dbs
		next unless $_->{latitude} && $_->{longitude};

		#group by lat/long
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
	return [ values %$data ];
}



1;
