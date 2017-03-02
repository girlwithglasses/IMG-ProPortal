package IMG::Util::Factory;

use IMG::Util::Import;
use IMG::App::Role::ErrorMessages qw( :all );
use Module::Runtime;

sub create {
	my $class = shift;

#	my ( $ok, $error ) = try_load_class($class);

	eval { Module::Runtime::use_module( $class ); 1 } or die err({
		err => 'module_load',
		subject => $class,
		msg => $@
	});

	return $class->new( @_ );
}

sub load_module {

	my $module = shift;

	eval { Module::Runtime::use_module( $module ); 1 } or die err({
		err => 'module_load',
		subject => $module,
		msg => $@
	});
	return;

}

sub require_module {

	my $module = shift;

	eval { Module::Runtime::require_module( $module ); 1 } or die err({
		err => 'module_load',
		subject => $module,
		msg => $@
	});
	return;

}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::Factory - Instantiate components by name and args

=head1 VERSION

version 0.160003

=head1 AUTHOR

Based on Dancer2::Core::Factory by Dancer Core Developers

Minor modifications by AIreland.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head3 create

	my $obj = IMG::Factory->create( $class, %options );

@param $class   -- fully-specified class name (e.g. ProPortal::Controller::Base)
@param %options -- for constructor

@return $class->new(%options);

=cut
