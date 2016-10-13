package MyUserAgent;

use strict;
use warnings;
use feature ':5.16';
use Data::Dumper::Concise;
use Test::More;

sub new {
    my $class = shift;
    return bless {@_}, $class;
}

sub get {
    my $self = shift;
    isa_ok( $self, 'MyUserAgent' );

#	say 'self->{get}: ' . Dumper $self->{get};

    isa_ok( $self->{'get'}, 'CODE' );

    $self->{'get'} and $self->{'get'}->(@_);
}

sub head {
	my $self = shift;
	isa_ok( $self, 'MyUserAgent' );
	isa_ok( $self->{'head'}, 'CODE' );
	$self->{head} and $self->{head}->(@_);
}

1;
