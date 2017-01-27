############################################################################
#	GateKeeper.pm
#
#	Routes for logging in and out
#
#	$Id: GateKeeper.pm 36524 2017-01-26 17:57:46Z aireland $
############################################################################
package Routes::GateKeeper;

use IMG::Util::Import;
use Dancer2 appname => 'ProPortal';
use parent 'AppCore';

any '/' => sub {

	return template 'home', {};

};

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

1;
