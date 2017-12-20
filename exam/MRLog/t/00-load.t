#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

plan tests => 1;

BEGIN {
    use_ok( 'Local::MRLog' ) || print "Bail out!\n";
}

diag( "Testing Local::MRLog $Local::MRLog::VERSION, Perl $], $^X" );
