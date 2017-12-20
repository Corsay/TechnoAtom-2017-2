package Local::MRLog 1.00;

use 5.006;
use strict;
use warnings;

use Data::Dumper;
use DDP;

=head1 NAME

MRLog - The great new Log module!

=head1 VERSION

Version 1.00

=cut

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use MRLog;

    my $foo = MRLog->new();
    ...

=head1 EXPORT

    ToDo info about export functions

=head1 SUBROUTINES/METHODS
=cut

# уровни логирования
my %log_levels = (
	error => 5,
	warn => 4,
	info => 3,
	debug1 => 2,
	debug2 => 1,
	debug3 => 0,
);
# уровни логирования для конкретного модуля
my %mod_log_levels = ();
our $log_level = 'info';	# log_level по умолчанию
our $log_prefix = '';	# log_prefix по умолчанию

=head1 Loging_Output
    input -> args
    output -> output args to STDERR in one line, joined by " "
    print in STDERR only if log_level >= func_log_level
=cut
=head2 log_error
=cut
sub log_error {
	my @args = @_;
	return if $log_level < $log_levels{error};	# if log level lower

	# получаем prefix
	my $prefix = $log_prefix;
	$prefix = $log_prefix->( $log_level ) if (ref $log_prefix eq 'CODE');
	print STDERR $prefix;

	# выводим аргументы в STDERR
	for my $arg (@args) {
		if (ref $arg ne '') {
			print STDERR Dumper($arg);
		}
		else {
			print STDERR $arg;
		}
	}
	print "\n";
}

=head2 log_warn
=cut
sub log_warn {

}

=head2 log_info
=cut
sub log_info {

}

=head2 log_debug1
=cut
sub log_debug1 {

}

=head2 log_debug2
=cut
sub log_debug2 {

}

=head2 log_debug3
=cut
sub log_debug3 {

}

=head1 LogingManage
=cut
=head2 log_level
    input -> new log_level for CURRENT module
=cut
sub log_level {
	my $level = shift;

	if ( exists $log_levels{$level} ) {
		$log_level = $level;
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
