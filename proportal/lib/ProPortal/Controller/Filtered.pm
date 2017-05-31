package ProPortal::Controller::Filtered;

# use IMG::Util::Import 'MooRole';

use IMG::Util::Import 'Class';
use Hash::MultiValue;

extends 'ProPortal::Controller::Base';

has 'params' => (
	is => 'ro',
	trigger => 1,
);

sub _build_params {
	return {};
}

sub _trigger_params {
	my $self = shift;
	log_debug { 'running trigger query params!' };
	$self->set_filters( $self->params );
}

=head3 filters

The filters on the current query. Use $app->set_filters( $f ) to set filters.

Default filter for a filtered query: full ProPortal dataset

=cut

has 'filters' => (
	is => 'rwp',
	lazy => 1,
	coerce => sub {
		my $args = shift;
		log_debug { 'running coerce filters, ref $args: ' . ref $args };
		log_debug { Dumper $args };
		if ( 'Hash::MultiValue' eq ref $args ) {
			return $args;
		}
		else {
			return Hash::MultiValue->new( %$args );
		}
	},
	default => sub {
		return { pp_subset => 'all_proportal' };
	},
);

has 'filter_domains' => (
	is => 'lazy',
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
				enum => [ qw( pro pro_phage syn syn_phage other other_phage pp_isolate pp_metagenome all_proportal ) ]
			},
		};
	}
);

=head3 query_filter_schema

The JSON schema compatible representation of the filters for this query

=cut

has 'query_filter_schema' => (
	is => 'lazy'
);

sub _build_query_filter_schema {
	my $self = shift;
	my $valid = $self->valid_filters;

	my $schema;

#	log_debug { 'core: ' . Dumper $self->_core };

	for my $fn ( @{$self->filter_domains} ) {
		$schema->{$fn} = $self->_core->filter_schema( $fn );
		if ( $valid->{$fn} && $valid->{$fn}{enum} ) {
			$schema->{$fn}{enum} = $valid->{$fn}{enum};
		}
	}

#	log_debug { 'schema now: ' . Dumper $schema };

	return $schema;

}

=head3 set_filters

Set the filters for a query. Checks that the filter setting is valid and throws an error if it is not.

@param  $filters      filter hash in the form { param => value }, e.g. { pp_subset => 'pp_isolate' }

@output dies if there is an error; otherwise filters are set on the controller

=cut

sub set_filters {
	my $self = shift;
	my $filters = shift;

	# initialise filters
	my $curr_filters = $self->filters;

#	log_debug { 'filters: ' . Dumper $filters };
#	log_debug { 'filter schema: ' . Dumper $self->filter_schema };
#	log_debug { 'valid filters: ' . Dumper $self->valid_filters };
#	log_debug { 'current filts: ' . Dumper $curr_filters };

	my $tested = Hash::MultiValue->new;

	for my $f ( @{$self->filter_domains} ) {

		# now check the value
		if ( $filters->{$f} ) {
			log_debug { 'found ' . $f . ', values ' . join ", ", $filters->get_all($f) };
			if ( 'enum' eq $self->query_filter_schema->{$f}{type} ) {
				$self->test_enum({ schema => $self->query_filter_schema->{$f}, test => [ $filters->get_all($f) ] });
			}
			# what other types might we have?
			elsif ( $self->query_filter_schema->{$f}{pattern} ) {
				## TODO

			}
			elsif ( 'number' eq $self->query_filter_schema->{$f}{type} ) {

			}
			$tested->add( $f, $filters->get_all($f) );
		}
		elsif ( $curr_filters->get( $f ) ) {
			log_debug { 'using existing value for ' . $f };
			$tested->add( $f, $curr_filters->get( $f ) );
		}
		elsif ( $self->query_filter_schema->{$f}{default} ) {
			log_debug { 'using default for ' . $f };
			$tested->add( $f, $self->query_filter_schema->{$f}{default} );
		}
	}

	if ( $tested->keys ) {
		$self->_set_filters( $tested );
	}

	log_debug { 'filters post-setting: ' . Dumper $self->filters };

	return;
}

sub test_enum {
	my $self = shift;
	my $args = shift;

	for my $t ( @{$args->{test}} ) {
		if ( ! grep { $_ eq  $t } @{$args->{schema}{enum}} ) {
			$self->choke({
				err => 'invalid',
				subject => $t,
				type => 'filter value'
			});
		}
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

	my $active_h;
	for my $k ( keys %{$self->filters} ) {
		$active_h->{$k}{$_}++ for $self->filters->get_all( $k );
	}

	if ( $self->can('filters') ) {
		$rtn->{data_filters} = {
			active => $active_h,
			valid  => $self->valid_filters,
			schema => $self->query_filter_schema,
			full_schema => $self->_core->filter_schema(':all')
		};
	}
	return $rtn;

};

1;
