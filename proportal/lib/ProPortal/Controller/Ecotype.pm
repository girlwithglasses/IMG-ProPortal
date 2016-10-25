package ProPortal::Controller::Ecotype;

use IMG::Util::Base 'MooRole';

# extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/proportal/ecotype.tt',
			filters => {
				subset => 'prochlor'
			},
			valid_filters => {
				subset => {
					enum => [ qw( prochlor ) ],
				}
			}
		};
	}
);

=head3 render

Ecotype query: ecotype + clade classification

=cut

sub render {
	my $self = shift;

    my $res = $self->get_data();
    if ( ! $res || ! scalar @$res ) {
		$self->choke({
			err => 'no_results',
		});
    }

	my $data;
	# group by ecotype, then clade
	for ( @$res ) {
		$data->{ $_->{ecotype} }{ $_->{clade} }{ $_->{taxon_oid} } = $_;
	}

	return $self->add_defaults_and_render({
         output => $data,
#         js => {
#             class_type_h => $class_type_h,
#             tree => $tree,
#         }
    });

}

sub get_data {
    my $self = shift;

	my $res = $self->run_query({
		query => 'ecotype',
		filters => $self->filters,
	});

	# badly-populated DBs: remove blank results
	return [ grep { $_->{ecotype} } @{ $res || [] } ];
}

1;
