my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Base 'Test';
use Dancer2;
use Text::CSV_XS qw[ csv ];
use IMG::App::Core;
my $base = catdir( $dir, 'proportal/t/' );
say 'base: ' . $base;

use_ok('IMG::App::Role::FileManager');

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App::Core';
	with qw[
		IMG::App::Role::Session
		IMG::App::Role::FileManager
		IMG::App::Role::ErrorMessages
	];
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

my $msg;
my $app;
my $cfg = { cgi_tmp_dir => '/tmp', workspace_dir => '/worksp/' };

subtest 'directory names' => sub {

	$app = TestApp->new();

	subtest 'error states' => sub {

		$msg = err({ err => 'cfg_missing', subject => '"cgi_tmp_dir" configuration parameter' });
		throws_ok {
			$app->get_session_dirname()
		} qr[$msg];

		throws_ok {
			$app->get_dirname('cart')
		} qr[$msg];

		$msg = err({
			err => 'cfg_missing',
			subject => '"workspace_dir" configuration parameter'
		});

		throws_ok {
			$app->get_workspace_dirname();
		} qr[$msg];


		$app = TestApp->new( config => $cfg );

		$msg = err({
			err => 'missing',
			subject => 'sess_id'
		});
		throws_ok {
			$app->get_session_dirname()
		} qr[$msg];
		throws_ok {
			$app->get_dirname('yui')
		} qr[$msg];


		$msg = err({
			err => 'missing',
			subject => 'contact_oid'
		});
		throws_ok {
			$app->get_workspace_dirname()
		} qr[$msg];

		$app = TestApp->new( config => $cfg, session => FakeSession->new(id => 'abcdef', data => { contact_oid => 'mr_blobby' } ) );
		$msg = err({
			err => 'invalid',
			type => 'directory',
			subject => 'blobby'
		});
		throws_ok {
			$app->get_dirname('blobby')
		} qr[$msg];

		$app = TestApp->new( config => $cfg, session => FakeSession->new(id => 'abcdef', data => { this => 'that' } ) );
		$msg = err({
			err => 'missing',
			subject => 'contact_oid'
		});
		throws_ok {
			$app->get_dirname('workspace')
		} qr[$msg];


	};

	subtest 'valid' => sub {

		$app = TestApp->new( config => $cfg, session => FakeSession->new(id => 'abcdef', data => { contact_oid => 'mr_blobby' } ) );

		ok( '/tmp/abcdef' eq $app->get_session_dirname, 'got the session directory' );

		ok( '/tmp/abcdef/cart' eq $app->get_dirname('cart'), 'got the session directory' );

		# make sure the slashes are working correctly
		ok( '/worksp/mr_blobby' eq $app->get_workspace_dirname(), 'got the workspace directory directly' );

		ok( '/worksp/mr_blobby' eq $app->get_dirname('workspace'), 'got the workspace directory' );

		# make sure capitalisation is working
		ok( '/tmp/abcdef/GenomeListJSON' eq $app->get_dirname('GENOMELISTJSON'), 'get JSON dir' );

	};
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
			cgi_tmp_dir => catdir( $base, 'files/sessions' ),
			workspace_dir => catdir( $base, 'files/workspace' )
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

	#
	$app = TestApp->new(
		config => {
			cgi_tmp_dir => catdir( $base, 'files/sessions' ),
			workspace_dir => catdir( $base, 'files/workspace' )
		},
		session => FakeSession->new( id => '1a8ad3512d8d8d47073afb7d8a964ccb', data => { contact_oid => 111602 } ),
	);

	# get all the carts and their contents
	for my $c ( qw( gene func scaf genome ) ) {
		my $cart = $app->read_file( $c . "_cart_state" );
		if ('func' eq $c) {
			say "$c count: " . scalar keys %{$cart->{recs}};
		}
		else {
			say "$c count: " . scalar @$cart;
		}
	}

	# read the gene cart col IDs
	my $in = $app->read_file( 'gene_cart_col_ids' );
	say 'col ids: ' . Dumper $in;
	my $genes = $app->read_file( 'gene_cart_state' );
	# combine the two
	my @arr;
	for my $g ( @$genes ) {
		my %temp;
		@temp{ @$in } = @$g;
		push @arr, \%temp;
	}

	my $tsv = csv( in => catfile( $base, 'files/gene_cart.tsv' ), headers => 'auto', sep => "\t" );
	is_deeply( $tsv, \@arr, 'checking the concatted files' );

};


subtest 'file locations' => sub {

	subtest 'error states' => sub {

		$app = TestApp->new();
		$msg = err({
			err => 'cfg_missing',
			subject => '"web_data_dir" config parameter'
		});
		throws_ok {
			$app->get_taxon_file
		} qr[$msg];

		$app = TestApp->new( config => { web_data_dir => catdir( $base, 't/img_web_data' ) } );

		$msg = err({
			err => 'missing',
			subject => 'file type',
		});
		throws_ok {
			$app->get_taxon_file();
		} qr[$msg];

		$msg = err({
			err => 'invalid',
			subject => 'blob',
			type => 'file type',
		});
		throws_ok {
			$app->get_taxon_file({ type => 'blob' });
		} qr[$msg];

	};

	subtest 'valid' => sub {
		is_deeply(
			catfile( $base, 't/img_web_data/tab.files/pfam/12345.pfam.tab.txt' ),
			$app->get_taxon_file({ type => 'pfam', taxon_oid => 12345 }),
			'checking file locations'
		);

		is_deeply(
			catfile( $base, 't/img_web_data/taxon.faa/666.faa' ),
			$app->get_taxon_file({ type => 'aa_seq', taxon_oid => '666' }),
			'checking file locations'
		);

		is_deeply(
			catfile( $base, 't/img_web_data/taxon.faa/666.faa' ),
			$app->get_taxon_file({ type => 'faa', taxon_oid => '666' }),
			'checking file locations'
		);
	};
};

done_testing();
