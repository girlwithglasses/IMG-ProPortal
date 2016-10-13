package ProPortal::Controller::Filtered;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

=head3 filters

The filters on the current query. Use $app->set_filters( $f ) to set filters.

Default filter for a filtered query: full ProPortal dataset

=cut

has 'filters' => (
	is => 'rwp',
	lazy => 1,
	default => sub {
		return { subset => 'all_proportal' };
	}
);

=head3 valid_filters

Valid filters for the query

Default: all proportal options

=cut

has 'valid_filters' => (
	is => 'lazy',
	default => sub {
		return {
			subset => {
				enum => [ qw( prochlor synech prochlor_phage synech_phage isolate metagenome all_proportal ) ]
			}
		};
	}
);

=head3 filter_schema

The JSON schema compatible representation of the filters for this query

=cut

has 'filter_schema' => (
	is => 'lazy'
);

sub _build_filter_schema {
	my $self = shift;
	my $valid = $self->valid_filters;

	return {
		subset => {
			id => 'subset',
			type  => 'enum',
			title => 'subset',
			control => 'checkbox',
			enum => $valid->{subset}{enum},
			enum_map => {
				prochlor => 'Prochlorococcus',
				synech => 'Synechococcus',
				prochlor_phage => 'Prochlorococcus phage',
				synech_phage => 'Synechococcus phage',
				isolate => 'All ProPortal isolates',
				metagenome => 'Marine metagenomes',
				all_proportal => 'All isolates and metagenomes'
			}
		}
	};
}

=head3 set_filters

Set the filters for a query. Checks that the filter setting is valid and throws an error if it is not.

@param  $filters      filter hash in the form { param => value }, e.g. { subset => 'isolate' }

@output dies if there is an error; otherwise filters are set on the controller

=cut

sub set_filters {
	my $self = shift;
#	my $filters = shift // return;

	my $filters = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift // return;

#	say 'filters: ' . Dumper $filters;

# 	if ( ! $self->has_valid_filters ) {
# 		# no valid filters for this query
# 		$self->choke({
# 			err => 'invalid',
# 			subject => 'ZOMG! This',
# 			type => 'query to filter'
# 		});
# 	}
	for my $f ( keys %$filters ) {
		if ( ! $self->filter_schema->{ $f } ) {
			$self->choke({
				err => 'invalid',
				subject => $f,
				type => 'query dimension to filter'
			});
		}
		# now check the value
		if ( 'enum' eq $self->filter_schema->{$f}{type} ) {
			if ( ! grep { $_ eq  $filters->{$f} } @{$self->filter_schema->{$f}{enum}} ) {
				$self->choke({
					err => 'invalid',
					subject => $filters->{$f},
					type => 'filter value'
				});
			}
		}
		# what other types might we have?
		else {
			## TODO
		}
	}
	$self->_set_filters( $filters );
	return;
}

# after 'add_defaults_and_return' => sub {
#
# 	if ( $self->can('filters') ) {
# #	if ($self->has_filters) {
# 		$rtn->{data_filters}{active} = $self->filters;
# #	}
#
# #	if ($self->has_valid_filters) {
# 		$rtn->{data_filters}{all} = $self->valid_filters;
# #	}
# 	}
#
# };

around 'add_defaults_and_render' => sub {
	my $orig = shift;
	my $self = shift;
	my $rtn = $orig->($self, @_);

	if ( $self->can('filters') ) {
		$rtn->{data_filters}{active} = $self->filters;
		$rtn->{data_filters}{all} = $self->filter_schema;
	}
	return $rtn;

};



1;
