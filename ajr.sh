#!/bin/bash

# Билдер

# Определение родной директории скрипта
SCRIPT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"

# подключаем служебные файлы
source $SCRIPT_DIR/lib.sh
source $SCRIPT_DIR/config.cfg

# Не случайно ли запустили?
ask_YN "Установить пакет ${package}?" || exit $?

# Полезная работа
build
BUILD_STATUS=$?

if [ $BUILD_STATUS -eq 0 ]
then
  install $pkgpath
fi
exit 0

# TODO: реализовать механизм ключей, подобно этому: https://habrahabr.ru/post/158971/