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
				subset => 'coccus'
			},
			valid_filters => {
				subset => {
					enum => [ qw( prochlor synech coccus ) ],
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

	# get all distinct clade names
	my $clades = $self->run_query({
		query => 'distinct_clade',
		filters => { subset => 'coccus' }
	});

#	say 'Clades: ' . Dumper $clades;

	my $data;
	my $clade_h;

	for my $c ( @$clades ) {
		(my $wsc = $c->{generic_clade}) =~ s/([^\w]+)/_/g;
		$data->{ $c->{genus} }{ $c->{generic_clade} } = {
			id => 'clade_' . $wsc,
			label => $c->{generic_clade},
			genus => $c->{genus},
			genomes => [],
		};
		$clade_h->{ $c->{generic_clade} }++;
	}

	my $res = $self->get_data();

	for my $r (@$res) {
		# collect genomes by the generic clade name
		push @{$data->{ $r->{genus} }{ $r->{generic_clade} }{genomes}}, $r;
	}

	return $self->add_defaults_and_render({
		js => { data => $data, clade_arr => [ sort keys %$clade_h ] }
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

#	return $res;

#	only required for badly-populated dbs
	return [ grep { $_->{clade} =~ /\w/ } @$res ];

}

1;

