############################################################################
#	IMG::App::Role::PreFlight.pm
#
#	Run preflight checks to ensure app is ready for action
#
#	$Id: PreFlight.pm 37114 2017-05-30 14:14:14Z aireland $
############################################################################
package IMG::App::Role::PreFlight;

use IMG::Util::Import 'MooRole';
use IMG::Util::File;
use IMG::Util::Timed;
use IMG::App::Role::ErrorMessages qw( err );

requires 'config';

=head3 run_checks

Run preflight checks for IMG apps

	my $errors = IMG::App::Role::PreFlight::run_checks( config => $config, cgi => $cgi );

@param  config => configuration hash

@param  http_params => hash of parameters
    OR  cgi  => $cgi_object
    OR  psgi => $psgi_env_hash

@return undef if all checks were passed
        hashref containing error information in the form

	{ status => 500, title => 'Software Error', message => 'There was an error' }

	(keys are 'status', 'title', and 'message')

=cut

sub run_checks {
	my $self = shift;
	my $args = shift || {};

	my $resp;

	my @checks = qw(
		db_lock_check
		max_cgi_process_check
		check_dir
	);

	while ( ! defined $resp && @checks) {
		my $fn = shift @checks;
		if ( $args->{$fn} ) {
			if (ref $args->{$fn} && 'ARRAY' eq ref $args->{$fn}) {
				$resp = $self->$fn( @{$args->{$fn}} );
			}
			else {
				$resp = $self->$fn( $args->{$fn} );
			}
		}
		else {
			$resp = $self->$fn;
		}
	}

	return $resp;

}

=head3 db_lock_check

Check for a database lock file, $self->config->{dblock_file}

@return undef or a hashref with error information

=cut

sub db_lock_check {
	my $self = shift;

##	TODO: move this to the file manager!

	return undef unless $self->config->{dblock_file} && -e $self->config->{dblock_file};

	# check whether there is a message in the lock file
	local $@;
	my $s = eval { IMG::Util::File::file_slurp( $self->config->{dblock_file} ); };
	$s ||= err({ err => 'db_service' });

	return {
		status => 503,
		title  => 'Service Unavailable',
		message => $s,
	};
}


=head3 max_cgi_process_check

Check we're not exceeding the maximum number of processes

=cut

sub max_cgi_process_check {
	my $self = shift;
    my $scriptName = shift || $0;

	return undef unless $self->config->{max_cgi_procs};

	my $cmd = "/bin/ps -ef | grep -c $scriptName |";

#	log_debug { "Running $cmd" };

	# run the command, count the output
	delete @ENV{qw(PATH IFS CDPATH ENV BASH_ENV)};

	my $count = 0;

	open my $pipe, $cmd or $self->choke({  "Could not create pipe: $!" });
	while ( <$pipe> ) {
		$count = $1 if m!(\d+)!;
	}

	if ( $count > $self->config->{max_cgi_procs} + 1 ) {
		return {
			status => 503,
			title  => 'Service Unavailable',
			message => err({ err => 'server_overload' })
		};
    }
	return undef;

}

=head3 check_dir

Make sure that a directory is accessible

=cut

sub check_dir {
	my $self = shift;
	my $dir  = shift;

##	TODO: move this sub into IMG::Util::File

	return undef unless defined $dir;

	my $dir_check = sub {
		my $d = shift;
		return 1 if IMG::Util::File::is_dir( $d ) and IMG::Util::File::is_rw( $d );
		return 0;
	};

	local $@;
	my $result = IMG::Util::Timed::time_this( 5, $dir_check, $dir );
	return undef if $result;
	if ( $@ ) {
		# timeout
		# warn 'Accessing ' . $dir . ' timed out';
	}
	else {
		# permissions error
		# warn 'Permissions error when accessing ' . $dir;
	}

	return {
		status => 503,
		title  => 'Service Unavailable',
		message => err({ err => 'fs_unavailable' })
	};
}

=head3 db_connection_check

Make sure our database connection is still alive

=cut

sub db_connection_check {
	my $self = shift;

}

1;
