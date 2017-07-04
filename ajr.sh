#!/bin/bash

# Билдер

# Определение родной директории скрипта
SCRIPT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"

# подключаем служебные файлы
source $SCRIPT_DIR/lib.sh
source $SCRIPT_DIR/config.cfg

echo "${bold}AJ Builder ${version}${reset}"
tail "$SCRIPT_DIR/readme.txt"
echo

# Не случайно ли запустили?
ask_YN "Собрать пакет ${package}?" "[   ] y - да,
    ${bold}[ * ] n - пропустить,${reset}
    [   ] Y - быстрая сборка,
    [   ] q - прекратить работу." "n"
WAY=$?

if [ $WAY -eq 255 ]; then
	exit $WAY
fi

if [ $WAY -ne 254 ]; then
	# Полезная работа
	build
	BUILD_STATUS=$?
fi

BUILD_STATUS=${BUILD_STATUS:-0}

# Если не пропустили сборку и отсроили новый пакет, не "быстрой сборкой"
if [[ $BUILD_STATUS -eq 0 && $WAY -ne 1 && $WAY -ne 254 ]]; then
	if [ "$distrib" == 'stable' ] || [ "$distrib" == 'unstable' ]; then
		# Хотим ли класть в репозиторий?
		ask_YN "${red}Записать пакет ${package} в репозиторий (${distrib})?${reset}" "[   ] y - да,
    ${bold}[ * ] n - пропустить,${reset}
    [   ] q - прекратить работу." "n"
		WAY=$?
	else
		echo "${yellow}Пропускаем запись в репозиторий: операция должна быть выполнена вручную.${reset}"
	fi

	if [ $WAY -eq 255 ]; then
		exit $WAY
	fi

	if [ $WAY -eq 0 ] || [ $WAY -eq 1 ]; then
		put2rep $pkgpath
	fi
fi

if [ $WAY -ne 1 ]; then
	# Хотим ли ставить?
	ask_YN "Установить пакет ${package}?" "[   ] y - да,
    ${bold}[ * ] n - пропустить,${reset}
    [   ] q - прекратить работу." "n"
	WAY=$?
fi

if [ $WAY -eq 0 ] || [ $WAY -eq 1 ]; then
	install $pkgpath
fi

if [ $WAY -ne 1 ]; then
	# Надо ли удалить?
	ask_YN "Удалить файлы сборки $pkginfo*?" "[   ] y - да,
    ${bold}[ * ] n - пропустить,${reset}
    [   ] q - прекратить работу." "n"
	WAY=$?
fi

if [ $WAY -eq 0 ] || [ $WAY -eq 1 ]; then
	deldeb "${pkg_dir}/${pkginfo}*"
fi

exit 0

# TODO: реализовать механизм ключей, подобно этому: https://habrahabr.ru/post/158971/