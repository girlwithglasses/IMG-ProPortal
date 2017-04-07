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
use IMG::Util::Import 'Test';

use Dancer2;

use_ok( 'IMG::Views::Links' );
use_ok( 'IMG::Views::ExternalLinks' );

my $cfg = {
	base_url => 'http://example.com',
	main_cgi_url => 'http://example.com/main.cgi',
	server => 'http://another-server.com/'
};

my $cfg_w_jbrowse = {
	base_url => 'http://example_w_jbrowse.com',
	main_cgi_url => 'http://example_w_jbrowse.com/main.cgi',
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

	subtest 'error states' => sub {
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
};

my $links = [
{
	args => { id => 'login' },
	url => 'http://example.com/login',
	comment => 'login'
},{
	args => { id => 'TreeFile', style => 'old' },	# static link, old style
	url => 'http://example.com/main.cgi?domain=all&amp;page=domain&amp;section=TreeFile',
	comment => 'old-style link'
},{
	args => { id => 'er' },
	url => 'http://localhost/er',
	comment => 'datamart link'
},{
	args => { id => 'proportal/clade' },
	url  => 'http://example.com/proportal/clade',
	comment => 'proportal link'
},{
	args => { id => 'details/taxon' },
	url => 'http://example.com/details/taxon',
	comment => 'details link without params'
},{
	args => { id => 'details', params => { domain => 'taxon', taxon_oid => 1234567 } },
	url =>  'http://example.com/details/taxon/1234567',
	comment => 'fully-specified details link with params'
},{
	args => { id => 'details', params => { taxon_oid => 1234567 } },
	url =>  'http://example.com/details/taxon/1234567',
	comment => 'details link with params, taxon inferred'
},{
	args => { id => 'details', params => { scaffold_oid => 7654321 } },
	url => 'http://example.com/details/scaffold/7654321',
	comment => 'scaffold details'
},{
	args => { id => 'list', params => { taxon_oid => 1234, domain => 'taxon' } },
	url => 'http://example.com/list/taxon?taxon_oid=1234',
	comment => 'taxon list'
},{
	args => { id => 'list', params => { gene_oid => 1234, domain => 'taxon', output_format => 'csv' } },
	url => 'http://example.com/csv_api/list/taxon?gene_oid=1234',
	comment => 'taxon list, output format'
},{
	args => { id => 'file', params => { taxon_oid => 1234, file_type => 'gff' } },
	url => 'http://example.com/file?file_type=gff&taxon_oid=1234',
	comment => 'file query'
},{
	args => { id => 'file', params => [ pp_subset => 'pro', pp_subset => 'syn' ] },
	url => 'http://example.com/file?pp_subset=pro&pp_subset=syn',
	comment => 'pro and syn file downloads'
}];

# 		static link, new style
# 		is( $app->img_link({ id => 'login' }), 'http://example.com/login' );
#
# 		static link, old style
# 		is( $app->img_link({ id => 'TreeFile', style => 'old' }), 'http://example.com/main.cgi?domain=all&amp;page=domain&amp;section=TreeFile', 'old-style link' );
# 		absolute URL
# 		is( $app->img_link({ id => 'er' }), 'http://localhost/er' );
#
# 		new static
# 		is( $app->img_link({ id => 'TreeFile', style => 'new' }), 'http://example.com/TreeFile/domain/all', 'new-style link' );
#
# 		proportal link
# 		is(
# 			$app->img_link({ id => 'proportal/clade' }),
# 			'http://example.com/proportal/clade',
# 			'proportal link'
# 		);
#
# 		new dynamic, taxon
# 		is( $app->img_link({ id => 'taxon', params => { taxon_oid => 1234567 } }), 'http://example.com/taxon/1234567', 'link with params');
#
# 		new dynamic, no params
# 		is( $app->img_link({ id => 'taxon' }), 'http://example.com/taxon', 'link without params' );
#

# 		# old dynamic
# 		is( $app->img_link({ id => 'taxon', params => { taxon_oid => 1234567 } }), 'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=1234567', 'link with params');
#
# 		# old dynamic, no params
# 		is( $app->img_link({ id => 'taxon' }), 'http://example.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=', 'Make sure that incomplete URLs have the incomplete bit at the end' );


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

		for my $l ( @$links ) {
			is ( $app->img_link( $l->{args} ), $l->{url}, $l->{comment} );
		}

	};
};

subtest 'jbrowse links' => sub {

	subtest 'valid' => sub {

		# with JBrowse server

		say 'starting jbrowse links';

		$app = TestApp->new;
		$msg = err({ err => 'missing', subject => 'config' });
		throws_ok {
			$app->img_link({ id => 'jbrowse' })
		} qr[$msg], 'insufficient configuration';

		$app = TestApp->new( config => $cfg_w_jbrowse );
		say 'app: ' . Dumper $app;
		is(
			$app->img_link({ id => 'details', params => { domain => 'taxon', taxon_oid => 1234567 } }),
			'http://example_w_jbrowse.com/details/taxon/1234567',
			'taxon link'
		);

		is(
			$app->img_link({ id => 'jbrowse', params => { taxon_oid => 1234567 } }),
			'http://jbrowse.com/1234567',
			'jbrowse server, link with params'
		);
		is(
			$app->img_link({ id => 'jbrowse' }),
			'http://jbrowse.com',
			'jbrowse server, link no params'
		);

		# without JBrowse server
		$app = TestApp->new( config => $cfg );
		say 'app: ' . Dumper $app;
		is(
			$app->img_link({ id => 'details/taxon', params => { taxon_oid => 1234567 } }),
			'http://example.com/details/taxon/1234567',
			'taxon link'
		);

		is(
			$app->img_link({ id => 'jbrowse', params => { taxon_oid => 1234567 } }),
			'http://example.com/jbrowse/1234567',
			'jbrowse link with params'
		);
		is(
			$app->img_link({ id => 'jbrowse' }),
			'http://example.com/jbrowse',
			'jbrowse link no params'
		);
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

		for ( @$links ) {
			my $args = $_->{args};
			is( $app->img_link_tt( $_->{args}{id}, ( $_->{args}{params} || {} ) ),
				$_->{url},
				$_->{comment}
			);
		}
	};
};


done_testing();
