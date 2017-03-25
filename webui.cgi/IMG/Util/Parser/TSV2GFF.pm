package IMG::Util::Parser::TSV2GFF;

use IMG::Util::Import;
use URI::Escape;
use IMG::App::Role::ErrorMessages qw( err );

our (@ISA, @EXPORT_OK);

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( prepare_parser tsv2gff get_seqid_from_gff );
}

my @gff_cols = qw( seqid source type start end score strand phase attributes );

my @valid_attrs = qw( ID length Target Dbxref target_name target_length target_xref domainid domaindb );

my $gff_data;

my %defaults = (
	# col 1 - seqid
	seqid => sub { $gff_data->{ shift->{gene_oid} }{seqid} },
	# col 2 - source

	# col 3 - type
	type => sub { $gff_data->{ shift->{gene_oid} }{type} },
	# col 4 - start_coord
	start => sub {
		my $r = shift;
		$gff_data->{ $r->{gene_oid} }{start} + $r->{query_start};
	},
	# col 5 - end_coord
	end => sub {
		my $r = shift;
		$gff_data->{ $r->{gene_oid} }{start} + $r->{gene_length}*3;
	},
	# col 6 - score
	score => sub { shift->{evalue} // '.'; },
	# col 7 - strand
	strand => sub { '.' },
	# col 8 - phase
	phase => sub { '.' },
	# col 9 - attributes


	ID => sub { shift->{gene_oid} } ,
	length => sub { shift->{gene_length} },


#	Name: # product from GFF file
#	Target => $r->{cog_id} $r->{subj_start} $r->{subj_end}
#	target_name: $r->{cog_name}
#	target_xref:
#	Note: $r->{cog_name} $r->{cog_length}


);

my $col_data = {

	cog => {
		ext => '.cog.tab.txt', # (from NCBI RPSBLAST)
		cols => [
			'gene_oid', # Gene object identifier of query gene
			'gene_length', # Length of protein sequence
			'percent_identity', # Percent identity of aligned amino acid residues
			'query_start', # Start coordinate of alignment on query gene
			'query_end', # End coordinate of alignment on query gene
			'subj_start', # Start coordinate of alignment on subject sequence
			'subj_end', # End coordinate of alignment on subject sequence
			'evalue', # Expectation value
			'bit_score', # Bit score of alignment
			'cog_id', # COG identifier
			'cog_name', # COG name
			'cog_length', # Length of COG consensus sequence
		],
		remap => {
			source => sub { 'COG mapping from NCBI RPSBLAST' },
			ID => sub { my $r = shift; return join "_", $r->{gene_oid}, $r->{cog_id}; },
			Target => sub { my $r = shift;
				return join " ", ( $r->{cog_id}, $r->{query_start}, $r->{query_end} );
			},
			target_name => sub { uri_escape( shift->{cog_name} ) },
			target_length => sub { shift->{cog_length} },
		},
	},

	ipr => {

		ext => '.ipr.tab.txt', #
		cols => [
			'gene_oid', # Gene object identifier of query gene
			'gene_length', # Length of protein sequence
			'query_start', # Start coordinate of alignment on query gene
			'query_end', # End coordinate of alignment on query gene
			'domaindb', # Original domain database.
			'domainid', # ID on original domain database.
			'iprid', # InterPro ID.
			'iprdesc', # InterPro description.
			'go_info', # Gene Ontology Information
		],
		remap => {
			source => sub { 'InterPro' },
			ID => sub { my $r = shift; return join "_", $r->{gene_oid}, ( $r->{iprid} // $r->{domainid} ); },
			Target => sub { shift->{iprid} // '' },
			target_name => sub { uri_escape( shift->{ipr_desc} ) // '' },
			domainid => sub { shift->{domainid} // '' },
			domaindb => sub { uri_escape( shift->{domaindb} ) // '' },
			Dbxref => sub { uri_escape( shift->{go_info} ) // '' },
		}
	},

	kegg => {

		ext => '.ko.tab.txt', # (from NCBI BLASTP on KEGG genes)
		cols => [
			'gene_oid', # Gene object identifier of query gene
			'gene_length', # Length of protein sequence
			'percent_identity', # Perceent identity of aligned amino acid residues
			'query_start', # Start coordinate of alignment on query gene
			'query_end', # End coordinate of alignment on query gene
			'subj_start', # Start coordinate of alignment on subject sequence
			'subj_end', # End coordinate of alignment on subject sequence
			'evalue', # Expectation value
			'bit_score', # Bit score of alignment
			'ko_id', # KEGG Orthology (KO) identifier
			'ko_name', # KO name
			'EC', # Enzyme Commission (EC) assignment from KO
			'img_ko_flag', # 'Yes' (assigned by IMG pipeline); 'No' - from KEGG.
		],

		remap => {
			source => sub { 'NCBI BLASTP on KEGG genes' },

			ID => sub { my $r = shift; return join "_", $r->{gene_oid}, uri_escape( $r->{ko_id} ); },
			Target => sub { my $r = shift; uri_escape( $r->{ko_id} ) . " " . $r->{subj_start} . " " . $r->{subj_end} },
			target_name => sub { uri_escape( shift->{ko_name} ) },
			Dbxref => sub { uri_escape( shift->{EC} ) },
		}
	},

	kog => {
		ext => '.kog.tab.txt', # (from NCBI RPSBLAST)
		cols => [
			'gene_oid', # Gene object identifier of query gene
			'gene_length', # Length of protein sequence
			'percent_identity', # Perceent identity of aligned amino acid residues
			'query_start', # Start coordinate of alignment on query gene
			'query_end', # End coordinate of alignment on query gene
			'subj_start', # Start coordinate of alignment on subject sequence
			'subj_end', # End coordinate of alignment on subject sequence
			'evalue', # Expectation value
			'bit_score', # Bit score of alignment
			'kog_id', # KOG identifier
			'kog_name', # KOG name
			'kog_length', # Length of KOG consensus sequence
		],
		remap => {
			source => sub { 'KOG mapping from NCBI RPSBLAST' },
			ID => sub { my $r = shift; return join "_", $r->{gene_oid}, $r->{kog_id}; },
			Target => sub { my $r = shift;
				return join " ", ( $r->{kog_id}, $r->{subj_start}, $r->{subj_end} );
			},
			target_name => sub { uri_escape( shift->{kog_name} ) },
			target_length => sub { shift->{kog_length} },
		},
	},

	pfam => {

		ext => '.pfam.tab.txt', # (from EBI's pfam_scan which uses HMMER 3.0)
		cols => [
			'gene_oid', # Gene object identifier of query gene
			'gene_length', # Length of protein sequence
			'query_start', # Start coordinate of alignment on query gene
			'query_end', # End coordinate of alignment on query gene
			'subj_start', # Start coordinate of alignment on subject sequence
			'subj_end', # End coordinate of alignment on subject sequence
			'evalue', # Expectation value
			'bit_score', # Bit score of alignment
			'pfam_id', # Pfam identifier
			'pfam_name', # Pfam name
			'pfam_length', # Length of Pfam consensus sequence
		],
		remap => {
			source => sub { 'Pfam from EBI pfam_scan (HMMER 3.0)' },
			ID => sub { my $r = shift; return join "_", $r->{gene_oid}, $r->{pfam_id}; },
			Target => sub { my $r = shift;
				return join " ", ( $r->{pfam_id}, $r->{subj_start}, $r->{subj_end} );
			},
			target_name => sub { uri_escape( shift->{pfam_name} ) },
			target_length => sub { shift->{pfam_length} },
		},
	},

	tigrfam => {

		ext => '.tigrfam.tab.txt', # (from hmmscan HMMER3.0)
		cols => [
			'gene_oid', # Gene object identifier of query gene
			'gene_length', # Length of protein sequence
			'query_start', # Start coordinate of alignment on query gene
			'query_end', # End coordinate of alignment on query gene
			'evalue', # Expectation value
			'bit_score', # Bit score of alignment
			'tigrfam_id', # TIGRFAM identifier
			'tigrfam_name', # TIGRFAM name
		],
		remap => {
			source => sub { 'hmmscan HMMER3.0' },
			ID => sub { my $r = shift; return join "_", $r->{gene_oid}, $r->{tigrfam_id}; },
			Target => sub { shift->{tigrfam_id} },
			target_name => sub { uri_escape( shift->{tigrfam_name} ) },
		}
	},

# 	signalp => {
# 		ext => '.signalp.tab.txt', # (SignalP)
# 		cols => [
# 			'gene_oid', # Gene object identifier of query gene
# 			'gene_length', # Length of protein sequence
# 			'feature_type', # "cleavage"
# 			'start_coord', # start coordinate of feature
# 			'end_coord', # end coordinate of feature
# 		],
# 	},
#
# 	tmhmm => {
# 		ext => '.tmhmm.tab.txt', # (TMHMM)
# 		cols => [
# 			'gene_oid', # Gene object identifier of query gene
# 			'gene_length', # Length of protein sequence
# 			'feature_type', # feature
# 			'start_coord', # start coordinate of feature
# 			'end_coord', # end coordinate of feature
# 		],
# 		remap => {
# 			source => sub { 'TMHMM' },
# 			start => sub { shift->{start_coord} },
# 			end => sub { shift->{end_coord} },
# 		}
# 	},
#
# 	xref => {
# 		ext => '.xref.tab.txt', #
# 		cols => [
# 			'gene_oid', # Gene object identifier of query gene
# 			'db_name', # External database
# 			'id', # External ID corresponding to database
# 		],
# 	}
};

sub _get_col_data {
	return $col_data;
}
sub _get_gff_cols {
	return [ @gff_cols ];
}

=head3 prepare_parser

Create the dispatch table of subs for parsing a certain TSV file

@param  $f_type    - the file type

@return \%d_hash   - dispatch table of subs for remapping the file to produce gff

=cut

sub prepare_parser {
	my $f_type = shift || die err({ err => 'missing', subject => 'file type' });

	if ( ! $col_data->{$f_type} ) {
		die err({
			err => 'invalid',
			subject => $f_type,
			type => 'parseable file type'
		});
	}

	my %d_hash = ( %defaults, %{$col_data->{$f_type}{remap}} );

	# set up the attributes sub
	my @got_em = grep { defined $d_hash{$_} } @valid_attrs;

	$d_hash{ attributes } = sub {
		my $r = shift;
		return join ";", map { "$_=" . $d_hash{$_}->( $r ) } @got_em;
	};

	return \%d_hash;

}

=head3 get_seqid_from_gff

Retrieve the sequence ID from the GFF file

@param  $file   - /path/to/GFF_file.gff

@return $id     - ID from the GFF file

=cut

sub get_seqid_from_gff {

	my $file = shift || die err({ err => 'missing', subject => 'GFF file' });

	my ($id, $is_gff);
	open( my $fh, '<', $file ) or die err({
		err => 'not_readable',
		subject => $file,
		msg => $!
	});

	while ( <$fh> ) {
		next unless m!\w!;
		if ( m!^##gff-version 3! ) {
			$is_gff++;
			next;
		}
		if ( $is_gff ) {
			my @arr = split "\t";
			# rudimentary check that it is a GFF file: should have 9 tab-sep'd cols
			return $arr[0] if scalar @arr >= 9;
		}
	}

	die err({ err => 'not_found_in_file', subject => 'GFF header', file => $file }) unless $is_gff;
	die err({ err => 'not_found_in_file', subject => 'sequence ID', file => $file }) unless defined $id;
	return $id;
}

=head3 parse_gff

Retrieve the sequence ID from the GFF file

@param  $file   - /path/to/GFF_file.gff

@return mapping hashref with keys

	gene ID =>
	{	seqid => sequence ID
		type  => GP type
		start => start coordinate
		end   => end coordinate
	}

=cut

sub parse_gff {

	my $file = shift || die err({ err => 'missing', subject => 'GFF file' });

	my ($id, $is_gff);
	my $mapping;
	open( my $fh, '<', $file ) or die err({
		err => 'not_readable',
		subject => $file,
		msg => $!
	});

	while ( <$fh> ) {
		next unless m!\w!;
		if ( m!^##gff-version 3! ) {
			$is_gff++;
			next;
		}
		if ( $is_gff ) {
			my @arr = split "\t";
			# get the GP type, ID, and coords
			if ( $arr[8] =~ m!ID=(\d+);! ) {
				$mapping->{ $1 } = { seqid => $arr[0], type => $arr[2], start => $arr[3], end => $arr[4] };
			}
		}
	}

	die err({ err => 'not_found_in_file', subject => 'GFF header', file => $file }) unless $is_gff;
	return $mapping;
}

=head3 tsv2gff

Convert tab-separated values into GFF3!

@param   hashref of params, including

	infile    input file to be parsed

	outfile   output file (for GFF data) [optional]
	out_fh    output file handle         [optional]
	          output is stored in an arrayref otherwise

	fmt       format


@return

=cut

sub tsv2gff {

	my $args = shift;

	die err({ err => 'missing', subject => 'input file' }) unless defined $args->{infile};
	die err({ err => 'missing', subject => 'GFF data' }) unless defined $args->{gff_data};
	die err({ err => 'missing', subject => 'format' }) unless defined $args->{fmt};

	my $parse_h = $args->{parse_h};

	$gff_data = $args->{gff_data};

    my $output_me;
    my $out;

    if ( $args->{outfile} ) {
        # open a file for output, and set up output_me as a writer
        open( $out, '>', $args->{outfile} ) or die err({ err => 'not_writable', subject => $args->{outfile}, msg => $! });

        $output_me = sub {
            my $line = shift;
            print { $out } $line . "\n";
        };
    }
    elsif ( $args->{out_fh} ) {
        # outfile handle supplied
        $out = $args->{out_fh};
        $output_me = sub {
            my $line = shift;
            print { $out } $line . "\n";
        };
    }
    else {
        # $out is an arrayref; push the lines on to it.
        $out = [];
        $output_me = sub {
            my $line = shift;
            push @$out, $line;
        };
    }


	open( my $fh, '<', $args->{infile} ) or die err({ err => 'not_readable', subject => $args->{infile}, msg => $! });
	my $first_line = <$fh>;
	while ( my $line = <$fh> ) {
		chomp $line;
		my %data;
		@data{ @{$col_data->{ $args->{fmt} }{cols}} } = split "\t", $line;
        $output_me->( join "\t", map { $parse_h->{$_}->( \%data ) } @gff_cols );
	}
#	log_debug { 'Finished parsing!' };

	undef $gff_data;

	return $out;
#	log_debug { Dumper [@rows] };

}

1;
