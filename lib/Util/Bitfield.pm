use v6;

module Util::Bitfield:ver<0.0.1>:auth<github:jonathanstowe> {

    class X::BitOverflow is Exception {
        has Int $.value is required;
        has Int $.width is required;
        method message() returns Str {
            "Value '{ $!value }' would overflow bitfield of '{ $!width }' bits";
        }
    }

    sub make-mask(Int $bits, Int $start = 0, Int $word-size = 32, Bool :$invert) is export(:DEFAULT) {
	    my $ret = (((1 +< $bits) - 1) +< ($word-size - ($bits + $start)));

        if $invert {
            $ret = ((2^$word-size) - 1) +^ $ret;
        }

        $ret;
    }

    sub extract-bits(Int $value, Int $bits, Int $start = 0, Int $word-size = 32) is export(:DEFAULT){
	    ($value +& make-mask($bits, $start, $word-size)) +> ( $word-size - ( $bits + $start));
    }

    sub insert-bits(Int $ins, Int $value, Int $bits, Int $start = 0, Int $word-size = 32) is export(:DEFAULT) {
        if $ins > (2**$bits) - 1 {
            X::BitOverflow.new(value => $ins, width => $bits).throw;
        }

        ($value +& make-mask($bits, $start, $word-size, :invert)) +| ( $ins +< ($word-size - ($bits + $start)));
    }


}
# vim: expandtab shiftwidth=4 ft=perl6
