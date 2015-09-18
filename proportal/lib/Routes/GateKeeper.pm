############################################################################
#	GateKeeper.pm
#
#	Routes for logging in and out
#
#	$Id: GateKeeper.pm 33827 2015-07-28 19:36:22Z aireland $
############################################################################
package Routes::GateKeeper;

use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'CoreStuff';
our $VERSION = 0.01;

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

	debug "c: " . Dumper $c;
	debug "to header: " . Dumper $c->to_header();
#	say "jgi cookie: " . Dumper cookie->{jgi_return};
	debug "cookies: " . Dumper cookies;

	push_header 'Set-Cookie' => $c->to_header();

	return template "pages/login", { path => $path, login => param('login') || undef, password => param('password') || undef };

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

	# "$sso_url/signon/destroy"
	if ( cookies->{jgi_return} ) {
		cookie jgi_return => 'http://google.com';
	}
	app->destroy_session;

	redirect 'https://signon.jgi-psf.org/signon/destroy';

};

hook before => sub {

	debug "Running before hook for " . request->dispatch_path;
	# should we bother with checks for logout?
	return if request->dispatch_path =~ m!^/log(in|out|ged_in)!;

#	debug "request: " . Dumper request->env;

#	debug 'config: ' . Dumper config;

	my $core = setting('_core') // CoreStuff::create_core();

	my $resp = $core->run_checks();
	if ( $resp ) {
		my $error = Dancer2::Core::Error->new( %$resp );
		$error->throw();
	}

#	debug "response: " . Dumper $resp;

	if ( config->{sso_enabled} ) {

		info "sso is enabled";
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
				info "found a JGI session cookie!";

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

				info "We got " . ( $@ || "through the checks" );

			}
		}
		else {
			info "sending the request on to 'login'";
			forward '/login', { post_login => request->dispatch_path };
		}
	}

	info "Finished the pre hook checks!";

	return;

};

sub do_login {

	debug 'running do_login';
	forward '/login', { post_login => request->dispatch_path };

}

1;
