#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'Test';

use_ok 'ProPortal';

use_ok 'ProPortal::Controller::Base';

my $cfg = { dbi_module => 'TSV' };

my $pp = ProPortal::Controller::Base->new($cfg);

ok ($pp->has_config, "ProPortal controller has a config!");

ok (! $pp->has_valid_filters, "No filters by default");

ok( ! $pp->has_tmpl_includes, "No default tmpl includes");


done_testing();
