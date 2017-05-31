#!/usr/bin/env perl

my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir catfile );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Import 'Test';

use File::Basename;
use Config::Any;
use IMG::Util::DB;
use IMG::Util::File;
use JSON;

my $data = {

	h1 => {
		ora_host => 'foo',
		ora_port => 1234,
		ora_sid  => 'bar'
	},
	str1 => 'dbi:Oracle:host=foo;port=1234;sid=bar',
	r1 => {
		dsn => 'dbi:Oracle:host=foo;port=1234;sid=bar',
#		options => { RaiseError => 1 }
	},

	h2 => {
		ora_sid => 'blob'
	},
	str2 => 'dbi:Oracle:sid=blob',

	h3 => {
		ora_dbi_dsn => 'blob'
	},
	str3 => 'dbi:Oracle:blob',
	r3 => {
		dsn => 'dbi:Oracle:blob',
#		options => { RaiseError => 1, FetchHashKeyName => 'NAME_lc' },
	},

	h4 => {
		dsn => 'blob'
	},

	h5 => {
		ora_dbi_dsn => 'dbi:Oracle:dbname',
		ora_user => 'Mr. Blobby',
		ora_password => 'secret',
	},

	r5 => {
		dsn => 'dbi:Oracle:dbname',
		username => 'Mr. Blobby',
		password => 'secret',
#		options => { RaiseError => 1, FetchHashKeyName => 'NAME_lc' },
	},

	img_gold_file => catfile(
				$dir,
				"proportal/t/files/test_oracle_config",
				"web.imgsg_dev.config" ),
	img_core_file => catfile(
				$dir,
				"proportal/t/files/test_oracle_config",
				"web.img_core_v400.config" ),

};

my $more_data = {
	img_core => {
		dirty => {
			database => 'img_core',
			file => $data->{img_core_file},
			ora_password => "encoded:aW1nQ29yZUMwc00wczE=",
			ora_user => "img_core_v400",
			ora_service => 'gemini1_shared'
		},
		clean => {
#			database => 'img_core',
#			file => $data->{img_core_file},
			"password" => "imgCoreC0sM0s1",
			"dsn" => "dbi:Oracle:gemini1_shared",
			"username" => "img_core_v400"
		}
	},

	img_gold => {
		dirty => {
			database => "img_gold",
			file => $data->{img_gold_file},
			ora_password => "encoded:VHVlc2RheQ==",
			ora_service => "imgiprd",
			ora_user => "imgsg_dev"
		},
		clean => {
#			database => "img_gold",
#			file => $data->{img_gold_file},
			"password" => "Tuesday",
			"dsn" => "dbi:Oracle:imgiprd",
			"username" => "imgsg_dev"
		}
	}
};

my $msg;

sub write_env_file {

	my $params = shift;
	my ($fh, $fname) = tempfile();

	for my $p ( keys %$params ) {
		print { $fh } sprintf '$ENV{ %s } = "%s";' . "\n", uc($p), $params->{$p};
	}
	return $fname;
}


subtest 'get / set oracle_cfg_dir' => sub {

	subtest 'error states' => sub {

		$msg = err({ err => 'missing', subject => 'Oracle config directory' });
		throws_ok {
			IMG::Util::DB::set_oracle_cfg_dir()
		} qr[$msg],
		'no directory';

		throws_ok {
			IMG::Util::DB::set_oracle_cfg_dir(undef)
		} qr[$msg],
		'no directory';

		$msg = err({ err => 'not_found', subject => 'not/a/real/directory' });
		throws_ok {
			IMG::Util::DB::set_oracle_cfg_dir('not/a/real/directory')
		} qr[$msg],
		'fake dir';

		my ( $fh, $fn ) = tempfile();
		$msg = err({ err => 'invalid', subject => $fn, type => 'directory' });
		throws_ok {
			IMG::Util::DB::set_oracle_cfg_dir($fn)
		} qr[$msg],
		'file, not directory';

	};

	subtest 'valid' => sub {
		my $o_dir = catdir( $dir, 'proportal/t/files/test_oracle_config' );
		lives_ok {
			IMG::Util::DB::set_oracle_cfg_dir( $o_dir );
		};

		ok( IMG::Util::DB::get_oracle_cfg_dir( $o_dir ) eq $o_dir );
	};

};



subtest 'get_oracle_cfg_files' => sub {

	my $dir = IMG::Util::DB::get_oracle_cfg_dir;
	my $conf = IMG::Util::DB::get_oracle_cfg_files;

	ok( scalar values %$conf == scalar grep { m#$dir#i } values %$conf, 'Making sure the directory paths correctly' );

};

subtest 'make_dsn_str' => sub {

	subtest 'error states' => sub {

		$msg = err({ err => 'missing', subject => 'db_conn_params'});
		throws_ok {
			IMG::Util::DB::make_dsn_str()
		} qr[$msg],
		'testing error handling';

		$msg = err({ err => 'invalid_enum',
			subject => ".*?",
			type => 'input to make_dsn_str',
			enum => [ "a hash ref" ]
		});

		throws_ok {
			IMG::Util::DB::make_dsn_str( 'a', 'b', 'c' )
		} qr[$msg],
		'error handling';

		$msg = err({ err => 'missing', subject => 'DSN information' });
		throws_ok {
			IMG::Util::DB::make_dsn_str( $data->{h4} )
		} qr[$msg],
		'No DSN info';
	};

	subtest 'valid' => sub {

		for my $n ( 1, 2, 3 ) {
			is( IMG::Util::DB::make_dsn_str( $data->{"h$n"} ), $data->{"str$n"}, 'Valid DSN info' );
		}
	};
};

subtest 'decode_pass' => sub {

	is( IMG::Util::DB::decode_pass( 'not_encoded:password' ),
	'not_encoded:password');

	is( IMG::Util::DB::decode_pass( 'encoded:aW1nc2dfMTczNQ==' ),
	'imgsg_1735' );

	is( undef, IMG::Util::DB::decode_pass() );

};

subtest 'clean_oracle_params' => sub {

	subtest 'error states' => sub {
		$msg = err({ err => 'missing', subject => 'db_conn_params'});
		throws_ok {
			IMG::Util::DB::clean_oracle_params
		} qr[$msg],
		'no input params';

		$msg = err({ err => 'invalid_enum',
			subject => ".*?",
			type => 'input to clean_oracle_params',
			enum => [ "a hash ref" ]
		});

		throws_ok {
			IMG::Util::DB::clean_oracle_params( 'a', 'b', 'c' )
		} qr[$msg],
		'invalid input';
	};

	subtest 'valid' => sub {
		for my $n (3, 5) {

	#		say "test input: " . Dumper $data->{"h$n"};
			is_deeply(
				IMG::Util::DB::clean_oracle_params( $data->{"h$n"} ),
				$data->{"r$n"}
			) or diag explain IMG::Util::DB::clean_oracle_params( $data->{"h$n"} );

			is_deeply(
				IMG::Util::DB::clean_oracle_params( $data->{"r$n"} ),
				$data->{"r$n"}
			) or diag explain IMG::Util::DB::clean_oracle_params( $data->{"r$n"} );
		}
	};
};

subtest '_read_oracle_connection_file' => sub {

	subtest 'error states' => sub {
		$msg = err({ err => 'missing', subject => 'db' });
		throws_ok {
			IMG::Util::DB::_read_oracle_connection_file
		} qr[$msg],
		'testing error handling';

		$msg = err({ err => 'invalid_enum',
			subject => ".*?",
			type => 'input to _read_oracle_connection_file',
			enum => [ "a hash ref with key 'file' and value '/path/to/config/file', or key 'database' and value 'img_core' or 'img_gold'" ]
		});

		throws_ok {
			IMG::Util::DB::_read_oracle_connection_file( 'a', 'b', 'c' )
		} qr[$msg], 'incorrect param format';

		throws_ok {
			IMG::Util::DB::_read_oracle_connection_file({ 'a' => 'b', 'c' => 'd' })
		} qr[$msg],
		'incorrect param format';

		$msg = err({ err => 'missing', subject => 'config file for flopsy' });
		throws_ok {
			IMG::Util::DB::_read_oracle_connection_file({ database => 'flopsy' })
		} qr[$msg],
		'no config';
	};

	subtest 'valid, from files' => sub {
		my $rslt;

		for my $db ( qw( img_core img_gold ) ) {
			$rslt = IMG::Util::DB::_read_oracle_connection_file({ database => $db });
			is_deeply(
				$more_data->{$db}{dirty},
				IMG::Util::DB::_read_oracle_connection_file({ database => $db })
			) or diag explain $rslt;
		}
	};

	subtest 'valid' => sub {
		for my $n (1, 5) {
			my $fname = write_env_file( $data->{"h$n"} );
			my $contents = IMG::Util::File::file_slurp($fname);

			my $env = IMG::Util::DB::_read_oracle_connection_file( { file => $fname } );
			is_deeply(
				$env,
				{ file => $fname, %{$data->{"h$n"}} },
			);
		}
	};

};

sub data_str {
	my $hash = shift;
	say 'hash: ' . Dumper $hash;
	return join "\n", map { $_ ." = ". $hash->{$_} } ( qw( dsn username password ) );
}

subtest 'get_oracle_connection_params' => sub {

	subtest 'error states' => sub {
		$msg = err({ err => 'missing', subject => 'database identifier' });
		throws_ok {
			IMG::Util::DB::get_oracle_connection_params
		} qr[$msg],
		'No input args'
	};

	subtest 'valid, from files' => sub {
		my $rslt;
		for my $db ( qw( img_core img_gold ) ) {
			$rslt = IMG::Util::DB::get_oracle_connection_params({ database => $db });
			is_deeply(
				$more_data->{$db}{clean},
				$rslt,
				'cleaning ' . $db . ' params'
			) or diag explain $rslt;
		}
	};

	subtest 'valid' => sub {
		for my $n (1, 3, 5) {
			my $fname = write_env_file( $data->{"h$n"} );
			my $contents = IMG::Util::File::file_slurp($fname);

			my $env = IMG::Util::DB::get_oracle_connection_params( { file => $fname } );

			is_deeply(
				$env,
				$data->{"r$n"},
				'testing h' . $n
			) or diag $env;
		}
	};

};

subtest 'write_oracle_connection_params' => sub {

	for my $n (1, 3, 5) {
		my($fh, $fname) = tempfile();

		IMG::Util::DB::write_oracle_connection_params($fname, $data->{"h$n"});
		my $contents = IMG::Util::File::file_slurp($fname);
		is_deeply(
			decode_json($contents),
			$data->{"r$n"},
			"Checking data round-tripping" );
	}

};

subtest 'read_and_write' => sub {

	for my $n (1, 5) {
		# create a config file; read it in, and use it to create a JSON conf file
		my $fname = write_env_file( $data->{"h$n"} );
		my $contents = IMG::Util::File::file_slurp($fname);
		my $cfg = { file => $fname };
		IMG::Util::DB::get_oracle_connection_params($cfg);

		my ($nfh, $nfname) = tempfile( SUFFIX => '.json' );
		IMG::Util::DB::write_oracle_connection_params($nfname, $cfg);

		# read the JSON file and check the params are correct
		my $conf = Config::Any->load_files({files => [ $nfname ], use_ext => 1, flatten_to_hash => 1 });
		#
		is_deeply( $conf->{ $nfname }, $data->{"r$n"} );
	}
};

subtest 'dbh' => sub {

    #    TODO: write tests for DBH creation!
    ok( 1 );

};

done_testing();
