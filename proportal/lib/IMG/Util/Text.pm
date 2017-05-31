package IMG::Util::Text;

use IMG::Util::Import 'MooRole';
use utf8;

=head3 make_text_web_safe

remove anything except for \w from a text string, replace it with underscores

tests: img_util_text.t

=cut

sub make_text_web_safe {
	my $self = shift;
	my $text = shift // return;
	$text =~ s/\W+/_/g;
	return $text;
}

1;
