#!/usr/bin/env perl

use 5.016;
use warnings;

# один два
# одна две три четыре пять шесть семь восемь девять 
# десять одиннадцать двенадцать тринадцать четырнадцать пятнадцать
# шестнадцать семнадцать восемнадцать девятнадцать двадцать
# тридцать сорок пятьдесят шестьдесят семьдесят восемьдесят девяносто

# сто двести триста четыреста пятьсот шестьсот семьсот восемьсот девятьсот

# [одна, двадцать одна, сто одна, cто двадцать одна] тысяча, 
# [две-четыре, двадцать две, сто две, сто двадцать две] тясячи, 
# [пять-двадцать, двадцать пять, сто пять, сто двадцать пять] тысяч  

# [один, двадцать один, сто один, сто двадцать один] миллион,  
# [два-четыре, двадцать два, сто два, сто двадцать два] миллиона,
# [пять-двадцать, двадцать пять, сто пять, сто двадцать пять] миллионов 

# один миллиард

# Миллиард = 1 000 000 000
# Миллион  = 	 1 000 000
# Тысяча   =         1 000
# сто      =           100
# десять   =            10
# один     =             1

# Проверяем наличие и количество аргументов
die "Bad arguments: Need one argument" if not @ARGV;
warn "Warning: Too much arguments" if @ARGV > 1;

# принятый параметр
my ($N) = @ARGV;

# проверяем что N - натуральное число (допустим что пользователь может написать знак + перед числом)
die "Bad arguments: Argument is not a natural number" if $N !~ /^[+]?\d+$/;
die "Bad arguments: Argument is not a natural number" if not $N;

say Lingnum($N);

# Рассчитывает словесное представление переданного числа
sub Lingnum {
	# числовые представления делителя
	my $billion  = 1000000000;
	my $million  = 1000000;
	my $thousand = 1000;
	# массивы строк
	my @billions  = qw(миллиард);
	my @millions  = qw(миллион миллиона миллионов);
	my @thousands = qw(тысяча тясячи тысяч);
	# забираем аргумент переданный в функцию
	my $N = shift;
	# переменная для строки результата
	my $rezult = "";
	# обработка
	# миллиард (один миллиард)
	my $divider = int($N / $billion);
	if ($divider > 0) {
		$N = $N % $billion;
		$rezult = $rezult . "один " . $billions[0] . " ";
	}
	# миллион (один миллион - девятьсот девяносто девять миллионов)
	$divider = int($N / $million);
	if ($divider > 0) {
		# сокращаем исходное число
		$N = $N % $million;
		# добавляем информацию о количестве миллионов
		$rezult = LingnumPart($divider, $rezult, 1);
		# определяем какой тип миллионов выводить
		my $type = GetType($divider);		
		$rezult = $rezult . $millions[$type]. " ";
	}
	# тысячи (одна тысяча - девятьсот девяносто девять тысяч)
	$divider = int($N / $thousand);
	if ($divider > 0) {
		# сокращаем исходное число
		$N = $N % $thousand;
		# добавляем информацию о количестве тысяч
		$rezult = LingnumPart($divider, $rezult, 0);
		# определяем какой тип тысяч выводить
		my $type = GetType($divider);		
		$rezult = $rezult . $thousands[$type]. " ";
	}
	# выводим оставшиеся сотни, десятки, тысячи
	$rezult = LingnumPart($N, $rezult, 1);
	# возвращаем результат
	return $rezult;
}

# Принимает на вход:
# число, строку для помещения результата и тип используемых единиц(0 - units0, 1 - units1)
# Возвращает:
# строку с добавлением результата по числу
sub LingnumPart {
	# числовые представления делителя
	my $hundred  = 100;
	my $dozen    = 10;
	# массивы строк
	my @hundreds  = qw(сто двести триста четыреста пятьсот шестьсот семьсот восемьсот девятьсот);
	my @dozens    = qw(десять двадцать тридцать сорок пятьдесят шестьдесят семьдесят восемьдесят девяносто);
	my @units0    = qw(одна две три четыре пять шесть семь восемь девять); # тясяча
	my @units1    = qw(один два три четыре пять шесть семь восемь девять); # миллион, миллиард

	# принимаем параметры
	my $N = shift;
	my $rezult = shift;
	my $type = shift;

	# сотни
	my $divider = int($N / $hundred);
	if ($divider > 0) {
		$N = $N % $hundred;
		$rezult = $rezult . $hundreds[$divider-1]. " ";
	}
	# десятки
	$divider = int($N / $dozen);
	if ($divider > 0) {
		$N = $N % $dozen;
		$rezult = $rezult . $dozens[$divider-1]. " ";
	}
	# единицы
	if ($N > 0) {
		if ($type) { # один два
			$rezult = $rezult . $units1[$N-1]. " ";
		}
		else {	# одна две
			$rezult = $rezult . $units0[$N-1]. " ";
		}
	}

	return $rezult;
}

# Принимает на вход:
# число
# Возвращает:
# индекс (0-2) произношения числа (пример - тысяча(1) тясячи(2-4) тысяч(5-20))
sub GetType {
	my $N = shift;
	# отрезаем лишнее
	$N = $N % 10;
	#
	if ($N == 1) {
		return 0;
	}
	elsif ($N > 1 and $N < 5) {
		return 1;
	}
	else {
		return 2;
	}	
}