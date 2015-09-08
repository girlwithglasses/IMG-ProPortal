package IMG::Model::UnitConverter;

use IMG::Util::Base;

sub distance_in_m {

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
			#	say "Found $input; returning " . $1 * 1000;
				return $1 * 1000;
			}
			elsif ($4 eq 'cm') {
			#	say "Found $input; returning " . $1 / 100;
				return $1 / 100;
			}
		}
	#	if ($input ne $1) {
	#		say "Found $input; returning $1";
	#	}
		return $1;
	}
#	say "Could not parse $input!";
	return undef;
}

sub convertLatLong {

	my $coord = shift;

	# it is important to strip whitespaces at the beginning
	# and end of the string, since sometimes longitude strings
	# like  " -72.886667" is passed.
	$coord =~ s/^\s+|\s+$//g;

	return unless $coord;

	# Regex for format: decimal number
	if ( $coord =~ /^-?\d+\.?\d*$/ ) {
		return sprintf( "%.5f", $coord );
	}

	# Regex for format: N44.560318 and/or W -110.8338344
	if ( $coord =~ /^([NWSE]\s+)?(-?\d+)(.\d+)?$/ ) {
		return sprintf "%.5f", $2.$3;
	}

    # Regex for format: N10.11.260
	if ( $coord =~ /^([NWSE])(\d+)\.(\d+)\.(\d+)$/ ) {
		my $sec    = $4 / 60;
		my $min    = $3 + $sec;
		my $mindeg = $min / 60;
		my $deg    = $2 + $mindeg;
		if ( $1 eq "S" || $1 eq "W" ) {
			return "-" . $deg;
		}
		return $deg;
	}


	# Regex for format: 47 degrees 38.075 minutes N
	if ( $coord =~ /^(\d+) (degrees|degress|degress,) (\d+).(\d+) minutes ([NWSE])/ ) {
		my $mins    = $3 . "." . $4;
		my $degmins = $mins / 60;
		$degmins = sprintf( "%.5f", $degmins );
		if ( length($degmins) > 8 ) {
			$degmins = substr( $degmins, 0, 7 );
		}
		my $deg = $1 + $degmins;
		if ( $5 eq "S" || $5 eq "W" ) {
			$deg = "-" . $deg;
		}
		return $deg;
	}

    # else
    return undef;
}


1;
