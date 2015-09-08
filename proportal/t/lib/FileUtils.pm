package FileUtils;

require 5.010_000;
use strict;
use warnings;
use feature ':5.10';

use Carp;



=head3 slurp

slurp a file into a scalar

=cut

sub slurp {

	my $file = shift;

	if (open(my $fh, "<", $file)) {
		local $/;
		my $contents = <$fh>;
		return $contents;
	}
	carp "Could not open $file: $!";
	return;

}


1;