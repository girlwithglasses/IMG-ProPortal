package ProPortal::Util::JBrowseFilePrep;

use IMG::Util::Base 'MooRole';
use IMG::Util::File;
use IMG::Util::Parser::TSV2GFF;
use File::Path qw( make_path remove_tree );
use File::Spec::Functions;
use JSON qw( decode_json );

with 'ProPortal::Util::Taxon';

requires 'config', 'run_query';

#
#	Needs the JBrowse libs located at
#	jbrowse/extlib/lib/perl5  and jbrowse/src/perl5
#

use Bio::JBrowse::Cmd::FlatFileToJson;
use Bio::JBrowse::Cmd::FormatSequences;
use Bio::JBrowse::Cmd::IndexNames;

has 'taxon_oid' => (
	is => 'rwp',
	lazy => 1,
#	predicate => 1,
	builder => 1
);

sub _build_taxon_oid {
	my $self = shift;
	say 'running build taxon ID';
	$self->choke({
		err => 'missing',
		subject => 'taxon_oid'
	});
}

has 'taxon_display_name' => (
	is => 'rwp',
);

has 'jbrowse_taxon_dir' => (
	is => 'lazy',
);

sub _build_jbrowse_taxon_dir {
	my $self = shift;
	if ( ! $self->config->{scratch_dir} ) {
		$self->choke({
			err => 'cfg_missing',
			subject => 'scratch_dir',
		});
	}
	return catdir(
		$self->config->{scratch_dir},
		$self->taxon_oid,
	);
}

has 'jbrowse_timestamp_file' => (
	is => 'lazy',
);

sub _build_jbrowse_timestamp_file {
	my $self = shift;
	return catfile(
		$self->jbrowse_taxon_dir,
		'jbrowse_data_gen.txt'
	);
}

has 'jbrowse_tracklist' => (
	is => 'lazy',
);

sub _build_jbrowse_tracklist {
	my $self = shift;
	return catfile(
		$self->jbrowse_taxon_dir,
		'trackList.json'
	);
}

=head3 steps

Steps to include in the data generation

Array of arrays, where each member of the array is in the form

[ $method_to_run, $boolean ]

$method_to_run must be an object method, e.g. $self->create_gff_track

$boolean indicates whether or not the method should die if it does
not complete successfully

=cut

my $steps = {
	std => sub {
		return [
		[ 'create_scratch_dir', 1 ],
		[ 'create_ref_seq', 1 ],
		[ 'create_gff_track', 1 ],
		[ 'create_mapping_tracks' ], # optional!
		[ 'index_names' ],
		[ 'create_jbrowse_timestamp_file' ]
		];
	},
	ref_seq => sub {
		return [
		[ 'create_scratch_dir', 1 ],
		[ 'create_ref_seq', 1 ],
		[ 'index_names' ],
		[ 'create_jbrowse_timestamp_file' ]
		];
	}
};

=head3 run

Run the steps required to generate the JBrowse json files.

By default, creation of a scratch directory, loading a reference sequence, indexing of names, and creating a timestamp file are run. Extra steps can be added in by adding them to $steps, above.

@param  $args               hashref of arguments, including

    taxon_oid => 12345678   (optional)

	force_regeneration => 1 (optional)  if true, will regenerate the data

=cut

sub run {
	my $self = shift;
	my $args = shift // {};

	# make sure that 'steps' is something sensible
	if ( ! $args->{steps} ) {
		$args->{steps} = 'std';
	}
	elsif ( ! exists $steps->{ $args->{steps} } ) {
		$self->choke({
			err => 'invalid',
			subject => $args->{steps},
			type => 'JBrowse file prep method'
		});
	}

	if ( ! $self->taxon_oid && ! defined $args->{taxon_oid} ) {
		$self->choke({
			err => 'missing',
			subject => 'taxon_oid',
		});
	}
	elsif ( ! $self->taxon_oid ) {
		$self->taxon_oid( $args->{taxon_oid} );
	}

	# get taxon data. Will bail on private genome
	$args->{taxon_data} = $self->get_taxon_data( $args );
	$self->_set_taxon_display_name( $args->{taxon_data}{taxon_display_name} );
	# see if we have already converted this data
	if ( $args->{force_regeneration}
	|| ! -e $self->jbrowse_tracklist
	|| ! -e $self->jbrowse_timestamp_file ) {

		remove_tree( $self->jbrowse_taxon_dir, { keep_root => 1 } );

#		say 'steps: ' . Dumper $steps->{ $args->{steps} }->();
		# sequence for preparing the JBrowse files
		for ( @{ $steps->{ $args->{steps} }->() } ) {
#			say 'running ' . join ", ", @$_;
			my ( $step, $fatal ) = @$_;
#			say 'running ' . $step;
			local $@;
			eval { $self->$step(); };

			if ( $@ && $fatal ) {
				# clean up any detritus
				remove_tree( $self->jbrowse_taxon_dir );
				die $@;
			}
			# otherwise, allow to continue
#			say 'steps now: ' . Dumper $steps->{ $args->{steps} };
		}
	}
}


=head3 create_scratch_dir

Scratch directory for the files while we're working on them

@param

	$self->taxon_oid => 12345678   # taxon ID

=cut

sub create_scratch_dir {
	my $self = shift;
	umask 0;
#	say 'current umask: ' . umask;
	my $args = { mode => 0777 };
	if ( $self->config->{environment} && 'production' ne $self->config->{environment} ) {
		$args->{verbose} = 1;
	}

	make_path( $self->jbrowse_taxon_dir, $args );

	return 1;
}


=head3 create_ref_seq

Create the reference track for the taxon

@param

	$self->taxon_oid => 12345678   # taxon ID

=cut

sub create_ref_seq {
	my $self = shift;

	# if the jbrowse_data_gen file is present, delete it
	$self->remove_jbrowse_timestamp_file;

	# make sure that the sequence file is readable
	my $seq_file = $self->get_taxon_file({ type => 'dna_seq', taxon_oid => $self->{taxon_oid} });
	if ( ! -r $seq_file ) {
		$self->choke({
			err => 'not_readable',
			subject => $seq_file
		});
	}

#	say 'Creating reference sequence...';
	Bio::JBrowse::Cmd::FormatSequences->new(
		'--fasta', $seq_file,
		'--key', $self->taxon_display_name,
		'--out', $self->jbrowse_taxon_dir,
	)->run;

	return 1;
}

=head3 create_gff_track

Thin wrapper to convert a GFF file to JSON for JBrowse

@param

	$self->taxon_oid   taxon ID to display

=cut

sub create_gff_track {
	my $self = shift;

	my $gff = $self->get_taxon_file({ type => 'gff', taxon_oid => $self->taxon_oid });

	if ( ! -r $gff ) {
		$self->choke({
			err => 'not_readable',
			subject => $gff
		});
	}

	Bio::JBrowse::Cmd::FlatFileToJson->new(
		'--gff', $gff,
		'--trackLabel', 'GFF data',
		'--trackType', 'CanvasFeatures',
		'--out', $self->jbrowse_taxon_dir
	)->run;

	return 1;
}

=head3 create_mapping_tracks

Create GFF3 tracks for mappings to different databases

@param hashref with data produced by get_gene_oids_from_gff

@return (true on success)

=cut

sub create_mapping_tracks {
	my $self = shift;
	my @args = @_;

	my $gff_data = $self->get_gene_oids_from_gff;

	my @mappings = qw( cog kog pfam tigrfam ipr kegg );
	map { $self->tab_delimited_to_gff( $_, $gff_data ) } @mappings;

	return 1;
}

=head3

Parse the GFF file to get the sequence and gene IDs

@param

	$self->taxon_oid   taxon ID of the GFF file to fetch

@return hashref with keys

	seqid    => #####
	gff_data => {
		gene ID =>
		{	seqid => sequence ID
			type  => GP type
			start => start coordinate
			end   => end coordinate
		}
	}

=cut

sub get_gene_oids_from_gff {
	my $self = shift;

	my $gff = $self->get_taxon_file({ type => 'gff', taxon_oid => $self->{taxon_oid} });
#	my $gff_data;
	my $seqid;

	my $gff_data = IMG::Util::Parser::TSV2GFF::parse_gff( $gff );

	for ( keys %$gff_data ) {
		$seqid = $gff_data->{$_}{seqid};
		last;
	}
	return { seqid => $seqid, gff_data => $gff_data };
}

=head3 tab_delimited_to_gff

Convert a tab-delimited file to GFF3 format

@param $f       file to load (cog / kog / kegg / pfam / tigrfam / ipr)

@param $gff_h   GFF data

Also requires $self->taxon_oid

=cut

sub tab_delimited_to_gff {
	my $self = shift;
	my ( $f, $gff_h ) = @_;

	# this should NOT happen!
	if ( ! $f ) {
		$self->choke({
			err => 'missing',
			subject => 'file to load'
		});
	}
	if ( ! defined $gff_h
	|| ! $gff_h->{seqid} || ! $gff_h->{gff_data} ) {
		$self->choke({
			err => 'missing',
			subject => 'GFF data'
		});
	}

	my $infile = $self->get_taxon_file({ type => $f, taxon_oid => $self->{taxon_oid} });

	if (! -r $infile ) {
# 		say $self->make_message({
# 			err => 'not_readable',
# 			subject => $infile
# 		});
		return;
	}
	# create the parser
	my $parser = IMG::Util::Parser::TSV2GFF::prepare_parser( $f );
	my $out_fh = File::Temp->new();
#	say 'Creating parser for ' . $f;
	local $@;
	eval {
		IMG::Util::Parser::TSV2GFF::tsv2gff({
			seqid => $gff_h->{seqid},
			parse_h => $parser,
			infile => $infile,
			fmt => $f,
			gff_data => $gff_h->{gff_data},
			out_fh => $out_fh,
		});
	};
	if ( $@ ) {
		warn 'Problem with parsing ' . $infile . ': ' . $@;
	}
	else {
		say 'Creating track for ' . $f;
		Bio::JBrowse::Cmd::FlatFileToJson->new(
			'--gff', $out_fh->filename,
			'--trackLabel', $f,
			'--trackType', 'CanvasFeatures',
			'--out', $self->jbrowse_taxon_dir,
			'--nameAttributes', 'Target',
#			'--className', "feature$n",
		)->run;
	}

	return 1;

}

=head3 index_names

Thin wrapper to index names for JBrowse

@param

	$self->taxon_oid   taxon ID to display

=cut

sub index_names {
	my $self = shift;

	# create name indexes
	say 'Indexing names...';
	Bio::JBrowse::Cmd::IndexNames->new(
		'--out', $self->jbrowse_taxon_dir
	)->run;

	return 1;
}

=head3 create_jbrowse_timestamp_file

Create a file with a timestamp to indicate when the tracks were generated

The file will be:

/<scratch_dir>/<taxon_oid>/<$self->jbrowse_timestamp_file>

The contents are:

'Generated <time()>'

@param

	$self->taxon_oid   taxon ID to display

@return (none)

=cut


sub create_jbrowse_timestamp_file {
	my $self = shift;

	# make sure the directory exists
	if ( ! -d $self->jbrowse_taxon_dir ) {
		$self->create_scratch_dir;
	}

	open my $fh, '>', $self->jbrowse_timestamp_file or $self->choke({
		err => 'not_writable',
		subject => $self->jbrowse_timestamp_file
	});

	print { $fh } 'Generated ' . time() . "\n";

	return 1;

}

=head3 remove_jbrowse_timestamp_file

Remove the timestamp file if it exists

The file will be:

/<scratch_dir>/<taxon_oid>/<$self->jbrowse_timestamp_file>

@param

	$self->taxon_oid   taxon ID to display

@return (none)

=cut

sub remove_jbrowse_timestamp_file {
	my $self = shift;

	if ( -e $self->jbrowse_timestamp_file ) {
		# remove it
		unlink $self->jbrowse_timestamp_file or $self->choke({
			err => 'not_removable',
			subject => $self->jbrowse_timestamp_file,
			msg => $!
		});
	}
	return 1;
}

=cut

sub generate_jbrowse_data_async {

	my $taxid = shift // die 'No taxon ID supplied; cannot generate JBrowse data';
	my $dest_dir = $self->config->{scratch_dir} . $taxid . '/source/';
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


sub create_scratch_dir_async {
	my $self = shift;
	my $args = shift;
	my $d = deferred;
	aio_mkdir $self->config->{scratch_dir} . $taxid, 0777, sub {
		-w $self->config->{scratch_dir} . $taxid
		? $d->resolve( $taxid )
		: $d->reject( 'Could not create ' . $self->config->{scratch_dir} . $taxid );
	};
#	make_path( $self->config->{scratch_dir} . $taxid, { verbose => 1, mode => 0777 } ) or $d->reject( 'Could not create scratch dir: ' . $! );
	$d->promise;

}

=cut

1;
