package ProPortal::Controller::Tools::JBrowse;

use IMG::Util::Base 'MooRole';

has 'controller_args' => (
	is => 'lazy',
	default => sub {
		return {
			class => 'ProPortal::Controller::Base',
			tmpl => 'pages/tools/jbrowse.tt',
			tmpl_includes => {
#				tt_scripts => qw( data_type )
			}
		};
	}
);

=head3 jbrowse page

???

=cut

sub render {
	my $self = shift;
	return;
}

1;
