package Dancer2::Logger::Log4perl;

$Dancer2::Logger::Log4perl::VERSION = '0.03';
use Log::Log4perl qw( :easy );
use Moo;
use Dancer2::Core::Types;

with 'Dancer2::Core::Role::Logger';

has config_file => (
	is => 'ro',
	isa => ReadableFilePath,
);

has config_watch_interval => (
	is => 'ro',
	isa => sub {
		my $config_watch_interval = shift;

		# Can either be 'HUP' or a number
		Str->( $config_watch_interval );
		if( $config_watch_interval eq 'HUP' ) {
			return;
		}
		else {
			Num->( $config_watch_interval );
		}
	},
);

sub _initialize_log4perl {
	my $self = shift;
#	warn 'initialising l4p from Dancer';
	# If config_file is defined, then use that
	if( defined $self->config_file ) {

		# ...optionally with the watch interval
		if( defined $self->config_watch_interval ) {
			Log::Log4perl->init_and_watch( $self->config_file, $self->config_watch_interval );
		}
		else {
			Log::Log4perl->init( $self->config_file );
		}
	}

	# Otherwise we'll easy init with the appropriate log level
	else {
		my $log_level_mapping = {
			'error'   => $ERROR,
			'warn'    => $WARN,
			'warning' => $WARN,
			'info'    => $INFO,
			'debug'   => $DEBUG,
			'trace'   => $TRACE,
			'core'    => $TRACE,
		};

		Log::Log4perl->easy_init( $log_level_mapping->{ $self->log_level } );
	}
}

sub log {
	my ( $self, $level, $message ) = @_;

	# Need to initialize Log4perl if it isn't yet
	if( ! Log::Log4perl->initialized() ) {
		$self->_initialize_log4perl();
	}

	# Need to convert Dancer2 log levels to Log4perl levels
	$level = 'warn' if $level eq 'warning';
	$level = 'trace' if $level eq 'core';

	# Couldn't get $Log::Log4perl::caller_depth to work
	Log::Log4perl->get_logger( scalar caller(4) )->$level( $message );
}

1;
__END__

=head1 SYNOPSIS

In your config.yml

   logger: log4perl
   log: core
   engines:
      logger:
         log4perl:
            config_file: log4perl.conf

In your log4perl.conf

   log4perl.rootLogger              = DEBUG, LOG1
   log4perl.appender.LOG1           = Log::Log4perl::Appender::File
   log4perl.appender.LOG1.filename  = /var/log/mylog.log
   log4perl.appender.LOG1.mode      = append
   log4perl.appender.LOG1.layout    = Log::Log4perl::Layout::PatternLayout
   log4perl.appender.LOG1.layout.ConversionPattern = %d %p %m %n

=head1 DESCRIPTION

This class is an interface between L<Dancer2>'s logging engine abstraction
layer and the L<Log::Log4perl> library. In order to use it, you have to
set the C<logger> engine to C<log4perl>.

L<Dancer2>'s C<core> level messages are passed to L<Log4perl> as level C<trace>
but will not be passed unless L<Dancer2>'s C<log> config is C<core>.

C<log> should be set a lower priority than the lowest priority as set in your
L<Log4perl> configuration. If it isn't, the log messages will not be passed
to L<Log4perl>.

=head1 CONFIGURATION

If you don't specify C<config_file> then Log4perl will easy init with the
appropriate log level, as specified by Dancer2.

=over

=item B<< config_file >>

You can specify the log4perl configuration file using the C<config_file> option:

   logger: log4perl
   engines:
      logger:
         log4perl:
            config_file: log4perl.conf

=item B<< config_watch_interval >>

You can optionally specify the watch interval, either in seconds or as 'HUP':

   logger: log4perl
   engines:
      logger:
         log4perl:
            config_file: log4perl.conf
            config_watch_interval: 30

=back

# From https://kb.wisc.edu/middleware/page.php?id=62507
