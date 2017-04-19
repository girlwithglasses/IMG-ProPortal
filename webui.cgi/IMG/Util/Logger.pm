package IMG::Util::Logger;

use IMG::Util::Import;
use parent 'Log::Contextual';
use Log::Log4perl qw( :easy );

=head4

logger configuration hash

possible keys, in order of priority of evaluation:

var            - a variable holding the config info (currently disabled)
config_file    - config file in log4perl format
watch_interval - how often to reload the conf file in case it changes

automatic initialisation is for the screen logger set at $WARN

=cut

my $cfg = {};

sub _initialize_log4perl {
	my $args = shift // $cfg;
#	say 'initialising l4p from IMG::App';

# 	do we have a config held in a variable?
# 	if ( defined $args->{var} ) {
# 		Log::Log4perl->init( $args->{var} );
# 	}

	# If config_file is defined, then use that
	if( defined $args->{config_file} ) {

		# ...optionally with the watch interval
		if( defined $args->{watch_interval} ) {
			Log::Log4perl->init_and_watch( $args->{config_file}, $args->{watch_interval} );
		}
		else {
			Log::Log4perl->init( $args->{config_file} );
		}
	}
	else {
		# choke or die here!
#		warn 'No Log4perl config found';
		Log::Log4perl->easy_init( $WARN );
	}
}

sub set_logger_conf {
	my $conf = shift;
	if ( ! ref $conf ) {
		$cfg->{config_file} = $conf;
	}
	elsif ( $conf->{config_file} || $conf->{var} ) {
		$cfg = {};
		for ( keys %$conf ) {
			$cfg->{$_} = $conf->{$_};
		}
	}
	# if l4p is already running, reinitialise it
	if ( Log::Log4perl->initialized() ) {
#		say 'initialising l4p via set_logger_conf';
		_initialize_log4perl();
	}
}

sub arg_default_logger {
	if ( $_[1] ) {
		return $_[1];
	}
	# otherwise, check whether we have init'd the logger or not, and log!
	if ( ! Log::Log4perl->initialized() ) {
#		say 'initialising l4p via arg_default_logger';
		_initialize_log4perl();
	}
	return Log::Log4perl->get_logger;
}

sub default_import { qw( :log :dlog ) }

1;

# sub _initialize_log4perl {
# 	my $self = shift;
#
# 	# If config_file is defined, then use that
# 	if( defined $self->config_file ) {
#
# 		# ...optionally with the watch interval
# 		if( defined $self->config_watch_interval ) {
# 			Log::Log4perl->init_and_watch( $self->config_file, $self->config_watch_interval );
# 		}
# 		else {
# 			Log::Log4perl->init( $self->config_file );
# 		}
# 	}
#
# 	# Otherwise we'll easy init with the appropriate log level
# 	else {
#
# 		Log::Log4perl->easy_init( $WARN );
# 	}
# }

# sub log {
# 	my ( $self, $level, $message ) = @_;
#
# 	# Need to initialize Log4perl if it isn't yet
# 	if( ! Log::Log4perl->initialized() ) {
# 		$self->_initialize_log4perl();
# 	}
#
# 	# Need to convert Dancer2 log levels to Log4perl levels
# 	$level = 'warn' if $level eq 'warning';
# 	$level = 'trace' if $level eq 'core';
#
# 	# Couldn't get $Log::Log4perl::caller_depth to work
# 	Log::Log4perl->get_logger( scalar caller(4) )->$level( $message );
# }
