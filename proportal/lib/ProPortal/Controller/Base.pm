package ProPortal::Controller::Base;

use IMG::Util::Base 'Class';

with 'IMG::App::Role::ErrorMessages';

# has '_core' => (
# 	is => 'ro',
# 	predicate => 1,
# 	handles => [ qw(
# 		config schema http_ua session user run_query
# 	) ],
# );

=head3 tmpl

templates to use for rendering the page

=cut

has 'tmpl' => (
	is => 'lazy'
);

sub _build_tmpl {
	my $self = shift;
	$self->choke({
		err => 'missing',
		subject => 'template name'
	});
}

=head3 tmpl_includes

templates to include in the page

=cut

has 'tmpl_includes' => (
	is => 'lazy',
);

sub _build_tmpl_includes {
	return {};
}

sub BUILDARGS {
	my $class = shift;

#	say __PACKAGE__ . " buildargs: config: " . Dumper [ @_ ];

	my $args = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift // {};

	return $args;
}


=head3 add_defaults_and_render

Note that if you pass in a data hash which has identical keys to those added by
this method, the existing data hash values will overwrite those that this sub
attempts to add

@param  $data   (opt)   data hash to add the defaults to

@output $data           data hash with lots of extra information added

=cut


sub add_defaults_and_render {
	my $self = shift;

	my $rtn = {
		results => $_[0] // {}
	};

	$rtn->{tmpl_includes} = $self->tmpl_includes;

# 	if ( $self->can('filters') ) {
# 		$rtn->{data_filters}{active} = $self->filters;
# 		$rtn->{data_filters}{all} = $self->valid_filters;
# 	}

	return $rtn;

}


1;
