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
use FindBin qw/ $Bin /;
use IMG::Util::Import 'Test';

use File::Temp;
use JSONProxy;
use WebUtil qw();
use Sub::Override;
use Test::MockModule;

use_ok( 'JSONProxy', 'Use OK' );

# fake
# getEnv()
# WebUtil::getSessionDir
# WebUtil::webError
# param

use Test::MockModule;

my $ok_config = { cgi_tmp_dir => make_ok_tempdir() };

throws_ok { JSONProxy::run() } qr[No parameters specified];

throws_ok { JSONProxy::run( param => {}, conf => undef ) } qr[Incorrect parameters passed to JSONProxy];

throws_ok { JSONProxy::run( params => {}, config => {} ) } qr[JSONProxy cannot retrieve data: no file name supplied in query params];

throws_ok { JSONProxy::run( params => { sid => undef }, config => {} ) } qr[JSONProxy cannot retrieve data: no file name supplied in query params];

throws_ok { JSONProxy::run( params => { sid => '' }, config => {} ) } qr[JSONProxy cannot retrieve data: no file name supplied in query params];

# fake WebUtil::getSessionDir()
# create a directory that cannot be written to
#my $mock = Test::MockModule('WebUtil');
#$mock->mock( 'getSessionDir' => sub { return make_unreadable_tempdir(); } );

#throws_ok { JSONProxy::run( params => { sid => 'test' }, config => {} ) } qr[Cannot create .*?];
#throws_ok { JSONProxy::run( params ) } qr[Cannot make ...];

done_testing();


=comment
config values required:

	session directory (not really required if faking WebUtil::getSessionDir)
	( but comes from $cgi_tmp_dir/$session_id )
	cgi_tmp_dir

=cut

sub make_config {




}

=comment
	sid => $arrayFile -- file to read data from
=cut

sub make_param_h {



}

# REPLACEMENT SUBS

sub make_ok_tempdir {
	my $dir = File::Temp->newdir();
	return $dir->dirname;
}

sub make_unreadable_tempdir {
	my $dir = File::Temp->newdir();
	chmod 0000, $dir or die 'Could not change directory permissions: ' . $!;
	return $dir->dirname;
}

sub make_unreadable_tempfile {
	my $file = File::Temp->new();
	chmod 0000, $file or die 'Could not create unreadable file: ' . $!;
	return $file;
}

