#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';

use IMG::App::Dispatcher;
use CGI;

use Test::Taint;

ok( 1, 'this passes' );

TODO : {

local $TODO = 'IMG::App::Dispatcher not yet implemented';

=cut

For each of a set of URL params, compare the module and sub run and the other changes made by main.pl vs Dispatcher.pm





my $cgi = CGI->new();

$cgi->param('section', 'StudyViewer');

IMG::Dispatcher::dispatch_page({ env => {}, cgi => $cgi, session => {} });

$cgi->param('section', 'GenomeListJSON');

IMG::Dispatcher::dispatch_page({ env => {}, cgi => $cgi, session => {} });

=cut
}

done_testing();
