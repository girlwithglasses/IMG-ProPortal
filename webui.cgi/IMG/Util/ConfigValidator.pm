package IMG::Util::ConfigValidator;

use IMG::Util::Import;
use IMG::Util::Logger;
use File::Spec::Functions qw( catdir catfile );
use Config::Any;
use WebConfig ();
# use IMG::App::Role::ErrorMessages;
# use IMG::Util::DB;

#	Creates the appropriate configuration for an IMG::App/Dancer instance

#	schema  => # schema data -- which db connection to use for which schema
#	db      => # database connection details
#	debug   => # debugging stuff
#	logger  => # logger config
#	session => # session engine config

sub make_config {

	my $args = shift;

	my $img_conf = WebConfig::getEnv();

	my @pieces = qw( schema db debug logger session );

	my @files = map { catfile( $args->{dir}, 'proportal/environments', $args->{$_} ) }
				grep { exists $args->{$_} } @pieces;

#	warn 'files: ' . join ", ", @files;

	my $cfg = Config::Any->load_stems({
		stems => [ @files ],
		use_ext => 1,
	#	flatten_to_hash => 1,
	});

	## TO INTEGRATE:
	#	logger.conf vs web_log_file / err_log_file
	#	session directory vs cgi_tmp_dir


	my $hash = {};
	for ( @$cfg ) {
		my $vals = ( values %$_ )[0];
		for my $k ( qw( schema db ) ) {
			if ( $vals->{$k} ) {
				$img_conf->{$k} = delete $vals->{$k};
			}
		}
		for my $k ( qw( session logger ) ) {
			if ( $vals->{$k} ) {
				$hash->{$k} = delete $vals->{$k};
			}
		}
		# integrate engines
		if ( $vals->{engines} ) {
			if ( $hash->{engines} ) {
				$hash->{engines} = { %{$hash->{engines}}, %{$vals->{engines}} };
			}
			else {
				$hash->{engines} = $vals->{engines};
			}
			delete $vals->{engines};
		}
		if ( keys %$vals ) {
#			say 'got this stuff left: ' . Dumper $vals;
			$hash = { %$hash, %$vals };
		}
	}

	# init the IMG::App logger
	if ( $hash->{engines}{logger}{log4perl} ) {
		IMG::Util::Logger::set_logger_conf( $hash->{engines}{logger}{log4perl} );
	}

#	log_debug { 'hash: ' . Dumper $hash };

#	log_debug { 'img_conf schema: ' . Dumper $img_conf->{schema} };
#	log_debug { 'img_conf db: ' . Dumper $img_conf->{db} };

	# check that we have the relevant DB config params
	for my $db ( keys %{$img_conf->{schema}} ) {
		if ( ! $img_conf->{db}{ $img_conf->{schema}{$db}{db} } ) {
			if ( 'img_core' eq $img_conf->{schema}{$db}{db} || 'img_gold' eq $img_conf->{schema}{$db}{db} ) {

				require IMG::Util::DB;

				my $dbh = IMG::Util::DB::get_oracle_connection_params({ database => $img_conf->{schema}{$db}{db} });
				$dbh->{dbi_params} = {
					RaiseError => 1,
					FetchHashKeyName => 'NAME_lc',
					LongReadLen => 38000,
					LongTruncOk => 1
				};
				$img_conf->{db}{ $img_conf->{schema}{$db}{db} } = $dbh;
			}
			else {
				log_error { 'No config for ' . $img_conf->{schema}{$db}{db} };
			}
		}
	}

#	say 'hash: ' . Dumper $hash;
#	say 'img conf: ' . Dumper $img_conf;

	# log files??
	# currently have web_err_log, web_log, login_log, etc.
	if ( $img_conf->{cgi_tmp_dir} && $hash->{engines}{session}{CGISession} ) {
		# change the session settings to take account of this
		$hash->{engines}{session}{CGISession}{driver_params}{Directory} = $img_conf->{cgi_tmp_dir};
	}

#	log_debug { 'other stuff: ' . Dumper $hash };

#	log_debug { 'Made a hash of things!' };
	$hash->{plugins}{Adapter}{img_app} = {
		class => 'ProPortalPackage',
		scope => 'singleton',
		options => { config => $img_conf }
	};

#	log_debug { 'config: ' . Dumper $img_conf };
	return $hash;
}
#
#
# requires 'config';
# has 'img_cfg
#
# has 'schema' => (
# 	is => 'ro',
# 	isa => Map[ Str => Dict[ module => Str, db => Str ]],
#	coerce => sub {
#		my $cfg = Config::Any->load_stems({
#			stems => [  ],
#			use_ext => 1
#		})
# );
#
# has 'db' => (
# 	is => 'ro',
# 	isa => Map[ Str => Dict[
# 		database => Str,
# 		driver => Str,
# 		[user|username] => Optional[Str],
# 		password => Optional[Str],
# 		dbi_options => Optional[HashRef]
# 		] ],
# );
#
# has 'session' => (
# 	is => 'ro',
# );



1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::ConfigValidator

Validate the format of a configuration hash

=cut

