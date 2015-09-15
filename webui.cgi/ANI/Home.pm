package ANI::Home;
use strict;
use warnings;
use feature ':5.16';
use WebConfig ();
use Storable;
use IMG::Views::Templater;
use CacheUtil;
use Date::Format;
use Number::Format;
use File::stat;

my $section = 'ANI';


sub getPageTitle {
    return $section;
}

sub getAppHeaderData {
    return ( 'CompareGenomes' );
}

sub get_stats_file {

	my $cacheDir = '/webfs/scratch/img/bcNp/';
	return $cacheDir . 'anistats.stor';

}

sub dispatch {

	CacheUtil::cgiCacheInitialize( $section );
    CacheUtil::cgiCacheStart() or return;

	my $output = IMG::Views::Templater::render_template( 'ani_home.tt', printLandingPage() );

	print $output;

	CacheUtil::cgiCacheStop();
	return;
}


sub printLandingPage {

	my $ani_stats_file = get_stats_file();
	my $data;

	if ( -e $ani_stats_file ) {
		my $stats = retrieve( $ani_stats_file );
		my $f_st = stat( $ani_stats_file );

		$data->{date} = Date::Format::time2str( "%a %b %e %Y", $f_st->mtime );

		for my $c ( qw( acount bcount ccount dcount ecount xcount ycount zcount) ) {
			$data->{ $c } = Number::Format::format_number( $href->{ $c } );
		}
	}
	return $data;

}

1;
