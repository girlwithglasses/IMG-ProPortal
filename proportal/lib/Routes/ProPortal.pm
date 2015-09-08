package Routes::ProPortal;
use IMG::Util::Base;
use parent 'CoreStuff';
use Dancer2 appname => 'ProPortal';
use ProPortal::Util::Factory;

our $VERSION = '0.1';

our @active_components = qw( home data_type location clade );

my $pp;

get '/test' => sub {

	template 'pages/test', {};

};


prefix '/proportal'; # => sub {

	# filterable queries
	get qr{
		/ (?<page> location | clade | data_type )
		/? (?<ecosystem_subtype> neritic | pelagic | marginal )?
		}x => sub {

		my $c = captures;
		my $p = delete $c->{page};
		$pp = bootstrap( $p, config );

		my $results;
		if ($c->{ecosystem_subtype}) {
			$pp->set_filters($c);
		}
		template "pages/" . $p, $pp->render();

	};

	get qr{
		/ ( home | index )?
		}x => sub {

		$pp = bootstrap( undef, config );

		template "pages/home", $pp->render();

	};

	get '/taxon/:taxon_oid' => sub {

		my $pp = bootstrap( 'Details' );

		$pp->set_filters({ taxon_oid => params->{taxon_oid} });

		template "pages/genome_details", $pp->render();

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
	$cfg->{_core} = setting("_core");

	debug "Running bootstrap...";

	# temporary hack!
	$cfg->{active_components} = [ @active_components ];

	my $c = ProPortal::Util::Factory::create_pp_component( 'Controller', $c_type, $cfg );
#	debug "component: " . Dumper $c;
	return $c;

}

1;
