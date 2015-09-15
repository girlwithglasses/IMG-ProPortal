package CoreStuff;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use Dancer2::Session::CGISession;
use Sys::Hostname;
use IMG::App;
use IMG::Views::Links;
use IMG::Views::Menu;

our $VERSION = '0.1';

sub init {
	my $class = shift;
	my %opts  = @_;

	# set optional configuration override
	set $_ => $opts{ $_ } for keys %opts;

	# create the core app parts
#	set '_core_app' => IMG::Core::App->new(  );

}

=head3 before_template_render

Default data to add to the templates

Adds external and internal links, plus navigation data.

@param  $output   (opt) data hash to add the defaults to

=cut


hook before_template_render => sub {

	my $output = shift // {};

	get_tmpl_vars ( $output );

};

sub get_tmpl_vars {

	my $output = shift // {};
	my $current = var 'current';
	my $page = var 'page';

	$output->{navigation} = IMG::Views::Menu::get_menus( config, $current, $page );

	$output->{ext_links} = { sso_url => 'https://signon.jgi-psf.org' }; #IMG::Views::Links::get_ext_link();
	$output->{links} = { %{ IMG::Views::Links::img_links( config ) }, %{ IMG::Views::Links::proportal_links( config ) } };
	$output->{cfg} = config;
	$output->{cfg}{server_name} = hostname;
	$output->{cfg}{perl_v} = $];
	$output->{cfg}{ora_service} = $ENV{ORA_SERVICE} || 'The Oracle is silent';
	# build date
	$output->{cfg}{remote_address} = request->forwarded_for_address // request->address;
	$output->{cfg}{current_page} = $page;
	if ( session->data ) {
		debug "session data: " . Dumper session->data;
		if ( session('name') ) {
			debug "session name: " . Dumper session('name');
			$output->{name} = session('name');
		}
	}
#	debug "output: " . Dumper $output;
}

sub create_core {

	my $core = IMG::App->new( config => config, psgi_req => request, session => session );
	set "_core" => $core;
	return $core;

}


1;
