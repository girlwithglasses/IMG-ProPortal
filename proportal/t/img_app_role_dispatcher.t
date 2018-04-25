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

use IMG::App::Role::Dispatcher;
use CGI;

use Test::Taint;





sub parse_params {
	my $self = shift;
	my $req = shift;

	coerce_section( $req );



}



my $VAR1 = bless( {
  _body_params => {},
  _chunk_size => 4096,
  _http_body => bless( {
    body => undef,
    buffer => "",
    chunk_buffer => "",
    chunked => 1,
    cleanup => 1,
    content_length => -1,
    content_type => "",
    length => 0,
    param => {},
    param_order => [],
    part_data => {},
    state => "buffering",
    tmpdir => "/var/folders/dx/_rvxq0y113vcyj9x8rpxbf4m0000gq/T",
    upload => {}
  }, 'HTTP::Body::OctetStream' ),
  _params => {
    page => "preferences",
    section => "MyIMG",
    splat => [
      [
        "i"
      ]
    ]
  },
  _query_params => {
    page => "preferences",
    section => "MyIMG"
  },
  _read_position => 0,
  _route_params => {
    splat => []
  },
  body => "",
  body_parameters => bless( {}, 'Hash::MultiValue' ),
  data => undef,
  env => {
    HTTP_ACCEPT => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    HTTP_ACCEPT_ENCODING => "gzip, deflate",
    HTTP_ACCEPT_LANGUAGE => "en-gb",
    HTTP_CACHE_CONTROL => "max-age=0",
    HTTP_COOKIE => "plack_debug_panel=hide",
    HTTP_DNT => 1,
    HTTP_HOST => "localhost:5000",
    HTTP_REFERER => "http://img-proportal.test/proportal/data_type/pp_subset=all_proportal",
    HTTP_UPGRADE_INSECURE_REQUESTS => 1,
    HTTP_USER_AGENT => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/602.4.8 (KHTML, like Gecko) Version/10.0.3 Safari/602.4.8",
    HTTP_X_FORWARDED_FOR => "127.0.0.1",
    HTTP_X_FORWARDED_HOST => "img-proportal.test",
    HTTP_X_FORWARDED_SERVER => "img-proportal.test",
    PATH_INFO => "/cgi-bin/main.cgi",
    QUERY_STRING => "page=preferences&section=MyIMG",
    REMOTE_ADDR => "127.0.0.1",
    REMOTE_HOST => "127.0.0.1",
    REMOTE_PORT => 49921,
    REQUEST_METHOD => "GET",
    REQUEST_URI => "/cgi-bin/main.cgi?page=preferences&section=MyIMG",
    SCRIPT_NAME => "",
    SERVER_NAME => "127.0.0.1",
    SERVER_PORT => 5000,
    SERVER_PROTOCOL => "HTTP/1.1",
    "plack.debug.panels" => [],
    "plack.request.body" => bless( {}, 'Hash::MultiValue' ),
    "plack.request.body_parameters" => [],
    "plack.request.upload" => bless( {}, 'Hash::MultiValue' ),
    "psgi.errors" => *::STDERR,
#    "psgi.input" => \*{"Starman::Server::\$io"},
    "psgi.multiprocess" => 1,
    "psgi.multithread" => "",
    "psgi.nonblocking" => "",
    "psgi.run_once" => "",
    "psgi.streaming" => 1,
    "psgi.url_scheme" => "http",
    "psgi.version" => [
      1,
      1
    ],
    "psgix.harakiri" => 1,
    "psgix.input.buffered" => 1,
    "psgix.io" => bless( \*Symbol::GEN159, 'Net::Server::Proto::TCP' )
  },
  id => 1,
  is_behind_proxy => "",
  route_parameters => bless( {}, 'Hash::MultiValue' ),
  uploads => {},
  vars => {}
}, 'Dancer2::Core::Request' );
$VAR1->{_route_params}{splat} = $VAR1->{_params}{splat};
*Symbol::GEN159 = {
  NS_port => 5000,
  io_socket_domain => 2,
  io_socket_peername => "\20\2\303\1\177\0\0\1\0\0\0\0\0\0\0\0",
  io_socket_proto => 6,
  io_socket_timeout => undef,
  io_socket_type => 1
};

my $obj = $VAR1;

say 'obj: ' . Dumper $obj;

ok( $obj->param('page') eq 'preferences', 'Page param');
ok( $obj->param('section') eq 'MyIMG', 'MyIMG' );

subtest 'parse params' => sub {




};

subtest 'coerce section' => sub {

	my $url_h = {



	};
# _section_MyIMG_setPreferences
# _noHeader||downloadTaxonFnaFile||section||taxon_oid	1
# _section_AllPwayBrowser_searchAllPathways||cmpd_type||compound_filter||pway_type||searchCmpdKey||searchEc1||searchEc2||searchEc3||searchEc4||searchKey	1
# _section_Artemis_processArtemisFile||format||scaffold_oid	2
# _section_ClustalW_runClustalW||alignGenes||align_down_stream||align_up_stream||alignment||



};



=cut

For each of a set of URL params, compare the module and sub run and the other changes made by main.pl vs Dispatcher.pm





my $cgi = CGI->new();

$cgi->param('section', 'StudyViewer');

IMG::App::Role::Dispatcher::dispatch_page({ env => {}, cgi => $cgi, session => {} });

$cgi->param('section', 'GenomeListJSON');

IMG::App::Role::Dispatcher::dispatch_page({ env => {}, cgi => $cgi, session => {} });

=cut

done_testing();
