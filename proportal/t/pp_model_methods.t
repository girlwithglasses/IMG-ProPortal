#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Import 'Test';

# use ProPortal::Methods;

# my $m = ProPortal::Methods->new();


my $f = [
'a	b	c	d	e',
'	f	g	h	i',
'j	k	l	m	n',
'	o	p	Q	R',
's	t	u	v' ];


sub samples {

	return ( '.1m', '<.1m', '~0-12 cm below ground', '~2500 m', '0 m', '0 meters', '0-5 cm', '0-20 meters', '0.1m', '0.5 m', '0.5 meters', '0.25 m', '0', '0m', '1 m', '1 meter', '1,325 meters', '1.1m', '1.2m', '1.4m', '1.5 m', '1.6m', '1.7m', '1.8m', '1.9m', '1m', '2 m', '2-4km below sea level', '2-5 meters', '2,000 - 2,200 m', '2.1m', '2.2m', '2.07m', '2m', '3 meters', '3-5 meters', '3,500 m', '3m into Sediment Floor', '4 m', '4 meters', '4-10 m', '5 m', '5 meters', '5cm', '5m', '6 m', '7.5cm', '8cm', '8m', '9 meters', '9.5m', '9cm', '10 m but also isolates from surface to 200 m', '10 m', '10 meters', '10-50 cm depth of coastal sediment', '10', '10m', '11.3m', '11cm', '12.3 m', '12.3m', '12m', '13.2m', '13cm', '15 m', '16.3m water depth', '19m', '20 m', '20.5m', '21m', '23.45m', '24 cm below seafloor', '25 m', '29cm', '29m', '30 m', '30 meters', '30cm', '30m', '31.4 meters', '39cm', '40 m', '41 m', '45m', '47 m', '47m', '50 m', '50m', '51 m', '60 m', '67cm', '72cm', '75 m', '75m', '77.35 m', '79 m', '80 m', '80m', '82cm', '83 m', '85m', '90 m', '90 meters', '94m - .03m into Sediment Floor', '94m - .05m into Sediment Floor', '94m - .08m into Sediment Floor', '94m - .10m into Sediment Floor', '94m - .14m into Sediment Floor', '94m - .17m into Sediment Floor', '95 m', '100 m', '100m', '110 m', '110m', '120 m', '120 meters', '120-130 m', '120m', '125 m', '125m', '135 m', '135m', '136-143 cm below seafloor', '150 m', '150m', '167 m', '180 m', '200m', '215 m', '220m', '226-246&#8197;m', '240 meters', '250 meters', '290', '294', '300m', '454', '500m', '516 m', '520m', '539.2m', '550m', '608 m', '630 m', '642 m', '731 meters', '743m', '754m', '770 m', '770m', '800m', '968 meters', '984 m', '1000m', '1100 m', '1100 meters', '1125m', '1180.5m', '1200 m', '1210m', '1234 meters', '1250m', '1271 m', '1296', '1300m', '1338 meters', '1385 m', '1500 meters', '1500', '1650 m', '1650 meters', '1670m', '1693 m', '1855', '1900m', '1914 meters', '1990m', '1993 m', '1996 m', '1996m', '2000 meters', '2000m', '2147.76', '2230m', '2290 m', '2300 meters', '2402.15', '2420', '2500 m', '2500 meters', '2502m', '2503 m', '2600 m', '2600 meters', '2600m', '2630 meters', '2950 m', '3000m', '3007.91', '3083 meters below sea level', '3103.11', '3199.21', '3500 meters', '3500m depth', '3501.1', '3504.69', '3550 meters', '3600 meters', '3650 meters', '3818.06', '3850.45', '3865 m', '3901.64', '3906.8', '3995.55', '4000.29', '4000.85', '4000m', '4001.3', '4001.15', '4001.48', '4002.04', '4002.4', '4002.6', '4002.12', '4002.51', '4002.69', '4003.17', '4003.26', '4003.49', '4004.03', '4004.21', '4004.97', '4005.01', '4005.12', '4012.79', '4017.73', '4100 meters', '5027m', '5110 meters', '5110m', '5800 meters', '5904 m', '9000 meters', '10897 m', 'Intertidal', 'N/A', 'sea level', 'sediment surface', 'surface water', 'surface waters', 'Surface, 10 m', 'surface', 'total depth >2500 m, 267 m in the oxygen minimum zone', 'water depths 1600, 1775, 1900, 1996 m', '-500m', '+537 meters', '-500km' );
}

sub convert_depth {
	my $input = shift;

	# check for a number
	if ($input =~
		m/^\s*\+?	# redundant positive sign
		(-? 	# negative sign
		[0-9]*\.?
		[0-9]+)
		\s*
		(m|met(er|re)s?)?	# m, meter, meters, etc.
		(cm|km)?
		\s*$/ix ) {
		if ($4) {
			if ($4 eq 'km') {
				say "Found $input; returning " . $1 * 1000;
				return $1 * 1000;
			}
			elsif ($4 eq 'cm') {
				say "Found $input; returning " . $1 / 100;
				return $1 / 100;
			}
		}
		if ($input ne $1) {
			say "Found $input; returning $1";
		}
		return $1;
	}
#	say "Could not parse $input!";
}

for my $x ( samples() ) {
	convert_depth( $x );
}

done_testing();
