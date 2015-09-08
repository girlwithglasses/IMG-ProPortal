#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';
use File::Temp qw/tempfile tempdir/;
use IMG::App::Core;
my $base = $Bin;
say 'base: ' . $base;

use_ok('IMG::App::FileManager');

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with 'IMG::App::Session', 'IMG::App::FileManager';
}

{
	package FakeSession;
	use Moo;
	has id => ( is => 'ro' );
	has data => ( is => 'ro' );
	sub read {
		my $self = shift;
		my $param = shift;
		return $self->data->{$param} || undef;
	}
}

{
	package FakeUser;
	use Moo;
	has id => ( is => 'ro' );
}

subtest 'directory names' => sub {

	my $app = TestApp->new();

	throws_ok { $app->get_session_dirname() } qr[Config parameter "cgi_tmp_dir" not set];

	throws_ok { $app->get_workspace_dirname() } qr[Config parameter "workspace_dir" not set];

	throws_ok { $app->get_dirname('cart') } qr[Config parameter "cgi_tmp_dir" not set];


	my $cfg = { cgi_tmp_dir => '/tmp', workspace_dir => '/worksp/' };

	$app = TestApp->new( config => $cfg );

	throws_ok { $app->get_session_dirname() } qr[No session ID found];

	throws_ok { $app->get_workspace_dirname() } qr[User ID not found in session];

	throws_ok { $app->get_dirname('yui') } qr[No session ID found];

	$app = TestApp->new( config => $cfg, session => FakeSession->new(id => 'abcdef', data => { contact_oid => 'mr_blobby' } ) );

	ok( '/tmp/abcdef' eq $app->get_session_dirname, 'got the session directory' );

	ok( '/tmp/abcdef/cart' eq $app->get_dirname('cart'), 'got the session directory' );

	# make sure the slashes are working correctly
	ok( '/worksp/mr_blobby' eq $app->get_workspace_dirname(), 'got the workspace directory directly' );

	ok( '/worksp/mr_blobby' eq $app->get_dirname('workspace'), 'got the workspace directory' );

	# make sure capitalisation is working
	ok( '/tmp/abcdef/GenomeListJSON' eq $app->get_dirname('GENOMELISTJSON'), 'get JSON dir' );

	throws_ok { $app->get_dirname('blobby') } qr[directory 'blobby' not known];

	$app = TestApp->new( config => $cfg, session => FakeSession->new(id => 'abcdef', data => { this => 'that' } ) );

	throws_ok { $app->get_dirname('workspace') } qr[User ID not found in session];

};

subtest 'get filename' => sub {
	my $cfg = { cgi_tmp_dir => '/tmp', workspace_dir => '/worksp/' };
	my $app = TestApp->new( config => $cfg, session => FakeSession->new(id => 'abcdef', data => { contact_oid => 'mr_blobby' } ) );
	say 'get prefs filename: ' . $app->get_filename('prefs');
	is( $app->get_filename('prefs'), '/worksp/mr_blobby/mypreferences', 'Prefs file' );


	say 'get cart filename: ' . $app->get_filename('genome_cart_state');
	is( $app->get_filename('genome_cart_state'), '/tmp/abcdef/cart/genomeCart.abcdef.stor', 'Genome cart state file' );

};


subtest 'read file' => sub {

	my $app = TestApp->new(
		config => {
			cgi_tmp_dir => $base . '/files/sessions',
			workspace_dir => $base . '/files/workspace'
		},
		session => FakeSession->new( id => '93078af1a34d731e32b5365ab1ede128', data => { contact_oid => 111602 } ),
	);

	# read the user prefs file
	my $data = $app->read_file('prefs');
	is( 'No', $data->{hideGFragment}, 'Checking prefs' );
	is( undef, $data->{genePageDefaultHomologs}, 'Checking prefs' );
	is( 30, $data->{minHomologPercentIdentity}, 'Checking prefs' );

	# read a cart file
	my $g_cart = $app->read_file('genome_cart_state');
#	my $col_file = $app->read_file('genome_cart_cols');
	ok( scalar @{$g_cart} == 10, '10 spp in genome cart' );

	my $fn_cart = $app->read_file('func_cart_state');
	say Dumper $fn_cart;
	ok( 1, 'read in function cart' );

};


done_testing();
