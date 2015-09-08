#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use IMG::Util::Base 'Test';

my $base = dirname( $FindBin::Bin );

use Config::Any;
use DBI;

#use DataModel::IMG_Core;

use_ok( 'DataModel::IMG_Core' );

use_ok( 'ProPortal::IO::DBIxDataModel' );

my $cfg = $base . '/environments/development';

my $conf = Config::Any->load_stems( { stems => [ $cfg ], use_ext => 1, flatten_to_hash => 1 } );


if (scalar keys %$conf == 1) {
#	my @arr = values %$conf;
#	$conf = $arr[0];
	$conf = ( values %$conf )[0];
}

my $db = $conf->{plugins}{Database};

my $dbh = DBI->connect(
	# dsn
	'dbi:' . $db->{driver} . ':' . $db->{database},
	# user, pass
	$conf->{plugins}{Database}{user} || $conf->{plugins}{Database}{username} || undef,
	$conf->{plugins}{Database}{password} || undef,
	# options
	{ RaiseError => 1 }
	)

or die "Could not connect: $DBI::errstr";

DataModel::IMG_Core->dbh( $dbh );
subtest 'checking GoldTaxon view' => sub {

	my @cols = qw( taxon_display_name taxon_oid family ecosystem_subtype genome_type );
	my @order = qw( genome_type ecosystem_subtype taxon_display_name );
	my $where = { is_public => 'Yes', obsolete_flag => 'No', family => { '!=', 'unclassified' };
	my $stt = DataModel::IMG_Core
			->join( qw/GoldSequencingProject <=> taxa/)
			->select(
				-columns  => [ @cols ],
				-where    => {
					ecosystem_type => 'Marine',
				},
	#			-order_by => [ @order ],
				-result_as => 'statement',
			);
	$stt->refine(-where => $where, -order_by => [ @order ]);

	# set up a view.
	my $stt2 = DataModel::IMG_Core->table('GoldTaxon')
		->select(
				-columns  => [ @cols ],
				-where    => {
					ecosystem_type => 'Marine',
					%$where,
				},
				-order_by => [ @order ],
			);

	is_deeply( $stt->all, $stt2, "Checking refined results using a view are equal");

};
#
subtest 'checking filters' => sub {



};

done_testing();

