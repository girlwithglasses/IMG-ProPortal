#!/usr/bin/env perl

my @dir_arr;
my $dir;
BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Import 'Test';
use ProPortal::App::BioPerlConverter;

my $args = script_prep();
my $msg;


sub new_app {
	return ProPortal::App::BioPerlConverter->new(
		#config => config,
		args => shift
	);
}

my $tests = {
	error => [
{	desc => 'infile not readable',
	args => { infile => $args->{no_read_file}, outfile => $args->{read_only_file}, to => 'newick', from => 'nhx',  },
	err  => {
		err => 'not_readable',
		subject => $args->{no_read_file},
	},
},
{	desc => 'outfile not writable',
	args => { infile => $args->{infile}, outfile => $args->{read_only_file}, to => 'newick', from => 'nhx' },
	err => { err => 'not_writable', subject => $args->{read_only_file} }
},
{	desc => 'input / output are identical',
	err  => {
		err => 'different',
		a => 'The source',
		b => 'destination formats'
	},
	args => {
		infile => $args->{infile},
		outfile => $args->{outfile},
		to => 'newick',
		from => 'newick'
	}
},
{	desc => 'tree => alignment conversion',
	err => {
		err => 'same',
		a => 'The source',
		b => 'destination format types'
	},
	args => {
		infile => $args->{infile},
		outfile => $args->{outfile},
		to => 'newick',
		from => 'phylip'
	}
},
{	desc => 'invalid format',
	err => {
		err => 'invalid',
		subject => 'blob',
		type => 'format'
	},
	args => {
		infile => $args->{infile},
		outfile => $args->{outfile},
		to => 'newick',
		from => 'blob'
	}
}
]};

subtest 'args' => sub {

	subtest 'error states' => sub {

		for my $t ( @{$tests->{error}} ) {
			$msg = err( $t->{err} );
			throws_ok {
				new_app( $t->{args} )->args->mode;
			} qr[$msg], $t->{desc};
		}
	};

	subtest 'valid' => sub {
		my $module = new_app({
				infile => $args->{infile},
				outfile => $args->{outfile},
				to => 'newick',
				from => 'nhx'
			})->args->bioperl_module;
		ok( $module eq 'Bio::TreeIO', 'checking module is correct' );

		$module = new_app({
				infile => $args->{infile},
				outfile => $args->{outfile},
				to => 'clustalw',
				from => 'phylip'
			})->args->bioperl_module;
		ok( $module eq 'Bio::AlignIO', 'checking module is correct' );
	};
};


subtest 'conversion' => sub {


	subtest 'invalid' => sub {
		my ( $fh, $temp ) = tempfile(UNLINK => 1);
		# nhx to newick
		throws_ok { new_app({
			infile => $args->{clustal},
			outfile => $temp,
			to => 'clustalw',
			from => 'phylip'
		})->convert()
		} qr[BioPerl error:];

	};

	subtest 'valid' => sub {
		my ( $fh, $temp ) = tempfile(UNLINK => 1);
		# clustalw to phylip
		ok( 1 == new_app({
			infile => $args->{clustal},
			outfile => $temp,
			to => 'phylip',
			from => 'clustalw'
		})->convert(), 'Checking for successful conversion' );
		# count seqs in phylip and clustal files
		my $count;
		my $in_c = Bio::AlignIO->new(
			-file => $args->{clustal},
			-format => 'clustalw'
		);
		my $in_p = Bio::AlignIO->new(
			-file => $temp,
			-format => 'phylip'
		);
		while ( my $o = $in_c->next_aln ) {
			$count->{c}++;
		}
		while ( my $o = $in_p->next_aln ) {
			$count->{p}++;
		}
		ok( $count->{p} == $count->{c} && $count->{p} > 0, 'Checking number of sequences');

		( $fh, $temp ) = tempfile(UNLINK => 1);
		# nhx to newick
		ok( 1 == new_app({
			infile => $args->{nhx_file},
			outfile => $temp,
			to => 'newick',
			from => 'nhx'
		})->convert(), 'Checking for successful conversion' );
		my $in_nhx = Bio::TreeIO->new(
			-file => $args->{nhx_file},
			-format => 'nhx'
		);
		my $in_new = Bio::TreeIO->new(
			-file => $temp,
			-format => 'newick'
		);

		while ( my $o = $in_nhx->next_tree ) {
			$count->{nhx}+= $o->number_nodes;
		}
		while ( my $o = $in_new->next_tree ) {
			$count->{newick}+= $o->number_nodes;
		}

		# count tree nodes
		ok( $count->{nhx} == $count->{newick} && $count->{nhx} > 0, 'Checking number of nodes');


	};


};

=cut

## SCRIPT TESTS!

subtest 'galaxy script test' => sub {

	my $args = script_prep();

	script_compiles( $args->{script} );

	my $test_name = 'img_gene_id_to_fasta script';

	subtest 'errors: missing arguments' => sub {

		my ($fh, $fn) = tempfile();

		$test_name = 'script run with no newick file specified';
		script_runs([ $args->{script}, '--outfile', $args->{outfile} ], { exit => 1 }, $test_name );
		script_stderr_like qr/No input file specified/, $test_name;

		$test_name = 'input file does not exist';
		script_runs([ $args->{script}, '--infile', 'made_up_file' ], { exit => 1 }, $test_name );
		script_stderr_like qr[Input file made_up_file does not exist], $test_name;

		$test_name = 'invalid sequence type argument';
		script_runs([ $args->{script}, '--infile', $fn, '--seq_type', 'DNA' ], { exit => 1 }, $test_name );
		script_stderr_like qr[Invalid seq_type argument], $test_name;

		$test_name = 'invalid sequence type, no input file';
		script_runs([ $args->{script}, qw( --infile made_up_file --seq_type DNA ) ], { exit => 1 }, $test_name );
		script_stderr_like qr[Input file made_up_file does not exist.*?\s+Invalid seq_type argument], $test_name;

		$test_name = 'specified output file does not exist';
		script_runs([ $args->{script}, '--infile', $fn, '--outfile', 'does_not_exist',  '--seq_type', 'FNA'], { exit => 1 }, $test_name );
		script_stderr_like qr[Output file does_not_exist is not writable], $test_name;

		# TODO!
#		$test_name = 'output file is read-only';

	};


	subtest 'script run with errors' => sub {

		my ($fh, $fn) = tempfile();

		$test_name = 'Error: no gene IDs';
		# No gene IDs
		script_runs( [ $args->{script}, '--infile', $fn, '--outfile', $args->{outfile}, '--test' ], { exit => 1 }, $test_name );

		script_stderr_like( qr[No gene IDs supplied], $test_name );

		# No gene IDs
		$test_name .= ', short args';
		script_runs( [ $args->{script}, '-i', $fn, '-o', $args->{outfile}, '-t' ], { exit => 1 }, $test_name );

		script_stderr_like( qr[No gene IDs supplied], $test_name );

		# invalid gene IDs
		$test_name = 'Invalid gene IDs';
		script_runs( [ $args->{script}, '--infile', $args->{invalid}, '--outfile', $args->{outfile}, '--test' ], { exit => 1 }, $test_name );

		script_stderr_like( qr[No gene IDs supplied], $test_name );

		$test_name .= ', short args';
		script_runs( [ $args->{script}, '-i', $args->{invalid}, '-o', $args->{outfile}, '-t' ], { exit => 1 }, $test_name );

		script_stderr_like( qr[No gene IDs supplied], $test_name );

		# invalid gene IDs
		$test_name = 'The query for genes returned no results';
		script_runs( [ $args->{script}, '--infile', $args->{not_fnd}, '--outfile', $args->{outfile}, '--test' ], { exit => 1 }, $test_name );

		script_stderr_like( qr[The query for genes returned no results], $test_name );

		$test_name .= ', short args';
		script_runs( [ $args->{script}, '-i', $args->{not_fnd}, '-o', $args->{outfile}, '-t' ], { exit => 1 }, $test_name );

		script_stderr_like( qr[The query for genes returned no results], $test_name );

		# missing gene IDs in the DB
		$test_name = 'Missing gene IDs';
		script_runs( [ $args->{script}, '--infile', $args->{missing}, '--outfile', $args->{outfile}, '--test' ], { exit => 1 }, $test_name );

		script_stderr_like( qr/The following gene IDs returned no results:\s+666/, $test_name );

		# files don't exist
		$test_name = 'Sequence files missing';
		script_runs( [ $args->{script}, '--infile', $args->{no_files}, '--outfile', $args->{outfile}, '--test' ], { exit => 1 }, $test_name );
		script_stderr_like( qr[Could not read file .*? No such file or directory], $test_name );

		# missing all sequence files
		$test_name = 'No sequences found';
		script_runs( [ $args->{script}, '--infile', $args->{no_seqs}, '--outfile', $args->{outfile}, '--test' ], { exit => 1 }, $test_name );
		script_stderr_like( qr[The query for sequences returned no results], $test_name );

		# some results missing
		script_runs( [ $args->{script}, '--infile', $args->{missing_seqs}, '--outfile', $args->{outfile}, '--test' ], { exit => 1 }, $test_name );
		script_stderr_like( qr[The following sequences returned no results:\s+2504649900,\s+2504649902], $test_name );


	};


	subtest 'successful script run' => sub {

		$test_name = 'successful run, fna';
		script_runs( [ $args->{script}, '--infile', $args->{infile}, '--outfile', $args->{outfile}, '--test' ], $test_name );

		script_stdout_is $args->{outfile}, $test_name;

		my $expect = fasta_hash_from_input({ -string => all_results_fna() });
		my $result = fasta_hash_from_input({ -file => $args->{outfile} });

		is_deeply( $result, $expect, 'checking generated FNA file' );

#		script_stderr_is '', $test_name;

		$test_name = 'successful run, faa';
		script_runs( [ $args->{script}, '--infile', $args->{infile}, '--outfile', $args->{outfile}, '--seq_type', 'FAA', '--test' ], $test_name );

		script_stdout_is $args->{outfile}, $test_name;

		$expect = fasta_hash_from_input({ -string => all_results_faa() });
		$result = fasta_hash_from_input({ -file => $args->{outfile} });

		is_deeply( $result, $expect, 'checking generated FAA file' );



	};


};

=cut

done_testing();

sub script_prep {

	my ( $fh1, $outfile ) = tempfile(UNLINK => 1);
	my ( $fh2, $infile )  = tempfile(UNLINK => 1);
	my $test_file_dir = catdir( $dir, 'proportal/t/files/' );
	return {
		script  		=> 'script/bioperl_converter.pl',
		outfile 		=> $outfile,
		infile  		=> $infile,
		not_found		=> 'made_up_file',
		read_only_file	=> read_only_file(),
		no_read_file	=> no_read_file(),
		nhx_file		=> $test_file_dir . '/testtree.nhx',
		phylip =>		=> $test_file_dir . '/testaln.phylip',
		clustal =>		=> $test_file_dir . '/testaln.clustalw'
	};
}

sub read_only_file {

	my ($fh, $filename) = tempfile(UNLINK => 1);
	chmod 0400, $filename;
	return $filename;

}

sub no_read_file {

	my ($fh, $filename) = tempfile(UNLINK => 1);
	chmod 0100, $filename;
	return $filename;

}

sub make_file {

	my $to_do = shift;
	my ($fh, $fn) = tempfile();
	print { $fh } $to_do->();
	return $fn;

}
