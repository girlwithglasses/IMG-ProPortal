package ProPortal::Controller::Base;

use IMG::Util::Base 'Class';

has '_core' => (
	is => 'ro',
	predicate => 1,
	handles => [ qw(
		schema http_ua session user
	) ],
);

with 'ProPortal::IO::DBIxDataModel';

=head3 tmpl_includes

templates to include in the page

=cut

has 'tmpl_includes' => (
	is => 'ro',
	predicate => 1,
);

=head3 filters

The filters on the current query

=cut

has 'filters' => (
	is => 'rw',
	predicate => 1,
	writer => 'set_filters',
);

=head3 valid_filters

Valid filters for the query

=cut

has 'valid_filters' => (
	is => 'ro',
	predicate => 1,
);


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
	my $data = shift // {};

	my $rtn = {
		results => $data
	};

	if ($self->has_tmpl_includes) {
		$rtn->{tmpl_includes} = $self->tmpl_includes;
	}

	if ($self->has_filters) {
		$rtn->{data_filters}{active} = $self->filters;
	}

	if ($self->has_valid_filters) {
		$rtn->{data_filters}{all} = $self->valid_filters;
	}

	return $rtn;
}


1;
