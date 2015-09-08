#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib ( "$Bin/..", "$Bin/../../proportal/lib", "$Bin/lib" );
use IMG::Util::Base 'Test';
use File::Temp qw/tempfile tempdir/;

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




done_testing();
