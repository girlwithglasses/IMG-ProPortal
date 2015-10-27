#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib webui.cgi/t/lib );
}
use lib @dir_arr;
use FindBin qw/ $Bin /;
use IMG::Util::Base 'Test';

use IMG::App::Role::Templater;

{   package TemplateApp;
    use IMG::Util::Base 'Class';
    has 'config' => ( is => 'ro' );
    with 'IMG::App::Role::LinkManager', 'IMG::App::Role::Templater';
    1;
}


subtest 'template errors' => sub {
    my $app = TemplateApp->new();

    throws_ok { $app->render_template( undef, 'hello mum' ) } qr[No template name specified];

    throws_ok { $app->render_template( '' ) } qr[No template name specified];

    $app = TemplateApp->new( config => { tmpl_dir => 'a/completely/made/up/path' } );
    throws_ok { $app->render_template( 'ani_home.tt' ) } qr[file error - ani_home.tt: not found];

};


subtest 'template rendering' => sub {

	my $dir = $Bin;
	$dir =~ s!webUI/.*!webUI/proportal/!;

	my $args = { tmpl_dir => join ( ":", map { $dir . $_ } qw( views views/inc views/pages views/layouts ) ), pp_assets => 'http://my.site.com/' };

    my $tmpl_app = TemplateApp->new( config => $args );

    ok( $tmpl_app->can( 'render_template' ) );
    ok( $tmpl_app->can( 'ext_link' ) );
    ok( Role::Tiny::does_role( $tmpl_app, 'IMG::App::Role::LinkManager' ) );
	my $output = $tmpl_app->render_template( 'any_content.tt', { title => 'My Cool Page', content => { fee => 'fi', fo => 'fum' } } );
	ok( $output =~ m!<title>My Cool Page</title>!, 'Checking title' );
	ok( $output =~ m#'fee'\s+\=>\s+'fi'#, 'Checking content' ) or diag explain $output;
    ok( $output =~ m#<link rel="stylesheet" type="text/css" href="http://my.site.com/css/proportal.css">#, 'Checking asset settings' ) or diag explain $output;
};



done_testing();
