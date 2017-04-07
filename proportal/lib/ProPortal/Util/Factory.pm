package ProPortal::Util::Factory;

use IMG::Util::Import 'LogErr';
use String::CamelCase qw(camelize);
use IMG::Util::Factory;

# adding a controller to

sub create_pp_component {

	return IMG::Util::Factory::create( _rename( shift, shift ), @_ );

}


sub load_module {

	return IMG::Util::Factory::load_module( _rename( @_ ) );

}

sub _rename {

	my $type = shift;
	my $name = shift;

	err({
		err => 'missing',
		subject => 'type and name parameters'
	}) unless $type && $name;

	if ( $name =~ /::/ ) {
		$name = join '::', map { camelize( $_ ) } split '::', $name;
	}

	$type = camelize($type);
	$name = camelize($name);
	return "ProPortal::${type}::${name}";

}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

ProPortal::Core::Factory - Instantiate components by type and name

=head1 VERSION

version 0.160003

=head1 AUTHOR

Dancer Core Developers

Minor modifications by AIreland.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Alexis Sukrieh.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head3 create

	my $obj = ProPortal::Factory->create( $type, $name, %options );

@param $class
@param $type
@param $name
@param %options

@return ProPortal::$type::$name->new(%options);

Uses IMG::Util::Factory on the backend; for basic instantiation of classes not in the ProPortal namespace, see that module.

=cut
