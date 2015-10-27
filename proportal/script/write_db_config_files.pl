#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';
use Data::Dumper;

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";
use File::Basename;

use IMG::Util::DB;
my $base = dirname( $Bin );

my $cfg = IMG::Util::DB::get_oracle_cfg_files;

for my $d (keys %$cfg) {
	# read in the env files
	my $p = IMG::Util::DB::get_oracle_connection_params({ database => $d });
	IMG::Util::DB::write_oracle_connection_params( $base . "/environments/" . $d . ".json", $p );

}

=head2 write_db_config_files.pl

Create JSON files with the DB connection params in them

Files go in $base/environments/<dbname>.json

Existing files are overwritten without a second thought

=cut
