package IMG::IO::HttpClient;

use IMG::Util::Base 'MooRole';

use HTTP::Tiny;
use Scalar::Util qw(blessed);
use IO::Socket::SSL;
use Net::SSLeay;

has 'http_ua' => (
	is => 'rw',
	builder => 1,
	lazy => 1,
	writer => 'set_http_ua',
	coerce => sub {
		# allow objects to be passed in
		if ( @_ ) {
			if ( blessed( $_[0] ) ) {
				return shift;
			}
			if ( 1 == scalar @_ ) {
				return HTTP::Tiny->new( %{ +shift } );
			}
		}
		return HTTP::Tiny->new();
	}
);

sub _build_http_ua {
	my $self = shift;
	return HTTP::Tiny->new();
}

1;
