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
		return { subset => 'all_proportal' };
	},
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

	for my $fn ( qw( subset dataset_type ) ) {
		$schema->{$fn} = $self->_core->filter_schema( $fn );
		if ( $valid->{$fn} ) {
			$schema->{$fn}{enum} = $valid->{$fn}{enum};
		}
	}

	return $schema;

# 	return {
# 		subset => {
# 			id => 'subset',
# 			type  => 'enum',
# 			title => 'subset',
# 			control => 'checkbox',
# 			enum => $valid->{subset}{enum},
# 			enum_map => {
# 				pro => 'Prochlorococcus',
# 				syn => 'Synechococcus',
# 				pro_phage => 'Prochlorococcus phage',
# 				syn_phage => 'Synechococcus phage',
# 				other => 'Other bacteria',
# 				other_phage => 'Other phages',
# 				phage => 'Prochlorococcus, Synechococcus, and other phages',
# 				coccus => 'Prochlorococcus, Synechococcus, and other bacteria',
# 				isolate => 'All ProPortal isolates',
# 				metagenome => 'Marine metagenomes',
# 				all_proportal => 'All isolates and metagenomes'
# 			}
# 		},
# 		dataset_type => {
# 			id => 'dataset_type',
# 			type => 'enum',
# 			title => 'data type',
# 			control => 'checkbox',
# 			enum => $valid->{dataset_type}{enum},
# 			enum_map => {
# 				'single cell' => 'Single cell',
# 				isolate => 'Isolate',
# 				metagenome => 'Metagenome',
# 				transcriptome => 'Transcriptome',
# 				metatranscriptome => 'Metatranscriptome'
# 			}
# 		}
# 	};
}

=head3 set_filters

Set the filters for a query. Checks that the filter setting is valid and throws an error if it is not.

@param  $filters      filter hash in the form { param => value }, e.g. { subset => 'isolate' }

@output dies if there is an error; otherwise filters are set on the controller

=cut

sub set_filters {
	my $self = shift;

	my $filters = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift // return;

	log_debug { 'filters: ' . $filters };

	for my $f ( keys %$filters ) {
		if ( ! $self->valid_filters->{ $f } ) {
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
	if ( keys %$filters ) {
		$self->_set_filters( $filters );
	}
	return;
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
