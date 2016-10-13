#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}
use lib @dir_arr;
use IMG::Util::Base 'Test';

use IMG::App::Role::Dispatcher;
use CGI;

use Test::Taint;

ok( 1, 'this passes' );

TODO : {

local $TODO = 'IMG::App::Role::Dispatcher not yet implemented';

=cut

For each of a set of URL params, compare the module and sub run and the other changes made by main.pl vs Dispatcher.pm





my $cgi = CGI->new();

$cgi->param('section', 'StudyViewer');

IMG::App::Role::Dispatcher::dispatch_page({ env => {}, cgi => $cgi, session => {} });

$cgi->param('section', 'GenomeListJSON');

IMG::App::Role::Dispatcher::dispatch_page({ env => {}, cgi => $cgi, session => {} });

=cut
}

done_testing();
