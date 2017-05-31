package ProPortal::Controller::ProPortal::Ecotype;

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

    my $res = $self->get_data->all;

	# badly-populated DBs: remove blank results
#	return [ grep { $_->{ecotype} } @{ $res || [] } ];

    if ( ! $res || ! scalar @$res ) {
		$self->choke({
			err => 'no_results',
		});
    }

	return { results => {
		js => {
			arr => $res,
			table_cols => [ 'cbox_taxon', 'taxon_oid', 'taxon_display_name', 'ecotype', 'clade', 'pp_subset' ]
		}
	} };

}

sub get_data {
    my $self = shift;

	return $self->_core->run_query({
		query => 'ecotype',
		filters => $self->filters,
		-result_as => 'statement'
	});
}

1;
