package Routes::ProPortal;
use IMG::Util::Base;
use parent 'CoreStuff';
use Dancer2 appname => 'ProPortal';
use ProPortal::Util::Factory;

our $VERSION = '0.1';

our @active_components = qw( home data_type location clade phylo_heat );

get '/test' => sub {

	template 'pages/test', {};

};

prefix '/proportal'; # => sub {

	# filterable queries
	get qr{
		/ (?<page> location | clade | data_type | phylo_heat )
		/? (?<ecosystem_subtype> neritic | pelagic | marginal )?
		}x => sub {

		my $c = captures;
		my $p = delete $c->{page};

		var current => 'proportal';
		var page => 'proportal/' . $p;

		my $pp = bootstrap( $p, config );

		my $results;
		if ($c->{ecosystem_subtype}) {
			$pp->set_filters($c);
		}
		template "pages/" . $p, $pp->render();

	};

	get '/taxon/:taxon_oid' => sub {

		my $pp = bootstrap( 'Details' );

		$pp->set_filters({ taxon_oid => params->{taxon_oid} });

		template "pages/genome_details", $pp->render();

	};

	get qr{
		( / ( home | index ) )?
		}x => sub {

		var current => 'proportal';
		var page => '/proportal';

		my $pp = bootstrap( undef, config );

		template "pages/home", $pp->render();

	};

#};


=head3 bootstrap

Initialise a Controller and run a query.

=cut

sub bootstrap {
	my ($c_type, $cfg) = @_;
	$c_type ||= 'Home';
	$cfg ||= config;

#	if ($cfg->{sessions_enabled}) {
#		$cfg->{ session } = session;
#	}
#	my $core = setting('_core') || create_core();
	$cfg->{_core} = setting("_core") || create_core();

	debug "Running bootstrap...";

	# temporary hack!
	$cfg->{active_components} = [ @active_components ];

	my $c = ProPortal::Util::Factory::create_pp_component( 'Controller', $c_type, $cfg );
#	debug "component: " . Dumper $c;
	return $c;

}

1;
