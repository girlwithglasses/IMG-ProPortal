#!/usr/bin/env perl

=head2 generate_static_pages.pl

Generate the 404 and 500 error pages; adds the files to public/ as 404.html and 500.html

usage:

	perl render_static_pages.pl

=cut

use strict;
use warnings;
use feature ':5.10';
use local::lib;

use Data::Dumper;
use Template;
use FindBin qw/ $Bin /;
use File::Basename;

my $base = dirname( $Bin );

say "base dir: $base";

my $tt = Template->new({
    INCLUDE_PATH => "$base/views:$base/views/pages:$base/views/layouts:$base/views/inc",
    OUTPUT_PATH  => "$base/public/",
}) || die "$Template::ERROR\n";

my @errors = qw( 404 500 );

for ( @errors ) {

	$tt->process( $_ . '.tt', { error => $_ }, $_ .'.html' )
		|| die $tt->error() . "\n";

}

say "Work complete!";