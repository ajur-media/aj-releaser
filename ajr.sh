#!/bin/bash

# Билдер

# Определение родной директории скрипта
SCRIPT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"

# подключаем служебные файлы
source $SCRIPT_DIR/lib.sh
source $SCRIPT_DIR/config.cfg

# Не случайно ли запустили?
ask_YN "Собрать пакет ${package}?" "[ y ] - да,
    [ Y ] - сборка, установка пакета, удаление deb-файла,
    [ any key ] - прекратить работу."
WAY=$?

echo $WAY

if [ $WAY -eq 255 ]
then
	exit $WAY
fi

# Полезная работа
build
BUILD_STATUS=$?

if [ $BUILD_STATUS -eq 0 ] || [ $BUILD_STATUS -eq 1 ]
then
	if [ $WAY -ne 1 ]
	then
		# Хотим ли ставить?
		ask_YN "Установить пакет ${package}?" "[ y ] - да,
    [ any key ] - прекратить работу." || exit $?
		WAY=$?
	fi

	install $pkgpath

	if [ $WAY -ne 1 ]
	then
		# Надо ли удалить?
		ask_YN "Удалить файлы сборки $pkgfiles?" "[ y ] - да,
    [ any key ] - прекратить работу." || exit $?
		WAY=$?
	fi

	deldeb $pkgfiles
fi
exit 0

# TODO: реализовать механизм ключей, подобно этому: https://habrahabr.ru/post/158971/