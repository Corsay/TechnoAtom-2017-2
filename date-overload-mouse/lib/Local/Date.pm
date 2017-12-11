package Local::Date;

use Time::Local;
use locale;	# Для вывода AM\PM
use POSIX qw(strftime locale_h);
setlocale(LC_TIME, "C");

use Local::Date::Interval;
use Mouse;

=head2
	Аттрибуты
=cut
has [qw(day month year hours minutes seconds)] => (
	is => 'rw',
	isa => 'Int',
);
has epoch => (
	is => 'rw',
	isa => 'Int',
	builder => '_init_by_date_comp',
	trigger => \&_get_date_comp,	# при изменении timestamp изменять соответственно day month year hours minutes seconds
);
has format => (
	is => 'rw',
	isa => 'Str',
	default => '%a %b %e %T %Y',
);

=head2
	Инициализируем epoch (сразу) согласно переданной дате.
=cut
sub _init_by_date_comp {
	my ($self) = @_;
	my $time = timegm($self->seconds(), $self->minutes(), $self->hours(), $self->day(), $self->month() - 1, $self->year());
	$self->epoch($time);
}

=head2
	Перерасчитывает компоненты даты (согласно timestamp)
=cut
sub _get_date_comp {
	my ($self) = @_;

	# получаем компоненты даты (по GMT)
	my @time = gmtime($self->epoch());
	$self->seconds($time[0]);
	$self->minutes($time[1]);
	$self->hours($time[2]);
	$self->day($time[3]);
	$self->month($time[4]);
	$self->year(1900 + $time[5]);
}

=head2
	Перегрузка операторов
=cut
use overload
	# контексты
	'""' => '_string_con',	# строковый
	'0+' => '_digit_con',	# числовой
	fallback => 1;

=head2
	Строковый контекст.
	* Дата должна преобразовываться в строку вида `"Fri May 19 02:08:33 2017"`.
	* Формат преобразовния определяется атрибутом объекта, и должен быть совместим с форматами функции `strftime`.
=cut
sub _string_con {
	my ($self) = @_;
	return strftime( $self->format(), gmtime($self->epoch()) );
}

sub _digit_con {
	my ($self) = @_;
	return $self->epoch();
}

no Mouse;

1;
