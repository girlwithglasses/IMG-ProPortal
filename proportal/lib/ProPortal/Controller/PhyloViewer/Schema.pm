package ProPortal::Controller::PhyloViewer::Schema;

use IMG::Util::Import 'MooRole';


sub get_query_schema {

=cut

Also:
		gp => {
			control => 'array',
			name => 'gp',
			label => 'Gene products',
			pattern => /\d+__\d+/

=cut


	return {
		input => {
			control => 'radio',
			type => 'enum',
			name => 'input',
			label => 'Input sequences',
			default => 'cart',
			enum => [
				{	id => 'cart',
					label => 'Use current gene cart',
				}
			],
		},
		gp => {
			control => 'checkbox_table',
			type => 'array',
			name => 'gp',
			label => 'Input',
		},
		msa => {
			control => 'radio',
			type => 'enum',
			name => 'msa',
			label => 'Multiple sequence alignment method',
			default => 'clustal_omega',
			enum => [
				{	id => 'clustal_omega',
					label => 'Clustal Omega',
					description => 'Clustal Omega is blah blah blah',
				},
				{	id => 'tcoffee',
					label => 'T-Coffee',
					description => 'T-Coffee is ...'
				},
				{	id => 'muscle',
					label => 'MUSCLE',
					description => 'MUSCLE is ... '
				}
			],
		},
		tree => {
			control => 'radio',
			type => 'enum',
			name => 'tree',
			label => 'Phylogenetic tree generation method',
			default => 'phyml',
			enum => [
				{	id => 'phyml',
					label => 'PhyML'
				},
				{	id => 'phylip',
					label => 'PHYLIP'
				}
			],
		},
# 		output => {
# 			label => 'Output options',
# 			enum => [
# 				view => {
# 					label => 'View in browser'
# 				}
# 			],
# 			control => 'radio',
# 			default => 'view',
# 		}

	};
}

1;
