############################################################################
#	IMG::App::Core.pm
#
#	Core attributes, etc.
#
#	$Id: Core.pm 34542 2015-10-20 20:56:35Z aireland $
############################################################################
package IMG::App::Core;

use IMG::Util::Base 'Class';

has 'config' => (
	is => 'ro',
	isa => HashRef,
    lazy => 1,
	predicate => 1,
);

has 'http_params' => (
	is => 'lazy',
	isa => HashRef,
);

has 'cgi' => (
	is => 'ro',
	isa => InstanceOf['CGI'],
	predicate => 1,
);

has 'psgi_req' => (
	is => 'ro',
	isa => InstanceOf['Dancer2::Core::Request'],
	predicate => 1,
);

sub BUILDARGS {
	my $class = shift;
	my $args = ( @_ && 1 < scalar( @_ ) ) ? { @_ } : shift;
	return $args || {};
}

sub _build_http_params {

	my $self = shift;

	if ( $self->has_psgi_req ) {
		return $self->psgi_req->env;
	}
	elsif ( $self->has_cgi ) {
		my %params = $self->cgi->Vars;
		return \%params;
	}
	return {};
}

sub env {
	my $self = shift;
	warn 'use of "env" is deprecated; please use "config" instead';
	return $self->config;
}

1;
