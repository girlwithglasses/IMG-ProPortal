package ProPortal::Controller::Ecotype;

use IMG::Util::Import 'Class';#'MooRole';

extends 'ProPortal::Controller::Filtered';
with 'IMG::Util::Text';

use Template::Plugin::JSON::Escape;

has '+page_id' => (
	default => 'proportal/ecotype'
);

has '+tmpl_includes' => (
	default => sub {
		return { tt_scripts => qw( ecotype ) };
	}
);

has '+filters' => (
	default => sub {
		return { pp_subset => 'pro' };
	}
);

has '+valid_filters' => (
	default => sub {
		return { pp_subset => { enum => [ qw( pro ) ] } };
	}
);

=head3 render

Ecotype query: ecotype + clade classification

=cut

sub _render {
	my $self = shift;

    my $res = $self->get_data();
    if ( ! $res || ! scalar @$res ) {
		$self->choke({
			err => 'no_results',
		});
    }

	my $data;
	my $wsn;
	# group by ecotype, then clade
	for ( @$res ) {
		$data->{ $_->{ecotype} }{ $_->{clade} }{ $_->{taxon_oid} } = $_;
		$wsn->{ $_->{clade} }++;
	}

	for ( keys %$wsn ) {
		$wsn->{$_} = $self->make_text_web_safe( $_ );
	}

	return { results => {
		js => {
			data => $data,
			web_safe_names => $wsn
		}
	} };

}

sub get_data {
    my $self = shift;

	my $res = $self->_core->run_query({
		query => 'ecotype',
		filters => $self->filters,
	});

	# badly-populated DBs: remove blank results
	return [ grep { $_->{ecotype} } @{ $res || [] } ];
}

1;
