package IMG::Util::StashDump;

use IMG::Util::Import 'LogErr';

sub stash_dump {
	my $package_name = shift;

	local (*alias);             # a local typeglob

=cut
	# We want to get access to the stash corresponding to the package
	# name
	*stash = *{"${package_name}::"};  # Now %stash is the symbol table

	$, = " ";                        # Output separator for print
	# Iterate through the symbol table, which contains glob values
	# indexed by symbol names.
	while ((my $k, my $v) = each %stash) {
		print "$k ============================= \n";
		*alias = $v;
		if (defined ($alias)) {
			print "\t \$$k $alias \n";
		}
		if ( @alias ) {
			print "\t \@$k @alias \n";
		}
		if ( %alias ) {
			print "\t \%$k ",%alias," \n";
		}
	 }
=cut
}

sub stash_keys {
	my $package_name = shift;

	warn 'getting symbol table for ' . $package_name;
#	*stash = *{"${package_name}::"};  # Now %stash is the symbol table
	$package_name .= "::";
	no strict 'refs';
	warn map { "$_: " . $package_name->{$_} . "\n" }
	grep { defined *{ $package_name->{$_} }{CODE} }
	sort keys %$package_name;

}

sub stash_contains {
	my $package_name = shift;
	my $regex = shift;

	warn 'getting symbol table for ' . $package_name;
#	*stash = *{"${package_name}::"};  # Now %stash is the symbol table

	$package_name .= "::";
	no strict 'refs';

	local $@;
	eval {
		warn map { "$_\n" }
		grep { $_ =~ /$regex/i }
		grep { defined *{ $package_name->{$_} }{CODE} }
		sort keys %$package_name;
	};
	if ($@) {
		warn $@;
		warn Dumper { %$package_name };
	}
}



1;

=pod

=encoding UTF-8

=head1 NAME

IMG::Util::StashDump - dump the symbol table for a package

=head2 SYNOPSIS

	IMG::Util::StashDump::stash_dump( $package_name );

=cut
