#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'Test';

use IMG::Util::Factory;
use ProPortal::Util::Factory;

my $c = IMG::Util::Factory::create( 'IMG::Util::Base' );
isa_ok $c, 'IMG::Util::Base';

my $l = ProPortal::Util::Factory::create_pp_component( 'model', 'filter', { id => 'test', type => 'slider', label => 'test filter' });
isa_ok $l, 'ProPortal::Model::Filter';
ok( $l->type eq 'slider' && $l->label eq 'test filter', "checking component values" );

like(
	exception { my $x = IMG::Util::Factory::create('A::Made::Up::Class', { args => 'here' } ); },
	qr{Unable to load class A::Made::Up::Class:},
	'Failure to create nonsense class'
);

like(
    exception { my $l = ProPortal::Util::Factory::create_pp_component( unknown => 'stuff' ) },
    qr{Unable to load class ProPortal::Unknown::Stuff:},
    'Failure to load nonexistent class',
);

done_testing;
