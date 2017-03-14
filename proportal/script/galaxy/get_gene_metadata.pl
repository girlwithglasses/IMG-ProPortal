#!/usr/bin/env perl

my @dir_arr;
BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	my $dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib );
}

use lib @dir_arr;
use IMG::Util::Import;
use Dancer2;
use IMG::App::Role::ErrorMessages qw( script_die );
use ProPortal::App::GetGeneMetadata;
use Getopt::Long;

my $args = {};
my $opt = GetOptions( $args,
	"outfile|o=s",
	"infile|i=s",
	"infile_format|f=s",
	"test|t"         # flag for test mode
) or script_die( 255, "Error in command line arguments" );

if ( ! $args->{infile_format} || 'arr' eq $args->{infile_format} ) {
	# prepend the file with 'gene_oid'
	my $cmd_arr = [ 'echo "gene_oid" | cat -', $args->{infile}, '>', $args->{infile} . '.new' ];
	system( join " ", @$cmd_arr ) == 0 or script_die( 255, [ "system @$_ failed: $?" ] );
	$args->{infile_format} = 'tsv';
	$args->{infile} .= '.new';
}

local $@;

eval {
	ProPortal::App::GetGeneMetadata->new(
		dancer_config => config,
		args => $args,
	)->run();
};

script_die( 255, [ $@ ] ) if $@;

exit(0);
