package Local::Date::Interval;

use Mouse;

=head2
	Аттрибуты
=cut
has [qw(days hours minutes seconds)] => (
	is => 'rw',
	isa => 'Int',
);
has duration => (
	is => 'rw',
	isa => 'Int',
	builder => '_init_by_duration_comp',
	trigger => \&_get_duration_comp,	# при изменении duration изменять соответственно days hours minutes seconds
);

=head2
	Инициализируем duration (сразу) согласно переданным компонентам длительности интервала.
=cut
sub _init_by_duration_comp {
	my ($self) = @_;
	# получаем длительность интервала в секундах
	$self->duration( ( ( $self->days() * 24 + $self->hours() ) * 60 + $self->minutes() ) * 60 + $self->seconds() );
}

=head2
	Перерасчитывает компоненты длительности интервала
=cut
sub _get_duration_comp {
	my ($self) = @_;

	# получаем компоненты длительности интервала
	my $duration = $self->duration();
	$self->days( int($duration / 60 / 60 / 24) );	$duration %= 60 * 60 * 24;
	$self->hours( int($duration / 60 / 60) );	$duration %= 60 * 60;
	$self->minutes( int($duration / 60) );	$duration %= 60;
	$self->seconds( int($duration) );
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
	* Интервал должен преобразовываться в строку вида `"1524 days, 20 hours, 0 minutes, 14 seconds"`.
=cut
sub _string_con {
	my ($self) = @_;
	return $self->days() . " days, " . $self->hours() . " hours, " . $self->minutes() . " minutes, " . $self->seconds() . " seconds";
}

sub _digit_con {
	my ($self) = @_;
	return $self->duration();
}

no Mouse;

1;
