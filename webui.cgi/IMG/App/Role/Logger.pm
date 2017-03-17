package IMG::App::Role::Logger;

use parent 'Log::Contextual';
use Log::Log4perl;

############################################################
# A simple root logger with a Log::Log4perl::Appender::File
# file appender and output to STDOUT.
############################################################

# Configuration in a string ...
my $conf = q(
	log4perl.rootLogger                = DEBUG, Logfile, Screen

	log4perl.appender.Logfile          = Log::Log4perl::Appender::File
	log4perl.appender.Logfile.filename = /global/homes/a/aireland/webUI/proportal/log/proportal-log4perl.log
	log4perl.appender.Logfile.mode     = append
	log4perl.appender.Logfile.layout   = Log::Log4perl::Layout::PatternLayout
	log4perl.appender.Logfile.layout.ConversionPattern = [%r] %F %L %c - %m%n

	log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
	log4perl.appender.Screen.stderr  = 0
	log4perl.appender.Screen.layout  = Log::Log4perl::Layout::SimpleLayout
);

Log::Log4perl->init( \$conf );

sub arg_default_logger { $_[1] || Log::Log4perl->get_logger }

sub default_import { qw( :log :dlog ) }

1;
