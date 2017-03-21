#!/usr/bin/env perl

my @dir_arr;
my $dir;
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
use IMG::Util::DB;
use DBIx::DataModel::Schema::Generator;
use DBIC::IMG_Core;
use Carp::Always;
use Getopt::Long;

my $args = { source => 'fromDBIxClass' };
my $opt = GetOptions( $args,
	"source|s=s",
#	"test|t"         # flag for test mode
) or script_die( 255, "Error in command line arguments" );

# options for 'source': --fromDBI || --fromDBIxClass

# {
#   dsn => "dbi:Oracle:gemini1_shared",
#   password => "imgCoreC0sM0s1",
#   username => "img_core_v400"
# }
# {
#   dsn => "dbi:Oracle:imgiprd",
#   password => "Tuesday",
#   username => "imgsg_dev"
# }

my $dbs = {
	'img_core' => 'DataModel::IMG_Core',
	'img_gold' => 'DataModel::IMG_Gold'
};

for my $x ( keys %$dbs ) {

	say 'Running schema generator for ' . $x;

	my $generator = DBIx::DataModel::Schema::Generator->new( schema => $dbs->{$x} );

	if ( $args->{fromDBI} ) {
		say 'Running generator->fromDBI';
		my $dbh = IMG::Util::DB::get_oracle_dbh({
			database => $x,
			options => {
				RaiseError => 1,
	#			FetchHashKeyName => 'NAME_lc'
				LongReadLen => 38000,
				LongTruncOk => 1
			}
		});

		$generator->fromDBI( $dbh );
	}
	else {
		eval { $generator->parse_DBIx_Class('DBIC::IMG_Core'); };
	}

	say 'Done! Perl code generated:';

	say $generator->perl_code;

}


# $generator->parse_DBI($dbh);
#
# my $gen = DBIx::DataModel::Schema::Generator->new( schema => 'DataModel::IMG_Core');
#
# local $@;
#
#
# die $@ if $@;
#
# say $gen->perl_code;
