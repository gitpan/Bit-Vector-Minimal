# vim:ft=perl

use Test::More qw(no_plan);

use_ok("Bit::Vector::Minimal");
my $vec = new Bit::Vector::Minimal (size => 8, width => 1, endianness => "little");
isa_ok($vec, "Bit::Vector::Minimal");
$vec->set(2); # $vec's internal vector now looks like "00000100"
is($vec->display(), "00000100", "Bits pattern is set correctly for a LE array");
is($vec->get(3), 0, "Bit three not set");

my $vec2 = new Bit::Vector::Minimal (size => 32, width => 2, endianness
=> "big");
isa_ok($vec2, "Bit::Vector::Minimal");
$vec2->set(2, 0b10); 
is($vec2->display(), "00001000000000000000000000000000", "Bits pattern is set correctly for a BE array");
