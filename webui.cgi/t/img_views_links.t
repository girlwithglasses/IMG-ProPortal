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
use IMG::Util::Base 'Test';

use_ok( 'IMG::Views::Links' );
use_ok( 'IMG::Views::ExternalLinks' );

my $cfg = { base_url => 'http://this.com', main_cgi_url => 'http://this.com/main.cgi' };

{	package TestApp;
	use Moo;
	has config => ( is => 'ro' );
	with 'IMG::App::Role::LinkManager';
	1;
}


subtest 'external links: no args' => sub {

	throws_ok { IMG::Views::ExternalLinks::get_external_link() } qr[No link target provided], 'Dies without arguments';
	throws_ok { IMG::Views::ExternalLinks::get_external_link( undef ) } qr[No link target provided], 'Dies without arguments';

	throws_ok { IMG::Views::ExternalLinks::get_external_link( 'blob' ) } qr[Link target blob not found];

};

subtest 'internal links: no config' => sub {

	throws_ok { IMG::Views::Links::init() } qr[init requires a configuration hash for URL generation], 'No config hash supplied';

	throws_ok { IMG::Views::Links::init( 'hello world' ) } qr[init requires a configuration hash for URL generation], 'Incorrect format for config';

	throws_ok { IMG::Views::Links::get_img_link() } qr[get_img_link requires a configuration hash for URL generation], 'No config hash for get_img_link';
};



subtest 'external links: working' => sub {

	ok( 'http://biocyc.org/META/NEW-IMAGE?object=' eq IMG::Views::ExternalLinks::get_external_link('metacyc_url'), 'MetaCyc link' );

	ok( 'http://www.genome.jp/dbget-bin/www_bget?md+12345' eq IMG::Views::ExternalLinks::get_external_link('kegg_module_url', 12345), 'KEGG module link' );

};

subtest 'internal links: no args' => sub {

	my $app = TestApp->new( config => $cfg );

	ok( 1 == $app->_links_init, 'Links have been initiated!' );

	throws_ok { $app->img_link() } qr[No arguments supplied to get_img_link];

	throws_ok { $app->img_link({}) } qr[Link ID not specified];

	throws_ok { $app->img_link({ id => 'blob' }) } qr[Link ID blob not found in library];

};

subtest 'internal links: working' => sub {
	my $app = TestApp->new({ config => $cfg });
	is( $app->img_link({ id => 'login' }), 'http://this.com/login' );

	is( $app->img_link({ id => 'TreeFile', style => 'old' }), 'http://this.com/main.cgi?domain=all&amp;page=domain&amp;section=TreeFile', 'old-style link' );

	$app = TestApp->new({ config => { base_url => 'http://this.com/', main_cgi_url => 'http://this.com/main.cgi' } });

	is( $app->img_link({ id => 'TreeFile', style => 'new' }), 'http://this.com/TreeFile/domain/all', 'new-style link' );

	is( $app->img_link({ id => 'taxon', params => { taxon_oid => 1234567 } }), 'http://this.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=1234567', 'link with params');

	is( $app->img_link({ id => 'taxon' }), 'http://this.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=', 'Make sure that incomplete URLs have the incomplete bit at the end' );

};

subtest 'template toolkit links working' => sub {
	my $app = TestApp->new({ config => $cfg });
	is( $app->img_link_tt('login'), 'http://this.com/login' );

	is( $app->img_link_tt('TreeFile'), 'http://this.com/main.cgi?domain=all&amp;page=domain&amp;section=TreeFile', 'old-style link' );

	$app = TestApp->new({ config => { base_url => 'http://this.com/', main_cgi_url => 'http://this.com/main.cgi' } });

	is( $app->img_link_tt('taxon', { taxon_oid => 1234567 }), 'http://this.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=1234567', 'link with params');

	is( $app->img_link_tt('proportal/location'), 'http://this.com/proportal/location', 'ProPortal link' );

	is( $app->img_link_tt('taxon'), 'http://this.com/main.cgi?page=taxonDetail&amp;section=TaxonDetail&amp;taxon_oid=', 'link without params');

};


done_testing();
