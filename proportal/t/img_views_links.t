#!/usr/bin/env perl

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

use_ok( 'IMG::Views::Links' );
use_ok( 'IMG::Views::ExternalLinks' );

my $cfg = {
	base_url => 'http://example.com',
	main_cgi_url => 'http://example.com/main.cgi',
	server => 'http://another-server.com/'
};

my $cfg_w_jbrowse = {
	base_url => 'http://example.com',
	main_cgi_url => 'http://example.com/main.cgi',
	server => 'http://another-server.com/',
	jbrowse => 'http://jbrowse.com'

};

{	package TestApp;
	use Moo;
	has config => ( is => 'ro' );
	with 'IMG::App::Role::LinkManager';
	1;
}

my $msg;
my $app;

subtest 'external links' => sub {
	subtest 'error states' => sub {
		$msg = err({ err => 'missing', subject => 'link target' });
		throws_ok {
			IMG::Views::ExternalLinks::get_external_link()
		} qr[$msg], 'Dies without arguments';
		throws_ok {
			IMG::Views::ExternalLinks::get_external_link( undef )
		} qr[$msg], 'Dies without arguments';

		$msg = err({ err => 'not_found',
			subject => 'link target blob'
		});
		throws_ok {
			IMG::Views::ExternalLinks::get_external_link( 'blob' )
		} qr[$msg];
	};

	subtest 'valid' => sub {

		ok( 'http://biocyc.org/META/NEW-IMAGE?object=' eq IMG::Views::ExternalLinks::get_external_link('metacyc_url'), 'MetaCyc link' );

		ok( 'http://www.genome.jp/dbget-bin/www_bget?md+12345' eq IMG::Views::ExternalLinks::get_external_link('kegg_module_url', 12345), 'KEGG module link' );

	};
};

subtest 'internal links: no config' => sub {

	$msg = err({ err => 'missing', subject => 'config' });
	throws_ok {
		IMG::Views::Links::init()
	} qr[$msg], 'No config hash supplied';

	$msg = err({
		err => 'format_err',
		subject => 'link configuration',
		fmt => 'a hashref'
	});
	throws_ok {
		IMG::Views::Links::init( 'hello world' )
	} qr[$msg], 'Incorrect format for config';

	$msg = err({
		err => 'cfg_missing',
		subject => 'link URLs'
	});
	throws_ok {
		IMG::Views::Links::get_img_link()
	} qr[$msg], 'No config hash for get_img_link';
};

subtest 'internal links' => sub {

	$app = TestApp->new( config => $cfg );

	subtest 'error states' => sub {
		ok( 1 == $app->_links_init, 'Links have been initiated!' );

		$msg = err({
			err => 'missing',
			subject => 'arguments to get_img_link'
		});
		throws_ok {
			$app->img_link()
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'link ID'
		});
		throws_ok {
			$app->img_link({})
		} qr[$msg];

		$msg = err({
			err => 'invalid',
			type => 'link ID',
			subject => 'blob'
		});
		throws_ok {
			$app->img_link({ id => 'blob' })
		} qr[$msg];
	};

	subtest 'valid' => sub {

		# static link, new style
		is( $app->img_link({ id => 'login' }), 'http://example.com/login' );

		# static link, old style
		is( $app->img_link({ id => 'TreeFile', style => 'old' }), 'http://example.com/main.cgi?domain=all&amp;page=domain&amp;section=TreeFile', 'old-style link' );
		# absolute URL
		is( $app->img_link({ id => 'er' }), 'http://localhost/er' );

		# new static
		is( $app->img_link({ id => 'TreeFile', style => 'new' }), 'http://example.com/TreeFile/domain/all', 'new-style link' );

		# proportal link
		is(
			$app->img_link({ id => 'proportal/clade' }),
			'http://example.com/proportal/clade',
			'proportal link'
		);

		# new dynamic
		is(
			$app->img_link({ id => 'jbrowse', params => { taxon_oid => 1234567 } }),
			'http://example.com/jbrowse/1234567',
			'jbrowse link with params'
		);

		# new dynamic, no params
		is(
			$app->img_link({ id => 'jbrowse' }),
			'http://example.com/jbrowse/',
			'jbrowse link no params'
		);

		# old dynamic
		is( $app->img_link({ id => 'taxon', params => { taxon_oid => 1234567 } }), 'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=1234567', 'link with params');

		# old dynamic, no params
		is( $app->img_link({ id => 'taxon' }), 'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=', 'Make sure that incomplete URLs have the incomplete bit at the end' );

	};
};

subtest 'template toolkit links' => sub {

	$app = TestApp->new({ config => $cfg });

	subtest 'error states' => sub {
		ok( 1 == $app->_links_init, 'Links have been initiated!' );

		$msg = err({
			err => 'missing',
			subject => 'link ID'
		});
		throws_ok {
			$app->img_link_tt()
		} qr[$msg];

		throws_ok {
			$app->img_link_tt({})
		} qr[$msg];

		$msg = err({
			err => 'invalid',
			type => 'link ID',
			subject => 'blob'
		});
		throws_ok {
			$app->img_link_tt({ id => 'blob' })
		} qr[$msg];
		throws_ok {
			$app->img_link_tt( 'blob' )
		} qr[$msg];
	};

	subtest 'valid' => sub {



		# old dynamic
		is( $app->img_link({ id => 'taxon', params => { taxon_oid => 1234567 } }), 'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=1234567', 'link with params');

		# old dynamic, no params
		is( $app->img_link({ id => 'taxon' }), 'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=', 'Make sure that incomplete URLs have the incomplete bit at the end' );

		# static link, new style
		is( $app->img_link_tt('login'),
			'http://example.com/login',
			'static link, new style'
		);

		# static link, old style
		is(
			$app->img_link_tt('TreeFile'),
			'http://example.com/main.cgi?domain=all&amp;page=domain&amp;section=TreeFile',
			'static link, old style'
		);

		# new static
		is( $app->img_link_tt('TreeFile', { style => 'new' }), 'http://example.com/TreeFile/domain/all', 'new-style link' );

		# absolute URL
		is(
			$app->img_link_tt('er'),
			'http://localhost/er',
			'absolute URL'
		);

		# new dynamic
		is(
			$app->img_link_tt('jbrowse', { taxon_oid => 1234567 } ),
			'http://example.com/jbrowse/1234567',
			'jbrowse link with params'
		);

		# new dynamic
		is(
			$app->img_link_tt('jbrowse'),
			'http://example.com/jbrowse/',
			'jbrowse link, no params'
		);

		# new static
		is(
			$app->img_link_tt('taxon', { taxon_oid => 1234567 }),
		'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=1234567',
			'link with params'
		);

		is(
			$app->img_link_tt('proportal/location'),
			'http://example.com/proportal/location',
			'ProPortal link'
		);

		is( $app->img_link_tt('taxon'), 'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=', 'link without params');

	};
};


done_testing();
