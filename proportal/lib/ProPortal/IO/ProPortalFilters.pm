package ProPortal::IO::ProPortalFilters;

use IMG::Util::Import 'MooRole';

=head2 subset_filter

Get the filters for the ProPortal-specific species

Filters apply to the 'VW_GOLD_TAXON' table (view)

Current filters:

prochlor
prochlor_phage
synech
synech_phage
metagenome

coccus -- prochlor + synech
phage  -- prochlor_phage + synech_phage

isolate -- coccus + phage

all_proportal -- isolate + metagenome

=cut

sub subset_filter {
	my $self = shift;
	my $f_name = shift // $self->choke({
		err => 'missing',
		subject => 'filter'
	});

	my $filters = {

		prochlor => sub {
			return {
				ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
				genome_type => 'isolate',
				genus => 'Prochlorococcus',
				domain => 'Bacteria',
			};
		},

		synech => sub {
			return {
				ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
				genome_type => 'isolate',
				genus => 'Synechococcus',
				domain => 'Bacteria',
			};
		},

		prochlor_phage => sub {
			return {
			#	ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
				genome_type => 'isolate',
				taxon_display_name => { -like => 'Prochlorococcus%' },
				domain => 'Viruses',
			};
		},

		synech_phage => sub {
			return {
			#	ecosystem_subtype => [ 'Marginal Sea', 'Pelagic' ],
				genome_type => 'isolate',
				taxon_display_name => { -like => 'Synechococcus%' },
				domain => 'Viruses',
			};
		},

		metagenome => sub {
			return {
				genome_type => 'metagenome',
				ecosystem_type => 'Marine',
			};
		},
	};

	$filters->{coccus} = sub {
		return [ map { $filters->{$_}->() } qw( prochlor synech ) ];
	};

	$filters->{phage} = sub {
		return [ map { $filters->{$_}->() } qw( prochlor_phage synech_phage ) ];
	};

	$filters->{isolate} = sub {
		return [ map { $filters->{$_}->() } qw( prochlor synech prochlor_phage synech_phage ) ];
	};

	$filters->{all_proportal} = sub {
		return [ map { $filters->{$_}->() } qw( prochlor synech prochlor_phage synech_phage metagenome ) ];
	};

	$filters->{isolates} = $filters->{isolate};
	$filters->{metagenomes} = $filters->{metagenome};

	$self->choke({
		err => 'invalid',
		type => 'subset filter',
		subject => $f_name
	}) unless defined $filters->{$f_name};

	return { -where => $filters->{$f_name}->() };

}

1;
