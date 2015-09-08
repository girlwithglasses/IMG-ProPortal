package IMG::Util::ConfigValidator;

use IMG::Util::Base 'Class';

requires 'config';

has 'schema' => (
	is => 'ro',
	isa => Map[ Str => Dict[ module => Str, db => Str ]],
);

has 'db' => (
	is => 'ro',
	isa => Map[ Str => Dict[
		database => Str,
		driver => Str,
		[user|username] => Optional[Str],
		password => Optional[Str],
		dbi_options => Optional[HashRef]
		] ],
);

has 'session' => (
	is => 'ro',
);



1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::ConfigValidator

Validate the format of a configuration hash

=cut

