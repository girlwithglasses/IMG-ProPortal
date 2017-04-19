package AppCore;
use IMG::Util::Import;
use Dancer2 appname => 'ProPortal';
use Dancer2::Session::CGISession;

use Sys::Hostname;
use IMG::App;
use ProPortal::Util::Factory;
use AppCorePlugin;
use IMG::Util::Logger;

our $VERSION = '0.1.0';


sub init {
	my $class = shift;
	my %opts  = @_;

#	log_debug { 'running init code!' };
	# set optional configuration override
	set $_ => $opts{ $_ } for keys %opts;

}

=head3 before hook

Shared code to run before every request

=cut

hook 'before' => sub {

	log_debug { "Running before hook for " . request->path };

	# should we bother with checks for logout? no.
	return if request->path =~ m!^/(log(in|out|ged_in)|offline)!;

	img_app->init_current_query( app );

	my $resp = img_app->run_checks();
	if ( $resp ) {
		my $error = Dancer2::Core::Error->new( %$resp );
		$error->throw();
	}

#	log_debug { "response: " . Dumper $resp };

	if ( img_app->config->{sso_enabled} ) {

		log_debug { "sso is enabled" };
		#	we have the JGI session cookie
		#	JGI SSO returns a cookie with ID jgi_session
		if ( cookies && cookies->{jgi_session} ) {
			log_debug { 'found cookies, and found a jgi_session cookie!' };
			if ( session('jgi_session_id') ) {
				# make sure that the session is still valid
				local $@;
				my $ok = eval { img_app->check_jgi_session( session('jgi_session_id') ) };

				if ( $@ ) {
					log_debug { 'Got an error' };

					if ( ref $@  && 'HASH' eq ref $@ && $@->{status} && 404 == $@->{status} ) {
						log_debug { 'found a 404 error' };
						do_login();
					}
				}
				else {
					log_debug { 'No local error found!' };
				}
				# we need to log back in again
#				forward '/login', { post_login => request->path } if ! $ok;
				log_debug { 'Not OK!' };
				do_login() if ! $ok;

				# load the user data and create a new user object
				my $user_h = img_app->run_user_checks( cookies->{jgi_session}->value );

				img_app->set_up_session( $user_h );

			}
			else {
				# use the cookie value to get user info
				log_debug { "found a JGI session cookie!" };

				# reinstantiate user object if it doesn't exist
				local $@;
				my $user_h = eval { img_app->run_user_checks( cookies->{jgi_session}->value ) };
				if ( $@ ) {
					log_debug { 'Got an error: ' . Dumper $@ };
					my $err = $@;


					if ( ref $err && 'HASH' eq ref $err && defined $err->{status} && 404 == $err->{status} ) {
						log_debug { 'found a 404 error' };
						do_login();
					}
				}
				else {
					log_debug { 'No local error found!' };
				}

				img_app->set_up_session( $user_h );

				log_debug { "We got " . ( $@ || "through the checks" ) };

			}
		}
		else {
			log_debug { "sending the request on to 'login'" };
			forward '/login', { post_login => request->path };
		}
	}

	log_debug { "Finished the pre hook checks!" };

	return;

};

=head3 before_template_render

Hook triggered before templates are rendered; adds useful data to templates.

See get_tmpl_vars for details

=cut


hook before_template_render => sub {

	my $args = get_menu_vars();

	my $tmpl_extras = get_tmpl_vars ( $args );

	# merge the two
	$_[0]->{$_} = $tmpl_extras->{$_} for keys %$tmpl_extras;

};

sub get_menu_vars {
	my $output;

	my $rslt = img_app->make_menu({
		page  => img_app->current_query->page_id,
		group => img_app->current_query->menu_group
	});

	my $class;
	for ( @{$rslt->{menu}} ) {
		$class++ if defined $_->{class};
		if ( $_->{id} && "menu/DataMarts" eq $_->{id} ) {
			$output->{data_marts} = $_;
		}
		else {
			push @{$output->{navigation}}, $_;
		}
	}

	if ( ! $class ) {
		$output->{no_sidebar} = 1;
	}
	$output->{current_page} = img_app->current_query->page_id;

	return { output => $output, core => img_app };

}


=head3 get_tmpl_vars

Default data to add to the templates

Adds external and internal links, plus navigation data.

@param  $args hashref with  keys
	core	IMG::App core
	output	(opt) data hash to add the defaults to

@return $args->{output} with added goodness

=cut

sub get_tmpl_vars {

	my $args = shift;
	my $output = $args->{output};
	my $core = $args->{core};

	$output->{link} = sub { return $core->img_link_tt( @_ ) };
	$output->{ext_link} = sub { return $core->ext_link( @_ ) };

	$output->{img_app_config} = img_app->config;
	$output->{sw_version} = $VERSION;
	$output->{server_name} = hostname;
	$output->{ora_service} = $ENV{ORA_SERVICE} || 'The Oracle is silent';
	$output->{breadcrumbs}++;
	$output->{copyright_year} = ( localtime(time) )[5] + 1900;

	if ( session->data ) {
	#	debug "session data: " . Dumper session->data;
		if ( session('name') ) {
			log_debug { "session name: " . Dumper session('name') };
			$output->{name} = session('name');
		}
	}

#	$output->{img_cfg} = $core->img_cfg;
	return $output;
}

#	forward login requests to the JGI login page

any '/login' => sub {

	# no sso_domain configuration
	if ( ! img_app->config->{sso_domain} ) {
		forward '/';
	}

	# Display a login page; the original URL they requested is available as
	# param('post_login'), so could be put in a hidden field in the form
	my $path = query_parameters->get('post_login') // '';
	$path =~ s!^/!!;
	$path ||= 'proportal';

#	delete cookies->{jgi_return} if cookies && exists cookies->{jgi_return};

	my $c = Dancer2::Core::Cookie->new(
		name => 'jgi_return',
		value => img_app->config->{ top_base_url } . $path,
		domain => img_app->config->{ sso_domain },
		path => '/',
		expires => '5 mins'
	);

	push_response_header 'Set-Cookie' => $c->to_header();

	log_debug { 'cookie: ' . $c->to_header() };

	redirect 'https://signon.jgi.doe.gov';

};

get '/logged_in' => sub {

#	delete cookies->{jgi_return} if cookies && cookies->{jgi_return};

	# initialise the session
#	set_session_user_data( cookies->{jgi_session}->value );

#	var menu_grp => 'proportal';
#	var page_id => 'proportal';

	return template 'pages/logged_in';

};

any qr{
	/logout
	}x => sub {

	app->destroy_session;

	redirect 'https://signon.jgi.doe.gov/signon/destroy';
};

sub do_login {

	log_debug { 'running do_login' };
	forward '/login', { post_login => request->path };

}


1;
