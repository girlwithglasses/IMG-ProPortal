#!/usr/bin/env perl

BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	our @dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib );
}
use lib @dir_arr;
use IMG::Util::Base 'Test';
use Test::MockModule;
use SQL::Abstract::More;

use_ok( 'Vista' );

my $ani_home = Test::MockModule->new( 'Vista' );

subtest 'load Vista sets' => sub {

	my %sets = Vista::loadSets( { vista_sets_file => 't/files/vista.sets.txt' } );

	my $s2 = Vista::load_sets( { vista_sets_file => 't/files/vista.sets.txt' } );
#	say "sets: " . Dumper $s2;

	is_deeply( \%sets, $s2, 'Checking that we get the same results' ) or diag explain $s2;

	open( my $fh, '<', 't/files/vista.sets.txt' ) or die 'Cannot open file: ' . $!;
	my @ordered = sort { $a <=> $b } grep { defined $_ } map { m!^(\d+)\s+.*! ? $_ = $1 : undef $_ } <$fh>;

#	say 'ordered: ' . Dumper \@ordered;
	my @temp;
	$temp[0][0] = shift @ordered;
	for my $o ( @ordered ) {
		if ( $temp[-1][-1] + 1 == $o ) {
			# we have a sequence.
			push @{$temp[-1]}, $o;
			next;
		}
		push @temp, [ $o ];
	}

#	say 'temp: ' . Dumper \@temp;

	my $min = $ordered[0];
	my $max = $ordered[-1];
	say 'min: ' . $min . '; max: ' . $max;
	say 'range: ' . ( $max - $min ) . '; n array items: ' . scalar( @ordered );

	my $sql = SQL::Abstract::More->new();

	my @and;
	my @misc;
	for my $t ( @temp ) {
		if ( scalar @$t < 3 ) {
			push @misc, @$t;
		}
		else {
			push @and, { -between => [ $t->[0], $t->[-1] ] };
		}
	}
	push @and, { -in => [ @misc ] };


	my ($stt, @bind) = $sql->select(
		-columns => [ 'taxon_oid', 'taxon_display_name' ],
		-from => 'taxon',
		-where => {
			taxon_oid => [ -and => \@and ]
		}
	);

#	say 'statement: ' . $stt;

    say join ( "\t",
    "Gene ID",
    "Genome",
    "Original Product Name",
    "Annotated Product Name",
    "Annotated Prot Desc",
    "Annotated EC Number",
    "Annotated PUBMED ID",
    "Inference",
    "Is Pseudo Gene?",
    "Notes",
    "Annotated Gene Symbol",
    "Remove Gene from Genome?",
    "Last Modified Date" )
    . "\n";



};



done_testing();
