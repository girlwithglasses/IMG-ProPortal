package AppCorePlugin;
use IMG::Util::Import;
use Dancer2::Plugin;
use ProPortalPackage;

use Dancer2::Plugin::Adapter;

my %obj_h;

plugin_keywords qw/
	bootstrap
	img_app
/;

=head3 img_app

Return the IMG::App object

=cut

sub img_app {

	return service( 'img_app' );

}

=head3 bootstrap

Initialise a ProPortal::Controller for running a query; see
ProPortal::Controller::Base for an example of the default controller.

@param  $c_type - the controller to instantiate; defaults to 'Base'
@param  $args   - arguments for the controller (e.g. filters)

@return $c      - the img_app instance with controller

=cut

sub bootstrap {
	my $plugin = shift;
	my $c_type = shift;
	$c_type ||= 'Base';

	$plugin->img_app->add_controller( $c_type, @_ );

	return service( 'img_app' );
}



1;
