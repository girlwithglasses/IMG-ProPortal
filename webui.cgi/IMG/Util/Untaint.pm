package IMG::Util::Untaint;

use IMG::Util::Base;
use File::Spec::Functions qw( splitpath catdir catfile );
use Scalar::Util qw( tainted );
use Test::More;
#use Role::Tiny;

=head3 check_file

Check a file and path for dodgy characters, and return an untainted
version if all looks OK. Splits up the path into directory and file, and checks them
separately. Croaks with a message on failure.

Allowed characters: a-z A-Z 0-9 . _ -

@param  $file (including path)

@return $sanitised_file

=cut

sub check_file {

	my $file = shift;
	die 'No file specified' if not defined $file or ref $file;
	return '' if 0 == length $file;

	my ( $vol, $dir, $f_name ) = splitpath( $file );

	my $path = ( 0 != length $vol ) ? catdir( $vol, $dir ) : $dir;

	return _check_file_name( $f_name ) if 0 == length( $path );

	return check_path( $path ) if 0 == length( $f_name );
#	{
#		return check_path( $path );
#	}

	my $rtn = catfile(
		check_path( catdir( $vol, $dir) ),
		_check_file_name( $f_name )
	);
	if ( $rtn ne $file ) {
		say "original: $file\nchecked: $rtn";
	}
	return $rtn;
}

=head3 check_path

Check a path for dodgy characters, and return an untainted version of the path
if all looks OK. Croaks with a message on failure.

Allowed characters: a-z A-Z 0-9 _ - ~ . /

@param  $path

@return $sanitised_path

=cut

sub check_path {

	my $path = shift;
	die 'No path specified' if not defined $path or ref $path;
	return '' if 0 == length $path;

	## Catch bad patterns first.
	if ( index( $path, '..' ) != -1 ) {
		die "check_path: invalid path contains '..': $path\n";
	}

	my $new_path;
	if ( $path =~ m!([
		a-z0-9
		_
		\-
		~
		\.
		/
	]+)!xi ) {
		$new_path = $1;
	}

	return $new_path if defined $new_path && $new_path eq $path;

	die "check_path: invalid path:\noriginal: $path\nchecked: $new_path";

}

=head3 _check_file_name

Check a file name (without path) for dodgy characters, and return an untainted
version of the name if all looks OK. Croaks with a message on failure. Should be called
via check_file, not directly

Allowed characters: a-z A-Z 0-9 . _ -

@param  $f_name

@return $sanitised_name

=cut

sub _check_file_name {
	my $f_name = shift;
	die 'No file name specified' if not defined $f_name or ref $f_name;
	return '' if 0 == length $f_name;

	my $new_name;
	if ( $f_name =~ m#([
		a-z0-9
		\.
		_
		\-
	]+)#xi ) {
		$new_name = $1;
	}

	return $new_name if defined $new_name && $new_name eq $f_name;

	die "_check_file_name: invalid name:\noriginal: $f_name\nchecked: " . ( $new_name || '<undefined>' );
}


=head3 unset_env

unset the usual tainted path suspects

=cut

sub unset_env {

	delete @ENV{qw( BASH_ENV CDPATH ENV IFS PATH )};

}


=head3 untaint_env

untaint all the environment paths that we might come across

runs everything through check_path

=cut

sub untaint_env {

	my @paths = qw( BASH_ENV CDPATH ENV IFS PATH );
	for my $p (@paths) {
		if ($ENV{ $p }) {

#			say STDERR "$p: paths: " . Dumper $ENV{ $p };

			# filter out everything that isn't in /usr, /global, or /opt
			my @p_arr = eval {
				map {
					local $@;
					my $new_path = check_path( $_ );
					( $@ ) ? return "" : $new_path;
				}
				grep { m#^/(usr|global|opt)# }
				split ":", $ENV{ $p };
			};

			if ( $@ ) {
				delete $ENV{ $p };
			}
			else {
				$ENV{ $p } = join ":", @p_arr;
			}
		}
	}
	return;
}


=head3 untaint_file

Given a file name and path, checks both for dodgy characters, and return an
untainted version if all looks OK. Croaks with a message on failure.

Allowed characters: a-z A-Z 0-9 _ - ~ . /

@param  $file_with_path

@return $sanitised_path

Object-oriented version, suitable for use as a role

=cut

sub untaint_file {
	my $self = shift;
	return check_file( @_ );
}

=head3 untaint_path

Check a path for dodgy characters, and return an untainted version of the path
if all looks OK. Croaks with a message on failure.

Allowed characters: a-z A-Z 0-9 _ - ~ . /

@param  $path

@return $sanitised_path

=cut

sub untaint_path {
	my $self = shift;
	return check_path( @_ );
}


1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::Untaint - untaint external data

=head2 SYNOPSIS

	use strict;
	use warnings;
	use IMG::Util::Untaint;

=cut
