package ProPortal::Controller::Tools::JBrowse;

use IMG::Util::Import 'Class'; #'MooRole';

extends 'ProPortal::Controller::Base';

# has 'controller_args' => (
# 	is => 'lazy',
# 	default => sub {
# 		return {
# 			class => 'ProPortal::Controller::Base',
# 			tmpl => 'pages/tools/jbrowse.tt',
# 		};
# 	}
# );

has '+page_id' => (
	default => 'tools/jbrowse'
);


=head3 jbrowse page

???

=cut

sub _render {
	my $self = shift;
	return;
}

1;
