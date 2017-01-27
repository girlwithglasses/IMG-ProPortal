############################################################################
#	IMG::App::Role::PreFlight.pm
#
#	Run preflight checks to ensure app is ready for action
#
#	$Id: PreFlight.pm 36523 2017-01-26 17:53:41Z aireland $
############################################################################
package IMG::App::Role::PreFlight;

use IMG::Util::Import 'MooRole';
use IMG::Util::File;
use IMG::Util::Timed;
use IMG::App::Role::ErrorMessages qw( err );

requires 'config'; # 'remote_addr', 'user_agent';

has 'remote_addr' => (
	is => 'lazy',
);

has 'user_agent' => (
	is => 'lazy',
);

sub _build_remote_addr {
	my $self = shift;
	if ($self->has_psgi_req) {
		return $self->psgi_req->forwarded_for_address // $self->psgi_req->address // '';
#		return $self->psgi->{HTTP_X_FORWARDED_FOR} // $self->psgi->{REMOTE_ADDR} // '';
	}
	return $ENV{HTTP_X_FORWARDED_FOR} // $ENV{REMOTE_ADDR} // '';
}

sub _build_user_agent {
	my $self = shift;
	if ( $self->has_psgi_req ) {
		return $self->psgi_req->user_agent // '';
	}
	elsif ( $self->has_cgi ) {
		return $self->cgi->user_agent // '';
	}
	return $ENV{HTTP_USER_AGENT} // '';
}


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

#	croak __PACKAGE__ . " requires parameters 'config' and either 'cgi' or 'psgi'" unless defined $self->config && ( defined $self->cgi || defined $self->psgi_req || defined $self->http_params ) ;

#	warn "http_params: " . Dumper ( $http_params || {} );

	my $resp;

	my @checks = qw(
		db_lock_check
		max_cgi_process_check
		check_dir
	);
#	removed as are covered by Apache config
# 		block_bots
# 		block_ip_address

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
	$s ||= err({ err => 'db_service' });#'The database is currently being serviced; we apologise for the inconvenience. Please try again later.';

	return {
		status => 503,
		title  => 'Service Unavailable',
		message => $s,
	};
}


=head3

Block bots, held in $config->{bot_patterns}

@return undef or a hashref with error information

=head3 bots_allowed_here

Pages where bots are allowed

=comment

Should be dealt with by the Apache config now

=cut

sub bots_allowed_here {

	return [ qw( home help uiMap ) ];

}


sub block_bots {
	my $self = shift;
	if ( $self->http_params->{page} ) {
		# is this a page where bots are allowed?
		if ( grep { $self->http_params->{page} eq $_ } @{ $self->bots_allowed_here() } ) {
			return;
		}
	}

    if ( $self->config->{allow_hosts} && @{$self->config->{allow_hosts}} ) {

		my @remote_ip_parts;
      ALLOW_HOSTS:
        for my $ah (@{$self->config->{allow_hosts}}) {
			# no wildcards
			if ( index($ah, '*') == -1 ) {
				next ALLOW_HOSTS unless $self->remote_addr eq $ah;
#				say "Found an exact match for an allow IP!";
			}
			else {
				@remote_ip_parts = split '.', $self->remote_addr unless scalar @remote_ip_parts;
				my @ah_parts = split '.', $ah;
				my $i = 0;
				for ( @ah_parts ) {
					if ( $remote_ip_parts[$i] ne $ah_parts[$i] && '*' ne $ah_parts[$i] ) {
						next ALLOW_HOSTS;
					}
					$i++;
				}
			}
			$self->webLog( $self->remote_addr . " allowed by '$ah' rule\n");
			return undef;
        }
    }

    # NCBI LinkOut Link Check Utility
    # IP proxy: 130.14.254.25 or 130.14.254.26
    # User agent : "LinkOut Link Check Utility"
    # IP range: 130.14.*.*
    #
    if ($self->user_agent =~ /LinkOut Link Check Utility/  && $self->remote_addr =~ m!^1(28\.55\.71\.38|30\.14\.\d+\.\d+)$! ) {
        # it must go thru genome.php
#        my $ip = $self->http_params->{ip};
#        my $useragent = $self->http_params->{useragent};

        $self->webLog("\nNCBI bot ignored for LinkOut test Apr 27 2015\n");
#        webLog("$self->remote_addr === $ip\n");
#        webLog("$self->user_agent === $useragent\n\n");

        return undef;
    }

	if ( $self->config->{bot_patterns} ) {
        for my $pattern ( @{$self->config->{bot_patterns}} ) {
            if ( $self->user_agent =~ /$pattern/i ) {
				return {
					status  => 403,
					title   => 'Forbidden',
					message => err({ err => 'no_bots' })#'Bots are forbidden from accessing this area of IMG.',
				};
            }
        }
    }

	return undef;
}

=head3

Block users by IP address; blocked IPs are in $self->config->{block_ip_address_file}

@return undef or a hashref with error information

=comment

Should be dealt with by Apache config

=cut

sub block_ip_address {
	my $self = shift;
	return undef unless $self->config->{block_ip_address_file} && -e $self->config->{block_ip_address_file};

    # read in the file
    local $@;
    my $contents = eval { IMG::Util::File::file_to_hash( $self->config->{block_ip_address_file}, '=' ); };
    if ( $@ ) {
    	# is there a problem with the file?
		$self->webLog("problem reading " . $self->config->{block_ip_address_file} . ": $@");
		return undef;
    }
	if ( $contents && keys %$contents && $contents->{ $self->remote_addr } ) {

		return {
			status => 429,
			title  => 'Too Many Requests',
			message => err({ err => 'ip_blocked' }) #'There have been too many requests from your IP address, so it has blocked.',
		};

	}
	return undef;
}

=head3 max_cgi_process_check

Check we're not exceeding the maximum number of processes

=cut

sub max_cgi_process_check {
	my $self = shift;
    my $scriptName = shift || $0;

	return undef unless $self->config->{max_cgi_procs};

#    $self->webLog( $self->config->{max_cgi_procs} . " allowed processes" );

#    return if ! $max_cgi_procs;

	my $cmd = "/bin/ps -ef | grep -c $scriptName |";

#	say "Running $cmd";

	# run the command, count the output
	delete @ENV{qw(PATH IFS CDPATH ENV BASH_ENV)};

	my $count = 0;

	open my $pipe, $cmd or $self->choke({  "Could not create pipe: $!" });
	while ( <$pipe> ) {
		$count = $1 if m!(\d+)!;
	}

#    $self->webLog("max_cgi_process_check: $count $scriptName running\n");

    if ( $count > $self->config->{max_cgi_procs} + 1 ) {
        #webLog "WARNING: max_cgi_procs exceeded.\n";
		return {
			status => 503,
			title  => 'Service Unavailable',
			message => err({ err => 'server_overload' })#'The IMG servers are currently overloaded and unable to process your request. Please try again later.',
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
		message => err({ err => 'fs_unavailable' }) # 'The IMG file system is not available. Please try again later.',
	};
}

sub webLog {
	my $self = shift;
	warn $_[0];

}

1;
