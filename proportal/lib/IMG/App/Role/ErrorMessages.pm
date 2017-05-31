############################################################################
#	IMG::App::Role::ErrorMessages.pm
#
#	Standardised error messages
#
#	$Id: ErrorMessages.pm 37114 2017-05-30 14:14:14Z aireland $
############################################################################
package IMG::App::Role::ErrorMessages;

use IMG::Util::Import 'MooRole';

our ( @ISA, @EXPORT_OK, %EXPORT_TAGS );

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( err script_die ); #  die_with_err
	%EXPORT_TAGS = ( all => \@EXPORT_OK );
}


sub make_message {
	my $self = shift;
	return err(@_);
}

sub choke {
	my $self = shift;
	my $args = shift;

	if ( $args->{status} && $args->{title} ) {
		die {
			status => $args->{status} || 500,
			title  => $args->{title} || 'Application Error',
			message => err( $args )
		};
	}

#	croak
#	confess
	die
	err( $args ) . ".\n";

}

sub err {
	my $args = shift;
	my $err = $args->{err};

	my $m = {

	# GENERAL ERROR
		not_implemented => sub {
			return 'This functionality has not yet been implemented';
		},


	# SERVER ERRORS
		server_overload => sub {
			return 'The IMG servers are currently overloaded and unable to process your request. Please try again later.';
		},

		fs_unavailable => sub {
			return 'The IMG file system is not available. Please try again later.';
		},

		db_service => sub {
			return 'The database is currently being serviced; we apologise for the inconvenience. Please try again later.';
		},

		db_conn_err => sub {
			return 'Database connection error: '
			. $args->{msg};
		},

		no_bots => sub {
			return 'Bots are forbidden from accessing this area of IMG.';
		},

		ip_blocked => sub {
			return 'There have been too many requests from your IP address, so it has blocked.';
		},

		caliban_err => sub {
			return 'The JGI login server did not return the expected response';
		},

	# PERL ERRORS
		module_load => sub {
			return 'Unable to load '
			. $args->{subject}
			. ': '
			. $args->{msg};
		},

		module_err => sub {
			return
			$args->{subject}
			. " error: "
			. $args->{msg};
		},


	# CONFIG ERRORS
		cfg_missing => sub {
			return 'No '
			. dict($args->{subject})
			. ' specified in application config';
		},

	# FILE ERRORS
		not_known => sub {
			return 'File ' . $args->{subject}
			. ' is unknown';
		},

		not_found => sub {
			return $args->{subject}
			. ' could not be found';
		},

		not_readable => sub {
			my $err = $args->{subject}
			. ' could not be '
			. ( -e $args->{subject} ? 'read' : 'found' );
			if ( $args->{msg} ) {
				$err .= ': ' . $args->{msg};
			}
			return $err;
		},

		not_writable => sub {
			my $err = $args->{subject}
			. ' could not be '
			. ( -e $args->{subject} ? 'written' : 'found' );
			if ( $args->{msg} ) {
				$err .= ': ' . $args->{msg};
			}
			return $err;
		},

		not_removable => sub {
			my $err = $args->{subject}
			. ' could not be deleted';
			if ( $args->{msg} ) {
				$err .= ': ' . $args->{msg};
			}
			return $err;

		},

		not_found_in_file => sub {
			return 'No '
			. dict( $args->{subject} )
			. ' found in '
			. dict( $args->{file} )
		},

		action_err => sub {
			return
			dict( $args->{action} )
			. ' failed'
			. ( $args->{msg}
			? ': ' . $args->{msg}
			: '.' );
		},

		# data format error
		format_err => sub {
			return
			dict( $args->{subject} )
			. ( $args->{fmt}
			? ' should be ' . $args->{fmt}
			: ' is in the wrong format' );
		},

		# missing params
		missing => sub {
			return 'No '
			. dict($args->{subject})
			. ' specified';
		},

		# mostly for database results
		no_results => sub {
			return 'The query' .
			( $args->{subject}
			? ' for ' . dict( $args->{subject} )
			: '' )
			. ' returned no '
			. dict( $args->{target} || 'results' );
		},

		missing_results => sub {
			return 'The following '
			. dict($args->{subject})
			. ' returned no results: '
			. join ', ', sort @{$args->{ids}};
		},

		invalid => sub {
			return dict($args->{subject}) .
			' is not a valid '
			. dict($args->{type});
		},

		unexpected => sub {
			return 'The query' .
			( $args->{subject}
			? ' for ' . dict( $args->{subject} )
			: '' )
			. ' returned unexpected results' .
			( $args->{msg}
			? ': ' . $args->{msg}
			: '.' );
		},

		invalid_enum => sub {
			return dict($args->{subject}) .
			' is not a valid '
			. dict($args->{type})
			. '. Permissible values are: '
			. join ", ", @{$args->{enum}};
		},

		# JSON errors
		json_decode_err => sub {
			return 'JSON decoding error'
			. ( $args->{msg}
			? ': ' . $args->{msg}
			: '');
		},

		# VALID COMPARISONS
		different => sub {
			return $args->{a}
			. ' and '
			. $args->{b}
			. ' must be different';
		},

		same => sub {
			return $args->{a}
			. ' and '
			. $args->{b}
			. ' must be the same';
		},

		# RESTRICTIONS

		full_data_disabled => sub {
			return 'Viewing the full data set is currently disabled.';
		},

		private_data => sub {
			return 'The data you are trying to access is private';
		},

		acc_locked => sub {
			return 'Your account has been locked. If you believe this is an error, please email us at <a href="mailto:imgsupp@lists.jgi-psf.org">imgsupp@lists.jgi-psf.org</a>.';
		},

		# SCRIPT-SPECIFIC ERRORS

		script_run_err => sub {
			return 'Error running '
			. $0
			. ":\n"
			. ( join "\n", @{ $args->{err_arr} || [] } )
			. "\nDying! ";
		},

		# custom message
		message => sub {
			return $args->{message};
		}

	};

	for ( qw( not_found not_readable not_writable ) ) {
		$m->{ 'file_' . $_ } = $m->{$_};
	}

#	log_debug { 'error args: ' . Dumper $args };

	if ( $m->{$err} ) {
		if ( ! ref $m->{$err} ) {
			return $m->{$err};
		}
		# otherwise, it's a coderef
		return $m->{$err}->();
	}

}

sub dict {

	my $word = shift;

	my $dict = {
		cols => 'columns',
		config => 'configuration data',
		contact_oid => 'user ID',

		data_arr => 'data array',
		db_conn => 'database connection',
		db_conn_params => 'database connection parameters',
		db_conf => 'database configuration',
		dbh => 'database handle',

		file_dir => 'file or directory',
		file_fmt => 'file format',
		fread_sub => 'file parsing subroutine',

		gene_oid => 'gene ID',
		gene_oids => 'gene IDs',

		seq_type => 'sequence type',
		sess_id => 'session ID',
		sso_config => 'SSO configuration',

		scaffold_oid => 'scaffold ID',
		scaffold_oids => 'scaffold IDs',

		taxon_oid => 'taxon ID',
		taxon_oids => 'taxon IDs',

	};

	return $dict->{ $word } || $word;

}

sub script_die {

	my $code = shift // 255;
	my $err_arr = shift // [];
	if (! ref $err_arr ) {
		$err_arr = [ $err_arr ];
	}
	warn err({
		err => 'script_run_err',
		err_arr => $err_arr
	});

	exit( $code );

}

1;
