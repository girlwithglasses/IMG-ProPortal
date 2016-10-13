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
use IMG::Util::Base 'Test';
use Text::CSV_XS qw( csv );

use_ok('IMG::Util::FileAppender');

{
	package TestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App';
	with qw(
		IMG::Util::FileAppender
	);

	1;
}

{
	package OtherTestApp;
	use IMG::Util::Base 'Class';
	extends 'IMG::App';
	with qw(
		IMG::Util::FileAppender
	);

	1;
}


my $files_dir = catdir( $dir, 'proportal/t/files' );
my $msg;
my $args = {
	ro_file => test_ro_file(),
	wo_file => test_wo_file(),
	tsv => catfile( $dir, 'proportal/t/files', 'gene_cart.tsv' ),
	tsv_compos => catfile( $dir, 'proportal/t/files/gene_cart-compos.tsv' ),
	tsv_hdrs => [ qw( gene_oid locus_tag desc desc_orig taxon_oid taxon_display_name batch_id scaffold_oid ) ],
	hdr_file => catfile( $dir, 'proportal/t/files', 'headers.tsv' ),
};


my $arr = [
['cyclophilin-type peptidyl-prolyl cis-trans isomerase', 637000210, 'ctppcti'],
['Cyclophilin-type peptidyl-prolyl cis-trans isomerase', 637000211, 'Ctppcti'],
['cyclophilin-type peptidyl-prolyl cis-trans isomerase', 637000212, 'ctppcti'],
['FKBP-type peptidyl-prolyl cis-trans isomerase (PPIase)', 637000211, 'FtppctiP'],
['FKBP-type peptidyl-prolyl cis-trans isomerase (PPIase)', 637000212, 'FtppctiP'],
['peptidyl-prolyl cis-trans isomerase', 637000212, 'ppcti'],
['Peptidyl-prolyl cis-trans isomerase', 637000213, 'Ppcti'],
['putative Peptidyl-prolyl cis-trans isomerase (rotamase) - cyclophilin family', 637000212, 'pPpctir']];

my @arr_hdrs = ( qw( desc taxon_oid abbrev ) );
for my $line (@$arr) {
	$args->{tsv_compos_data}{ $line->[0] . "\0" . $line->[1] } = { abbrev => $line->[2] };
	my %hash = ();
	@hash{ @arr_hdrs } = @$line;
	push @{$args->{tsv_compos_data_arr}}, \%hash;
}

sub prep_data_from_file {
	my $f = shift;
	my $ix = shift;

	my $reading = csv(
		in => catfile( $dir, 'proportal/t/files/', 'gene_cart-' . $f . '.tsv' ),
		headers => 'auto',
		sep => "\t"
	);

	for my $r ( @$reading ) {
		$args->{'tsv_' . $f . '_rslts'}{ $ix->($r) } = $r;
	}
}

my $data_to_prep = {
	latlong => sub {
		return shift->{taxon_oid};
	},
	compos => sub {
		my $h = shift;
		return $h->{desc} . "\0" . $h->{taxon_oid};
	}
};

for my $d ( keys %$data_to_prep ) {
	prep_data_from_file( $d, $data_to_prep->{$d} );
}

my $tests;

$tests->{instantiation} = {

error => [
# Instantiation errors
{	err => { err => 'missing', subject => 'required input file columns' },
	args => {},
	desc => 'no cols specified'
},
{	err => { err => 'missing', subject => 'CSV input file' },
	args => { cols_reqd => [ qw( blob ) ] },
	desc => 'missing CSV input file',
},
{	err => { err => 'not_readable', subject => $args->{wo_file} },
	args => {
		cols_reqd => [ qw( blob ) ],
		csv_input_file => $args->{wo_file},
		csv_output_file => $args->{ro_file}
	},
	desc => 'input file is not readable',
},
{	err => { err => 'module_err', subject => 'Text::CSV_XS', msg => 'INI - the header is empty' },
	args => {
		cols_reqd => [ qw( blob ) ],
		csv_input_file => $args->{ro_file},
		csv_output_file => $args->{ro_file},
	},
	desc => 'problem parsing headers',
},
{	err => {
		err => 'not_found_in_file',
		file => $args->{tsv},
		subject => 'column header(s) blob'
	},
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'blob' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	desc => 'missing headers in csv file'
},
{	err => {
		err => 'not_found_in_file',
		file => $args->{tsv},
		subject => 'column header(s) blob'
	},
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'gene_oid', 'desc', 'blob' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	desc => 'missing headers in csv file'
},
], # end error

valid => [
{	desc => 'valid data, single col, not unique',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'taxon_display_name', 'taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	headers => $args->{tsv_hdrs},
	rslts => $args->{tsv_hdrs},
},
],
	fn => sub {
		return shift->headers;
	}
};  # end instantiation

$tests->{extract} = {
error => [
{	desc => 'empty file (headers present)',
	args => {
		csv_input_file => $args->{hdr_file},
		cols_reqd => [ 'gene_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	fn => sub {
		my $rtn = shift->extract;
		if ( ! @$rtn ) {
			die err({
				err => 'missing',
				subject => 'stuff returned by extract'
			});
		}
	},
	err => { err => 'missing', subject => 'stuff returned by extract' }
}
],
valid => [
{	desc => 'valid data, single col, all unique',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'gene_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	headers => $args->{tsv_hdrs},
	rslts => [ 637447396, 637441362, 637687628, 637797782, 637446700, 637687175, 637688278, 637447871, 637796528, 637687726, 637440421, 637441674, 637447026, 637688228 ],
},
{	desc => 'valid data, single col, not unique',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	headers => $args->{tsv_hdrs},
	rslts => [ 637000211, 637000213, 637000212, 637000210 ]
},
{	desc => 'valid data, two cols',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'locus_tag','taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	headers => $args->{tsv_hdrs},
	rslts => [ map { join "\0", reverse @$_ } (
[ 637000210, 'PMT9312_0025' ],
[ 637000210, 'PMT9312_1254' ],
[ 637000211, 'PMT0030' ],
[ 637000211, 'PMT0341' ],
[ 637000211, 'PMT0707' ],
[ 637000211, 'PMT1177' ],
[ 637000212, 'PMN2A_0316' ],
[ 637000212, 'PMN2A_0765' ],
[ 637000212, 'PMN2A_0860' ],
[ 637000212, 'PMN2A_1352' ],
[ 637000212, 'PMN2A_1403' ],
[ 637000213, 'Pro0025' ],
[ 637000213, 'Pro0942' ],
[ 637000213, 'Pro1252' ] ) ]
}
	], # end valid
	fn => sub {
		return shift->extract;
	},
}; # end extract

$tests->{reintegrate} = {

	error => [

{	desc => 'no data',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'locus_tag','taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" }
	},
	err => { err => 'missing', subject => 'data' }
}
	], # end error
	valid => [
{	desc => 'single col, multiple entries per col value',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" },
	},
	data => {
		637000210 =>
		{ taxon_oid => 637000210, lat => 10, long => 99 },
		637000211 =>
		{ taxon_oid => 637000211, lat => 11, long => 89 },
		637000212 =>
		{ taxon_oid => 637000212, lat => 12, long => 79 },
		637000213 =>
		{ taxon_oid => 637000213, lat => 13, long => 69 },
	},
#	dump_rslts => 1,
	rslts => $args->{tsv_latlong_rslts}
},
{	desc => 'composite col',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'desc', 'taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" },
	},
	data => $args->{tsv_compos_data},
	dump_rslts => 1,
	rslts => $args->{tsv_compos_rslts}
},
{	desc => 'single col, data array',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" },
	},
	data_arr => [
		{ taxon_oid => 637000210, lat => 10, long => 99 },
		{ taxon_oid => 637000211, lat => 11, long => 89 },
		{ taxon_oid => 637000212, lat => 12, long => 79 },
		{ taxon_oid => 637000213, lat => 13, long => 69 },
	],
	dump_rslts => 1,
	rslts => $args->{tsv_latlong_rslts}
},
{	desc => 'composite col',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'desc', 'taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" },
	},
	data_arr => $args->{tsv_compos_data_arr},
	dump_rslts => 1,
	rslts => $args->{tsv_compos_rslts}
},


	], # end valid
	fn => sub {
		my $app = shift;
		my $arg_h = shift;
		$app->extract;
#		say 'lines: ' . Dumper $app->lines;
		say 'data: ' . Dumper $arg_h->{data};
		my $out = $app->reintegrate( $arg_h );
		my $h;
		my $ix_by = $app->index_by;
		for ( @$out ) {
			$h->{ $ix_by->( $_ ) } = $_;
		}
		return $h;
	},
};

$tests->{expel} = {
	error => [

{	desc => 'ro output file',
	args => {
		csv_input_file => $args->{tsv},
		cols_reqd => [ 'taxon_oid' ],
		csv_output_file => $args->{ro_file},
		csv_args => { sep => "\t" },
		data_arr => [
			{ taxon_oid => 637000210, lat => 10, long => 99 },
			{ taxon_oid => 637000211, lat => 11, long => 89 },
			{ taxon_oid => 637000212, lat => 12, long => 79 },
			{ taxon_oid => 637000213, lat => 13, long => 69 },
		],
	},
	err => { err => 'not_writable', subject => $args->{ro_file} }
}


	],
	valid => [

	],
	fn => sub {
		my $app = shift;
		my $arg_h = shift;

	}
};

$tests->{all} = {





};

my @test_order = qw( instantiation extract reintegrate );

sub run_invalid_test {
	my $args = shift;
	my $t_app = TestApp->new( $args->{args} );
	return $args->{fn}->( $t_app, $args );
}


sub run_valid_test {
	my $args = shift;
	my $t_app = TestApp->new( $args->{args} );
	say $args->{desc};
	my $rslts = $args->{fn}->( $t_app, $args );
#	say 'args: ' . Dumper $args;
#	say 'rslts: ' . Dumper $rslts if $args->{dump_rslts};
	is_deeply(
		$t_app->headers,
		[ qw( gene_oid locus_tag desc desc_orig taxon_oid taxon_display_name batch_id scaffold_oid ) ],
		'testing headers'
	) or diag explain $t_app->headers;

	if ( 'ARRAY' eq ref $rslts ) {
		is_deeply(
			[ sort @$rslts ], # got
			[ sort @{$args->{rslts}} ], # expected
			'testing results'
		) or diag explain [ sort @$rslts ], [ sort @{$args->{rslts}} ];
	}
	else {
		is_deeply(
			$rslts,
			$args->{rslts},
			'testing results'
		) or diag explain $rslts, $args->{rslts};
	}
#	say 'lines: ' . Dumper $t_app->lines;
# 	is_deeply(
# 		$t_app->lines,
# 		$args->{lines},
# 		'testing stored lines'
# 	) or diag explain $t_app->lines;
}


for my $ti ( @test_order ) {
	subtest $ti => sub {
		if ( scalar @{$tests->{$ti}{error}} ) {

		subtest 'error states' => sub {
			for my $t ( @{$tests->{$ti}{error}} ) {
				$msg = err( $t->{err} );
				throws_ok {
					run_invalid_test({ fn => $tests->{$ti}{fn}, %$t });
				} qr[$msg];
			}
		};

		}

		if ( scalar @{$tests->{$ti}{valid}} ) {

		subtest 'valid' => sub {
			for my $t ( @{$tests->{$ti}{valid}} ) {
				run_valid_test({ fn => $tests->{$ti}{fn}, %$t });
			}
		};

		}
	};
}


done_testing();
