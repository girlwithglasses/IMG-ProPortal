#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../";
use IMG::Util::Import 'Test';

use_ok( 'XMLProxy', 'Use OK!' );

done_testing();
