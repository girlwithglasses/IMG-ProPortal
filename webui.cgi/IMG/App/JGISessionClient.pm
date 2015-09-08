###########################################################################
#
# $Id: JGISessionClient.pm 34176 2015-09-03 19:41:14Z aireland $
#
############################################################################
package IMG::App::JGISessionClient;

use IMG::Util::Base 'MooRole';
use DBI;
use JSON;
use IMG::Model::Contact;
use IMG::IO::File;
use DataModel::IMG_Core;
use DataModel::IMG_Gold;

requires 'config', 'http_ua';

=head3 get_jgi_user_json

Get user JSON from Caliban

@param  $cookie_val     value from JGI session cookie

@return JSON from Caliban
        die with error on failure

=cut

sub get_jgi_user_json {
	my $self = shift;
	my $cookie_val = shift // die "No user ID supplied";

	if ( ! $self->has_config ) {
		die "No config found!";
	}

	if ( ! $self->config->{sso_url_prefix} || ! $self->config->{sso_domain} ) {

		die "Missing required config parameters: sso_url_prefix: "
			. ( $self->config->{sso_url_prefix} || '<undefined>' )
			. '; sso_domain: '
			. ( $self->config->{sso_domain} || '<undefined>' );
	}

	my $response = $self->_run_request( $self->config->{sso_url_prefix} . $self->config->{sso_domain} . $cookie_val . '.json' );

	if (! $response->{success}) {
		if ( 599 == $response->{status} ) {
			# programmer error...
			die Dumper $response;
		}

		warn 'Response: ' . Dumper $response;

		warn "No user data found for $cookie_val";
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
	my $jgi_sess_id = shift // die 'No session ID supplied';

	if ( ! $self->has_config ) {
		die "No config found!";
	}

	if ( ! $self->config->{sso_url_prefix} || ! $self->config->{sso_domain} ) {

		die "Missing required config parameters: sso_url_prefix: "
			. ( $self->config->{sso_url_prefix} || '<undefined>' )
			. '; sso_domain: '
			. ( $self->config->{sso_domain} || '<undefined>' );
	}

	my $insert = ( substr( $self->config->{sso_domain}, -1) eq '/' )
	? 'api/sessions/'
	: '/api/sessions/';

    # https://signon.jgi-psf.org/api/sessions/
	my $response = $self->_run_request( $self->config->{sso_url_prefix} . $self->config->{sso_domain} . $insert . $jgi_sess_id . '.json', 'head' );

	if ( $response->{status} && ( '200' eq $response->{status} || '204' eq $response->{status} ) ) {
		return 1;
	}
	return 0;
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
