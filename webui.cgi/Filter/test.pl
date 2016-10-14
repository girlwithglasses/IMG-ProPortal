use strict;
use Test;

## 1. Test module compilation.
use vars qw/$loaded/;
BEGIN { plan tests => 5 }
END { print "not ok 1\n" unless $loaded; }
use Filter::Handle qw/subs/;
$loaded++;
ok($loaded);

## 2. Test OO interface and printf method.
{
    my $out;
    my $f = Filter::Handle->new(\*STDOUT, sub {
        $out = sprintf "%d: %s\n", 1, "@_";
        ()
    });
    $f->printf("(%s)", "Foo");
    ok($out, "1: (Foo)\n");
}

## 3. Test Filter/UnFilter routines.
my $out;
Filter \*STDOUT, sub {
    $out = sprintf "%d: %s\n", 1, "@_";
    ()
};
print "Foo";
UnFilter \*STDOUT;
ok($out, "1: Foo\n");

## 4. Test that we're actually untie-d (we should be).
ok(not tied *STDOUT);

## 5. Test tie interface.
local *FH;
my $test_out = "tout";
open FH, ">$test_out" or die "Can't open $test_out: $!";
tie *STDOUT, 'Filter::Handle', \*FH, sub {
    sprintf "%d: %s\n", 1, "@_";
};
print "Foo";
untie *STDOUT;
open FH, "$test_out" or die "Can't open $test_out: $!";
ok(scalar <FH>, "1: Foo\n");
close FH;
unlink $test_out or die "Can't unlink $test_out: $!";
