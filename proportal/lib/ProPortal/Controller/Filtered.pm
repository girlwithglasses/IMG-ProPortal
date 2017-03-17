package ProPortal::Controller::Filtered;

# use IMG::Util::Import 'MooRole';

use IMG::Util::Import 'Class';

extends 'ProPortal::Controller::Base';

=head3 filters

The filters on the current query. Use $app->set_filters( $f ) to set filters.

Default filter for a filtered query: full ProPortal dataset

=cut

has 'filters' => (
	is => 'rwp',
	lazy => 1,
	default => sub {
		return { pp_subset => 'all_proportal' };
	},
);

has 'filter_domains' => (
	is => 'ro',
	lazy => 1,
	default => sub {
		return [ qw( pp_subset ) ];
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
			pp_subset => {
				enum => [ qw( pro pro_phage syn syn_phage other other_phage isolate metagenome all_proportal ) ]
			},
#			dataset_type => {
#				enum => [ 'isolate', 'single cell', qw( metagenome transcriptome metatranscriptome ) ]
#			},
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

	my $schema;

	for my $fn ( @{$self->filter_domains} ) {
		$schema->{$fn} = $self->_core->filter_schema( $fn );
		if ( $valid->{$fn} && $valid->{$fn}{enum} ) {
			$schema->{$fn}{enum} = $valid->{$fn}{enum};
		}
	}

	return $schema;

}

=head3 set_filters

Set the filters for a query. Checks that the filter setting is valid and throws an error if it is not.

@param  $filters      filter hash in the form { param => value }, e.g. { pp_subset => 'isolate' }

@output dies if there is an error; otherwise filters are set on the controller

=cut

sub set_filters {
	my $self = shift;

	my $filters = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift // return;

	log_debug { 'filters: ' . Dumper $filters };
	log_debug { 'filter schema: ' . Dumper $self->filter_schema };
	log_debug { 'valid filters: ' . Dumper $self->valid_filters };

# 	for my $f ( keys %$filters ) {
# 		log_debug { 'f: ' . $f };
# 		if ( ! $self->valid_filters->{ $f } ) {
# 			$self->choke({
# 				err => 'invalid',
# 				subject => $f,
# 				type => 'query dimension to filter'
# 			});
# 		}
# 	}
	my $tested;

	for my $f ( @{$self->filter_domains} ) {

		# now check the value
		if ( $filters->{$f} ) {
			if ( 'enum' eq $self->filter_schema->{$f}{type} ) {

				$self->test_enum({ schema => $self->filter_schema->{$f}, test => $filters->{$f} });
			}
			# what other types might we have?
			elsif ( $self->filter_schema->{$f}{pattern} ) {
				## TODO

			}
			elsif ( 'number' eq $self->filter_schema->{$f}{type} ) {

			}
			$tested->{$f} = $filters->{$f};
		}
		elsif ( $self->filter_schema->{$f}{default} ) {
			$tested->{$f} = $self->filter_schema->{$f}{default};
		}
	}
	if ( keys %$filters ) {
		$self->_set_filters( $tested );
	}

	log_debug { 'filters post-setting: ' . Dumper $self->filters };

#	die;

	return;
}

sub test_enum {
	my $self = shift;
	my $args = shift;

	if ( ! grep { $_ eq  $args->{test} } @{$args->{schema}{enum}} ) {
		$self->choke({
			err => 'invalid',
			subject => $args->{test},
			type => 'filter value'
		});
	}
	return;
}

sub test_number {
	my $self = shift;
	my $args = shift;

	$self->choke({
		err => 'invalid',
		subject => $args->{test},
		type => 'filter value'
	}) unless $args->{test} =~ m!^\d+$!;
}

sub test_string {
	my $self = shift;
	my $args = shift;

	$self->choke({
		err => 'invalid',
		subject => $args->{test},
		type => 'filter value'
	}) unless $args->{test} =~ m!\w+!;

}

sub test_pattern {
	my $self = shift;
	my $args = shift;



}

around 'render' => sub {
	my $orig = shift;
	my $self = shift;
	my $rtn = $orig->( $self, @_ );

	if ( $self->can('filters') ) {
		$rtn->{data_filters} = {
			active => $self->filters,
			valid  => $self->valid_filters,
			all    => $self->filter_schema,
			schema => $self->filter_schema
		};
	}
	return $rtn;

};

1;
