#!/usr/bin/env perl

my @dir_arr;
my $dir;
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
use File::stat;
use_ok('IMG::Util::File');
my $msg;

my $data = [{

		file_slurp =>
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

	file_slurp => sub {
		return IMG::Util::File::file_slurp( @_ );
	},
	file_to_array => sub {
		return IMG::Util::File::file_to_array( @_ );
	},
	file_to_aoa => sub {
		return IMG::Util::File::file_to_aoa( @_ );
	},
	file_to_hash => sub {
		return IMG::Util::File::file_to_hash( @_ );
	},
	fh_slurp => sub {
		return IMG::Util::File::fh_slurp( @_ );
	},
	fh_to_array => sub {
		return IMG::Util::File::fh_to_array( @_ );
	},
	fh_to_aoa => sub {
		return IMG::Util::File::fh_to_aoa( @_ );
	},
	fh_to_hash => sub {
		return IMG::Util::File::fh_to_hash( @_ );
	},
};


subtest 'File reading' => sub {

	subtest 'error states' => sub {
		$msg = err({
			err => 'missing',
			subject => 'fread_sub'
		});
		throws_ok {
			IMG::Util::File::_parse({ file => 'blob' });
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'input file',
		});
		throws_ok {
			IMG::Util::File::_parse({ fread_sub => 'file_to_hash' });
		} qr[$msg];

		# invalid subroutine
		my ($fh, $fname) = tempfile();
		$msg = err({ err => 'invalid', subject => 'blob', type => 'fread_sub' });
		throws_ok {
			IMG::Util::File::_parse({ file => $fname, fread_sub => 'blob' });
		} qr[$msg], 'Invalid subroutine';

		throws_ok {
			IMG::Util::File::_parse({ fh => $fh, fread_sub => 'blob' });
		} qr[$msg], 'Invalid subroutine';


	};

	subtest 'valid' => sub {

		for my $d (@$data) {

			my ($fh, $fname) = tempfile();
			print { $fh } $d->{file_slurp};
			close $fh;

			ok( -e $fname && -s $fname, 'File exists and has non-zero size' );

			for my $s ( qw( slurp to_array to_aoa to_hash ) ) {
				# parse the file
				is_deeply(
					$dispatch_h->{'file_'.$s}->( $fname ),
					$d->{'file_'.$s},
					"Checking file_$s"
				);

				open ( my $temp_fh, '<', $fname ) or die 'could not open ' . $fname  . ': ' . $!;
				# do the fh form
				is_deeply(
					$dispatch_h->{'fh_'.$s}->( $temp_fh ),
					$d->{'file_'.$s},
					"Checking fh_$s"
				) or diag explain $dispatch_h->{'fh_'.$s}->( $temp_fh );


				if ( $s eq 'to_aoa' || $s eq 'to_hash' ) {
					# try different separators
					is_deeply(
						$dispatch_h->{'file_'. $s}->($fname, 'href'),
						$d->{'file_'. $s . '_href'},
						"checking with text string as separator"
					);

					# try different separators
					is_deeply(
						$dispatch_h->{'fh_'. $s}->($temp_fh, 'href'),
						$d->{'file_'. $s . '_href'},
						"checking with text string as separator"
					) or diag explain $dispatch_h->{'fh_'. $s}->($temp_fh, 'href');
				}
			}
		}
	};
};
# readable, writable, directory tests

subtest 'readable, writable, etc.' => sub {
	for my $f ( qw( file_exists is_readable is_writable is_dir is_rw ) ) {
		# cheat by calling in OO manner
		my $to_do = \&{ 'IMG::Util::File::' . $f };

		throws_ok { $to_do->( undef ) } qr[No file or directory specified];

		if ( 'file_exists' eq $f ) {
			is( undef, $to_do->( 'A file I made up earlier' ), 'test: ' . $f );
		}
		else {
			my $msg = err({
				err => 'not_found',
				subject => 'A file I made up earlier'
			});

			throws_ok { $to_do->( 'A file I made up earlier' ) } qr[$msg], "test: $f";
		}
	}
};

subtest 'directory checks' => sub {

	my $d = File::Temp->newdir();

	ok( 1 == IMG::Util::File::is_dir( $d ), 'is directory' );
	chmod 0400, $d;
	ok( 1 == IMG::Util::File::is_readable( $d ), 'chmod 400: still readable' );
	is( '', IMG::Util::File::is_rw( $d ), 'not rw' );
	is( '', IMG::Util::File::is_writable( $d ), 'not writable' );
	chmod 0200, $d;
	is( '', IMG::Util::File::is_rw( $d ), 'chmod 200: not rw' );
	ok( 1 == IMG::Util::File::is_writable( $d ), 'writable' );
	is( '', IMG::Util::File::is_readable( $d ), 'not readable' );
	chmod 0755, $d;
	ok( 1 == IMG::Util::File::is_rw( $d ), 'dir is rw' );

};

subtest 'file checks' => sub {

	my $d = tempfile();

	is( '', IMG::Util::File::is_dir( $d ), 'not a directory' );
	chmod 0400, $d;
	ok( 1 == IMG::Util::File::is_readable( $d ), 'chmod 400: still readable' );
	is( '', IMG::Util::File::is_rw( $d ), 'not rw' );
	is( '', IMG::Util::File::is_writable( $d ), 'not writable' );
	chmod 0200, $d;
	is( '', IMG::Util::File::is_rw( $d ), 'chmod 200: not rw' );
	ok( 1 == IMG::Util::File::is_writable( $d ), 'writable' );
	is( '', IMG::Util::File::is_readable( $d ), 'not readable' );
	chmod 0755, $d;
	ok( 1 == IMG::Util::File::is_rw( $d ), 'dir is rw' );

};

# file touching
subtest 'file touching' => sub {

	subtest 'error states' => sub {
		$msg = err({
			err => 'missing',
			subject => 'file'
		});
		throws_ok {
			IMG::Util::File::file_touch()
		} qr[$msg];

		$msg = err({
			err => 'not_found',
			subject => 'A made up file'
		});
		throws_ok {
			IMG::Util::File::file_touch('A made up file')
		} qr[$msg];
	};

	subtest 'valid' => sub {
		my ($fh, $fn) = tempfile();
		my $t = time;
		lives_ok { IMG::Util::File::file_touch( $fn ) } 'Touching an extant file';
		lives_ok { IMG::Util::File::file_touch( $fh ) } 'Using a filehandle instead';
		my $sb = stat( $fn );
		ok( $sb->mtime == $sb->atime, 'Checking a and m times' );
		ok( ( $sb->mtime - $t ) < 2, 'Making sure the time diff is small' );
		say 'mtime: ' . $sb->mtime . '; time: ' . $t;
	};
};

subtest 'write csv' => sub {

	my ($fh, $fn) = tempfile( UNLINK => 1 );
	subtest 'error states' => sub {
		# no output file specified
		$msg = err({
			err => 'missing',
			subject => 'output file'
		});
		throws_ok {
			IMG::Util::File::write_csv()
		} qr[$msg];

		my $f = test_ro_file();
		# output file not writable
		$msg = err({
			err => 'not_writable',
			subject => $f,
		});
		throws_ok {
			IMG::Util::File::write_csv({ file => $f });
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'data_arr'
		});
		throws_ok {
			IMG::Util::File::write_csv({ file => $fn, cols => [] });
		} qr[$msg];

		$msg = err({
			err => 'missing',
			subject => 'cols'
		});
		throws_ok {
			IMG::Util::File::write_csv({ file => $fn, data_arr => [] });
		} qr[$msg];

		$msg = err({
			err => 'format_err',
			subject => 'cols',
			fmt => 'an arrayref'
		});
		throws_ok {
			IMG::Util::File::write_csv({ file => $fn, data_arr => [], cols => 1 });
		} qr[$msg];

		$msg = err({
			err => 'format_err',
			subject => 'data_arr',
			fmt => 'an arrayref'
		});
		throws_ok {
			IMG::Util::File::write_csv({ file => $fn, data_arr => {}, cols => [] });
		} qr[$msg];
	};

	subtest 'valid' => sub {

		lives_ok {
			IMG::Util::File::write_csv({
				file => $fn,
				cols => [ qw( number letter ) ],
				data_arr => []
			});
		};

		my $str = IMG::Util::File::file_slurp( $fn );
		ok( $str =~ /^number\tletter\s*$/, 'checking file writing was OK' );

		# new files
		($fh, $fn) = tempfile( UNLINK => 1 );
		lives_ok {
			IMG::Util::File::write_csv({
				fh => $fh,
				cols => [ qw( number letter ) ],
				data_arr => [
					{ number => '001', letter => 'a' },
					{ qw( number 002 letter b ) },
					{ number => '003', letter => 'c' }
				]
			});
		};
		$str = IMG::Util::File::file_slurp( $fn );
		say $str;
		ok( $str =~ /^number\tletter\s+001\ta\s+002\tb\s+003\tc\s*$/, 'checking file writing was OK' );

	};
};


subtest 'get dir contents' => sub {

	my ($fh, $fn) = tempfile( UNLINK => 1 );
	my $tempdir = File::Temp->newdir();
	subtest 'error states' => sub {
		$msg = err({
			err => 'missing', subject => 'dir'
		});
		throws_ok {
			IMG::Util::File::get_dir_contents();
		} qr[$msg];

		throws_ok {
			IMG::Util::File::get_dir_contents({ tip => 'top' });
		} qr[$msg];

		$msg = err({
			err => 'not_found',
			subject => 'i/made/this/up',
		});
		throws_ok {
			IMG::Util::File::get_dir_contents({ dir => 'i/made/this/up' });
		} qr[$msg];

		$msg = err({
			err => 'format_err',
			subject => $fn,
			fmt => 'a directory'
		});
		throws_ok {
			IMG::Util::File::get_dir_contents({ dir => $fn });
		} qr[$msg];

		$msg = err({
			err => 'not_readable',
			subject => $tempdir,
		});
		chmod 0200, $tempdir;
		throws_ok {
			IMG::Util::File::get_dir_contents({ dir => $tempdir });
		} qr[$msg];
	};

	subtest 'valid' => sub {

		$tempdir = File::Temp->newdir();
		my $files = IMG::Util::File::get_dir_contents({ dir => $tempdir });
		is_deeply( [ '.', '..' ], $files, 'checking we have no files' );

		my @fns = qw( . .. );
		for ( 0 .. 5 ) {
			($fh, $fn) = tempfile( 'tempfileXXXX', DIR => $tempdir);
			$fn =~ s!$tempdir\/!!;
			push @fns, $fn;
		}
		my @files = @{IMG::Util::File::get_dir_contents({ dir => $tempdir })};

		is_deeply(
			[ sort @fns ],
			[ sort @files ],
			'checking populated dir'
		) or diag explain
			[ sort @fns ],
			[ sort @files ];

		# add in a filter
		@files = @{ IMG::Util::File::get_dir_contents({
			dir => $tempdir,
			filter => sub { -f "$tempdir/$_" }
		}) };
		@fns = grep { $_ !~ /^\./ } @fns;

		is_deeply(
			[ sort @fns ],
			[ sort @files ],
			'checking populated dir'
		) or diag explain
			[ sort @fns ],
			[ sort @files ];

	};
};


done_testing();
