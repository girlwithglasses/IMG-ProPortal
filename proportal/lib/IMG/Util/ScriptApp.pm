package IMG::Util::ScriptApp;

use IMG::Util::Import 'MooRole';
use ScriptAppArgs;

has 'args' => (
	is => 'rw',
	isa => InstanceOf['ScriptAppArgs'],
	required => 1,
	coerce => sub {
		return ScriptAppArgs->new( +shift );
	},
);

1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::ScriptApp

This module provides a simple wrapper for script-based applications. It should be used to create a custom class by creating a 'ScriptAppArgs' object with the appropriate properties.

{	package ScriptAppArgs;
	use IMG::Util::Import 'Class';

	has 'switch' => (
		is => 'ro',
		isa => Bool
	);
	has 'volume' => (
		is => 'ro',
		isa => Int,
		default => 10
	);
}

{
	package TestApp;
	use IMG::Util::Import 'Class';
	use ScriptAppArgs;
	extends 'IMG::Util::ScriptApp';
}

use TestApp;

my $app = TestApp->new( args => { switch => 0, volume => 5 } );

say $app->args->volume;  # prints '5'

=cut

