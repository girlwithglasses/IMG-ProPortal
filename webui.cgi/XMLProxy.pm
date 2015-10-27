############################################################################
# This is used to get XML data objects from server.
# It follows the same logic as main.pl and inner.pl
# see xml.cgi
#
# $Id: xml.pl 33401 2015-05-22 17:59:24Z klchu $
############################################################################
package XMLProxy;
use strict;
use warnings;
use feature ':5.16';
use Data::Dumper;
use CGI qw( :standard );
use CGI::Session qw/-ip-match/;    # for security - ken
use perl5lib;
use FileHandle;
use WebConfig;
use WebUtil qw();
use IMG::Util::File;
use IMG::App::DispatchCore;

$| = 1;

my $env                  = getEnv();
my $base_dir             = $env->{base_dir};
my $default_timeout_mins = $env->{default_timeout_mins} // 5;

#blockRobots();

WebUtil::timeout( 60 * $default_timeout_mins );

sub init {
	WebUtil::blockRobots();
	run();
	exit(0);
}

############################################################################
# main
############################################################################
# arguments: no_munge -- if it evaluates to true, don't munge the headers and return text

sub run {
	my $no_munge = shift || undef;

	my $response = prepare_xml_dispatch();

	return $response if $no_munge;

	if ( $response ) {
		if ( $response->{headers} ) {
			# output the headers
			my %headers;
			for my $k ( keys %{$response->{headers}} ) {
				$headers{ '-'.$k } = $response->{headers}{$k};
			}
			print header( %headers );
		}
		print $response->{output} if $response->{output};
	}
}


sub prepare_xml_dispatch {

	my $section = param('section') || return undef;

	my $module;           # the module to load
	my $sub = 'dispatch'; # subroutine to run (if not dispatch)
	my $hdrs;             # page headers to set
#	my $code_ref;         # directly set the code ref to be run -- not used at present

	my $section_table = {
		ANI => sub {
			$hdrs = { type => 'application/json', expires => '-1d' };
			my $page = param('page') || '';
			$hdrs = { type => 'text/xml' } if 'selectFiles' eq $page;
		},
		GenomeListJSON => sub {
			$hdrs = { type => 'text/plain' };
			my $page = param('page') || '';
			$hdrs = { type => 'application/json', expires => '-1d' } if 'json' eq $page;
		},
		PhylumTree => sub {
			$hdrs = { type => 'text/xml' };
		},
		BinTree => sub {
			$hdrs = { type => 'text/xml' };
		},
		BarChartImage => sub {
			$hdrs = { type => 'text/xml' };
		},
		TaxonList => sub {
			$hdrs = { type => 'text/xml' };
		},
		IMGProteins => sub {
			$hdrs = { type => 'text/xml' };
		},
		RNAStudies => sub {
			$hdrs = { type => 'text/xml' };
		},
		PathwayMaps => sub {
			$hdrs = { type => 'text/xml' };
		},
		TableUtil => sub {
			$hdrs = { type => 'text/xml' };
		},
		Methylomics => sub {
			$hdrs = { type => 'text/xml' };
		},
		BiosyntheticDetail => sub {
			$hdrs = { type => 'text/xml' };
		},
		BiosyntheticStats => sub {
			$hdrs = { type => 'text/xml' };
		},
		GenomeListFilter => sub {
			$hdrs = { type => 'text/xml' };
		},
		FindGenomesByMetadata => sub {
			$hdrs = { type => 'text/xml' };
		},
		FunctionAlignment => sub {
			$hdrs = { type => 'text/xml' };
		},
		GeneDetail => sub {
			$hdrs = { type => 'text/xml' };
		},
		ACT => sub {
			$hdrs => { type => "text/html" };
		},
		GeneCassetteSearch => sub {
			$hdrs = { type => 'text/html' };
		},
		ProPortal => sub {
			$hdrs = { type => 'text/html' };
		},
		Selection => sub {
			$hdrs = { type => 'text/html' };
		},
		TreeFile => sub {
			$hdrs = { type => 'text/html' };
		},
		TreeFileMgr => sub {
			$hdrs = { type => 'text/html' };
		},
		Workspace => sub {
			$hdrs = { type => 'text/html' };
		},
		Artemis => sub {
			# ...
		},
		Cart => sub {
			# ...
		},
		Check => sub {
			$hdrs => { type => "text/plain" };
		},
		MeshTree => sub {
			# ...
		},
		RadialPhyloTree => sub {
			# ...
		},
	};

	$section_table->{ check } = sub {
		$module = 'Check';
		$section_table->{Check}->();
	};

	my $non_module_sections = {
		tooltip => sub {
			$hdrs = { type => 'text/html' };
			my $filename = param('filename');
			my $file = $base_dir . '/doc/tooltips/' . $filename;
			if ( -e $file ) {
				local $@;
				my $str = eval { IMG::Util::File::slurp($file) };
				return $str if ! $@;
				warn $@;
			}
		},
		yuitracker => sub {
			$hdrs = { type => 'text/html' };
			my $file = $env->{yui_export_tracker_log};
			my $afh = WebUtil::newAppendFileHandle( $file, 'yui', 1 );
			my $text = param('text');
			my $s = WebUtil::dateTimeStr() . ' ' . WebUtil::getContactOid() . " $text\n";
			print { $afh } $s;
			close $afh;
		},
		config => sub {
			$Data::Dumper::Sortkeys = 1;
			$hdrs = { type => 'text/plain' };
			return Dumper $env;
		},
		MessageFile => sub {
			# ajax general message check - see header.js and main.pl footer section
			$hdrs = { type => 'text/html' };
			if ( $env->{message_file} && -e $env->{message_file} ) {
				local $@;
				my $str = eval { IMG::Util::File::slurp( $env->{message_file} ) };
				return $str if ! $@;
				warn $@;
			}
		},
		NewsFile => sub {
			# ajax general message check - see header.js and main.pl footer section
			$hdrs = { type => 'text/html' };
			my $message_file = '/webfs/scratch/img/proPortal/news.txt';
			if ( $message_file && -e $message_file ) {
				local $@;
				my $str = eval { IMG::Util::File::slurp($message_file) };
				return $str if ! $@;
				warn $@;
			}
		},
		scriptEnv => sub {
			$hdrs = { type => 'text/plain' };

			# test
			WebUtil::unsetEnvPath();
			my $str;
			$str .= $ENV{PATH} . "\n";

			#delete @ENV{ 'IFS', 'CDPATH', 'ENV', 'BASH_ENV' };
			my $scriptEnv = $env->{scriptEnv_script};
			if ( $scriptEnv ne '' ) {
				my $cmd1 = 'java -version';
				$str .= "$cmd1\n";
				# $cfh = new FileHandle("PATH=/bin:/usr/bin:/usr/local/bin; IFS=''; CDPATH=''; ENV=''; BASH_ENV=''; $cmd 2>\&1 |");
				#my $fh = newCmdFileHandle( $cmd1, '', 1 );
				my $fh =  new FileHandle("$cmd1 2>\&1 |");
				if ($fh) {
					while ( my $line = $fh->getline() ) {
						chomp $line;
						$str .= "Status: $line\n";
					}
					close $fh;
				}

				my $cmd2 = "$scriptEnv java -version";
				$str .= "\n\n$cmd2\n";
				#my $fh = newCmdFileHandle($cmd2);

				$fh = new FileHandle("$cmd2 2>\&1 |");
				while ( my $line = $fh->getline() ) {
					chomp $line;
					$str .= "Status: $line\n";
				}
				close $fh;
			} else {
				$str .= "hello world\n";
			}
			$str .= "\n\nTest Done\n";
			return $str;
		}
	};

	if ( $section && $section_table->{$section} ) {
		$module = is_valid_module( $section ) if ! $module;
		die "$section does not seem to be a valid module!" unless $module;
		$section_table->{$section}->();

		my $to_do = IMG::App::DispatchCore::prepare_dispatch_coderef({
			sub        => $sub,
			module     => $module,
			headers    => $hdrs,
		});

		return { headers => $hdrs, output => run_coderef_capture_output( $to_do ) };
	}


	if ( $non_module_sections->{$section} ) {
		my $output = $non_module_sections->{$section}->();
		if ( $output ) {
			return { headers => $hdrs, output => $output };
		}
		return undef;
	}

	warn "Unknown section = '$section'\n";
	return undef;

}

sub run_coderef_capture_output {

	my $to_do = shift // die 'No coderef specified';
	die "Cannot execute $to_do" unless ref($to_do) && 'CODE' eq ref($to_do);

	my $output;
	local $@;
	eval {

		open local *STDOUT, '>', \$output or die "Could not open STDOUT: $!";

		$to_do->();

		close local *STDOUT;

	};

	die $@ if $@;

	warn "Got output: " . Dumper $output;

	return $output;
}

sub is_valid_module {
	my $m = shift;
	my $valid = valid_modules();
	for (@$valid) {
		# untaint
		return $_ if $_ eq $m;
	}
	return 0;
}

sub valid_modules {
	return [ qw(
	ACT
	ANI
	Artemis
	BarChartImage
	BinTree
	BiosyntheticDetail
	BiosyntheticStats
	Cart
	Check
	FindGenomesByMetadata
	FunctionAlignment
	GeneCassetteSearch
	GeneDetail
	GenomeListFilter
	GenomeListJSON
	IMGProteins
	MeshTree
	Methylomics
	PathwayMaps
	PhylumTree
	ProPortal
	RadialPhyloTree
	RNAStudies
	Selection
	TableUtil
	TaxonList
	TreeFile
	TreeFileMgr
	Workspace
) ];
}

1;
