package Bit::Vector::Minimal;

use 5.006;
use strict;
use warnings;
use Carp;

our $VERSION = '1.0';

=head1 NAME

Bit::Vector::Minimal - Object-oriented wrapper around vec()

=head1 SYNOPSIS

  use Bit::Vector::Minimal;
  my $vec = new Bit::Vector (size => 8, width => 1, endianness => "little");
                             # These are the defaults

  $vec->set(1); # $vec's internal vector now looks like "00000010"
  $vec->get(3); # 0

=head1 DESCRIPTION

This is a much simplified, lightweight version of L<Bit::Vector>, and
wraps Perl's (sometimes confusing) C<vec> function in an object-oriented
abstraction.

=head1 METHODS

=head2 new

Creates a new bit vector. By default, this creates a one-byte vector
with 8 one-bit "slots", with bit zero on the right of the bit pattern.
These settings can be changed by passing parameters to the constructor:
C<size> will alter the size in bits of the vector; C<width> will alter
the width of the slots. The module will die if C<width> is not an
integer divisor of C<size>. C<endianness> controls whether the zeroth
place is on the right or the left of the bit vector.

=cut

sub new {
    my $class = shift;
    my $self = bless {
        width      => 1,
        size       => 8,
        endianness => "little",
        @_}, $class;
    croak "Don't know what endianness $self->{endianness} is meant to be"
        unless $self->{endianness} =~ /^(little|big)$/i;

    croak "Width ought to be a power of two"
        if !$self->{width} or (($self->{width}-1) & $self->{width});

    my $slots = $self->{size}/$self->{width};
    croak "Cowardly refusing to store $slots items in a vector" unless
        $slots == int($slots);
    $self->{pattern} = "\0" x ($self->{size}/8);
    return $self;
}

=head2 set(POS[, VALUE])

Sets the bit or slot at position C<POS> to value C<VALUE> or "all bits
on" if C<VALUE> is not given.

=cut

sub set {
    my ($self, $pos, $value) = @_;
    if (!defined $value) {
        $value = 2**$self->{width}-1;
    }
    $pos = 1+ $self->{width} - $pos if $self->{endianness} eq "big";
    vec($self->{pattern}, $pos, $self->{width}) = $value;
}

=head2 get(POS)

Returns the bit or slot at position C<POS>.

=cut

sub get {
    my ($self, $pos) = @_;
    $pos = 1+$self->{width} - $pos if $self->{endianness} eq "big";
    return vec($self->{pattern}, $pos, $self->{width});
}

sub display {  # For debugging
    my $self = shift;
    return join "", map { sprintf("%08b", ord $_) } split //, $self->{pattern};
}

=head1 SEE ALSO

L<Bit::Vector>

=head1 AUTHOR

Simon Cozens, E<lt>simon@kasei.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Kasei

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut