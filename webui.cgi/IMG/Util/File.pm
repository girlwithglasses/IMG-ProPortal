package IMG::Util::File;

use IMG::Util::Base;
use Scalar::Util qw(tainted);
use IMG::Util::Untaint;
use Storable;

our (@ISA, @EXPORT_OK);

BEGIN {
	require Exporter;
	@ISA = qw( Exporter );
	@EXPORT_OK = qw( slurp file_to_array file_to_aoa file_to_hash file_touch );
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
	my $str = IMG::Util::File::slurp( '/path/to/text/file.txt' );
	# $str will still have line endings embedded in it

	# parse a file of key-value data with ':' as the separator
	my $hashref = IMG::Util::File::file_to_hash( '/my/key/value/store.txt', ':' );
	if ( $hashref->{thing_of_interest} eq 'value of interest' ) {
		# do something
	}

=head3 slurp

slurp a file into a scalar (the file contents will be a single string)

=cut

=head3 file_to_array

read a file into an array

@param  $file       the file to parse (including path)

@return $arrayref   of non-blank lines in the file


=head3 file_to_hash

read a file and parse it into a hash

Identical keys are overwritten

@param  $file       the file to parse (including path)
@param  $sep        key / value separator; defaults to '='

@return $hashref


=head3 file_to_aoa

parse a file into an array of arrays

@param  $file       the file to parse (including path)
@param  $sep        record separator; defaults to "\t" (tab)

@return $arrayref of arrays

=cut


sub slurp {

	return _parse( 'slurp', @_ );

}

sub file_to_array {

	return _parse( 'file_to_array', @_ );

}

sub file_to_aoa {

	return _parse( 'file_to_aoa', @_ );

}

sub file_to_hash {

	return _parse( 'file_to_hash', @_ );

}

sub _parse {

	my $sub = shift || croak 'No file reading sub specified!';
	my $file = shift || croak 'No file specified!';

	# if file is tainted, untaint it
#	if ( tainted( $file ) ) {
#		$file = IMG::Util::Untaint::check_file( 'fake', $file );
#	}

	open (my $fh, "<", $file) or croak "Could not open $file: $!";

	my $sub_h = {

		slurp => sub {
			local $/;
			my $contents = <$fh>;
			return $contents;
		},

		file_to_array => sub {
			my @contents;
			while (<$fh>) {
				next unless /\w/;
				chomp;
				push @contents, $_;
			}
			return [ @contents ];
		},

		file_to_aoa => sub {
			my $sep = shift // "\t";
			my @contents;
			while (<$fh>) {
				next unless /\w/;
				chomp;
				push @contents, [ split $sep, $_ ];
			}
			return [ @contents ];
		},

		file_to_hash => sub {
			my $sep = shift // '=';
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

	croak 'invalid file parsing routine supplied' unless $sub_h->{$sub};

	return $sub_h->{ $sub }->( @_ );

}


=head3 file_touch

Update the access and modification times of a file

@param  $file_with_path

Warns if the file could not be touched; dies if file does not exist

=cut

sub file_touch {
	my $file_path = shift // die 'No file specified';

	die $file_path . ' does not exist' if ! -e $file_path;

	# untaint path if necessary
	if ( tainted($file_path) ) {
		$file_path = IMG::Util::Untaint::check_file( $file_path )
	}

	utime( undef, undef, $file_path ) || warn "Could not touch $file_path: $!";
	return;
}

=head3

does $d exist?

=cut

sub file_exists {
	my $d = shift // die 'No file or directory specified';
	return 1 if -e $d;
	return 0;
}

=head3 is_readable

is $d readable?

=cut

sub is_readable {
	my $d = shift // die 'No file or directory specified';
	return -r $d if file_exists($d);
	die "$d does not exist";
}

=head3 is_writable

is $d writable?

=cut

sub is_writable {
	my $d = shift // die 'No file or directory specified';
	return -w $d if file_exists($d);
	die "$d does not exist";
}

=head3 is_dir

is $d a directory?

=cut

sub is_dir {
	my $d = shift // die 'No file or directory specified';
	return -d $d if file_exists($d);
	die "$d does not exist";
}

=head3 is_rw

is $d readable and writable?

=cut

sub is_rw {
	my $d = shift // die 'No file or directory specified';
	return -r $d && -w _ if file_exists($d);
	die "$d does not exist";
}




1;
