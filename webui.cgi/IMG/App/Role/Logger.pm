package IMG::Log::Contextual;

use IMG::Util::Base;

use parent 'Log::Contextual';

use Log::Log4perl;

############################################################
# A simple root logger with a Log::Log4perl::Appender::File
# file appender in Perl.
############################################################

my $cfg = {
	log4perl.rootLogger => 'ERROR, LOGFILE',
	log4perl.appender.LOGFILE => 'Log::Log4perl::Appender::File',
	log4perl.appender.LOGFILE.filename => 'proportal/logs/proportal-log4perl.log',
	log4perl.appender.LOGFILE.mode => 'append',
	log4perl.appender.LOGFILE.layout => 'PatternLayout',
	log4perl.appender.LOGFILE.layout.ConversionPattern => '[%r] %F %L %c - %m%n'
};

Log::Log4perl->init( \$cfg );

sub arg_default_logger { $_[1] || Log::Log4perl->get_logger }
# sub arg_levels { [qw( debug trace warn info error fatal )] }
sub default_import { ':log' }

1;


package IMG::App::Role::Logger;

use IMG::Util::Base 'MooRole';
use IMG::Log::Contextual;

has logcont_logger => (
	is => 'rwp',
#	builder => 1,
	default => sub {
		my $self = shift;
		Log::Log4perl->init( \$cfg );
		return Log::Log4perl->get_logger;
	},
);

1;
