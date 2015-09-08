package CoreStuff;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use Dancer2::Session::CGISession;
use Sys::Hostname;
use Role::Tiny::With;
use IMG::App;

with qw(
	ProPortal::Views::Links
	ProPortal::Views::Menu
);

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

	$output->{navigation} = get_menus( config );
	$output->{ext_links} = external_links();
	$output->{links} = { %{ img_links( config ) }, %{ proportal_links( config ) } };
	$output->{cfg} = config;
	$output->{cfg}{server_name} = hostname;
	$output->{cfg}{perl_v} = $];
	$output->{cfg}{ora_service} = $ENV{ORA_SERVICE} || 'The Oracle is silent';
	# build date
	$output->{cfg}{remote_address} = request->forwarded_for_address // request->address;

	if ( session->data ) {
		debug "session data: " . Dumper session->data;
		if ( session('name') ) {
			debug "session name: " . Dumper session('name');
			$output->{name} = session('name');
		}
	}
}

sub create_core {

	my $core = IMG::App->new( config => config, psgi_req => request, session => session );
	set "_core" => $core;
	return $core;

}


1;
