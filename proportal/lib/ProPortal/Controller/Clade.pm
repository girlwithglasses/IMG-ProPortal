package ProPortal::Controller::Clade;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Filtered';

use Template::Plugin::JSON::Escape;

has '+tmpl_includes' => (
	default => sub {
		return {
			tt_scripts => qw( clade ),
			tt_styles  => qw( clade ),
		};
	},
);

=head3 render

Requires JSON plugin for rendering data set

=cut

sub render {

	my $self = shift;

	my $data = $self->coerce_for_clade_graph(
		$self->run_query({
			query => 'clade',
			filters => $self->filters,
		})
	);

	return $self->add_defaults_and_render( $data );

}

=head3 coerce_for_clade_graph

collect genomes by the web-friendly clade name

=cut

sub coerce_for_clade_graph {
	my $self = shift;
	my $res = shift;
	my $data;
	# map by clade

#	say "results: " . Dumper $res;

	for my $r (@$res) {
		# only required for badly-populated dbs
		next unless $r->{clade};

		if ( ! $data->{ $r->{generic_clade} }) {
			(my $wsc = $r->{generic_clade}) =~ s/([^\w]+)/_/g;
			$data->{ $r->{generic_clade} } = {
				id => 'clade_' . $wsc,
				label => $r->{generic_clade},
				genus => $r->{genus},
				count => 1,
				genomes => [ $r ],
			};
		}
		else {
			push @{$data->{ $r->{generic_clade} }{genomes}}, $r;
			$data->{ $r->{generic_clade} }{count}++;
		}
	}

	return {
		data => $data,
		js => { data => $data }
	};

}

1;
