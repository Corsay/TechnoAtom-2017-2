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

# Тест уровней логирования (обращение на прямую)
use Local::MRLog;
Local::MRLog::log_debug1('one','two');	# default log level = info (nothing printed)
Local::MRLog::log_info('1','2', $TEST);	# printed 1 2 $TEST by Dunper

Local::MRLog::log_level('error');	# change log level for cur package to error
Local::MRLog::log_warn('3','4');	# try to print warn (but warn bigger than error)

Local::MRLog::log_level('warn');	# change log level for cur package to warn
Local::MRLog::log_warn('five');		# printed five
Local::MRLog::log_level('debug3');	# change log level for cur package to debug3 (max)

package TestLogLevel;
Local::MRLog::log_debug3('7');	# nothing printed because cur package log_level = info

Local::MRLog::log_prefix('my_pref: ');	# add prefix
Local::MRLog::log_level('debug3');	# change log level for cur package to debug3 (max)
Local::MRLog::log_debug3('five', '6');	# printed my_pref: five 6

Local::MRLog::log_prefix(sub { return $_[0] . ": "; });	# add prefix sub
Local::MRLog::log_level('debug3');	# change log level for cur package to debug3 (max)
Local::MRLog::log_debug3('five', '7');	# printed debug3: five 7
no Local::MRLog;

package TestLogLevel2;
use Local::MRLog qw/log_cluck_info/;
# функция без использования скобок
log_info '3','4', $TEST;	# printed 3 4 $TEST by Dunper
Local::MRLog::log_info '5','6', $TEST;	# printed 5 6 $TEST через Dunper
# log_cluck with stacktrace
Local::MRLog::log_prefix('my_new_pref: ');	# add prefix
log_cluck_info '7','8', $TEST;	# printed my_new_pref: 7 8 $TEST через Dunper
Local::MRLog::log_cluck_info '9','10', $TEST;	# printed my_new_pref: 9 10 $TEST через Dunper
no Local::MRLog;

=head2
	# ToDo дотестировать (our %mod_log_levels виден только в модуле Local::MRLog)
=cut
=head Comment
	package TestLogLevel3;
	# Тест уровней логирования (обращение с учётом import)
	use Local::MRLog;
	log_debug1('one','two');	# default log level = info (nothing printed)
	log_info('1','2', $TEST);	# printed '1','2', $TEST

	log_level('error');	# change log level for cur package to error
	log_warn('3','4');	# try to print warn (but warn bigger than error)

	log_level('warn');	# change log level for cur package to warn
	log_warn('five');		# printed 'five'
	log_level('debug3');	# change log level for cur package to debug3 (max)

	package TestLogLevel4;
	log_debug3('7');	# nothing printed because cur package log_level = info

	log_prefix('my_pref: ');	# добавим префикс
	log_level('debug3');	# change log level for cur package to debug3 (max)
	log_debug3('five', '6');	# printed my_pref: five 6

	log_prefix(sub { return $_[0] . ": "; });	# добавим префикс функцию
	log_level('debug3');	# change log level for cur package to debug3 (max)
	log_debug3('five', '7');	# printed debug3: five 7
=cut
