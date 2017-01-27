#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Import 'Test';

ok( 1, 'this passes');

TODO : {

local $TODO = 'ViewMaker not yet implemented';

#use IMG::Views::ViewMaker;


}

done_testing();
