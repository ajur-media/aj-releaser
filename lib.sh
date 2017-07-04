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
# @since 0.5.0
ask_YN() {
	local AMSURE

while true; do
	if [ -n "$1" ]; then
		read -n 1 -p "${bold}$1${reset}
    $2
    Ваш выбор: " AMSURE
	else
		read -n 1 AMSURE
	fi
	echo "" 1>&2

	# Параметр по умолчанию, если есть
	if [ -n "$3" ]; then
		AMSURE=${AMSURE:-${3}}
	fi

	case "$AMSURE" in
		y)
			echo "Сами попросили..."
			return 0
			;;
		Y)
			echo "Вы согласились на всё сами..."
			return 1
			;;
		n)
			echo "Пропускаем..."
			return 254
			;;
		q)
			echo "Не смогла я... не смогла..."
			exit 0
			;;
		*) echo "Давайте попробуем ещё раз:";;
		esac
	done
}

# Функция проверки статуса выполнения операции
# @since 0.4.0
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
# @since 0.4.0
build() {
	dpkg-buildpackage -rfakeroot

	check_success $? "Сборка..."
	return $?
}

# Ставим пакет
# @since 0.5.0
install() {
	if [ -e $1 ]; then
		sudo dpkg -i $1

		check_success $? "Установка..."
		return $?
	else
		echo -n "${yellow}Отсутствует deb-файл: $1"
		echo "${reset}"
		return 1
	fi
}

# Удаляем сбилдованный deb-файл
# @since 0.5.0
deldeb() {
	local FILELIST=$(find $pkg_dir -name "${pkginfo}*" -print -quit)

	if [ -n "$FILELIST" ]; then
		rm $*

		check_success $? "Удаление файлов сборки..."
		return $?
	else
		echo -n "${yellow}Не найдено файлов сборки"
		echo "${reset}"
		return 1
	fi
}

# Положить пакет в репозиторий
# @since 0.5.0
put2rep() {
	if [ -e $pkg4rep ]; then
		dput -u $repository_user $pkg4rep

		check_success $? "Запись в репозиторий"
		return $?
	fi
}