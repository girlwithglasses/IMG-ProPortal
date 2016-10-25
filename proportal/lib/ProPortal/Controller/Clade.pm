package ProPortal::Controller::Clade;

use IMG::Util::Base 'MooRole';

use Template::Plugin::JSON::Escape;

has 'controller_args' => (
	is => 'lazy',
	default => sub {
#		say 'running default controller args';
		return {
			class => 'ProPortal::Controller::Filtered',
			tmpl => 'pages/proportal/clade.tt',
			tmpl_includes => {
				tt_scripts => qw( clade ),
				tt_styles  => qw( clade ),
			},
			filters => {
				subset => 'isolate'
			},
			valid_filters => {
				subset => {
					enum => [ qw( prochlor synech isolate ) ],
				}
			},
		};
	}
);


=head3 render

Requires JSON plugin for rendering data set

=cut

sub render {

	my $self = shift;

#	say 'self: ' . $self;

	my $res = $self->get_data();
	my $data;

	for my $r (@$res) {
		# only required for badly-populated dbs
		next unless $r->{clade};

		# collect genomes by the web-friendly clade name
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

	return $self->add_defaults_and_render({
		js => { data => $data, original_data => $res }
	});

# 	return {
# 		results => {
# 			js => { data => $data, original_data => $res }
# 		}
# 	};

}

sub get_data {
	my $self = shift;

	my $res = $self->run_query({
		query => 'clade',
		filters => $self->filters,
	});

	return [ grep { $_->{clade} } @$res ];

}

1;

