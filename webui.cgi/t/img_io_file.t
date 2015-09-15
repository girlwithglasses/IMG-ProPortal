#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';
use File::Temp qw/tempfile tempdir/;
use File::stat;
use_ok('IMG::IO::File');

my $data = [{

		slurp =>
'my $href	= decode_json($content);
my $sid	= $href->{id};
my $user_href = $href->{user};
my $user_id	= $user_href->{id};

my ( $contact_oid, $username, $super_user, $name, $email2 ) = getContactOid( $dbh, $user_id );
my ( $ans, $login, $email, $userData_href ) = getUserInfo3( $user_id, $user_href );

',
		file_to_array => [
'my $href	= decode_json($content);',
'my $sid	= $href->{id};',
'my $user_href = $href->{user};',
'my $user_id	= $user_href->{id};',
'my ( $contact_oid, $username, $super_user, $name, $email2 ) = getContactOid( $dbh, $user_id );',
'my ( $ans, $login, $email, $userData_href ) = getUserInfo3( $user_id, $user_href );'
		],

		file_to_hash => {
'my $href	' => ' decode_json($content);',
'my $sid	' => ' $href->{id};',
'my $user_href ' => ' $href->{user};',
'my $user_id	' => ' $user_href->{id};',
'my ( $contact_oid, $username, $super_user, $name, $email2 ) ' => ' getContactOid( $dbh, $user_id );',
'my ( $ans, $login, $email, $userData_href ) ' => ' getUserInfo3( $user_id, $user_href );',
		},

		file_to_aoa => [
	['my $href','= decode_json($content);'],
	['my $sid','= $href->{id};'],
	['my $user_href = $href->{user};'],
	['my $user_id','= $user_href->{id};'],
	['my ( $contact_oid, $username, $super_user, $name, $email2 ) = getContactOid( $dbh, $user_id );'],
	['my ( $ans, $login, $email, $userData_href ) = getUserInfo3( $user_id, $user_href );' ],
		],

		file_to_hash_href => {
'my $' => '	= decode_json($content);',
'my $sid	= $' => '->{id};',
'my $user_' => ' = $href->{user};',
'my $user_id	= $user_' => '->{id};',
'my ( $contact_oid, $username, $super_user, $name, $email2 ) = getContactOid( $dbh, $user_id );' => undef,
'my ( $ans, $login, $email, $userData_' => ' ) = getUserInfo3( $user_id, $user_href );',
		},


		file_to_aoa_href => [
	['my $','	= decode_json($content);'],
	['my $sid	= $','->{id};'],
	['my $user_',' = $','->{user};'],
	['my $user_id	= $user_','->{id};'],
	['my ( $contact_oid, $username, $super_user, $name, $email2 ) = getContactOid( $dbh, $user_id );'],
	['my ( $ans, $login, $email, $userData_',' ) = getUserInfo3( $user_id, $user_',' );']
		],


}];

my $dispatch_h = {

	slurp => sub {
		return IMG::IO::File::slurp( @_ );
	},
	file_to_array => sub {
		return IMG::IO::File::file_to_array( @_ );
	},
	file_to_aoa => sub {
		return IMG::IO::File::file_to_aoa( @_ );
	},
	file_to_hash => sub {
		return IMG::IO::File::file_to_hash( @_ );
	},

};


for my $d (@$data) {

	my ($fh, $fname) = tempfile();
	print { $fh } $d->{slurp};
	close $fh;

	ok( -e $fname && -s $fname, 'File exists and has non-zero size' );

	# parse the file
	my @subs = qw( slurp file_to_array file_to_aoa file_to_hash );

	for my $s (@subs) {

		is_deeply( $d->{$s}, $dispatch_h->{$s}->( $fname ), "Checking $s" );

		if ( $s eq 'file_to_aoa' || $s eq 'file_to_hash' ) {
			# try different separators
			is_deeply( $d->{$s . '_href'}, $dispatch_h->{$s}->($fname, 'href'), "checking with text string as separator");
		}
	}

}

# readable, writable, directory tests

for my $f ( qw( file_exists is_readable is_writable is_dir is_rw ) ) {
	# cheat by calling in OO manner
	my $to_do = \&{ 'IMG::IO::File::' . $f };

	throws_ok { $to_do->( undef ) } qr[No file or directory specified];

	if ( 'file_exists' eq $f ) {
		is( 0, $to_do->('A file I made up earlier'), 'test: ' . $f );
	}
	else {
		throws_ok { $to_do->( 'A file I made up earlier' ) } qr[does not exist], "test: $f";
	}
}

subtest 'directory checks' => sub {

	my $d = tempdir();

	ok( 1 == IMG::IO::File::is_dir( $d ), 'is directory' );
	chmod 0400, $d;
	ok( 1 == IMG::IO::File::is_readable( $d ), 'chmod 400: still readable' );
	is( '', IMG::IO::File::is_rw( $d ), 'not rw' );
	is( '', IMG::IO::File::is_writable( $d ), 'not writable' );
	chmod 0200, $d;
	is( '', IMG::IO::File::is_rw( $d ), 'chmod 200: not rw' );
	ok( 1 == IMG::IO::File::is_writable( $d ), 'writable' );
	is( '', IMG::IO::File::is_readable( $d ), 'not readable' );
	chmod 0755, $d;
	ok( 1 == IMG::IO::File::is_rw( $d ), 'dir is rw' );

};

subtest 'file checks' => sub {

	my $d = tempfile();

	is( '', IMG::IO::File::is_dir( $d ), 'not a directory' );
	chmod 0400, $d;
	ok( 1 == IMG::IO::File::is_readable( $d ), 'chmod 400: still readable' );
	is( '', IMG::IO::File::is_rw( $d ), 'not rw' );
	is( '', IMG::IO::File::is_writable( $d ), 'not writable' );
	chmod 0200, $d;
	is( '', IMG::IO::File::is_rw( $d ), 'chmod 200: not rw' );
	ok( 1 == IMG::IO::File::is_writable( $d ), 'writable' );
	is( '', IMG::IO::File::is_readable( $d ), 'not readable' );
	chmod 0755, $d;
	ok( 1 == IMG::IO::File::is_rw( $d ), 'dir is rw' );

};

# file touching
subtest 'file touching' => sub {

	throws_ok { IMG::IO::File::file_touch() } qr[No file specified];
	throws_ok { IMG::IO::File::file_touch('A made up file') } qr[ does not exist];
	my ($fh, $fn) = tempfile();
	my $t = time;
	lives_ok { IMG::IO::File::file_touch( $fn ) } 'Touching an extant file';
	lives_ok { IMG::IO::File::file_touch( $fh ) } 'Using a filehandle instead';
	my $sb = stat( $fn );
	ok( $sb->mtime == $sb->atime, 'Checking a and m times' );
	ok( ( $sb->mtime - $t ) < 2, 'Making sure the time diff is small' );
	say 'mtime: ' . $sb->mtime . '; time: ' . $t;

};

done_testing();
