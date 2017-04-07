{
	package ProPortal::IO::ProPortalFilter::pp_subset;

	use IMG::Util::Import 'Class';
	extends 'IMG::Model::EnumFilter';

	has '+id' => (
		default => 'pp_subset'
	);

	# the current query value
	has '+current' => (
		default => 'all_proportal'
	);

	# all valid values
	has '+valid' => (
		default => sub {
			return [ qw( pro syn other pro_phage syn_phage other_phage isolate metagenome all_proportal ) ];
		}
	);

	sub schema {
		my $self = shift;
		return {
			id => $self->id,
			type  => 'enum',
			title => $self->title,
			control => 'checkbox',
			enum => $self->valid,
			enum_map => {
				pro => 'Prochlorococcus',
				syn => 'Synechococcus',
				other => 'Other bacteria',
				pro_phage => 'Prochlorococcus phage',
				syn_phage => 'Synechococcus phage',
				other_phage => 'Other phages',
				coccus => 'Prochlorococcus and Synechococcus',
				bacteria => 'Prochlorococcus, Synechococcus, and other bacteria',
				phage => 'Phages from Prochlorococcus, Synechococcus, and others',
				isolate => 'All ProPortal isolates',
				metagenome => 'Marine metagenomes',
				pp_isolate => 'All ProPortal isolates',
				pp_metagenome => 'Marine metagenomes',
				proportal => 'All isolates and metagenomes',
				all_proportal => 'All isolates and metagenomes'
			}
		};
	}

	sub sql_filter {
		my $self = shift;
		my $f_name = shift // $self->choke({
			err => 'missing',
			subject => 'filter'
		});

		my $filters;

		for ( qw( pro syn other pro_phage syn_phage other_phage ) ) {
			$filters->{$_} = $_;
		}

		$filters->{coccus} = [ qw( pro syn ) ];
		$filters->{bacteria} = [ qw( pro syn other ) ];
		$filters->{phage} = [ qw( pro_phage syn_phage other_phage ) ];

		$filters->{isolate} = { '!=' => [ -and => undef, 'metagenome' ] };
		$filters->{isolates} = $filters->{isolate};
		$filters->{metagenome} = 'metagenome';
		$filters->{metagenomes} = $filters->{metagenome};
		$filters->{all_proportal} = { '!=' => undef };

	#	$filters->{pp_metagenome} = 'metagenome';
	#	$filters->{pp_isolate} = { '!=' => [ -and => undef, 'metagenome' ] };
	#	$filters->{pp_isolates} = $filters->{pp_isolate};
	#	$filters->{pp_metagenomes} = $filters->{pp_metagenome};
	#	$filters->{proportal} = { '!=' => undef };

		$self->choke({
			err => 'invalid',
			type => 'pp_subset filter',
			subject => $f_name
		}) unless defined $filters->{$f_name};

	#	log_debug { 'Filters: ' . Dumper $filters };



		return { pp_subset => $filters->{$f_name} };

	}

	1;
}


{
	package ProPortal::IO::ProPortalFilter::dataset_type;

	use IMG::Util::Import 'Class';
	use IMG::Model::Filter;
	extends 'IMG::Model::EnumFilter';

	has '+id' => (
		default => 'dataset_type'
	);

	sub sql_filter {
		my $self = shift;
		my $f_name = shift // $self->choke({
			err => 'missing',
			subject => 'filter'
		});

		$self->choke({
			err => 'invalid',
			type => 'data type filter',
			subject => $f_name
		}) unless grep { $f_name eq $_ } @{ $self->valid };

		return { dataset_type => $f_name };
	}

	sub default {
		return;
	}

	sub valid {
		return [ qw( isolate single_cell metagenome metatranscriptome transcriptome ) ];
	}

	sub schema {
		my $self = shift;
		return {
			id => 'dataset_type',
			type => 'enum',
			title => 'data type',
			control => 'checkbox',
			enum => $self->valid,
			enum_map => {
				'single cell' => 'Single cell',
				single_cell => 'Single cell',
				isolate => 'Isolate',
				metagenome => 'Metagenome',
				transcriptome => 'Transcriptome',
				metatranscriptome => 'Metatranscriptome'
			}
		};
	}

	1;
}



package ProPortal::IO::ProPortalFilters;

use IMG::Util::Import 'MooRole';
with 'IMG::App::Role::ErrorMessages';

=head3 schema

The json-schema data structure for the filters

=cut

my $schema = {
	pp_subset => {
		id => 'pp_subset',
		type  => 'enum',
		title => 'ProPortal subset',
		control => 'checkbox',
		enum => pp_subset_valid(),
		default => 'all_proportal',
		enum_map => {
			pro => 'Prochlorococcus',
			syn => 'Synechococcus',
			pro_phage => 'Prochlorococcus phage',
			syn_phage => 'Synechococcus phage',
			other => 'Other bacteria',
			other_phage => 'Other phages',
			phage => 'Phages from Prochlorococcus, Synechococcus, and others',
			coccus => 'Prochlorococcus and Synechococcus',
			bacteria => 'Prochlorococcus, Synechococcus, and other bacteria',
			isolate => 'All ProPortal isolates',
			metagenome => 'Marine metagenomes',
			pp_isolate => 'All ProPortal isolates',
			pp_metagenome => 'Marine metagenomes',
			proportal => 'All isolates and metagenomes',
			all_proportal => 'All isolates and metagenomes'
		}
	},
	dataset_type => {
		id => 'dataset_type',
		type => 'enum',
		title => 'data type',
		control => 'checkbox',
		enum => dataset_type_valid(),
		enum_map => {
			'single cell' => 'Single cell',
			single_cell => 'Single cell',
			isolate => 'Isolate',
			metagenome => 'Metagenome',
			transcriptome => 'Transcriptome',
			metatranscriptome => 'Metatranscriptome'
		},
	},

	taxon_oid => {
		id => 'taxon_oid',
		title => 'Taxon ID',
		type => 'number'
	},

	gene_oid => {
		id => 'gene_oid',
		title => 'Gene ID',
		type => 'number'
	},
	scaffold_oid => {
		id => 'scaffold_oid',
		title => 'Scaffold ID',
		type => 'number',
	},
	locus_type => {
		id => 'locus_type',
		title => 'locus type',
		type => 'string',
		pattern => "[a-z]RNA"
	},
	gene_symbol => {
		id => 'gene_symbol',
		title => 'gene symbol',
		type => 'string',
		pattern => '\w+'
	},
	category => {
		id => 'category',
		title => 'gene type',
		type => 'enum',
		enum => [ qw(
			rna
			proteinCodingGenes
			withFunc
			withoutFunc
			fusedGenes
			signalpGeneList
			transmembraneGeneList
			geneCassette
			biosynthetic_genes
			pseudogene
		)],
		enum_map => {
			rna => 'RNA',
			proteinCodingGenes => 'protein coding genes',
			withFunc => 'genes with function assignment',
			withoutFunc => 'genes without function assignment',
			fusedGenes => 'fused genes',
			signalpGeneList => 'signalP genes',
			transmembraneGeneList => 'transmembrane proteins',
			geneCassette => 'genes in cassette',
			biosynthetic_genes => 'genes in biosynthetic clusters',
			pseudogene => 'pseudogene'
		}
	},
	db => {
		id => 'db',
		title => 'database',
		type => 'enum',
		enum => [ qw(
			cycog
		) ],
		enum_map => {
			cycog => 'CyCOG'
		}
	},
	xref => {
		id => 'xref',
		title => 'reference',
		type => 'string',
	},
	file_type => {
		id => 'file_type',
		title => 'file type',
		type => 'enum',
		enum => [ qw(
			aa_seq
			dna_seq
			lin_fna
			lin_idx
			genes
			intergenic
			gff
			cog
			kog
			pfam
			tigrfam
			ipr
			kegg
			tmhmm
			signalp
			xref
			bundle
		) ],

# taxon.lin.fna/xxxxxxxx.lin.fna contains DNA seq of the entire set of scaffolds of taxon in a contiguous manner and indexes of each scaffold <start,end> in that can be found in xxxxxxx.lin.fna.idx.

# This directory contains the .faa seqs of alternate splice variant genes for the model orgs such as human, mouse, fly, worm etc. which we integrated a long while ago. UI gene detail displays these sequences, if the gene has splice variants...

		enum_map => {
			aa_seq => 'AA seq',
			dna_seq => 'DNA seq',
			lin_fna => 'scaffold DNA',
			lin_idx => 'scaffold index',
			genes => 'gene DNA seq',
			intergenic => 'intergenic DNA',
			alt_seq => 'alternative splice variant genes for model organisms (e.g. human, mouse, fly, worm, etc.)',
			gff => 'GFF3 annotations',
			cog => 'COG annotations',
			kog => 'KOG annotations',
			pfam => 'PFAM annotations',
			tigrfam => 'TIGRFAM annotations',
			ipr => 'InterPro',
			ko => 'KEGG',
			signalp => 'signal peptides',
			tmhmm => 'transmembrane helixes',
			xref => 'external references',
			bundle => 'file bundle'
		},
		enum_desc => {
			aa_seq => 'amino acid sequence',
			dna_seq => 'DNA sequence',
			lin_fna => 'DNA sequence of all scaffolds in a taxon',
			lin_idx => 'index file for the scaffold sequence',
			genes => 'DNA sequence, genes',
			intergenic => 'DNA sequence of intergenic regions',
			alt_seq => 'amino acid sequence of alternative splice variant genes for model organisms (e.g. human, mouse, fly, worm, etc.)',
			gff => 'GFF3 format (strict conformance not guaranteed for type and attribute fields)',
			cog => 'COG annotations, tab-delimited',
			kog => 'KOG annotations, tab-delimited',
			pfam => 'PFAM annotations, tab-delimited',
			tigrfam => 'TIGRFAM annotations, tab-delimited',
			ipr => 'non-Pfam/TIGRFAM InterPro hits, tab-delimited',
			ko => 'KEGG orthology and EC annotations, tab-delimited',
			signalp => 'signal peptide annotation, tab-delimited',
			tmhmm => 'transmembrane helix annotation, tab-delimited',
			xref => 'external references (spotty coverage)',
			bundle => 'bundle of sequence and annotation files, .tar.gz compressed'
		},
		no_sqlize => 1
	}
};

=head2 pp_subset_filter

Get the filters for the ProPortal-specific species

Filters apply to the 'VW_GOLD_TAXON' table (view)

Current filters:

pro
pro_phage
syn
syn_phage
other
other_phage
metagenome

coccus -- pro + syn
bacteria -- pro + syn + other
phage  -- pro_phage + syn_phage

isolate -- coccus + phage

all_proportal -- isolate + metagenome

=cut

sub pp_subset_filter {
	my $self = shift;
	my $f_name = shift // $self->choke({
		err => 'missing',
		subject => 'filter'
	});

	my $filters;

	for ( qw( pro syn other pro_phage syn_phage other_phage ) ) {
		$filters->{$_} = $_;
	}

	$filters->{coccus} = [ qw( pro syn ) ];
	$filters->{bacteria} = [ qw( pro syn other ) ];
	$filters->{phage} = [ qw( pro_phage syn_phage other_phage ) ];

	$filters->{isolate} = { '!=' => [ -and => undef, 'metagenome' ] };
	$filters->{isolates} = $filters->{isolate};
	$filters->{metagenome} = 'metagenome';
	$filters->{metagenomes} = $filters->{metagenome};
	$filters->{all_proportal} = { '!=' => undef };

#	$filters->{pp_metagenome} = 'metagenome';
#	$filters->{pp_isolate} = { '!=' => [ -and => undef, 'metagenome' ] };
#	$filters->{pp_isolates} = $filters->{pp_isolate};
#	$filters->{pp_metagenomes} = $filters->{pp_metagenome};
#	$filters->{proportal} = { '!=' => undef };

	return { pp_subset => [ map {
			$self->choke({
				err => 'invalid',
				type => 'pp_subset filter',
				subject => $_
			}) unless defined $filters->{$_};
			$filters->{$_}
		} @$f_name ] };

}

sub default_filter {
	my $self = shift;
	my $args = shift;
	if ( ! $args || ! $args->{domain} || ! $args->{filter_value} ) {
		$self->choke({
			err => 'missing',
			subject => 'filter'
		});
	}

	if ( scalar @{$args->{filter_value}} == 1 ) {
		return { $args->{domain} => $args->{filter_value}[0] };
	}
	else {
		return { $args->{domain} => $args->{filter_value} };
	}
}

sub dataset_type_filter {
	my $self = shift;
	return $self->default_filter({
		domain => 'dataset_type',
		filter_value => @_
	});
}

sub locus_type_valid {
	return [ qw( xRNA tRNA rRNA ) ];
}

sub locus_type_filter {
	my $self = shift;
	my $f_name = shift // $self->choke({
		err => 'missing',
		subject => 'filter'
	});

	my $l_type_f = {
		xrna => { like => '%RNA', not_in => [ qw( rRNA tRNA ) ] },
	};

# 	$self->choke({
# 		err => 'invalid',
# 		type => 'data type filter',
# 		subject => $f_name
# 	}) unless grep { $f_name eq $_ } @{ locus_type_valid() };
#
# 	if ( 'xrna' eq lc( $f_name ) ) {
# 		return {
# 			locus_type => {
# 				like => '%RNA',
# 				not_in => [ qw( rRNA tRNA ) ]
# 			}
# 		};
# 	}
	return { locus_type => [ map { $l_type_f->{ lc($_) } || $_ } @$f_name ] };
}




sub category_filter {
	my $self = shift;
	my $f_name = shift // $self->choke({
		err => 'missing',
		subject => 'filter'
	});

	my $filters = {
		rna => { locus_type => { like => '%RNA' } },
		pseudogene => { is_pseudogene => 'Yes' }
	};

	my %h;

	for ( @$f_name ) {
		$self->choke({
#				err => 'invalid',
#				type => 'category filter',
#				subject => $_
			err => 'not_implemented'
		}) unless defined $filters->{$_};
		%h = ( %h, %{$filters->{$_}} );
	}

	return \%h;

# 	$self->choke({
# 		err => 'invalid',
# 		type => 'category filter',
# 		subject => $f_name
# 	}) unless grep { $f_name eq $_ } @{ category_valid() };

}

sub pp_subset_default {
	return { pp_subset => 'all_proportal' };
}

sub pp_subset_valid {

	return [ qw( pro syn other pro_phage syn_phage other_phage isolate metagenome all_proportal ) ];

}


=cut filter_schema

Retrieve the schema for a dimension $f

=cut

sub filter_schema {
	my $self = shift;
	my $f = shift // $self->choke({
		err => 'missing',
		subject => 'filter schema'
	});

	log_debug { 'looking for filter schema for ' . $f };

	if ( $schema->{$f} ) {
		return $schema->{$f};
	}

	if ( ':all' eq $f ) {
		return $schema;
	}

	$self->choke({
		err => 'missing',
		subject => 'json schema for ' . $f
	});
}


=cut sql_filter

Retrieve the SQL filter for a dimension $fd

=cut

sub filter_sqlize {
	my $self = shift;
	my $filters = shift // $self->choke({
		err => 'missing',
		subject => 'filter schema'
	});

	log_debug { 'filter pre-sqlize: ' . Dumper $filters };

	my %f;
	my $h;
	if ( 'HASH' eq ref $filters ) {
		$h++;
	}

	for my $fd ( keys %$filters ) {
		if ( $schema->{$fd} && $schema->{$fd}{no_sqlize} ) {
			# skip non-SQL filters
			next;
		}
		my $fd_fn = $fd . '_filter';
		if ( $self->can( $fd_fn ) ) {
			my @f = $h
				? ( $filters->{$fd} ) # standard hash
				: $filters->get_all( $fd ); # Hash::MultiValue version

			%f = ( %f, %{ $self->$fd_fn( [ @f ] ) } );
		}
		else {
			$f{ $fd } = $filters->{$fd};
		}
	}

	log_debug { 'post-filter sqlize: ' . Dumper \%f };

	return \%f;
# 	$self->choke({
# 		err => 'missing',
# 		subject => 'json schema for ' . $f
# 	});
}

sub dataset_type_valid {
	return [ qw( isolate single_cell metagenome metatranscriptome transcriptome ) ];
}

sub dataset_type_default {
	return {};
}


1;
