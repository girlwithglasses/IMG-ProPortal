package IMG::App::Role::Logger;

use parent 'Log::Contextual';
use Log::Log4perl;
use File::Spec::Functions qw( rel2abs catdir catfile );
use File::Basename qw( dirname basename );
use feature ':5.16';

# find the config file
my $dir = dirname( rel2abs( $0 ) );
while ( 'webUI' ne basename( $dir ) ) {
	$dir = dirname( $dir );
}

my $conf = 'logger.conf';

sub get_logger {
	Log::Log4perl->get_logger('rootLogger');
}

sub set_logger_conf {
	$conf = +shift;
	Log::Log4perl->init( catfile( $dir, 'proportal/environments', $conf ) );
}

Log::Log4perl->init( catfile( $dir, 'proportal/environments', $conf ) );

sub arg_default_logger { $_[1] || Log::Log4perl->get_logger }

sub default_import { qw( :log :dlog ) }

1;
