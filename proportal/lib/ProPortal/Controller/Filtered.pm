package ProPortal::Controller::Filtered;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

has '+valid_filters' => (
	default => sub {
		return {
			subset => {
				id => 'subset',
				label => 'subset',
				type => 'checkbox',
				values => [
					{ id => 'prochlor', label => 'Prochlorococcus' },
					{ id => 'synech',  label => 'Synechococcus' },
					{ id => 'prochlor_phage',  label => 'Prochlorococcus phage' },
					{ id => 'synech_phage',  label => 'Synechococcus phage' },
					{ id => 'isolate', label => 'All isolates' },
					{ id => 'metagenome', label => 'Marine metagenomes' },
				]
			}
		};
	},
);

1;
