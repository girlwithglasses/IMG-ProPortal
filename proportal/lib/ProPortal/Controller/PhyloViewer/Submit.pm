package ProPortal::Controller::PhyloViewer::Submit;

use IMG::Util::Base 'Class';

extends 'ProPortal::Controller::Base';

=head3 render

Create the PhyloViewer submission form

=cut

sub render {
	my $self = shift;

	my $options = [

		input => {
			type => 'radio',
			label => 'Input sequences',
			default => 'cart',
			values => [
				{	id => 'cart',
					label => 'Use current gene cart',
				}
			],
		},
		msa => {
			type => 'radio',
			label => 'Multiple sequence alignment method',
			default => 'clustalw',
			values => [
				{	id => 'clustalw',
					label => 'ClustalW',
					description => 'ClustalW is blah blah blah',
				},
				{	id => 'tcoffee',
					label => 'T-Coffee',
					description => 'T-Coffee is ...'
				}
			],
		},
		tree => {
			type => 'radio',
			label => 'Phylogenetic tree generation method',
			default => 'phyml',
			values => [
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
# 			values => [
# 				view => {
# 					label => 'View in browser'
# 				}
# 			],
# 			type => 'radio',
# 			default => 'view',
# 		}

	];


	return $self->add_defaults_and_render( {
		options => $options
	} );

}

1;
