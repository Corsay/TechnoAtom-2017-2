package Local::MRLog 1.00;

use 5.006;
use strict;
use warnings;

use Data::Dumper::OneLine;

=head1 NAME

    MRLog - The great new Log module!

=head1 VERSION

    Version 1.00

=cut

=head1 SYNOPSIS

    ToDo info about what module does

=head1 EXPORT

    ToDo info about export functions

=head1 SUBROUTINES/METHODS
=cut

# уровни логирования
my %log_levels = (
	error => 0,
	warn => 1,
	info => 2,
	debug1 => 3,
	debug2 => 4,
	debug3 => 5,
);
# уровни логирования для каждого вызывающего модуля
our %mod_log_levels = ();
# по-умолчанию
my $log_level = 'info';
my $log_prefix = '';
# цвета вывода
my $prefix_color = "\x1b[1;34m";
my $args_color = "\x1b[32m";
my $default_color = "\x1b[0m";

=head1 Loging_Output
	input -> args in not private func
=cut
=head2 _log_main
    input -> log level of call function(string), package and args
    output -> output args to STDERR in one line, joined by " "
    print in STDERR only if log_level >= func_log_level
=cut
sub _log_main {
	my ($level, $package, $self, @args) = @_;
	_check_package_log_level($package);	# проверяем что для данного модуля уже есть уровень логирования

	my $cur_pac_level = $mod_log_levels{$package}{log_level};
	return if $cur_pac_level < $log_levels{$level};	# если уровень логирования меньше чем требуемый

	# получаем prefix
	my $prefix = $log_prefix;
	$prefix = $log_prefix->( $cur_pac_level ) if (ref $log_prefix eq 'CODE');
	print STDERR $prefix_color . $prefix . $default_color;

	# выводим аргументы в STDERR
	print STDERR $args_color;
	while (@args) {
		my $arg = shift @args;
		if (ref $arg ne '') {
			print STDERR Dumper($arg);
		}
		else {
			print STDERR $arg;
		}
		print STDERR " " if @args;	# вывод пробела всегда кроме последнего аргумента
	}
	print STDERR $default_color;
	print STDERR "\n";
}

sub log_error {
	my ($package) = caller;
	_log_main('error', $package, @_);
}

sub log_warn {
	my ($package) = caller;
	_log_main('warn', $package, @_);
}

sub log_info {
	my ($package) = caller;
	_log_main('info', $package, @_);
}

sub log_debug1 {
	my ($package) = caller;
	_log_main('debug1', $package, @_);
}

sub log_debug2 {
	my ($package) = caller;
	_log_main('debug2', $package, @_);
}

sub log_debug3 {
	my ($package) = caller;
	_log_main('debug3', $package, @_);
}

=head1 Loging_Checkers
=cut
=head2
	check existing of package log_level;
	input -> pckage name
	do -> add package log level info if it not exists
	output -> nothing
=cut
sub _check_package_log_level {
	my ($package) = @_;
	$mod_log_levels{ $package }{ log_level } = $log_levels{$log_level} unless (exists $mod_log_levels{ $package });	# устанавливаем вес log_level по умолчанию.
	return;
}

=head1 Loging_Manage
=cut
=head2 log_level
    input -> new log_level for CURRENT module
=cut
sub log_level {
	my $self = shift;
	my $level = shift;
	my ($package) = caller;

	if ( exists $log_levels{$level} ) {
		$mod_log_levels{ $package }{ log_level } = $log_levels{$level};
	}
	# ToDo else -> неподдерживаемый уровень логирования
}

=head2 log_prefix
	input -> string prefix or func ref.
	if ref -> log_prefix = result of func.
	if ref -> send as arg current log_level,
    Ввод -> строковый префикс или ссылка на функцию
    Если ссылка на функцию -> префикс = результат выполнения функции, непосредственно во время вывода данных.
    Также в эту функцию в неё в качестве аргумента передается уровень логирования(чтобы его можно было вывести в префиксе)
=cut
sub log_prefix {
	my $pref = shift;

	# ToDo проверить на соответствие параметра ожидаемому (строка или ссылка на функцию)

	$log_prefix = $pref;
}

=head1 AUTHOR

Dmitriy, C<< <Dmitriy at Tcibisov.ru> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mrlog at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MRLog>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MRLog


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MRLog>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MRLog>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MRLog>

=item * Search CPAN

L<http://search.cpan.org/dist/MRLog/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2017 Dmitriy.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of MRLog
