#!/usr/bin/env perl

my $dir;
my @dir_arr;

BEGIN {
	$ENV{'DANCER_ENVIRONMENT'} = 'proportal-dev';
	use File::Spec::Functions qw( rel2abs catdir );
	use File::Basename qw( dirname basename );
	$dir = dirname( rel2abs( $0 ) );
	while ( 'webUI' ne basename( $dir ) ) {
		$dir = dirname( $dir );
	}
	@dir_arr = map { catdir( $dir, $_ ) } qw( webui.cgi proportal/lib proportal/t/lib install );
}

use lib @dir_arr;
use Dancer2;
use IMG::Util::Logger;
use IMG::Util::Import 'Test';
require 'WebConfig-img-dev-mer.pm';

my $config = WebConfig::getEnv();
# say Dumper 'WebConfig-img-dev: ' . $config;

# say 'config: ' . Dumper config->{plugins}{Adapter}{img_app}{options}{config};

my $str = dump_diff( $config, config->{plugins}{Adapter}{img_app}{options}{config} );
say $str;

is_deeply( $config, config->{plugins}{Adapter}{img_app}{options}{config}, 'Checking config' );

my $cfg = config;
delete $cfg->{plugins};

say 'config: ' . Dumper $cfg;


done_testing();

sub dump_diff
{
  my ( $one , $two , $opt ) = @_;

  local $Data::Dumper::Sortkeys = 1;
  local $Data::Dumper::Indent = 1;
  local $Data::Dumper::Deepcopy = 1;

  my $oh = File::Temp->new;
  print $oh Dumper( $one );
  close $oh;

  my $th = File::Temp->new;
  print $th Dumper( $two );
  close $th;

  my $one_dump = $oh->filename;
  my $two_dump = $th->filename;

  $opt ||= '-uBb';
  my @diff = qx{diff $opt $one_dump $two_dump};

  if ( $? == 0 && !$! )
  {
    return;
  }
  elsif ( $! )
  {
    croak "cannot run 'diff $opt $one_dump $two_dump'': $!";
  }

  return
    wantarray
      ? @diff
      : join '' , @diff
      ;
}


exit(0);
