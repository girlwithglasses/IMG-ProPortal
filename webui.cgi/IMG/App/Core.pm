############################################################################
#	IMG::App::Core.pm
#
#	Core attributes, etc.
#
#	$Id: Core.pm 36795 2017-03-22 19:30:58Z aireland $
############################################################################
package IMG::App::Core;

use IMG::Util::Import 'Class';
use IMG::Model::Contact;
use Time::HiRes;


has 'id' => (
	is => 'ro',
	builder => 1
);

sub _build_id {
	return Time::HiRes::gettimeofday;
}

has 'config' => (
	is => 'lazy',
	isa => HashRef,
);

sub _build_config {
	return {};
}

has 'user' => (
	is => 'rwp',
	predicate => 1,
	clearer => 1,
	coerce => sub {
		return IMG::Model::Contact->new( @_ );
	},
);

1;
