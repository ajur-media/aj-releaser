#!/bin/bash

#set -e

# Билдер

# Определение родной директории скрипта
SCRIPT_DIR="$( cd "$( dirname $(readlink -e "${BASH_SOURCE[0]}") )" && pwd )"

# подключаем служебные файлы
source $SCRIPT_DIR/config.cfg
source $SCRIPT_DIR/lib.sh

# Даём шанс отступить
echo -n "Установить пакет ${package}? (Y / N) "

read item

case "$item" in
  y|Y|д|Д) echo "Сами попросили..."
      ;;
  n|N|н|Н) echo "Отмена установки..."
      exit 0
      ;;
  *) echo "Не понял ответа: завершаю работу"
      exit 0
      ;;
esac
  
# Полезная работа
dpkg-buildpackage -rfakeroot

check_success

if [ -e $pkgpath ]
then
  sudo dpkg -i $pkgpath
  
  check_success
fi
exit 0
