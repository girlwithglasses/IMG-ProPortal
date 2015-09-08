package ProPortal;
use IMG::Util::Base;
use Dancer2;
use Dancer2::Session::CGISession;
use Sys::Hostname;
use Role::Tiny::With;
use IMG::App;
use ProPortal::IO::DBIxDataModel;
use ProPortal::Util::Factory;
use GateKeeper;
use IMaGene;
use CGI::PSGI;

with qw(
	ProPortal::Views::Links
	ProPortal::Views::Menu
);

our $VERSION = '0.1';

our @active_components = qw( home data_type location clade );

my $pp;

get '/test' => sub {

	template 'pages/test', {};

};


sub init {
	my $class = shift;
	my %opts  = @_;

	# set optional configuration override
	set $_ => $opts{ $_ } for keys %opts;

	# create the core app parts
#	set '_core_app' => IMG::Core::App->new(  );

}

get '/' => sub {

	$pp = bootstrap( undef, config );

	template "pages/home", $pp->render();
};

prefix '/proportal'; # => sub {

	# filterable queries
	get qr{
		/ (?<page> location | clade | data_type )
		/? (?<ecosystem_subtype> neritic | pelagic | marginal )?
		}x => sub {

		my $c = captures;
		my $p = delete $c->{page};
		$pp = bootstrap( $p, config );

		my $results;
		if ($c->{ecosystem_subtype}) {
			$pp->set_filters($c);
		}
		template "pages/" . $p, $pp->render();

	};

	get qr{
		/ ( home | index )?
		}x => sub {

		$pp = bootstrap( undef, config );

		template "pages/home", $pp->render();

	};

	get '/taxon/:taxon_oid' => sub {

		my $pp = bootstrap( 'Details' );

		$pp->set_filters({ taxon_oid => params->{taxon_oid} });

		template "pages/genome_details", $pp->render();

	};

#};


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



=head3 bootstrap

Initialise a Controller and run a query.

=cut

sub bootstrap {
	my ($c_type, $cfg) = @_;
	$c_type ||= 'Home';
	$cfg ||= config;

#	if ($cfg->{sessions_enabled}) {
#		$cfg->{ session } = session;
#	}
	$cfg->{_core} = setting("_core");

	debug "Running bootstrap...";

	# temporary hack!
	$cfg->{active_components} = [ @active_components ];

	my $c = ProPortal::Util::Factory::create_pp_component( 'Controller', $c_type, $cfg );
#	debug "component: " . Dumper $c;
	return $c;
	# run preflight checks
}


hook before => sub {

	debug "Running before hook for " . request->dispatch_path;
	# should we bother with checks for logout?
	return if request->dispatch_path =~ m!^/log(in|out)!;

#	debug "request: " . Dumper request->env;

#	debug 'config: ' . Dumper config;

	my $core = IMG::App->new( config => config, psgi_req => request, session => session );

	set "_core" => $core;

	my $resp = $core->run_checks();
	if ( $resp ) {
		my $error = Dancer2::Core::Error->new( %$resp );
		Dancer2::Core::Response->set( $error->render );
	}

#	debug "response: " . Dumper $resp;

	if ( config->{sso_enabled} ) {

		info "sso is enabled";
		#	we have the JGI session cookie
		# JGI SSO returns a cookie with ID jgi_session
		if ( cookies && cookies->{jgi_session} ) {
			if ( session('jgi_session_id') ) {
				# make sure that the session is still valid
				my $ok = $core->check_jgi_session( session('jgi_session_id') );
				# we need to log back in again
	#			forward '/login', { post_login => request->dispatch_path } if ! $ok;

				# load the user data and create a new user object

				my $user_h = $core->run_user_checks( cookies->{jgi_session}->value );

				$core->set_up_session( $user_h );

			}
			else {
				# use the cookie value to get user info
				info "found a JGI session cookie!";

				my $user_h = $core->run_user_checks( cookies->{jgi_session}->value );

				$core->set_up_session( $user_h );

				info "We got " . ( $@ || "through the checks" );

			}
		}
		else {
			info "sending the request on to 'login'";
			forward '/login', { post_login => request->dispatch_path };
		}
	}

	info "Finished the pre hook checks!";

	# get WebUtil set up. Ugh!
# 	require WebUtil;
# 	WebUtil::initialize(
# 		session => session,
# 		cookie_name => config->{engines}{session}{CGISession}{cookie_name},
# 		cgi => CGI::PSGI->new( request->env ),
# 		img_gold => $core->db_conn('img_gold')->dbh,
# 		img_core => $core->db_conn('img_core')->dbh,
# 	);

	info "Whew! Done that WebUtil stuff!";

	# make sure that the session stays active
#	my $cart_status = $core->touch_cart_files();

#	taxon_stuff();

	return;

};



1;
