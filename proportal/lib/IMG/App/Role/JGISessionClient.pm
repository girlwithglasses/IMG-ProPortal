###########################################################################
#
# $Id: JGISessionClient.pm 37114 2017-05-30 14:14:14Z aireland $
#
############################################################################
package IMG::App::Role::JGISessionClient;

use IMG::Util::Import 'MooRole';
use JSON;
use IMG::Model::Contact;
use IMG::Util::File;

requires 'config', 'http_ua', 'choke';

=head3 get_jgi_user_json

Get user JSON from Caliban

@param  $cookie_val     value from JGI session cookie

@return JSON from Caliban
        die with error on failure

=cut

sub get_jgi_user_json {
	my $self = shift;
	my $req_url = $self->_create_sso_url({ type => 'cookie_val', cookie_val => +shift });

	my $response = $self->_run_request( $req_url );

	if ( ! $response->{success}) {
# 		if ( 599 == $response->{status} ) {
# 			# programmer error...
# 			die Dumper $response;
# 		}
# 		warn "No user data found at $req_url";
		die {
			status  => $response->{status},
			title   => $response->{reason},
			message => $response->{content}
		};
	}

	local $@;
	my $json = eval { from_json $response->{content} };
	if ($@) {
		$self->choke({
			err => 'json_decode_err',
			msg => $@
		});
	}

	# make sure we have the correct fields
	if (! $json->{user} || ! $json->{user}{login} || ! $json->{user}{email_address} || ! $json->{user}{id} ) {
		$self->choke({
			err => 'caliban_err'
		});
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
	my $req_url = $self->_create_sso_url({ type => 'session_id', session_id => +shift });

    # https://signon.jgi-psf.org/api/sessions/
	my $response = $self->_run_request( $req_url, 'head' );

	if ( $response->{status} && ( '200' eq $response->{status} || '204' eq $response->{status} ) ) {
		return 1;
	}
	return 0;
}

=head3 _create_sso_url


@param $args    hashref with keys

	type   - either cookie_val or session_id
	$type  - $cookie_val or $session_id

i.e. to supply a cookie value:

	$self->_create_sso_url({
		type => 'cookie_val', cookie_val => 'abc123'
	});

@return $complete_url_for_json

=cut

sub _create_sso_url {
	my $self = shift;
	my $args = shift;

    if ( ! $self->config->{sso_url_prefix} || ! $self->config->{sso_domain} ) {
		$self->choke({
			err => 'cfg_missing',
			subject => 'sso_config'
		});
    }

	my $id_type = $args->{type} || $self->choke({
		err => 'missing',
		subject => 'ID type'
	});

	my @valid_types = qw( cookie_val session_id );
	if ( ref $id_type || ! grep { $id_type eq $_ } @valid_types ) {
		$self->choke({
			err => 'invalid_enum',
			subject => $id_type,
			type => 'ID type',
			enum => \@valid_types
		});
	}

	my $id = $args->{ $id_type } || $self->choke({
		err => 'missing',
		subject => $id_type
	});

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
		$self->choke({
			err => 'missing',
			subject => 'URL for _run_request'
		});
	}
	my $head = shift || undef;
	my $method = ( $head ) ? 'head' : 'get' ;
	return $self->http_ua->$method( $url );
}

1;
