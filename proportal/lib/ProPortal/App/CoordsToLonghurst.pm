{
	package ScriptAppArgs;
	use IMG::Util::Import 'Class';
	with 'IMG::App::Role::ErrorMessages';
	use IMG::Util::File;

	has 'valid_infile_formats' => (
		is => 'lazy',
	);

	sub _build_valid_infile_formats {
		return [ qw( arr tsv ) ];
	}

	has 'infile' => (
		is => 'ro',
		required => 1
	);

	has 'infile_format' => (
		is => 'lazy',
		isa => sub {
			my @valid = qw( arr tsv );
			if ( ! grep { $_[0] eq $_ } @valid ) {
				die err({
					err => 'invalid_enum',
					subject => $_[0],
					type => 'input format',
					enum => \@valid
				});
			}
		}
	);

	sub _build_infile_format {
		return 'arr';
	}

	has 'longhurst_fh' => (
		is => 'ro',
		required => 1,
		init_arg => 'longhurst_file',
		coerce => sub {
			open my $fh, "<", $_[0] or die err({
				err => 'not_readable',
				subject => $_[0],
				msg => $!
			});
			return $fh;
		}
	);

	has 'outfh' => (
		is => 'ro',
		required => 1,
		init_arg => 'outfile',
		coerce => sub {
			open my $fh, ">", $_[0] or die err({
				err => 'not_writable',
				subject => $_[0],
				msg => $!
			});
			return $fh;
		}
	);

	has 'taxon_oid' => (
		is => 'lazy',
		isa => ArrayRef[Int]
	);

	has 'test' => (
		is => 'ro',
		isa => Bool
	);

	has 'lines' => (
		is => 'rwp',
	);

	sub _build_taxon_oid {
		my $self = shift;
		my @arr;
		if ( 'arr' eq $self->infile_format ) {
			@arr = grep { /^\d+$/ }
			map { s/\s*(\d+)\s*/$1/; $_ }
			@{ IMG::Util::File::file_to_array( $self->infile ) };
		}
		elsif ( 'tsv' eq $self->infile_format ) {
			my $args;
			$args->{ix} = 'taxon_oid';

#			$self->choke({ err => 'not_implemented' });

			# parse in the file, save the lines
			my $csv = Text::CSV_XS->new ({
				auto_diag => 2,
				binary => 1,
				sep => "\t",
				empty_is_undef => 1
			});

			open my $fh, "<", $self->infile or $self->choke({
				err => 'not_readable', subject => $self->infile, msg => $!
			});

			my %ids;
			local $@;

			my @hdr = eval { $csv->header( $fh ) };
			if ( $@ || ! grep { $args->{ix} eq $_ } @hdr ) {

				if ( $@ ) {
					$self->choke({
						err => 'module_err',
						subject => 'Text::CSV_XS',
						msg => "" . $csv->error_diag()
					});
				}

				$self->choke({
					err => 'not_found_in_file',
					subject => '"' . $args->{ix} .'" header',
					file => $self->infile
				});
			}
			my $row = {};
			$csv->bind_columns( \@{$row}{@hdr} );
			while ( $csv->getline( $fh ) ) {
				if ( defined $row->{ $args->{ix} } ) {
					$ids{ $row->{ $args->{ix} } }
					? say 'Boo!'
					#push( @{ $ids{ $row->{ $args->{ix} } } }, \%$row )
					: say 'hoo!';
					#$ids{ $row->{ $args->{ix} } } = [ \%$row ];
				}
			}
			@arr = keys %ids;
		}

		if ( ! scalar @arr ) {
			$self->choke({
				err => 'not_found_in_file',
				subject => 'taxon_oids',
				file => $self->infile
			});
		}
		return \@arr;

	}

	1;

}


package ProPortal::App::CoordsToLonghurst;

use IMG::Util::Import 'Class';
use ScriptAppArgs;
extends 'IMG::App';
with qw(
	IMG::Util::ScriptApp
);
use XML::LibXML;
use GD;
use POSIX;

has 'dom' => (
	is => 'rwp',
);

has 'provinces' => (
	is => 'rwp'
);

has 'minmax' => (
	is => 'rwp'
);

has 'image' => (
	is => 'lazy',
);

sub _build_image {
	my $self = shift;
	my $map_bb = $self->map_bb;
	my $x = 360 * 10000;
	my $y = 180 * 10000;
	my $map = GD::Image->new($x, $y, 1);
	my $bg = $self->bg_colour;
	$map->filledRectangle( 0, 0, $x-1, $y-1, $bg );
	return $map;
}

has 'bg_colour' => (
	is => 'lazy'
);

sub _build_bg_colour {
	my $self = shift;
	return $self->image->colorAllocate( 255, 255, 255 );
}

has 'colour_key' => (
	is => 'rwp'
);

sub _build_colour_key {
	return {};
}

has 'map_bb' => (
	is => 'rwp'
);

=head3 ll_to_xy

Convert longitude/latitude coordinates to x / y, and translate them to be positive

=cut

sub ll_to_xy {
	my $self = shift;
	return( $_[0] += 180, $_[1] += 90 );
}


=cut
COORDS2LONGHURST

This script takes as input latitude and longitude coordinates and returns the  Longhurst Province where the coordinate is found.  It works by parsing a file that  contains lat/long coordinates that bound each province and performing the Crossings Test on each province.  The Crossings Test is used in computer graphics to quickly  determine if a point is within or outside a polygon by "drawing" a line east from the input coordinate and seeing how many crossings the line makes with the polygon border.  If there is an odd number of crossings, the point is within the polygon, otherwise the point is outside the polygon.


dependent on:
	longhurst.xml:	A .gml file that contains the coordinates that bound each province

in:
	lat:	Northerly latitude ranging from -90 to 90
	lon:  Easterly longitude ranging from -180 to 180

out:
	Longhurst province code and name where the coordinate can be found.
	If the coordinate is on land, or otherwise unassociated with a province,
		a list of candidate provinces to check manually will be returned.

@ Sara Collins.  MIT.  3/18/2015
@ Sara Collins.	 MIT.  6/28/2016.
	Adapted as a custom Galaxy tool.  Input is now a tabular file instead of from
	the command line.

=cut


sub run {
	my $self = shift;

	# extract the lat and long coords from the query
	$self->extract_ids;

	# open and parse the longhurst file
	$self->read_longhurst_file;

	#

	# print results

}

=head3

Parse GML data from the Longhurst file.

@param  $self->args->longhurst_fh   filehandle to a GML file containing the Longhurst data

@return  hashref with keys

	province => {
		<fid> => { # hashref with keys
			name (full province name), code (four letter abbreviation)
			x1, x2, y1, y2 (coordinates)
		}
	}
	minmax => {
		x => {
			min => { $lat_1 => { # hashref with keys $fid for all
			max => { $lat_2 => { # hashref with keys $fid for all
		}
=cut

sub read_longhurst_file {
	my $self = shift;

	my $dom = XML::LibXML->load_xml({
		IO => $self->args->longhurst_fh # should be a file handle
		# parser options ...
	});

	my $province;
	my $limit;

	# get the bounding box for the whole map
	my @map_bb = map { [ split ',', $_ ] } split ' ', trim_ws( $dom->findvalue('wfs:FeatureCollection/gml:boundedBy') );
	$self->_set_map_bb({
		x1 => POSIX::floor( $map_bb[0][0] ),
		y1 => POSIX::floor( $map_bb[0][1] ),
		x2 => POSIX::ceil( $map_bb[1][0] ),
		y2 => POSIX::ceil( $map_bb[1][1] )
	});

	for my $node ( @{ $dom->getElementsByTagName('MarineRegions:longhurst') } ) {

		# 1. Get province code, name and bounding box from file
		my $b = trim_ws( $node->findvalue('gml:boundedBy/gml:Box/gml:coordinates') );

		# 2. Parse bounding box coordinates
		my @b_arr = map { [ split ',', $_ ] } split ' ', $b;
		my $fid = $node->getAttribute('fid');
		$province->{ $fid } = {
			name => trim_ws( $node->findvalue('MarineRegions:provdescr') ),
			code => trim_ws( $node->findvalue('MarineRegions:provcode') ),
			x1 => $b_arr[0][0],
			y1 => $b_arr[0][1],
			x2 => $b_arr[1][0],
			y2 => $b_arr[1][1]
		};

		# 3. Save the minimum and maximum x and y values
		if ( $b_arr[0][0] < $b_arr[1][0] ) {
			# limit->{x}{ minimum }{ maximum }{ fid }
			$limit->{'x'}{ $b_arr[0][0] }{ $b_arr[1][0] }{ $fid }++;
		}
		else {
			$limit->{'x'}{ $b_arr[1][0] }{ $b_arr[0][0] }{ $fid }++;
		}

		if ( $b_arr[0][1] < $b_arr[1][1] ) {
			$limit->{'y'}{ $b_arr[0][1] }{ $b_arr[1][1] }{ $fid }++;
		}
		else {
			$limit->{'y'}{ $b_arr[1][1] }{ $b_arr[0][1] }{ $fid }++;
		}
		$self->make_polygons({ region => $node, data => $province->{$fid}, fid => $fid });
	}
	return { province => $province, minmax => $limit };
}

sub trim_ws {
	my $str = shift;
	$str =~ s/^\s*(\S.*\S?)\s*$/$1/;
	return $str;
}

=head3 make_polygons

Draw an image of the polygons for a Longhurst region

@param $args->{region}


=cut


sub make_polygons {
	my $self = shift;
	my $args = shift;

	for ( 'region', 'fid' ) {
		if (! $args->{$_} ) {
			$self->choke({
				err => 'missing',
				subject => $_
			});
		}
	}

	my $r = $args->{region};
	my $fid = $args->{fid} =~ s/\D//g;
	my $colour = $self->image->colorAllocate( unpack 'xCCC', pack 'N', $fid *= 64 );
	my $scaler = 10000;
	for my $g ( @{$r->findvalue('MarineRegions:the_geom/*/*/gml:outerBoundaryIs/*/gml:coordinates')} ) {
		my $poly = GD::Polygon->new();
		for my $c ( split ' ', trim_ws( $g ) ) {
			$poly->addPt( map { $_ * $scaler } ll_to_xy( split ',', $c ) );
		}
		# colour it in
		$self->image->filledPolygon($poly,$colour);
	}
	for my $g ( @{$r->findvalue('MarineRegions:the_geom/*/*/gml:innerBoundaryIs/*/gml:coordinates')} ) {
		my $poly = GD::Polygon->new();
		for my $c ( split ' ', trim_ws( $g ) ) {
			$poly->addPt( split ',', $c );
		}
		# remove colour
		$self->image->filledPolygon( $poly, $self->bg_colour );
	}
	return;
}


=head3 get_candidate_provinces

Find the province(s) for each coordinate pair

@param  $args->{coords}   lat/long coordinate pairs

=cut

sub get_candidate_provinces {
	my $self = shift;
	my $args = shift;

	# array of coordinates
	my $coords = $args->{coords};

	# stored province data
	my $provinces = $args->{province};

	my @all_x = sort keys %{ $args->{minmax}{'x'} };
	my @all_y = sort keys %{ $args->{minmax}{'y'} };
	my @long_arr = sort keys %$coords;

	# first item in the set of coordinates to test
	my $long = shift @long_arr;

	# lowest longitude (x) value
	my $x = shift @all_x;

	my $can_prov;

	LAT_LOOP:
	while ( @all_x ) {
		# the longitude is lower than the lowest known longitude
		if ( $long < $x ) {
			# problem!
			warn $long . ' is smaller than the smallest longitude!';
			$long = shift @long_arr;
			next LAT_LOOP;
		}
		# if the longitude is greater than all the maxes, go on to the next x
		my @maxes = sort keys %{$args->{minmax}{'x'}{$long}};
		if ( $long > $maxes[$#maxes] ) {
			$x = shift @all_x;
			next LAT_LOOP;
		}
		# otherwise, check which of the provinces have an ' match
		MAX_LOOP:
		for my $max ( @maxes ) {
			# the longitude is within this range
			if ( $long <= $max ) {
				# for each province that matches x-wise, check the y coords
				for my $p ( keys %{$args->{minmax}{'x'}{$long}{$max}} ) {
					for my $lat ( %{$coords->{$long}} ) {
						if ( $provinces->{$p}{y1} < $lat && $lat < $provinces->{$p}{y2} ) {
							$coords->{$long}{$lat}{$p}++;
							$can_prov->{ "$long,$lat" }{ $p }++;
						}
					}
				}
			}
			else {
			# we're done here.
				last;
			}
		}
		last LAT_LOOP if ! defined $long_arr[0];
		$long = shift @long_arr;
	}
}

# for i in range(0, len(lonList)):
#
# 	lat = latList[i];
# 	lon = lonList[i];

	### Find which candidate provinces our coordinates come from.
	###--------------------------------------------------------------------------

# 	my ( $inProvince, $inLat, $inLon );
#
# 	for my $p ( @$provinces ) {
# 		$inLat = 0;
# 		$inLon = 0;
#
# 		if ($lat >= $p->{y1} and $lat <= $p->{y2} ) {
# 			$inLat++;
# 		}
# 		if ( $lon >= $p->{x1} and $lon <= $p->{x2} ) {
# 			$inLon++;
# 		}
# 		if ( $inLat && $inLon ) {
# 			$inProvince->{$p}++;
# 		}
# 	}

	### Perform Crossings Test on each candidate province.
	###--------------------------------------------------------------------------

# 	for node in dom.getElementsByTagName('MarineRegions:longhurst'):
# 		fid = node.getAttribute("fid")
#
# 		if inProvince.get(fid):
# 			crossings = 0
#
# 			## 1. Get all coordinate pairs for this province.
# 			geom = node.getElementsByTagName('MarineRegions:the_geom')
#
# 			for g in geom:
# 				c = g.getElementsByTagName('gml:coordinates')
#
# 				for i in c:
# 					ii = i.childNodes
# 					coordStr = ii[0].data		#<--- contains coordinate strings
# 					P = coordStr.split(' ')
#
# 					pairs = []
# 					for p in P:
# 						[lplon,lplat] = p.split(',')
# 						pairs.append([float(lplon),float(lplat)])
#
# 					## 2. Use pair p and p+1 to perform Crossings Test.
# 					for i in range(len(pairs)-1):
# 						# test latitude
# 						passLat = (pairs[i][1]>=lat and pairs[i+1][1]<=lat) or (pairs[i][1]<=lat and pairs[i+1][1]>=lat)
#
# 						# test longitude
# 						passLon = (lon <= pairs[i+1][0])
#
# 						if passLon and passLat:
# 							crossings += 1
#
# 			if crossings % 2 == 1:
# 				inProvince[fid] = True
# 			else:
# 				inProvince[fid] = False
#


# 	### Print solutions to file.
# 	###--------------------------------------------------------------------------
#
# 	solution = []
# 	for p in inProvince:
# 		if inProvince[p] == True:
# 			solution.append([provinces[p]['provCode'], provinces[p]['provName']])
#
# 	if len(solution) == 1:
# 		print >> outFile, solution[0][0], '\t', solution[0][1]
# 	else:
# 		print >> outFile, ' '
#
#
# outFile.close()

=cut

sub output {
	my $self = shift;
	my $rslts = shift;
	# write out the file
	IMG::Util::File::write_csv({
		fh       => $self->args->outfh,
		cols     => [ @{$self->args->headers}, 'longhurst_province', 'longhurst_abbr' ],
		data_arr => $rslts
	});

}
=cut

1;
