package IMG::Util::File;

use IMG::Util::Base;
use Scalar::Util qw(tainted);
use IMG::Util::Untaint;
use IMG::App::Role::ErrorMessages qw( err );
use Text::CSV_XS;
use Storable;

our ( @ISA, @EXPORT_OK, %EXPORT_TAGS );

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( file_slurp file_to_array file_to_aoa file_to_hash file_touch get_dir_contents );
	%EXPORT_TAGS = ( all => \@EXPORT_OK );
}


=pod

=encoding UTF-8

=head1 NAME

IMG::Util::File - Miscellaneous file-related utility routines

=head2 SYNOPSIS

	use strict;
	use warnings;
	use IMG::Util::File;

	# read a file into an arrayref
	my $lines = IMG::Util::File::file_to_array( '/path/to/file' );
	for my $l (@$lines) {
		# do something with each line...
	}

	# parse a tab-delimited file into an array of arrays
	my $data = IMG::Util::File::file_to_aoa( '/my/file.tsv' );

	# get the fifth column on the third row
	my $cell = $data->[2][4];

	# get a file as a string
	my $str = IMG::Util::File::file_slurp( '/path/to/text/file.txt' );
	# $str will still have line endings embedded in it

	# parse a file of key-value data with ':' as the separator
	my $hashref = IMG::Util::File::file_to_hash( '/my/key/value/store.txt', ':' );
	if ( $hashref->{thing_of_interest} eq 'value of interest' ) {
		# do something
	}

=head3 file_slurp / fh_slurp

slurp a file or filehandle into a scalar (the file contents will be a single string)

@param  $file | $fh  the file or filehandle to parse (including path)

=cut

=head3 file_to_array / fh_to_array

read a file into an array

@param  $file | $fh  the file or filehandle to parse (including path)

@return $arrayref   of non-blank lines in the file


=head3 file_to_hash / fh_to_hash

read a file and parse it into a hash

Identical keys are overwritten

@param  $file | $fh  the file or filehandle to parse (including path)
@param  $sep         key / value separator; defaults to '='

@return $hashref


=head3 file_to_aoa / fh_to_aoa

parse a file into an array of arrays

@param  $file | $fh  the file or filehandle to parse (including path)
@param  $sep         record separator; defaults to "\t" (tab)

@return $arrayref of arrays

=cut


sub file_slurp {
	return _parse({ file => shift, fread_sub => 'slurp' });
}
sub fh_slurp {
	return _parse({ fh => shift, fread_sub => 'slurp' });
}

sub file_to_array {
	return _parse({ file => shift, fread_sub => 'to_array' }, @_ );
}
sub fh_to_array {
	return _parse({ fh => shift, fread_sub => 'to_array' }, @_ );
}

sub file_to_aoa {
	return _parse({ file => shift, fread_sub => 'to_aoa' }, @_ );
}
sub fh_to_aoa {
	return _parse({ fh => shift, fread_sub => 'to_aoa' }, @_ );
}

sub file_to_hash {
	return _parse({ file => shift, fread_sub => 'to_hash' }, @_ );
}
sub fh_to_hash {
	return _parse({ fh => shift, fread_sub => 'to_hash' }, @_ );
};

sub _parse {
	my $args = shift;

	if ( ! $args->{ fread_sub } ) {
		# THIS SHOULD NEVER HAPPEN!!!
		die err({
			err => 'missing',
			subject => 'fread_sub'
		});
	}
	if ( ! $args->{file} && ! $args->{fh} ) {
		die err({
			err => 'missing',
			subject => 'input file'
		});
	}

	my $fh;
	if ( $args->{fh} ) {
		$fh = $args->{fh};
		seek $fh, 0, 0;
	}
	else {
		# if file is tainted, untaint it
	#	if ( tainted( $file ) ) {
	#		$file = IMG::Util::Untaint::check_file( 'fake', $file );
	#	}
		open ( $fh, "<", $args->{file} ) or die err({
			err => 'not_readable',
			subject => $args->{file},
			msg => $!
		});
	}


	my $sub_h = {

		slurp => sub {
			my $par = shift;
			local $/;
			my $contents = <$fh>;
			if ( $args->{verbose} ) {
				say $contents;
			}
			return $contents;
		},

		to_array => sub {
			my $par = shift;
			my @contents;
			while (<$fh>) {
				next unless /\w/;
				chomp;
				push @contents, $_;
			}
			return [ @contents ];
		},

		to_aoa => sub {
			my $par = shift;
			my $sep = $par->{sep} // "\t";
			my @contents;
			while (<$fh>) {
				next unless /\w/;
				chomp;
				push @contents, [ split $sep, $_ ];
			}
			return [ @contents ];
		},

		to_hash => sub {
			my $par = shift;
			my $sep = $par->{sep} // '=';
			my %contents;
			while (<$fh>) {
				next unless /\w/;
				chomp;
				my ($k, $v) = split $sep, $_, 2;
				$contents{$k} = $v || undef;
			}
			return \%contents;
		},

	};

	die err({
		err => 'invalid',
		subject => $args->{fread_sub},
		type => 'fread_sub'
	}) unless $sub_h->{$args->{fread_sub}};

	if ( $_[0] ) {
		$args->{sep} = shift;
	}

	return $sub_h->{ $args->{fread_sub} }->( $args );

}


=head3 file_touch

Update the access and modification times of a file

@param  $file_with_path

Warns if the file could not be touched; dies if file does not exist

=cut

sub file_touch {
	my $file_path = shift // die err({ err => 'missing', subject => 'file' });

	die err({ err => 'not_found', subject => $file_path }) if ! -e $file_path;

	# untaint path if necessary
	if ( tainted($file_path) ) {
		$file_path = IMG::Util::Untaint::check_file( $file_path )
	}

	utime( undef, undef, $file_path ) || warn "Could not touch $file_path: $!";
	return;
}

=head3

does $d exist?

@return     true if the file is readable
            false if it is not
            dies if the file/dir isn't specified

=cut

sub file_exists {
	my $d = shift // die 'No file or directory specified';
	return 1 if -e $d;
	return 0;
}

=head3 is_readable

is $d readable?

@return     true if the file is readable
            false if it is not
            dies if the file/dir isn't specified or if it does not exist

=cut

sub is_readable {
	my $d = shift // die 'No file or directory specified';
	return -r $d if file_exists($d);
	die err({ err => 'not_found', subject => $d });
}

=head3 is_writable

is $d writable?

=cut

sub is_writable {
	my $d = shift // die 'No file or directory specified';
	return -w $d if file_exists($d);
	die err({ err => 'not_found', subject => $d });
}

=head3 is_dir

is $d a directory?

=cut

sub is_dir {
	my $d = shift // die 'No file or directory specified';
	return -d $d if file_exists($d);
	die err({ err => 'not_found', subject => $d });
}

=head3 is_rw

is $d readable and writable?

=cut

sub is_rw {
	my $d = shift // die 'No file or directory specified';
	return -r $d && -w _ if file_exists($d);
	die err({ err => 'not_found', subject => $d });
}

=head3 write_csv

Create a CSV file

@param $args->{...}
	file OR fh      output file or filehandle
	module_args     the arguments to pass directly to Text::CSV_XS
	cols            columns to print and in what order
	data_arr        array of data items to be printed
	csv_obj         CSV_XS object (optional)

@return

=cut

sub write_csv {
	my $args = shift;

	my $fh;

	if ( $args->{fh} ) {
		$fh = $args->{fh};
	}
	elsif ( $args->{file} ) {
		open $fh, ">", $args->{file} or die err({
			err => 'not_writable',
			subject => $args->{file},
			msg => $!
		});
	}
	else {
		die err({
			err => 'missing',
			subject => 'output file'
		});
	}

	# also need cols, data_arr
	for ( qw( cols data_arr ) ) {
		if ( ! $args->{$_} ) {
			die err({
				err => 'missing',
				subject => $_
			});
		}
		elsif ( ! ref $args->{$_} || 'ARRAY' ne ref $args->{$_} ) {
			die err({
				err => 'format_err',
				subject => $_,
				fmt => 'an arrayref'
			});
		}
	}

	if ( ! $args->{module_args} ) {
		$args->{module_args} = { eol => $/, sep_char => "\t" };
	}

	my $csv = $args->{csv_obj} // Text::CSV_XS->new( $args->{module_args} );
	#{ eol => $args->{eol} // $/, sep_char => $args->{sep_char} // "\t" });
	$csv->eol( $/ );
	$csv->print( $fh, $args->{cols} );

	for my $d ( @{$args->{data_arr}} ) {
		$csv->print( $fh, [ map { $d->{$_} // '' } @{$args->{cols}} ] );
	}
	close $fh;

	return;

}



# sub read_csv {
#
# 	my $aoh = csv (in => "data.csv",
#                headers => "auto");
#
#
# }

=head3 get_dir_contents

Get the contents of a directory

@param $args  hashref with keys

	dir => $directory

	filter => sub { ... }  (optional) filter

@return  arrayref of the file titles
=cut

sub get_dir_contents {
	my $args = shift // {};

	my $dir = $args->{dir} // die err({
		err => 'missing',
		subject => 'dir'
	});

	if ( ! is_dir( $dir ) ) {
		die err({
			err => 'format_err',
			subject => $dir,
			fmt => 'a directory'
		});
	}

	opendir( my $dh, $dir ) or die err({
		err => 'not_readable',
		subject => $dir,
		msg => $!
	});

	my @files;
	if ( $args->{filter} ) {
		@files = grep { $args->{filter}->($_) } readdir( $dh );
	}
	else {
		@files = readdir( $dh );
	}

	closedir( $dh );
	return [ @files ];
}



1;
