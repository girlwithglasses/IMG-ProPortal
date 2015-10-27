package Routes::JBrowse;
use IMG::Util::Base;
use Dancer2 appname => 'ProPortal';
use parent 'CoreStuff';
our $VERSION = '0.1';

use FindBin qw/ $Bin /;
use lib (
	"/Users/gwg/webUI/jbrowse/src/perl5",
	"/Users/gwg/webUI/jbrowse/extlib/lib/perl5"
);

use File::Path qw( make_path );
use File::Temp qw(tempfile);
use IMG::Util::Parser::TSV2GFF;

#
#	Needs the JBrowse libs located at jbrowse/extlib/lib/perl5  and jbrowse/src/perl5
#

use Bio::JBrowse::Cmd::FlatFileToJson;
use Bio::JBrowse::Cmd::FormatSequences;
use Bio::JBrowse::Cmd::IndexNames;

use AnyEvent;
use Promises backend => ['AE'], qw[ deferred collect ];
use AnyEvent::IO;
#use IO::AIO;
#use Carp 'verbose';

prefix '/jbrowse' => sub {

	# temporary fix for JBrowse path issues

#	get qr{/(img|plugins)/.*?} => sub {
#		my $path = request->dispatch_path;
#		$path =~ s!/jbrowse/!/jbrowse_assets/!;
#		redirect $path;
#	};

	get qr{
		/ (?<taxon_oid> \d{1,16} )
		/?
		}x => sub {

		var menu_grp => 'proportal';
		var page_id => 'proportal/jbrowse';

		my $c = captures;
		my $taxon_oid = delete $c->{taxon_oid};

		die 'No taxon specified' unless $taxon_oid;

		# see if we have already converted this data
		if ( ! -e config->{scratch_dir} . $taxon_oid . '/trackList.json') {
			generate_jbrowse_data( $taxon_oid );
		}

		template 'pages/jbrowse.tt', { data_dir => '/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid };

	};
};

prefix '/async/jbrowse' => sub {
	get qr{
		/ (?<taxon_oid> \d{1,16} )
		/?
		}x => sub {

		var menu_grp => 'proportal';
		var page_id => 'proportal/jbrowse';

		my $c = captures;
		my $taxon_oid = delete $c->{taxon_oid};

		die 'No taxon specified' unless $taxon_oid;

		# see if we have already converted this data
		delayed {
#			flush;

			use IMG::App::Role::Templater;
			my $conf = config;
			IMG::App::Role::Templater::init_env({ %$conf, base_dir => '/Users/gwg/webUI/proportal' });
			my $output = IMG::App::Role::Templater::render_template( 'pages/jbrowse.tt', { data_dir => '/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid } );
			content $output;

			if ( ! -e config->{scratch_dir} . $taxon_oid . '/trackList.json') {
				generate_jbrowse_data_async( $taxon_oid );
			}


#			template 'pages/jbrowse.tt', { data_dir => '/data_dir/' . $taxon_oid, taxon_oid => $taxon_oid };
			done;
		}

	};
};


sub get_taxon_name {

	my $taxid = shift;

	my $app = CoreStuff::bootstrap( undef, config );

	my $results = $app->schema('img_core')->table('Taxon')
		->select(
			-columns => [ qw( taxon_oid taxon_display_name ) ],
			-where   => { taxon_oid => $taxid },
		);

	if ( defined $results && defined $results->[0] && defined $results->[0]{taxon_display_name} ) {
		return $results->[0]{taxon_display_name};
	}

	die 'Taxon details for ' . $taxid . ' could not be found in the database';

}


my $file_locations = {
	dna_seq => sub { return config->{rsrc_dir} . 'taxon.fna/' . +shift . '.fna'; },
	gff => sub { return config->{rsrc_dir} . 'tab.files/gff/' . +shift . '.gff'; },
	cog => sub { return config->{rsrc_dir} . 'tab.files/cog/' . +shift . '.cog.tab.txt' },
	kog => sub { return config->{rsrc_dir} . 'tab.files/kog/' . +shift . '.kog.tab.txt' },
	pfam => sub { return config->{rsrc_dir} . 'tab.files/pfam/' . +shift . '.pfam.tab.txt' },
	tigrfam => sub { return config->{rsrc_dir} . 'tab.files/tigrfam/' . +shift . '.tigrfam.tab.txt' },
	ipr => sub { return config->{rsrc_dir} . 'tab.files/ipr/' . +shift . '.ipr.tab.txt' },
	kegg => sub { return config->{rsrc_dir} . 'tab.files/ko/' . +shift . '.ko.tab.txt' },
};


sub generate_jbrowse_data {

	my $taxid = shift // die 'No taxon ID supplied; cannot generate JBrowse data';

	my $dest_dir = config->{scratch_dir} . $taxid . '/source/';

	# generate the reference sequence
	my $prep_steps = [
		\&create_scratch_dir,
		\&create_ref_seq,
		\&create_gff_track,
		\&get_gene_oids_from_gff,
		sub {
			my @args = @_;
			map { tab_delimited_to_gff( $_, @args ) } qw( cog kog pfam tigrfam ipr kegg );
		},
		\&index_names
	];

=cut

		sub {
#			my $file_list = shift;

			umask 0;
			debug 'current umask: ' . umask;
			make_path( config->{scratch_dir} . $taxid, { verbose => 1, mode => 0777 } );
		},


		sub {
#			my $file_list = shift;
			my $tax_name = get_taxon_name( $taxid );

			# make sure that the sequence file is readable
			my $seq_file = $file_loc_h->{ dna_seq }->( $taxid );
			if ( ! -r $seq_file ) {
				my $msg = 'The sequence file for ' . $taxid . ' (' . $seq_file . ') could not be ';

				-e $seq_file
				? die $msg . 'read'
				: die $msg . 'found';
			}

			debug 'Creating reference sequence...';
			Bio::JBrowse::Cmd::FormatSequences->new(
				'--fasta', $seq_file,
				'--key', $tax_name,
				'--out', config->{scratch_dir} . $taxid,
			)->run;
#			delete $file_list->{dna_seq};
		},

		sub {
			my $seqid;
			my $gff_data;
			my $gff_file = $file_loc_h->{gff}->( $taxid );
			if ( -r $gff_file ) {

			#	$seqid = IMG::Util::Parser::TSV2GFF::get_seqid_from_gff( $gff_file );
				$gff_data = IMG::Util::Parser::TSV2GFF::parse_gff( $gff_file );
				for ( keys %$gff_data ) {
					$seqid = $gff_data->{$_}{seqid};
					last;
				}
			#	debug 'gff data: ' . Dumper $gff_data;

				Bio::JBrowse::Cmd::FlatFileToJson->new(
					'--gff', $gff_file,
					'--trackLabel', 'GFF data',
					'--trackType', 'CanvasFeatures',
					'--out', config->{scratch_dir} . $taxid
				)->run;
#				delete $file_list->{gff};
			}
			return { gff_data => $gff_data, seqid => $seqid };
		},

		sub {
			my $args = shift;
			my $seqid = $args->{seqid};
			my $gff_data = $args->{gff_data};

			my @fmts = qw( cog kog pfam tigrfam ipr kegg );

			FILE_FORMAT:
			for my $f (@fmts) {
				if ( ! -r $file_loc_h->{$f}->( $taxid ) ) {
					# create the parser
					info 'No ' . uc( $f ) . ' file for ' . $taxid;
					next FILE_FORMAT;
				}

				debug 'Adding file ' . $f;
				my $parser = IMG::Util::Parser::TSV2GFF::prepare_parser( $f );
				debug 'Creating parser for ' . $f;

				local $@;
				my $rows = eval { IMG::Util::Parser::TSV2GFF::tsv2gff({
					seqid => $seqid,
					parse_h => $parser,
					infile => $file_loc_h->{$f}->( $taxid ),
					fmt => $f,
					gff_data => $gff_data,
				}); };

				if ( $@ ) {
					warn 'Problem parsing ' . $file_loc_h->{$f}->( $taxid ) . ': ' . $@;
					next FILE_FORMAT;
				}

				debug 'Got ' . scalar(@$rows) . ' results from parser';
				my $new = $dest_dir . $f . '.gff';
				open( my $fh, '>', $new ) or die 'Cannot open ' . $new . ': ' . $!;
				print { $fh } '##gff-version 3' . "\n";
				print { $fh } join '', map { $_ . "\n" } @$rows;
				close $fh;

				local $@;
				debug 'Creating track for ' . $f;

				eval {
					Bio::JBrowse::Cmd::FlatFileToJson->new(
						'--gff', $new,
						'--trackLabel', $f,
						'--trackType', 'CanvasFeatures',
						'--out', config->{scratch_dir} . $taxid
					)->run;
				};

				if ( $@ ) {
					warn 'Problem with ' . $new. ': ' . $@;
				}
			#	delete $file_list->{gff};
			}
		},
		sub {
	# create name indexes
			debug 'Indexing names...';
			Bio::JBrowse::Cmd::IndexNames->new(
				'--out', config->{scratch_dir} . $taxid
			)->run;
		}
=cut

	my $temp;
	for my $step ( @$prep_steps ) {
		$temp = $step->( $taxid, $temp );
#		say 'temp is now: ' . Dumper $temp;
	}
	return;

}

sub generate_jbrowse_data_async {

	my $taxid = shift // die 'No taxon ID supplied; cannot generate JBrowse data';
	my $dest_dir = config->{scratch_dir} . $taxid . '/source/';
	my $cv = AE::cv;

	collect(
		create_scratch_dir_async( $taxid ),
		do_async( \&create_ref_seq, $taxid ),
		do_async( \&create_gff_track, $taxid ),
#		get_taxon_data( $taxid ),
		do_async( \&get_gene_oids_from_gff, $taxid ),

	)->then( sub {
		my @args = @_;
		collect(  ## these all need to be Promises
			map {
				do_async( \&tab_delimited_to_gff, [ $_, $taxid, $args[-1][0] ] )
				} qw( cog kog pfam tigrfam ipr kegg )
		);
	})->then( sub {
		do_async( \&index_names, $taxid )
	})->then(
		sub { say 'Success!' and $cv->send; },
		sub { $cv->croak( 'ERROR' ) }
	);

	$cv->recv;
}


sub do_async {
    my ( $callback, $input ) = @_;
    my $d = deferred;
    my $w;
    $w = AE::timer 0, 0, sub {
    	say 'Running an async callback';
    	$d->resolve( $callback->( ref( $input ) ? @$input : $input ) );
        undef $w;
    };
    $d->promise;
}


sub create_scratch_dir {
	my $taxid = shift;
	umask 0;
	debug 'current umask: ' . umask;
	make_path( config->{scratch_dir} . $taxid, { verbose => 1, mode => 0777 } );

#	make_path( config->{scratch_dir} . $taxid, { verbose => 1, mode => 0777 } ) or $d->reject( 'Could not create scratch dir: ' . $! );

}


sub create_scratch_dir_async {
	my $taxid = shift;
	my $d = deferred;
	aio_mkdir config->{scratch_dir} . $taxid, 0777, sub {
		-w config->{scratch_dir} . $taxid
		? $d->resolve( $taxid )
		: $d->reject( 'Could not create ' . config->{scratch_dir} . $taxid );
	};
#	make_path( config->{scratch_dir} . $taxid, { verbose => 1, mode => 0777 } ) or $d->reject( 'Could not create scratch dir: ' . $! );
	$d->promise;

}


sub create_ref_seq {
	my $taxid = shift;
	my $tax_name = get_taxon_name( $taxid );
	# make sure that the sequence file is readable
	my $seq_file = $file_locations->{ dna_seq }->( $taxid );
	if ( ! -r $seq_file ) {
		my $msg = 'The sequence file for ' . $taxid . ' (' . $seq_file . ') could not be ';
		-e $seq_file
		? die $msg . 'read'
		: die $msg . 'found';
	}

	debug 'Creating reference sequence...';
	Bio::JBrowse::Cmd::FormatSequences->new(
		'--fasta', $seq_file,
#		'--key', $tax_name,
		'--out', config->{scratch_dir} . $taxid,
	)->run;
}


sub get_gene_oids_from_gff {
	my $taxid = shift;
	my $gff_file = $file_locations->{gff}->( $taxid );
	my $gff_data;
	my $seqid;

	if ( ! -r $gff_file ) {
		my $msg = 'The GFF file for ' . $taxid . ' (' . $gff_file . ') could not be ';
		-e $gff_file
		? die $msg . 'read'
		: die $msg . 'found';
	}
	$gff_data = IMG::Util::Parser::TSV2GFF::parse_gff( $gff_file );
	for ( keys %$gff_data ) {
		$seqid = $gff_data->{$_}{seqid};
		last;
	}
	return { seqid => $seqid, gff_data => $gff_data };
}

sub create_gff_track {
	my $taxid = shift;
	my $gff = $file_locations->{gff}->( $taxid );
	Bio::JBrowse::Cmd::FlatFileToJson->new(
		'--gff', $gff,
		'--trackLabel', 'GFF data',
		'--trackType', 'CanvasFeatures',
		'--out', config->{scratch_dir} . $taxid
	)->run;
}

sub tab_delimited_to_gff {
	my ($f, $taxid, $arg_h) = @_;
	debug 'Adding file ' . $f;
	my $infile = $file_locations->{$f}->( $taxid );

	if (! -r $infile ) {
		info $infile . ' does not exist or is not readable';
		return;
	}
	# create the parser
	my $parser = IMG::Util::Parser::TSV2GFF::prepare_parser( $f );
	my $out_fh = File::Temp->new();
	debug 'Creating parser for ' . $f;
	local $@;
	eval {
		IMG::Util::Parser::TSV2GFF::tsv2gff({
			seqid => $arg_h->{seqid},
			parse_h => $parser,
			infile => $infile,
			fmt => $f,
			gff_data => $arg_h->{gff_data},
			out_fh => $out_fh,
		});
	};
	if ( $@ ) {
		warn 'Problem with parsing ' . $infile . ': ' . $@;
	}
	else {
		debug 'Creating track for ' . $f;
		Bio::JBrowse::Cmd::FlatFileToJson->new(
			'--gff', $out_fh->filename,
			'--trackLabel', $f,
			'--trackType', 'CanvasFeatures',
			'--out', config->{scratch_dir} . $taxid,
			'--nameAttributes', 'Target',
#			'--className', "feature$n",
		)->run;
	}
}

sub index_names {
	my $taxid = shift;
	# create name indexes
	debug 'Indexing names...';
	Bio::JBrowse::Cmd::IndexNames->new(
		'--out', config->{scratch_dir} . $taxid
	)->run;
}


1;
