#!/usr/bin/env perl

use FindBin qw/ $Bin /;
use lib "$Bin/../";
use IMG::Util::Import 'Test';

use Sub::Override;
use Test::MockModule;

=cut

my $mock =
require WebUtil;


my $die_sub = sub {
	my ( $txt, $exitcode, $noHtmlEsc ) = @_;
	my $err = {
		status => 500,
		title  => 'Software Error',
		message => $txt,
	};

	if ( defined $noHtmlEsc && 0 == $noHtmlEsc ) {
		$err->{message_html} = $txt; # escapeHTML
		delete $err->{message};
	}
	die $err;
};



local $@;
eval {

#	require GenomeCart;

	my $module = Test::MockModule->new('WebUtil');
	$module->mock('webError', $die_sub);
	my $mocked = Test::MockModule->new('GenomeCart', no_auto => 1 );
	$module->mock('webError', $die_sub);
	require GenomeCart;

	my $override = Sub::Override->new();
#	$override->replace('WebUtil::initialize', sub { say 'Hello world!'; });
#	$override->replace('WebUtil::webDie', $die_sub);
	$override->replace('*::webError', $die_sub);
#	$override->replace('webDie', $die_sub);
#	$override->replace('webError', $die_sub);
	GenomeCart::removeFromGenomeCart();

};

say "Died with error $@" if $@;
=cut

ok(1);
done_testing();
