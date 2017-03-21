package IMG::Util::ConfigValidator;

use IMG::Util::Import 'LogErr';
use File::Spec::Functions qw( catdir catfile );
use Config::Any;
use WebConfig ();
use IMG::Util::DB;

#	schema  => # schema data -- which db connection to use for which schema
#	db      => # database connection details
#	img_cfg => # IMG config stuff, probably from WebConfig::getEnv()
#	debug   => # debugging stuff
#	logger  => # logger config

sub make_config {

	my $args = shift;

	my $img_conf = WebConfig::getEnv();

	my @pieces = qw( schema db debug logger );

	my @files = map { catfile( $args->{dir}, 'proportal/environments', $args->{$_} ) }
				grep { exists $args->{$_} } @pieces;

	my $cfg = Config::Any->load_stems({
		stems => [ @files ],
		use_ext => 1,
	#	flatten_to_hash => 1,
	});

	my $hash = {};
	for ( @$cfg ) {
		my $vals = ( values %$_ )[0];
		if ( $vals->{ schema } ) {
			$img_conf->{schema} = $vals->{schema};
		}
		elsif ( $vals->{db} ) {
			$img_conf->{db} = $vals->{db};
		}
		else {
			$hash = { %$hash, %$vals };
		}
	}

#	say 'img_conf schema: ' . Dumper $img_conf->{schema};
#	say 'img_conf db: ' . Dumper $img_conf->{db};

	# check that we have the relevant DB config params
	for my $db ( keys %{$img_conf->{schema}} ) {
		if ( ! $img_conf->{db}{ $img_conf->{schema}{$db}{db} } ) {
			if ( 'img_core' eq $img_conf->{schema}{$db}{db} || 'img_gold' eq $img_conf->{schema}{$db}{db} ) {
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

	# log files??
	# currently have web_err_log, web_log, login_log, etc.


#	say 'Made a hash of things!';
	$hash->{plugins}{Adapter}{img_app} = {
		class => 'ProPortalPackage',
		scope => 'singleton',
		options => { config => $img_conf }
	};

#	say 'config: ' . Dumper $img_conf;
#	say 'other stuff: ' . Dumper $hash;
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

