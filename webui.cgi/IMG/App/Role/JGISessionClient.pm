###########################################################################
#
# $Id: JGISessionClient.pm 34501 2015-10-13 23:40:50Z aireland $
#
############################################################################
package IMG::App::Role::JGISessionClient;

use IMG::Util::Base 'MooRole';
use JSON;
use IMG::Model::Contact;
use IMG::Util::File;

requires 'config', 'http_ua';

=head3 get_jgi_user_json

Get user JSON from Caliban

@param  $cookie_val     value from JGI session cookie

@return JSON from Caliban
        die with error on failure

=cut

sub get_jgi_user_json {
	my $self = shift;
	my $req_url = $self->_create_sso_url( cookie_val => @_ );

	my $response = $self->_run_request( $req_url );

	if ( ! $response->{success}) {
		if ( 599 == $response->{status} ) {
			# programmer error...
			die Dumper $response;
		}
		warn "No user data found at $req_url";
		die {
			status  => $response->{status},
			title   => $response->{reason},
			message => $response->{content}
		};
	}

	local $@;
	my $json = eval { from_json $response->{content} };
	if ($@) {
		die 'JSON decoding error: $@';
	}

	# make sure we have the correct fields
	if (! $json->{user} || ! $json->{user}{login} || ! $json->{user}{email_address} || ! $json->{user}{id} ) {
		die 'JSON response lacks required fields';
	}

	return $json;

}

=head3 check_jgi_session

Checks that the current JGI session is still valid by pinging Caliban

@param  $jgi_sess_id    JGI session ID, stored in the IMG session

@return  1 if the session is valid
         0 otherwise

=cut

sub check_jgi_session {
	my $self = shift;
	my $req_url = $self->_create_sso_url( session_id => @_ );

    # https://signon.jgi-psf.org/api/sessions/
	my $response = $self->_run_request( $req_url, 'head' );

	if ( $response->{status} && ( '200' eq $response->{status} || '204' eq $response->{status} ) ) {
		return 1;
	}
	return 0;
}

=head3 _create_sso_url

@param  $id_type    - either cookie_val or session_id
@param  $id         - $cookie_val or $session_id

@return $complete_url_for_json

=cut

sub _create_sso_url {
    my $self = shift;
    my $id_type = shift || die 'No ID type specified';

    if ( ! $self->has_config ) {
        die "No config found!";
    }
    if ( ! $self->config->{sso_url_prefix} || ! $self->config->{sso_domain} ) {
        die "Missing required config parameters: sso_url_prefix: "
            . ( $self->config->{sso_url_prefix} || '<undefined>' )
            . '; sso_domain: '
            . ( $self->config->{sso_domain} || '<undefined>' );
    }

    if ( ref $id_type || ( 'cookie_val' ne $id_type && 'session_id' ne $id_type ) ) {
        die 'ID type must be "cookie_val" or "session_id"';
    }

    my $id = shift || die 'No ' . $id_type . ' supplied';

    die $id_type . ' must be a string' if ref $id;

    if ( 'session_id' eq $id_type ) {
        my $insert = ( substr( $self->config->{sso_domain}, -1) eq '/' )
        ? 'api/sessions/'
        : '/api/sessions/';
        $id = $insert . $id;
    }

    # https://signon.jgi-psf.org/api/sessions/
	return $self->config->{sso_url_prefix} . $self->config->{sso_domain} . $id . '.json';

}

=head3 _run_request

Does the actual JSON fetching

@param  $url
@param  $head   string or bool (optional); if it evaluates to true, a 'HEAD'
                request will be sent, rather than a 'GET'.

@return $response

=cut

sub _run_request {
	my $self = shift;
	my $url  = shift;
	if ( ! $url || $url !~ /\w+/ ) {
		die 'No URL specified for _run_request';
	}
	my $head = shift || undef;
	my $method = ( $head ) ? 'head' : 'get' ;
	return $self->http_ua->$method( $url );
}

1;
