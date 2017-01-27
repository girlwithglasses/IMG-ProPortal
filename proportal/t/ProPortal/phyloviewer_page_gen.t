#!/usr/bin/env perl

my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'testing';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}

use lib @dir_arr;
use IMG::Util::Import 'Test';
use Dancer2;

use ProPortal::Controller::PhyloViewer::DemoData;
use Bio::TreeIO;
{
	package PhyloViewerApp;
	use IMG::Util::Import 'Class';
	use Dancer2;
	extends 'IMG::App';
	with qw( ProPortal::IO::DBIxDataModel ProPortal::Controller::PhyloViewer::Pipeline IMG::App::Role::Templater );

	has 'controller_role' => (
		is => 'ro',
	);

	1;

}


my $args = script_prep();
my $app = PhyloViewerApp->new( config => config, controller_role => 'PhyloViewer::Results' );
my $msg;


subtest 'render' => sub {

	# TODO


};

## SCRIPT TESTS!
=cut
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

	my ( $fh, $outfile ) = tempfile();

	return {
		script          => 'script/phyloviewer_page_gen.pl',
		read_only_file  => read_only_file(),
		newick          => make_file( \&ProPortal::Controller::PhyloViewer::DemoData::newick ),
		gene_taxon_file => make_file( \&make_gt_file ),
		part_newick     => make_file( \&part_newick ),
#		not_fnd  => make_file( \&not_fnd ),
#		missing  => make_file( \&missing_genes ),
#		no_seqs  => make_file( \&no_seqs ),
#		no_files => make_file( \&no_files ),
#		missing_seqs => make_file( \&missing_seqs ),
		gp_arr   => gene_taxon_file(),
		outfile  => $outfile
	};
}

sub read_only_file {

	my ($fh, $filename) = tempfile(UNLINK => 1);
	chmod 0400, $filename;
	return $filename;

}

sub make_gt_file {

	my $arr = ProPortal::Controller::PhyloViewer::DemoData::gene_taxon_arr();
	my $str = join "\n", map { $_->{gene_oid} . "\t" . $_->{taxon_oid} } @{ $arr };
	say 'gene taxon arr: ' . Dumper $str;

	return $str;

}

sub gene_taxon_file {
	return [
{ gene_oid => 637449936, taxon_oid => 637000214 },
{ gene_oid => 637686994, taxon_oid => 637000212 },
{ gene_oid => 640078650, taxon_oid => 640069321 },
{ gene_oid => 640080686, taxon_oid => 640069324 },
{ gene_oid => 640087144, taxon_oid => 640069323 },
{ gene_oid => 640160519, taxon_oid => 640069322 },
{ gene_oid => 640943573, taxon_oid => 640753041 },
{ gene_oid => 647673898, taxon_oid => 647533199 },
{ gene_oid => 2553536569, taxon_oid => 2551306553 },
{ gene_oid => 2553547864, taxon_oid => 2551306560 },
{ gene_oid => 2607022457, taxon_oid => 2606217312 },
{ gene_oid => 2607024285, taxon_oid => 2606217313 },
{ gene_oid => 2607027401, taxon_oid => 2606217314 },
{ gene_oid => 2607028865, taxon_oid => 2606217315 },
{ gene_oid => 2607031065, taxon_oid => 2606217316 },
{ gene_oid => 2607035406, taxon_oid => 2606217318 },
{ gene_oid => 2607361738, taxon_oid => 2606217419 },
{ gene_oid => 2607807999, taxon_oid => 2606217555 },
{ gene_oid => 2607811795, taxon_oid => 2606217557 },
{ gene_oid => 2607814158, taxon_oid => 2606217558 },
{ gene_oid => 2607816045, taxon_oid => 2606217559 },
{ gene_oid => 2607817870, taxon_oid => 2606217560 },
{ gene_oid => 2607980288, taxon_oid => 2606217606 },
{ gene_oid => 2608168136, taxon_oid => 2606217667 },
{ gene_oid => 2608172107, taxon_oid => 2606217668 },
{ gene_oid => 2608172520, taxon_oid => 2606217669 },
{ gene_oid => 2608199767, taxon_oid => 2606217677 },
{ gene_oid => 2608208874, taxon_oid => 2606217679 },
{ gene_oid => 2608211019, taxon_oid => 2606217680 },
{ gene_oid => 2608213837, taxon_oid => 2606217681 },
{ gene_oid => 2608216457, taxon_oid => 2606217682 },
{ gene_oid => 2608217268, taxon_oid => 2606217683 },
{ gene_oid => 2608221109, taxon_oid => 2606217684 },
{ gene_oid => 2608227678, taxon_oid => 2606217688 },
{ gene_oid => 2608229857, taxon_oid => 2606217689 },
{ gene_oid => 2608232869, taxon_oid => 2606217690 },
{ gene_oid => 2608233838, taxon_oid => 2606217691 },
{ gene_oid => 2608236697, taxon_oid => 2606217692 },
{ gene_oid => 2624147685, taxon_oid => 2623620345 },
{ gene_oid => 2624149569, taxon_oid => 2623620346 },
{ gene_oid => 2624151930, taxon_oid => 2623620347 },
{ gene_oid => 2624154139, taxon_oid => 2623620348 },
{ gene_oid => 2626312088, taxon_oid => 2623620961 },
{ gene_oid => 2626314409, taxon_oid => 2623620962 },
{ gene_oid => 2626316849, taxon_oid => 2623620963 },
{ gene_oid => 2626399128, taxon_oid => 2623620984 },
];

}

sub part_newick {
	return '( ( ( ( ( ( ( ( 2553536569:0.04806, 2553547864:0.02318) :0.13790, ( ( 2607817870:0.06292, ( ( 637686994:0.00904, 2607361738:0.00877) :0.00237, ( 2607811795:0.00000, 2624154139:0.00000) :0.01417) :0.04807) :0.11480, ( ( ( ( ( ( 640087144:0.00000, 2608168136:0.00000) :0.00000, 2624151930:0.00000) :0.00000, 2626314409:0.00000) :0.01710, ( ( 2608213837:0.00000, 2608216457:0.00000) :0.00000, 2608221109:0.00000) :0.02405) :0.19430, 2607807999:0.14371) :0.03774, ( ( 2607024285:0.00000, 2607027401:0.00000) :0.00000, 2607028865:0.00000) :0.15988) :0.01777) :0.06318) :0.04989, ( ( 637449936:0.00000, 2608229857:0.00000) :0.07062, ( ( ( 640080686:0.00000, 2608172520:0.00000) :0.00000, 2624147685:0.00000) :0.00000, 2626316849:0.00000) :0.07352) :0.0407';
}

sub newick {
	return '( ( ( ( ( ( ( ( 2553536569:0.04806, 2553547864:0.02318) :0.13790, ( ( 2607817870:0.06292, ( ( 637686994:0.00904, 2607361738:0.00877) :0.00237, ( 2607811795:0.00000, 2624154139:0.00000) :0.01417) :0.04807) :0.11480, ( ( ( ( ( ( 640087144:0.00000, 2608168136:0.00000) :0.00000, 2624151930:0.00000) :0.00000, 2626314409:0.00000) :0.01710, ( ( 2608213837:0.00000, 2608216457:0.00000) :0.00000, 2608221109:0.00000) :0.02405) :0.19430, 2607807999:0.14371) :0.03774, ( ( 2607024285:0.00000, 2607027401:0.00000) :0.00000, 2607028865:0.00000) :0.15988) :0.01777) :0.06318) :0.04989, ( ( 637449936:0.00000, 2608229857:0.00000) :0.07062, ( ( ( 640080686:0.00000, 2608172520:0.00000) :0.00000, 2624147685:0.00000) :0.00000, 2626316849:0.00000) :0.07352) :0.04076) :0.05631, ( ( ( 2607035406:0.00000, 2608232869:0.00000) :0.00000, 2608236697:0.00000) :0.05689, ( 2608211019:0.05840, 2608233838:0.03815) :0.00863) :0.00299) :0.01776, 2608227678:0.02635) :0.00949, 2608199767:0.02571) :0.00179, ( ( 640943573:0.00000, 2607816045:0.00000) :0.00474, ( ( 647673898:0.00000, 2608172107:0.00000) :0.00000, 2626399128:0.00000) :0.00675) :0.01606) :0.00164, ( ( 2607980288:0.04953, ( ( 2607031065:0.00000, 2608208874:0.00000) :0.00000, 2608217268:0.00000) :0.02254) :0.00228, 2607022457:0.01276) :0.00073, ( ( 640078650:0.00000, 2624149569:0.00000) :0.01460, ( ( 640160519:0.00000, 2607814158:0.00000) :0.00000, 2626312088:0.00000) :0.01298) :0.00794)';
}

sub make_file {

	my $to_do = shift;
	my ($fh, $fn) = tempfile();
	print { $fh } $to_do->();
	return $fn;

}

sub tax_arr {
	return [ qw( 637000212 637000214 640069321 640069322 640069323 640069324 640753041 647533199 2551306553 2551306560 2606217312 2606217313 2606217314 2606217315 2606217316 2606217318 2606217419 2606217559 2606217560 2606217606 2606217677 2606217679 2606217680 2606217681 2606217682 2606217683 2606217684 2606217688 2606217689 2606217690 2606217691 2606217692 2623620345 2623620348 2623620961 2623620962 2623620984 ) ];
}
