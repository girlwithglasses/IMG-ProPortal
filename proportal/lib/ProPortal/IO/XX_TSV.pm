package ProPortal::IO::TSV;

require 5.010_000;
use strict;
use warnings;
use feature ':5.10';

use FindBin qw/ $Bin /;
use lib "$Bin/../lib";


use Moo;
use Types::Standard qw(Int Str Bool InstanceOf);
use Data::Dumper;

has 'verbose' => (
	is => 'rw',
	isa => Int,
	predicate => 1,
	clearer => 1,
);

has 'data_dir' => (
	is => 'rw',
	isa => Str,
	predicate => 1,
	default => sub {
		return '$Bin/../data/';
	}
);

=head3 run_query

Get data as if as db query had been run

@param  hash with keys

@param  query  => the name of the query to be run
	(a.k.a. the name of the method in this package)

@param  input  => extra query param to be filled in using $self->proportal_filters

@param  bind   => [ $arg1, $arg2, $arg3 ] - bind these to the SQL sttmnt

@param  output => how to return the output: e.g. fetchall_arrayref, fetchall_hashref

@return $output - raw output from the query

=cut

sub run_query {
	my $self = shift;
	my %args = @_;

	if ($args{input}) {
		return $self->get_data( $args{input}.'/'.$args{query}.'.txt', $args{output} );
	}
	return $self->get_data( $args{query}.'.txt', $args{output} );
}

=head3 get_data

Open a text file, read and parse contents, return!

=cut

sub get_data {
	my $self = shift;
	my $file = shift;
	my @hdrs;
	my $tform = {
		'arr' => sub {
			my $line = shift;
			# remove the quotes, get rid of "undef" text
			return [ map { s/^'//; s/'$//; s/^undef$//; $_ } split "\t", $line ];
		},
		'hash' => sub {
			my $line = shift;
			my $hdr = shift;
			my %h;
			@h{ @$hdr } = map { s/^'//; s/'$//; s/^undef$//; $_ } split "\t", $line;
			return \%h;
		},
	};
	my $sub = 'arr';

	if ( open (my $fh, "<", $self->data_dir . $file ) ) {
		my @arr;
		while (<$fh>) {
			next unless /\w/;
			if ( /^#HDR (.+)/ ) {
				@hdrs = split( qr#,\s*#, $1 );
			}
			next if /^\s*#/;
			chomp;
			push @arr, $tform->{$sub}->( $_, [@hdrs] );
		}
		return [ @arr ];
	}
	warn "Could not open " . $self->data_dir . $file . ": $!";
	return undef;
}

1;