############################################################################
#	IMG::App::Core.pm
#
#	Core attributes, etc.
#
#	$Id: Core.pm 36174 2016-09-15 13:29:13Z aireland $
############################################################################
package IMG::App::Core;

use IMG::Util::Base 'Class';
use IMG::Model::Contact;
use Time::HiRes;


has 'id' => (
	is => 'ro',
	builder => 1
);

sub _build_id {
	return [ Time::HiRes::gettimeofday ];
}

has 'config' => (
	is => 'lazy',
	isa => HashRef,
#	lazy => 1,
#	builder => 1,
#	predicate => 1,
);

sub _build_config {
	return {};
}


has 'user' => (
	is => 'rwp',
	predicate => 1,
	coerce => sub {
		return IMG::Model::Contact->new( @_ );
	},
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
