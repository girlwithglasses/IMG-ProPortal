package IMG::Util::DB;

use IMG::Util::Import 'LogErr';
use MIME::Base64;
use JSON::MaybeXS;

use File::Spec::Functions;
use IMG::Util::File;
use IMG::Util::DBIxConnector;
use IO::All;

my $dir = '/webfs/projectdirs/microbial/img/img_rdbms/config/';

=head3 common

Hash containing commonly-used Oracle config files

Current contents: img_core, img_gold

=cut

my $common = {
	img_core => 'web.img_core_v400.config', # alias pointing to gemini_1 or _2
	img_core_gem1 => 'oracle.img_core_v400_gem1_shared.config',
	img_core_gem2 => 'oracle.img_core_v400_gem2_shared.config',
	img_gold => 'web.imgsg_dev.config',
	i_taxon  => 'web.img_i_taxon.config'
};

#     $e->{ oracle_config } = $e->{ oracle_config_dir } . "web.$dbTag.config";
#     $e->{ img_er_oracle_config } = $e->{ oracle_config_dir } . "web.$dbTag.config";
#     $e->{ img_gold_oracle_config } = $e->{ oracle_config_dir } . "web.imgsg_dev.config";
#     $e->{ img_i_taxon_oracle_config } = $e->{ oracle_config_dir } . "web.img_i_taxon.config";


=head3 set_oracle_cfg_dir

Set the path of the directory containing the Oracle cfg files

=cut

sub set_oracle_cfg_dir {
	my $cfg_dir = shift // die err({ err => 'missing', subject => 'Oracle config directory' });
	# dies if the dir doesn't exist
	if ( IMG::Util::File::is_dir( $cfg_dir ) ) {
		$dir = $cfg_dir;
	}
	else {
		die err({ err => 'invalid', subject => $cfg_dir, type => 'directory' });
	}
	return $dir;
}

=head3 get_oracle_cfg_dir

Return the path of the directory containing the Oracle cfg files

=cut

sub get_oracle_cfg_dir {

	return $dir;

}

=head3 get_oracle_cfg_files

Get a hash of commonly-used db config files

includes the directory path

=cut

sub get_oracle_cfg_files {

	my %file_h;
	@file_h{ keys %$common } = map { catfile( $dir, $_ ) } values %$common;

	return \%file_h;

}

=head3 get_oracle_connection_params

Parse Oracle connection params for a database. Combines getting the config
params from a file with the cleaning them up using clean_oracle_params

@param $db - hash containing the config file in the format:

	$db = {
		file => '/path/to/name.of.config.file',
	};
		OR
	$db = {
		database => 'img_core' || 'img_gold' # one of the files in common hash
	};

@return $hash with cleaned connection parameters added:

	$db = {
		dsn => 'dbi:Oracle:big_data',
		username => 'user',
		password => 'pass'
	}

=cut

sub get_oracle_connection_params {

	my $db = shift // die err({ err => 'missing', subject => 'database identifier' });

	if ( 'ARRAY' eq ref $db ) {
		for my $d ( @$db ) {
			if ( ! ref $d ) {
				$d = clean_oracle_params( _read_oracle_connection_file({ database => $d }) );
			}
			else {
				$d = clean_oracle_params( _read_oracle_connection_file( $d ) );
			}
		}
#		log_debug { 'db now: ' . Dumper $db };
		return $db;
	}
	# open the file, read the connection params, clean them up

	return clean_oracle_params( _read_oracle_connection_file( $db ) );

}

=head3 _read_oracle_connection_file

Parse Oracle connection params from files that set them in $ENV.

@param $db - hash containing the config file in the format:

	$db = {
		file => '/path/to/name.of.config.file',
	};
		OR
	$db = {
		database => 'img_core' || 'img_gold' # one of the files in common hash
	};

@return $db with parameters added:

	$db = {
		cfg => '/path/to/name.of.config.file',
		ora_dbi_dsn => 'big_data',
		ora_user => 'user',
		ora_password => 'pass'
	}

=cut

sub _read_oracle_connection_file {
	my $db = shift // die err({ err => 'missing', subject => 'db' });

	if (! ref $db || ref $db ne 'HASH' || ( ! $db->{file} && ! $db->{database} ) ) {
#		croak "_read_oracle_connection_file expects a hash ref with key 'file' and value '/path/to/config/file' or key 'database' and value 'img_core' or 'img_gold' as input";

		die err({ err => 'invalid_enum',
			subject => $db,
			type => 'input to _read_oracle_connection_file',
			enum => [ "a hash ref with key 'file' and value '/path/to/config/file', or key 'database' and value 'img_core' or 'img_gold'" ]
		});
	}


	if ($db->{database}) {
		if (! $common->{ $db->{database} }) {
			die err({ err => 'missing', subject => 'config file for ' . $db->{database} })
			unless $common->{ $db->{database} };
		}
		$db->{file} = catfile( $dir, $common->{ $db->{database} } );
	}

	for ( io( $db->{file} )->chomp->slurp ) {
		if (/
		^\$ENV\{\s?
		(ORA_\w+?)(_GOLD)?
		\s?}
		\s*=\s*
		"(.+)";
		/x) {
			$db->{ lc( $1 ) } = $3;
#			log_debug { 'setting ' . $1 . ' to ' . $3 };
		}
	}

#	log_debug { "_read_oracle_connection_file: " . Dumper $db };

	return $db;
}

=head3 clean_oracle_params

turn the Oracle connection params into something a little more sane

@param $db_data - hash of Oracle params from a file

@return $h - tidied up params

	$h may include

	dsn
	username
	password
	options

=cut

sub clean_oracle_params {
	my $db_data = shift // die err({ err => 'missing', subject => 'db_conn_params'});

	if (! ref $db_data || ref $db_data ne 'HASH') {
#		croak "clean_oracle_params expects a hash ref as input";
		die err({ err => 'invalid_enum',
			subject => $db_data,
			type => 'input to clean_oracle_params',
			enum => [ "a hash ref" ]
		});
	}

	if (! $db_data->{ora_dbi_dsn} && ! $db_data->{ora_sid} && ! $db_data->{ora_host} && ! $db_data->{ora_user}) {
		# assume that the params are OK.
		return $db_data;
	}

	# convert to something understandable
	my $h = {};

	if ( $db_data->{options} ) {
		$h->{options} = $db_data->{options};
	}

	if ( $db_data->{ora_user} ) {
		$h->{username} = $db_data->{ora_user};
	}

	# decode password
	if ( $db_data->{ora_password} ) {
		$h->{password} = decode_pass( $db_data->{ora_password} );
	}

	# dsn string
	$h->{dsn} = make_dsn_str( $db_data );

	return $h;
}

=head3 write_oracle_connection_params

Output Oracle connection params as a JSON file

@param $output  - var specifying an 'open'-able handle (e.g. a file path)
@param $db_data - hash of Oracle connection params

@return

=cut

sub write_oracle_connection_params {
	my $output = shift;
	my $h = clean_oracle_params( shift );

	open( my $fh, ">", $output ) or die err({ err => 'not_writable', subject => $output,
		msg => $! });
	# write the params out as JSON
	print { $fh } encode_json $h;
	return;
}

=head3 decode_pass

Decode the db password

@param $pw - password to be decoded

@return $decoded_pw or $pw if the password was not decodable

=cut

sub decode_pass {
	my $pw = shift || return;
	if ( $pw =~ /^encoded:(.+)/ ) {
		return MIME::Base64::decode_base64($1);
	}
	return $pw;
}

=head3 make_dsn_str

Create the Oracle dsn string, using host, port, and SID or $ENV{ORA_DBI_DSN}

@param $arg_h - hash of ORA_* environment params, parsed by get_oracle_connection_params

@return $string in the form 'dbi:Oracle:...'

=cut

sub make_dsn_str {
	my $arg_h = shift // die err({ err => 'missing', subject => 'db_conn_params'});

	if (! ref $arg_h || ref $arg_h ne 'HASH') {
#		croak "make_dsn_str expects a hash ref as input";
		die err({ err => 'invalid_enum',
			subject => $arg_h,
			type => 'input to make_dsn_str',
			enum => [ "a hash ref" ]
		});

	}

	for my $x ( qw( ora_dbi_dsn ora_service ) ) {
		if ( $arg_h->{$x} ) {
			if ( $arg_h->{$x} =~ /\Adbi:Oracle:/i ) {
				return $arg_h->{$x};
			}
			return 'dbi:Oracle:' . $arg_h->{$x};
		}
	}

	my @extras = qw( host port sid );

	for (@extras) {
		if ($arg_h->{ 'ora_' . $_ }) {

			return 'dbi:Oracle:' . join ";", grep { defined($_) }
				map {
					if ($arg_h->{'ora_'. $_ }) {
						$_ . '=' . $arg_h->{'ora_'.$_};
					}
				} @extras;
		}
	}

	die err({ err => 'missing', subject => 'DSN information' });

}

=head3 get_oracle_dbh

Create a database handle for an Oracle DB using the config file settings

@param      hash of params, including database  -- the database name
                                      options   -- DBH options

            database name must be in the $common database names specified in this package.

@return     $dbh - database handle

=cut

sub get_oracle_dbh {
	my $arg_h = shift // die err({ err => 'missing', subject => 'db_conn_params'});

	if (! ref $arg_h || ref $arg_h ne 'HASH') {
#		croak "get_oracle_dbh expects a hash ref as input";
		die err({ err => 'invalid_enum',
			subject => $arg_h,
			type => 'input to get_oracle_dbh',
			enum => [ "a hash ref" ]
		});

	}

	die err({ err => 'missing', subject => 'db' }) unless $arg_h->{database};

	die err({ err => 'missing', subject => 'config file for ' . $arg_h->{database} }) unless $common->{ $arg_h->{database} };

	my $h = get_oracle_connection_params( $arg_h );

	if ($arg_h->{options}) {
		if ($h->{options}) {
			@{$h->{options}{ keys %{$h->{options}} }} = values %{$arg_h->{options}};
		}
		else {
			$h->{options} = $arg_h->{options};
		}
	}

	my $conn = IMG::Util::DBIxConnector::get_dbix_connector( $h );
	return $conn->dbh;

}

1;
