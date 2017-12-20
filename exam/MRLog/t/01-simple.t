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

#log_level('error');
Local::MRLog->log_error('one','two');
package TestLogLevel;
#Local::MRLog->log_error('line');


#is( log_error('line'), undef, 'Nothing in log' );
#log_level('error');
#is( log_error('line'), undef, 'Nothing in log' );
