package ProPortal::Controller::PhyloViewer::Pipeline;

use IMG::Util::Import 'MooRole';

requires 'config', 'schema';

use Bio::SeqIO;
use Bio::Seq;
use Bio::TreeIO;
use File::Temp qw( tempfile );
use File::Spec::Functions qw[ catdir catfile ];
use Text::CSV_XS qw[ csv ];

=head1 DESCRIPTION

Runs the body of the PhyloViewer Pipeline

The following steps are taken:

- group GPs by taxon, and then retrieve FASTA sequences for each GP

- create a file containing all the FASTA sequences

- save gene ID / taxon ID mappings

- submit the file to the appropriate tool (clustalw / t-coffee / MUSCLE)
or pipeline

- check for results. If results:

- get taxon metadata for each GP (is this stored in the cart?)

- parse Newick tree, create nested data structure

- add metadata to leaves

- calculate node depth


=cut

=head3 get_taxon_oid_for_genes


@param $args    hashref with keys

        gene_oid => $ids             arrayref of gene IDs (gene_oid)

@return $gene_taxon_data    arrayref of gene data, including gene ID and taxon ID

=cut

#requires 'run_query';

sub get_taxon_oid_for_genes {
	my $self = shift;
	my $args = shift;

	# make sure gene_oids are valid before starting query
	if ( ! $args->{gene_oid} || ! scalar @{$args->{gene_oid}} ) {
		$self->choke({
			err => 'missing',
			subject => 'gene_oids'
		});
	}

	return $self->run_query({
#		query => 'gene_oid_taxon_oid',
		query => 'gene_details',
		-cols => [ qw(
			gene_oid
			gene_symbol
			gene_display_name
			product_name
			description
			locus_tag
			locus_type
			dna_seq_length
			aa_seq_length
			gene.taxon|taxon_oid
			taxon_display_name
			gene.scaffold|scaffold_oid
			scaffold_name
			pp_subset
		) ],
		-where => {
			'gene.gene_oid' => $args->{gene_oid}
		},
		check_results => {
			param => 'gene_oid',
			query => $args->{gene_oid},
			subject => 'gene_oids',
		}
	});
}

=head3 get_metadata_for_taxa

Retrieve the metadata for an array of taxa

@param $args    hashref with keys

	taxon_oid     - taxon_oid array

=cut

sub get_metadata_for_taxa {

	my $self = shift;
	my $args = shift;

	if ( ! $args->{taxon_oid} || ! scalar @{$args->{taxon_oid}} ) {
		$self->choke({
			err => 'missing',
			subject => 'taxon_oids'
		});
	}

	return $self->run_query({
		query => 'taxon_metadata',
		-where => {
			'taxon.taxon_oid' => $args->{taxon_oid}
		},
		check_results => {
			param => 'taxon_oid',
			query => $args->{taxon_oid},
			subject => 'taxon_oids',
		}
	});

}


=head3 create_FASTA_file

	Given an array of objects containing gene and taxon IDs, create
	an FASTA file of concatenated sequences

@param $args    hashref with keys

	gp_arr => $gp_arr     - array of hashes of gene information,
	                        with keys gene_oid and taxon_oid

	src_dir => $src_dir   - source directory from whence to get the sequences

OR

	seq_type => 'faa' || 'fna'
	                      - sequence type: fna (nucleotide); faa (amino acid)

	file | fh => /path/to/file || filehandle
	                      - name of the output file or filehandle.

@output  1                - success

=cut

sub create_FASTA_file {
	my $self = shift;
	my $args = shift;

	# types of sequence to get: fna (nucleotide); faa (amino acid)
	my @valid_sequence_types = qw( fna faa );

	my $seq_type = lc( $args->{seq_type} || 'fna' );

	if ( $seq_type && ! grep { $seq_type eq $_ } @valid_sequence_types ) {
		$self->choke({
			err => 'invalid',
			subject => $seq_type,
			type => 'sequence type'
		});
	}

	# TODO: change this to use the configuration?

	my $src_dir = # $args->{src_dir} ||
		catdir( $self->get_dirname('web_data_dir'),
			'taxon.'
			. ( 'fna' eq $seq_type
				? "genes.$seq_type"
				: "$seq_type")
		);

	my $gp_arr  = $args->{gp_arr};
	if ( ! $gp_arr || ! scalar @$gp_arr ) {
		$self->choke({
			err => 'missing',
			subject => 'gene IDs'
		});
	}

	my ( $outfh, $outfile );
	if ( $args->{fh} ) {
		$outfh = $args->{fh};
	}
	elsif ( $args->{file} ) {
		open $outfh, '>', $args->{file} or $self->choke({
			err => 'not_writable',
			subject => $args->{file},
			msg => $!
		});
	}
	else {
#		log_debug { 'CREATING A NEW FILE!!' };
#		( $outfh, $outfile ) = tempfile();
		$self->choke({
			err => 'missing',
			subject => 'combined FASTA file'
		});
	}

	# extract gene and taxon IDs
	my $wanted;
	for ( @$gp_arr ) {
		$wanted->{ $_->{taxon_oid} }{ $_->{gene_oid} }++;
	}

	my $out = Bio::SeqIO->new(
		-fh => $outfh,
		-format => 'fasta'
	);

	my @missing;
	my $total = 0;
	for my $t ( keys %$wanted ) {
		$total += scalar keys %{$wanted->{$t}};
		# read in FASTA file, index by gene_oid
		local $@;
		my $in  = eval {
			Bio::SeqIO->new(
				-file =>  catfile( $src_dir, $t . '.' . $seq_type ),
				-format => 'fasta'
			);
		};
		if ( $@ ) {
			die $@->{'-text'};
		}
		while ( my $seq = $in->next_seq() ) {
			if ( $wanted->{$t}{ $seq->primary_id } ) {
				$out->write_seq($seq);
			}
			delete $wanted->{$t}{ $seq->primary_id };
		}
		if ( keys %{$wanted->{$t}} ) {
			push @missing, keys %{$wanted->{$t}};
		}
	}

	# make sure that we have all the sequences we need
	if ( scalar @missing ) {
		if ( $total == scalar @missing ) {
			# no IDs found!
			$self->choke({
				err => 'no_results',
				subject => 'sequences'
			});
		}

		$self->choke({
			err => 'missing_results',
			subject => 'sequences',
			ids => [ @missing ]
		});
	}

	return $outfile // 1;

}


=head3 read_gene_taxon_file

Get the gene/taxon array

@param $args    hashref with keys

	file    location of the gene taxon file

@return     array of hashes with keys gene_oid and taxon_oid

=cut

sub read_gene_taxon_file {
	my $self = shift;
	my $args = shift;

	if ( ! $args->{file} ) {
		$self->choke({
			err => 'missing',
			subject => 'gene taxon file'
		});
	}

	if ( ! IMG::Util::File::is_readable( $args->{file} ) ) {
		$self->choke({
			err => 'not_readable',
			subject => $args->{file}
		});
	}

	my $gene_tax_arr = csv ({
		in => $args->{file},
		headers => 'auto',
		eol => $/,
		sep_char => "\t"
	});

	return $gene_tax_arr;

}

=head3 write_gene_taxon_file

	Write an array of objects containing gene and taxon IDs as
	tab-separated data in a file

@param $args    hashref with keys

	gp_arr => $gp_arr     - array of hashes of gene information,
	                        with keys gene_oid and taxon_oid

	file => /path/to/file  - file for saving data
	OR fh => filehandle

@return   dies on failure, returns 1 for success

=cut

sub write_gene_taxon_file {
	my $self = shift;
	my $args = shift;

	if ( ! $args->{gp_arr} || ! scalar @{$args->{gp_arr}} ) {
		$self->choke({
			err => 'missing',
			subject => 'gene and taxon data'
		});
	}

	my $csv_args = {
		data_arr => $args->{gp_arr},
	};

	if ( ! $args->{file} ) {
		if ( ! $args->{fh} ) {
			$self->choke({
				err => 'missing',
				subject => 'gene taxon file'
			});
		}
		else {
			$csv_args->{fh} = $args->{fh};
		}
	}
	else {
		$csv_args->{file} = $args->{file};
	}

	$csv_args->{cols} = [ qw( gene_oid taxon_oid ), sort
		grep { $_ ne 'gene_oid' && $_ ne 'taxon_oid' && $_ ne '__schema' }
		keys %{$args->{gp_arr}[0]} ];

	IMG::Util::File::write_csv($csv_args);

	return 1;
}

=head3 read_tree_file

Retrieve the Newick or NHX file produced by the alignment; parsed
using BioPerl::TreeIO.

@param $args    hashref with keys

	file OR fh - input file or file handle
	format     - newick, nhx, nexus; defaults to newick if not set

@return

	$treeio    - BioPerl TreeIO stream handle

=cut

sub read_tree_file {
	my $self = shift;
	my $args = shift;
	my @tree_formats = qw( newick nhx nexus );

	if ( ! $args->{file} && ! $args->{fh} ) {
		$self->choke({
			err => 'missing',
			subject => 'tree file'
		});
	}
	else {
		if ( $args->{fh} ) {
			$args->{-fh} = delete $args->{fh};
		}
		elsif ( ! IMG::Util::File::is_readable( $args->{file} ) ) {
			$self->choke({
				err => 'not_readable',
				subject => $args->{file}
			});
		}
		else {
			$args->{-file} = delete $args->{file};
		}
	}

	if ( $args->{format} ) {
		if ( ! grep { $_ eq $args->{format} } @tree_formats ) {
			$self->choke({
				err => 'invalid',
				subject => $args->{format},
				type => 'tree format'
			});
		}
	}
	$args->{-format} = delete $args->{format} // 'newick';

	{
		local $@;
		my $treeio = eval {
			Bio::TreeIO->new( %$args );
		};

		if ( $@ ) {
			log_debug { 'err msg: ' . Dumper $@ };
			die $@->{'-text'};
		}
		return $treeio;
	}
}

1;
