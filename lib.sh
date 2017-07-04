#!/bin/bash

# Функция импорта сторонних файлов
# @since 0.2.0
import() {
	source "$1";
  
	if [ $? -ne 0 ]; then
		echo "Ошибка: не найден подключаемый файл: $1" 1>&2
		exit 254;
	fi
}

# Спрашиваем для верности
# y 						- согласие на отдельный вопрос
# Y 						- согласие на все вопросы
# любой символ 	- отмена операции, прекращение работы
# @since 0.4.0
ask_YN() {
	local AMSURE
  
	if [ -n "$1" ]; then
		read -n 1 -p "$1
    $2
    Ваш выбор: " AMSURE
	else
		read -n 1 AMSURE
	fi
	echo "" 1>&2

	case "$AMSURE" in
		y|д)
			echo "Сами попросили..."
			return 0
			;;
		Y|Д)
			echo "Вы согласились на всё сами..."
			return 1
			;;
		*)
			echo "Отмена..."
			return 255
			;;
	esac
}

# Функция проверки статуса выполнения операции
# @since 0.2.0
check_success() {
	local STATUS="[ OK ]"

	if [ $1 -eq 0 ]; then
		echo -n "${green}"
	else
		echo -n "${red}"
		STATUS="[fail]"
	fi

	if [ -n "$2" ]; then
		echo -n "$2"
	fi

	echo -n "${toend}$STATUS"
	echo "${reset}"
  
	[ $1 -eq 0 ] && return 0 || return 255
}

# Собираем пакет
# @since 0.2.0
build() {
	dpkg-buildpackage -rfakeroot

	check_success $? "Сборка..."
	return $?
}

# Ставим пакет
# @since 0.2.0
install() {
	if [ -e $1 ]; then
		sudo dpkg -i $1

		check_success $? "Установка..."
		return $?
	fi
}

# Удаляем сбилдованный deb-файл
# @since 0.4.0
deldeb() {
	rm $*

	check_success $? "Удаление файлов сборки..."
	return $?
}