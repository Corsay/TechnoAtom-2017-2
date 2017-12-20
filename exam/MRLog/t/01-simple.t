#!/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

plan tests => 1;

BEGIN { use_ok( 'Local::MRLog' ) || print "Bail out!\n"; }

my $TEST = {
	sv => "string",
	av => [ qw(some elements) ],
	hv => {
		nested => "value",
		key => [ 1,2,{},[],undef,'' ],
	},
};

# ToDo перенапрвлять STDERR в handler и сравнивать результат с ожидаемым

# Тест уровней логирования
use Local::MRLog;
Local::MRLog->log_debug1('one','two');	# default log level = info (nothing printed)
Local::MRLog->log_info('1','2', $TEST);	# printed '1','2', $TEST

Local::MRLog->log_level('error');	# change log level for cur package to error
Local::MRLog->log_warn('3','4');	# try to print warn (but warn bigger than error)

Local::MRLog->log_level('warn');	# change log level for cur package to warn
Local::MRLog->log_warn('five');		# printed 'five'
Local::MRLog->log_level('debug3');	# change log level for cur package to debug3 (max)

package TestLogLevel;
Local::MRLog->log_debug3('7');	# nothing printed because cur package log_level = info
Local::MRLog->log_level('debug3');	# change log level for cur package to debug3 (max)
Local::MRLog->log_debug3('five', '6');	# printed 'five', '6'
