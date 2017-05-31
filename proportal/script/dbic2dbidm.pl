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

#	command line options:
#	--source   fromDBI || fromDBIxClass
#	--db   img_core || img_gold || img_sat  (can specify multiple values;
#                                            by default, uses all three databases)

my $args = { source => 'fromDBIxClass' };

my $opt = GetOptions( $args,
	"source|s=s",
	"db=s@"
) or script_die( 255, "Error in command line arguments" );

my $abbr = {
	'img_core' => 'IMG_Core',
	'img_gold' => 'IMG_Gold',
	'img_sat'  => 'IMG_Sat'
};

my @dbs;
if ( ! $args->{db} ) {
	@dbs = keys %$abbr;
}
else {
	@dbs = grep { defined $abbr->{$_} } @{$args->{db}};
}

if ( ! @dbs || scalar @dbs == 0 ) {
	script_die( 255, 'No databases specified!' );
}

say 'Running DBIx::DataModel generator in mode ' . $args->{source} . ' for database(s) ' . join ", ", @dbs;

for my $x ( @dbs ) {

	say 'Running schema generator for ' . $x;

	my $generator = DBIx::DataModel::Schema::Generator->new( schema => 'DataModel::' . $abbr->{$x} );

	if ( $args->{source} eq 'fromDBI' ) {
		say 'Running generator->fromDBI';

		my $conn = IMG::Util::DB::get_oracle_conn({
			database => $x,
			options => {
				RaiseError => 1,
				LongReadLen => 38000,
				LongTruncOk => 1,
			}
		});
	#	$conn->mode('fixup');

	#	$generator->fromDBI(@dbi_connection_args, $catalog, $schema, $type);
	#	$type = "'TABLE','VIEW','SYNONYM'" | 'TABLE' | etc

# In addition the following special cases may also be supported by some drivers:
#
# If the value of $catalog is '%' and $schema and $table name are empty strings, the result set contains a list of catalog names. For example:
#
# $sth = $dbh->table_info('%', '', '');
# If the value of $schema is '%' and $catalog and $table are empty strings, the result set contains a list of schema names.
# If the value of $type is '%' and $catalog, $schema, and $table are all empty strings, the result set contains a list of table types.

# In Oracle, the concept of user and schema is (currently) the same. Because database objects are owned by an user, the owner names in the data dictionary views correspond to schema names. Oracle does not support catalogues so TABLE_CAT is ignored as selection criterion.

# Search patterns are supported for TABLE_SCHEM and TABLE_NAME.

# TABLE_TYPE may contain a comma-separated list of table types.


		$generator->fromDBI( $conn->dbh, '%', 'img_sat_v440', 'TABLE' );
	}
	else {
		eval { $generator->parse_DBIx_Class('DBIC::' . $abbr->{$x} ); };
	}

	say 'Done! Perl code generated:';

	say $generator->perl_code;

}
