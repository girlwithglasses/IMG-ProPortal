package IMG::Util::ConfigValidator;

use IMG::Util::Import;
use File::Spec::Functions qw( catdir catfile );
use Config::Any;
use WebConfig ();

#	schema  => # schema data -- which db connection to use for which schema
#	db      => # database connection details
#	img_cfg => # IMG config stuff, probably from WebConfig::getEnv()
#	debug   => # debugging stuff

sub make_config {

	my $args = shift;

	my $img_conf = WebConfig::getEnv();

	my @pieces = qw( schema db debug );

	my @files = map { catfile( $args->{dir}, 'proportal/environments', $_  ) }
				grep { exists $args->{$_} } @pieces;

	my $cfg = Config::Any->load_stems({
		stems => [ @files ],
		use_ext => 1,
	#	flatten_to_hash => 1,
	});

#	say 'cfg: ' . Dumper $cfg;

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

#	$hash->{img_app_cfg} = $img_conf;

	say 'Made a hash of things!';
	$hash->{plugins}{Adapter}{img_app} = {
		class => 'ProPortalPackage',
		scope => 'singleton',
		options => { config => $img_conf }
	};

#	say Dumper $hash;

	return $hash;
}
#
#
# requires 'config';
#
# has 'schema' => (
# 	is => 'ro',
# 	isa => Map[ Str => Dict[ module => Str, db => Str ]],
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

