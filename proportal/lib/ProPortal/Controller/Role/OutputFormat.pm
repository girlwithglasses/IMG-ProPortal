package ProPortal::Controller::Role::OutputFormat;

use IMG::Util::Import 'MooRole';

=head3 output_format

format for the output

One of html, csv, tab, json

=cut

has 'output_format' => (
	is => 'lazy',
	default => 'html'
);

# the status of the query
# init (not yet run) | success | fail

has 'status' => (
	is => 'rwp',
	default => 'init'
);

# where the result is stored

has 'result' => (
	is => 'rwp',
	default => undef
);

# the result format (e.g. an object; DBIx::DataModel statement; hashref; arrayref of results; etc.)

has 'result_format' => (
	is => 'rwp',
	default => undef
);

1;
