! Copyright (C) 2012 John Benediktsson
! See http://factorcode.org/license.txt for BSD license

USING: combinators.short-circuit kernel math math.combinatorics
math.functions math.order math.ranges math.statistics
math.vectors memoize sequences ;

IN: math.extras

<PRIVATE

DEFER: sterling

: (sterling) ( n k -- x )
    [ [ 1 - ] bi@ sterling ]
    [ [ 1 - ] dip sterling ]
    [ nip * + ] 2tri ;

PRIVATE>

MEMO: sterling ( n k -- x )
    2dup { [ = ] [ nip 1 = ] } 2||
    [ 2drop 1 ] [ (sterling) ] if ;

<PRIVATE

DEFER: bernoulli

: (bernoulli) ( p -- n )
    [ iota ] [ 1 + ] bi [
        0 [ [ nCk ] [ bernoulli * ] bi + ] with reduce
    ] keep recip neg * ;

PRIVATE>

MEMO: bernoulli ( p -- n )
    [ 1 ] [ (bernoulli) ] if-zero ;

: chi2 ( actual expected -- n )
    0 [ dup 0 > [ [ - sq ] keep / + ] [ 2drop ] if ] 2reduce ;

<PRIVATE

: df-check ( df -- )
    even? [ "odd degrees of freedom" throw ] unless ;

: (chi2P) ( chi/2 df/2 -- p )
    [1,b) dupd n/v cum-product swap neg exp [ v*n sum ] keep + ;

PRIVATE>

: chi2P ( chi df -- p )
    dup df-check [ 2.0 / ] [ 2 /i ] bi* (chi2P) 1.0 min ;
