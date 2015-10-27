package ANI::Home;
use strict;
use warnings;
use feature ':5.16';
use Data::Dumper::Concise;
use WebConfig ();
use Storable;
use IMG::App;
use Utils::Cache;
use Date::Format;
use Number::Format;
use File::stat;

my $metadata = {

	page_id => 'ani_home',
	section => 'ANI',
	title   => 'Average Nucleotide Identity (ANI)',
	group   => 'CompareGenomes',
	timeout => 60,

};

my $env;

sub getPageTitle {
    return $metadata->{title};
}

sub getAppHeaderData {
    return ( $metadata->{group} );
}

sub get_stats_file {

	die 'No bcnp cache dir specified!' unless defined $env->{bcnp_stats_dir};

	return $env->{bcnp_stats_dir} . 'anistats.stor';

}

sub dispatch {

	$env = WebConfig::getEnv();
	Utils::Cache::cache_init( $metadata->{section} );
	Utils::Cache::set_key( 'ani_home' );
	Utils::Cache::start_caching() or return;

    my $tmpl_app = IMG::App->new( config => $env );
	my $output = $tmpl_app->render_template( 'ani_home.tt', { data => get_ani_stats() } );
	print $output;
	Utils::Cache::stop_caching();
	return;
}

sub get_ani_stats {

	my $ani_stats_file = get_stats_file();
	my $data = {};

	if ( -r $ani_stats_file ) {
		my $stats = retrieve( $ani_stats_file );
		my $f_st = stat( $ani_stats_file );
		$data->{date} = Date::Format::time2str( "%a %b %e %Y", $f_st->mtime );

		for my $c ( qw( acount bcount ccount dcount ecount xcount ycount zcount) ) {
			$data->{ $c } = Number::Format::format_number( $stats->{ $c } ) if defined $stats->{ $c };
		}
		$data->{print_stats} = 1;
	}

	return $data;

}

sub render {
	return get_ani_stats();
}

1;
