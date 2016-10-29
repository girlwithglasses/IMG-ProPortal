package AppCore;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
# use Dancer2::Plugin::LogContextual;
use Dancer2::Session::CGISession;
use Log::Contextual ':log';
use Sys::Hostname;
use IMG::App;
use ProPortal::Util::Factory;
# use ProPortal::CoreAppAdapter;

our $VERSION = '0.1.0';

sub init {
	my $class = shift;
	my %opts  = @_;

	# set optional configuration override
	set $_ => $opts{ $_ } for keys %opts;

}

=head3 create_core

Create a new IMG::App instance. Stored in the Dancer2 app as '_core'

=cut

sub create_core {

	my $class = Role::Tiny->create_class_with_roles( 'IMG::App',
	qw( ProPortal::Views::ProPortalMenu
		IMG::App::Role::MenuManager
		ProPortal::IO::DBIxDataModel
		ProPortal::IO::ProPortalFilters
	) );
	my $core = $class->new( config => config, psgi_req => request, session => session );
	set "_core" => $core;
	return setting('_core');

}


=head3 bootstrap

Initialise a ProPortal::Controller for running a query; see
ProPortal::Controller::Base for an example of the default controller.

@param  $c_type - the controller to instantiate; defaults to 'Base'
@param  $args   - arguments for the controller (e.g. filters)

@return $c      - a controller instance

=cut

sub bootstrap {
	my ($c_type, $args) = @_;
	$c_type ||= 'Base';

#	debug 'Application: ';
#	debug Dumper app;

	debug "Running bootstrap...";

	my $core = setting('_core') || create_core();
	set '_core' => $core->add_controller_role($c_type);
	return $core;

}

=head3 before hook

Shared code to run before every request

=cut

hook 'before' => sub {

	debug "Running before hook for " . request->dispatch_path;

	# should we bother with checks for logout?
	return if request->dispatch_path =~ m!^/log(in|out|ged_in)!;

	my $core = create_core();

	my $resp = $core->run_checks();
	if ( $resp ) {
		my $error = Dancer2::Core::Error->new( %$resp );
		$error->throw();
	}

#	debug "response: " . Dumper $resp;

	if ( config->{sso_enabled} ) {

#		debug "sso is enabled";
		#	we have the JGI session cookie
		# JGI SSO returns a cookie with ID jgi_session
		if ( cookies && cookies->{jgi_session} ) {
			if ( session('jgi_session_id') ) {
				# make sure that the session is still valid
				local $@;
				my $ok = eval { $core->check_jgi_session( session('jgi_session_id') ) };

				if ( $@ ) {
					debug 'Got an error';

					if ( ref $@  && 'HASH' eq ref $@ && $@->{status} && 404 == ref $@->{status} ) {
						debug 'found a 404 error';
						do_login();
					}
				}
				else {
					debug 'No local error found!';
				}
				# we need to log back in again
#				forward '/login', { post_login => request->dispatch_path } if ! $ok;
				debug 'Not OK!';
				do_login() if ! $ok;

				# load the user data and create a new user object
				my $user_h = $core->run_user_checks( cookies->{jgi_session}->value );

				$core->set_up_session( $user_h );

			}
			else {
				# use the cookie value to get user info
				debug "found a JGI session cookie!";

				# reinstantiate user object if it doesn't exist
				local $@;
				my $user_h = eval { $core->run_user_checks( cookies->{jgi_session}->value ) };
				if ( $@ ) {
					debug 'Got an error: ' . Dumper $@;
					my $err = $@;


					if ( ref $err && 'HASH' eq ref $err && defined $err->{status} && 404 == $err->{status} ) {
						debug 'found a 404 error';
						do_login();
					}
				}
				else {
					debug 'No local error found!';
				}

				$core->set_up_session( $user_h );

				debug "We got " . ( $@ || "through the checks" );

			}
		}
		else {
			debug "sending the request on to 'login'";
			forward '/login', { post_login => request->dispatch_path };
		}
	}

#	debug "Finished the pre hook checks!";

	return;

};

=head3 before_template_render

Hook triggered before templates are rendered; adds useful data to templates.

See get_tmpl_vars for details

=cut


hook before_template_render => sub {

	my $out = get_menu_vars( @_ );
	get_tmpl_vars ( $out );

};

sub get_menu_vars {

	my $output = shift // {};
	my $page_id = var 'page_id';
	my $menu_grp = var 'menu_grp';

	debug 'page_id: ' . ( $page_id // 'is undefined' )
	. ' menu_grp: ' . ( $menu_grp // 'is undefined' );

	my $core = setting('_core') // create_core();

	for ( @{ $core->make_menu( $menu_grp, $page_id ) } ) {
		if ( $_->{id} && "menu/DataMarts" eq $_->{id} ) {
			$output->{data_marts} = $_;
		}
		else {
			push @{$output->{navigation}}, $_;
		}
	}

	$output->{current_page} = $page_id;
	if ( session->data ) {
	#	debug "session data: " . Dumper session->data;
		if ( session('name') ) {
			debug "session name: " . Dumper session('name');
			$output->{name} = session('name');
		}
	}

	return { output => $output, core => $core };

}


=head3 get_tmpl_vars

Default data to add to the templates

Adds external and internal links, plus navigation data.

@param  $output   (opt) data hash to add the defaults to

=cut

sub get_tmpl_vars {

	my $args = shift;
	my $output = $args->{output};
	my $core = $args->{core};

	$output->{sw_version} = $VERSION;
	$output->{ext_link} = sub { return $core->ext_link( @_ ) };
	$output->{link} = sub { return $core->img_link_tt( @_ ) };
	$output->{breadcrumbs}++;
	$output->{server_name} = hostname;
	$output->{ora_service} = $ENV{ORA_SERVICE} || 'The Oracle is silent';
	return $output;
}

any '/' => sub {

	return template 'pages/proportal/home', {};

};

#	forward login requests to the JGI login page

any '/login' => sub {

	# Display a login page; the original URL they requested is available as
	# param('post_login'), so could be put in a hidden field in the form
	my $path = param('post_login') // '';
	$path =~ s!^/!!;
	$path ||= 'logged_in';

	delete cookies->{jgi_return} if cookies && exists cookies->{jgi_return};

	debug 'uri_for ' . $path . ' = ' . uri_for( $path );

	my $c = Dancer2::Core::Cookie->new(
		name => 'jgi_return',
		value => uri_for( $path ),
		domain => config->{sso_domain},
		path => '/',
		expires => '5 mins'
	);

	push_response_header 'Set-Cookie' => $c->to_header();

#	return '';
	redirect 'https://signon.jgi.doe.gov';

#	return template "pages/login", { path => $path, login => param('login') || undef, password => param('password') || undef };

};

get '/logged_in' => sub {

	delete cookies->{jgi_return} if cookies && cookies->{jgi_return};

	# initialise the session
#	set_session_user_data( cookies->{jgi_session}->value );

	return 'Congratulations, you are logged in!';

};

any qr{
	/logout
	}x => sub {

	app->destroy_session;

	redirect 'https://signon.jgi-psf.org/signon/destroy';
};

# any qr{
# 	/(?<query> 403|404|500|503)
# 	}x => sub {
#
# 	return template captures->{query};
#
# };


sub do_login {

	debug 'running do_login';
	forward '/login', { post_login => request->dispatch_path };

}


1;
