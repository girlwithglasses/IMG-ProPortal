###############################################################
# JSON Proxy
# Generates JSON proxy by reading Perl array from a text file
# Server side sorting and pagination
# Ported to Perl from PHP version from Yahoo! Datatable example
# -BSJ 10/13/09
#
# $Id: json_proxy.pl 34103 2015-08-24 20:33:28Z klchu $
###############################################################
package JSONProxy;
use strict;
use warnings;
use feature ':5.16';

$ENV{TESTING} = 1;

use CGI qw( :standard unescape );
use CGI::Session qw/-ip-match/;	   # for security - ken
use JSON qw( encode_json );
use Data::Dumper;
#use perl5lib;
use WebConfig;
use WebUtil qw();
use IMG::IO::File;
use Selection;
use File::Copy qw( cp );
use Scalar::Util qw( looks_like_number );


=head3 init

Initialise the script; used when calling from json_proxy.cgi

=cut

sub init {

	my $env = getEnv();
	my $default_timeout_mins = $env->{default_timeout_mins} // 5;

	WebUtil::blockRobots();
	WebUtil::timeout( 60 * $default_timeout_mins );
	my $cgi = WebUtil::getCgi();
	my %param = $cgi->Vars();
	local $@;
	my $result = eval { run( params => \%param, config => $env ); };
	webError( $@ ) if $@;

	if ( $result ) {
		print header( -type => "application/json" );

	# JSONify
	# Use package JSON
		my $json = JSON->new;
	#$json->pretty;			   # display JSON array aesthetically - uncomment for debugging JSON
#	 warn 'JSON output: ' . ($json->encode(@returnValue)); # Instead of json_encode
		return encode_json( ( $result ) ); # Instead of json_encode

		#use this line for a text MIME type when debugging
		#print header( -type => "text/plain" );
		print $result;
	}
	exit(0);
}

=head3

Run and retrieve the data from the JSON proxy

@param  hash of arguments with keys

	- params    hashref of query parameters
    - config    app configuration

@return JSON for output

=cut

sub run {
	die 'No parameters specified' unless @_;

	my %args = ( @_ && 1 < scalar(@_) ) ? @_ : %{ +shift };

	if ( ! $args{params} || ! $args{config} ) {
		die 'Incorrect parameters passed to JSONProxy';
	}

	my $param_h = $args{params};

	warn 'Running JSONProxy -> run';


	# Define defaults
	my $results   = -1; # default get all
	my $startIndex = 0; # default start at 0
	my $sort = ''; # default don't sort
	my $dir = 'asc'; # default sort dir is asc
	my $sort_dir = "SORT_ASC";
	my $filter = ''; # default don't filter
	my $column = ''; # default don't filter
	my $type   = ''; # default don't filter
	my $checked = 0;
	my $filtChecked = 0;

=cut

		recordsReturned => scalar(@data),
		totalRecords => scalar(@allRecords),
		checked => $checked,
		filtChecked => $filtChecked,
		startIndex => $startIndex,
		sort => $sort,
		dir => $dir,
		pageSize => $results,
		records => [ @data ],
		allSelect => [ @arSelect ],

=cut

	# Get the temporary filename of data array
	my $arrayFile = $param_h->{sid} || die 'JSONProxy cannot retrieve data: no file name supplied in query params!';

	my $yui_dir = WebUtil::getSessionDir() . '/yui';
	if ( ! -e $yui_dir ) {
		mkdir $yui_dir or die 'Cannot create YUI directory $yui_dir: ' . $!;
	}

	# copy yui_dt_file from old session dir
	if(length(param('cached_session')) > 0) {
		my $cached = $args{config}{cgi_tmp_dir} . "/" . param('cached_session') . "/yui";
		my $f1 = "$cached/$arrayFile";
		my $f2 = "$yui_dir/$arrayFile";

#		my $cmd = "/bin/cp $f1 $f2";
		# make sure f1 exists and f2 does not
		if ( -e $f1 && ! -e $f2 ) {
			cp( $f1, $f2 ) or die("Could not copy cached session files: $!");

#			if ( $cmd =~ /^(.*)$/ ) { $cmd = $1; }	  # untaint
#			WebUtil::unsetEnvPath();
#			runCmd($cmd);
#			WebUtil::resetEnvPath();
#			webLog("\njson_proxy.pl: copy yui_dt_ file from old sesseion\n");
#			webLog("cp command: [$cmd]\n\n");
		}
	}

	my $data_file = "$yui_dir/$arrayFile";
	# read in the data file
	my @allRecords = initArray( $data_file );


	# How many records to get?
	if(length(param('results')) > 0) {
		$results = param('results');
	}

	# Start at which record?
	if(length(param('startIndex')) > 0) {
		$startIndex = param('startIndex');
	}
	# Invalid start value
	if( $startIndex eq "" || ! looks_like_number($startIndex) || $startIndex < 0 ) {
		# Default is zero
		$startIndex = 0;
	}
	# Valid start value
	else {
		# Convert to number
		$startIndex += 0;
	}

	# Sorted?
	if(length(param('sort')) > 0) {
		$sort = param('sort');
	}
	# Sort dir?
	if((length(param('dir')) > 0) && (lc(param('dir')) eq 'desc')) {
		$dir = 'desc';
		$sort_dir = "SORT_DESC";
	}
	else {
		$dir = 'asc';
		$sort_dir = "SORT_ASC";
	}

	# Filtered?
	if (defined(param('f')) && defined(param('c'))) {
		if(length(param('f')) > 0) {
		$filter = unescape(param('f')); # get URL unescaped param

		if(length(param('c')) > 0) {
			$column = param('c');
		}

		if(length(param('t')) > 0) {
			$type = param('t');
		}
		}
	}
	# Return the data
	return returnData($results, $startIndex, $sort, $dir, $sort_dir, $filter, $column, $type, [ @allRecords ]);
}

###############################################################
# returnData
# Returns data in JSON format
# -BSJ 10/13/09
###############################################################

sub returnData {
	my ($results, $startIndex, $sort, $dir, $sort_dir, $filter, $column, $type, $recs ) = @_;
	# All records
	my @allRecords = @$recs;

	warn 'running returnData';

	my $i = 0;
	my $j = 0;
	my $col;
	my $checked = 0;
	my $filtChecked = 0;
	my @sortByCol;
	my @data;

	# Need to sort records
	if ( $sort ne "") {

		# Get Select column, if any
		for my $c ( keys %{$allRecords[0]} ) {
			$col = $c;
			last if ($c =~ /(^Select$|^Selection$)/i);
		}

		# Obtain a list of columns
		for my $prt_array (@allRecords) {
			$sortByCol[$i++] = $prt_array->{$sort};
			if ($col) {
				if ($prt_array->{$col}) {
					$checked++ if ($prt_array->{$col} =~
						   /(\s*checked\s*=\s*'\s*checked\s*')|(\s*checked)/i);
				}
			}
		}

		$filtChecked = $checked; #Set checked rows and filtered rows totals the same

		# Valid sort value
		if (@sortByCol > 0) {
			if ($filter ne "" && $column ne "") {
				my $highLight = 1;
				# Filter the data if filter argument is passed
				# And return the filtered array
				@allRecords = Selection::array_filter($column, $filter, $type, $highLight, @allRecords);

	########### return if filter text error (most likely regex error)
				my $sRegexErr = $allRecords[0];
				if ($sRegexErr) {
					if ($sRegexErr =~ /^###/) {

						## check this bit!!
						print @allRecords;
						return;

					}
				}

				# Obtain a list of FILTERED columns
				$filtChecked = 0;
				for my $prt_array (@allRecords) {
					if ($col) {
						if ($prt_array->{$col}) {
							$checked++ if ($prt_array->{$col} =~
								   /(\s*checked\s*=\s*'\s*checked\s*')|(\s*checked)/i);
						}
					}
				}
			}
			# Sort the original data
			# Add @allRecords as the last parameter, to sort by the common key
			@allRecords = Selection::array_multisort($sort, $dir, @allRecords);
		}
	}

	# Invalid results value
	if( $results eq "" || ! looks_like_number($results) || $results < 1 || $results >= @allRecords ) {
		# Default is all
		$results = scalar @allRecords;
	}
	# Valid results value
	else {
		# Convert to number
		$results += 0;
	}

	# Iterate through records and return from start index
	my $lastIndex = $startIndex + $results;

	if ($lastIndex > @allRecords) {
		$lastIndex = @allRecords;
	}

	for ($i = $startIndex, $j=0; $i < $lastIndex; $i++,$j++) {
		$data[$j] = $allRecords[$i];
	}

	my @arSelect;
	if ( 0 == $startIndex ) {
		@arSelect = Selection::extractCheckBoxes($filter, @allRecords);
	}

	# Create return value
	my @returnValue = ({
		recordsReturned => scalar(@data),
		totalRecords => scalar(@allRecords),
		checked => $checked,
		filtChecked => $filtChecked,
		startIndex => $startIndex,
		sort => $sort,
		dir => $dir,
		pageSize => $results,
		records => [ @data ],
		allSelect => [ @arSelect ],
	});

	#my $json0 = new JSON;
	#$json0->pretty;
	#my $json0_text = $json0->encode(@returnValue);
	#webLog("json_proxy returnData() returnValue=\n$json0_text\n");
	#my $recordsReturnedSize = scalar(@data);
	#webLog("json_proxy returnData() returnValue size=$recordsReturnedSize\n");
	#my $allRecordsSize = scalar(@allRecords);
	#webLog("json_proxy returnData() allRecords size=$allRecordsSize\n");
}

###############################################################
# initArray
# Read in data array from file (name passed via QUERY_STRING)
# -BSJ 10/13/09
###############################################################

sub initArray {
	my $file = shift;
	local $@;
	my $arrayStr = eval { IMG::IO::File::slurp($file) };
	die $@ if $@;
	# Prevent file from being purged by cgi purge timeout +BSJ 01/25/12
	WebUtil::fileTouch( $file );
	$arrayStr = each %{{$arrayStr,0}};	# untaint the variable to make it safe for Perl
	return (eval($arrayStr));
}

1;
