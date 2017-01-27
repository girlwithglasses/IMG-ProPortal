#!/usr/bin/env perl

my $dir;
my @dir_arr;
BEGIN {
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib );
}
use lib @dir_arr;

use IMG::Util::Import;
use File::Path qw( make_path );

use File::Basename;

use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use SQL::Translator;
use IMG::Util::DB;

=head2 generate_schema.pl

Generate the database schema using DBIx::Class

Files will be generated in the 'tmp' dir

usage:

generate the DBIx::Class schema:

	perl generate_schema.pl

=cut

my $dbs = {
	'img_core' => { constraint => qr/^(cancelled|contact|taxon$|gene^|gold.+|img.+)/i },
	'img_gold' => { constraint => qr/^(cancelled|contact|gold|img)_*/i },
};

my $lib_dir = "$dir/tmp/";

for my $x (keys %$dbs) {
	$dbs->{$x}{conn} = IMG::Util::DB::get_oracle_connection_params({ database => $x });
	create_dbix_class_schema( $x );

}

sub create_dbix_class_schema {
	my $d = shift;

	my $dir = $lib_dir . '/' . $d;
	say "Running DBIx::Class schema generator";
	make_path( $dir . '/DBIC/' );

	say "dir: $dir";

	if (! -e $dir . "/DBIC/Schema.pm" ) {
		write_schema_pm( $dir );
	}

	my $class = 'DBIC::IMG_Core';
	if ($d eq 'img_gold') {
		$class = 'DBIC::IMG_Gold';
	}
	make_schema_at(
		$class,
		{	debug => 1,
			dump_directory => $dir,
			result_base_class => 'DBIC::Schema',
			constraint => $dbs->{$d}{constraint},
		},
		[	$dbs->{$d}{conn}{dsn},
			$dbs->{$d}{conn}{username},
			$dbs->{$d}{conn}{password},
		],
	);

	say "Finished running DBIC schema generator";
}

sub write_schema_pm {
	my $dir = shift;
	open(my $fh, ">", $dir . '/DBIC/Schema.pm') or die "Could not open output file " . $dir . '/DBIC/Schema.pm' . ": $!";
	print { $fh } join "\n", ( 'package DBIC::Schema;', 'use base "DBIx::Class::Core";', '1;' );
	return;
}

