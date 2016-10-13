package TestUtils;

use IMG::Util::Base;

use Acme::Damn;
use Scalar::Util qw[ blessed ];
use File::Temp qw[ tempfile ];
use parent qw[ Exporter ];

our @ISA = qw[ Exporter ];

our @EXPORT_OK = qw( clean_db_output test_ro_file test_wo_file test_make_file test_err );  # symbols to export on request

our %EXPORT_TAGS = ( all => \@EXPORT_OK );


# remove the gubbins from the db results from DBIx::DataModel
sub clean_db_output {
	my $out = shift;

	if (! blessed $out && ref $out && 'ARRAY' eq ref $out ) {
		return [ map { clean_db_output( $_ ) } @$out ];
	}

	if ( blessed( $out ) ) {
		$out = damn($out);
	}

	if ( ref $out && 'HASH' eq ref $out ) {
		delete $out->{__schema} if $out->{__schema};
	}
	return $out;
}

sub test_ro_file {

	(undef, my $fn) = tempfile( UNLINK => 1 );
	chmod 0400, $fn;
	return $fn;

}

sub test_wo_file {

	(undef, my $fn) = tempfile( UNLINK => 1 );
	chmod 0200, $fn;
	return $fn;

}

sub test_make_file {

	my $to_do = shift;
	my ($fh, $fn) = tempfile( UNLINK => 1 );
	print { $fh } $to_do->();
	return $fn;

}

# 	$msg = err({
# 		err => 'missing',
# 		subject => 'blob'
# 	});

sub test_err {

	local $@;
	my $rtn = eval { err( @_ ) };
	return $rtn unless ref $rtn;
	return $rtn->{message};

}

1;
