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

use ProPortal::App::ImportCart;

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
my $cfg = { cgi_tmp_dir => '/tmp', workspace_dir => '/worksp/' };
my $base = catdir( $dir, 'proportal/t/' );
my ( $fh, $fn ) = tempfile( UNLINK => 1 );

my $app = ProPortal::App::ImportCart->new(
	config => {
		cgi_tmp_dir => $base . '/files/sessions',
		workspace_dir => $base . '/files/workspace'
	},
	session => FakeSession->new( id => '1a8ad3512d8d8d47073afb7d8a964ccb', data => { contact_oid => 111602 } ),
	args => { outfile => $fn }
);


sub new_app {

	say '@_: ' . Dumper \@_;

	return ProPortal::App::ImportCart->new( config => config, @_ );
}

subtest 'instantiation' => sub {

	subtest 'error states' => sub {

#		$msg = err({
#		});
		throws_ok {
			new_app( args => {} )->run();
		} qr[mssng];

		$msg = err({
			err => 'missing',
			subject => 'session'
		});
		throws_ok {
			my $temp = new_app( args => { outfile => $fn } )->run();
			say 'temp: ' . Dumper $temp;
#			say 'session: ' . $temp->session;
			$temp->run();
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'sess_id'
		});
		throws_ok {
			new_app( session => FakeSession->new( data => 1 ), args => { outfile => $fn } )->run();
		} qr[$msg];

	};

	subtest 'valid' => sub {
		$app->run();
	};

};

done_testing();

