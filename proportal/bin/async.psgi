#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib (
	"$Bin/../lib",
	"$Bin/../../webui.cgi"
);
use local::lib;
use IMG::Util::Import;
use File::Basename;
my $base = dirname($Bin);
my $home = $base;
$home =~ s!webUI/.*!webUI!;
use Plack::Builder;
#use Log::Contextual qw(:log);
$ENV{PLACK_URLMAP_DEBUG} = 1;
$ENV{TWIGGY_DEBUG} = 1;

use Routes::JBrowse;
my $testapp = sub {
    Routes::JBrowse->to_app;
};


builder {
#	enable "Deflater";
#	enable "Static", path => qr#^/(images|css|js)#, root => $base . "/public";
	enable "Debug";

# 	enable 'Static',
# 		path => sub { s!^/jbrowse_assets!! },
# 		root => $home . '/jbrowse';
#
# 	enable 'Static',
# 		path => sub { s!^/data_dir!! },
# 		root => '/tmp/jbrowse';

    mount "/" => $testapp->();

};
