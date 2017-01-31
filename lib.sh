#!/bin/bash

red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)

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
# @since 0.2.0
ask_YN() {
  local AMSURE
  
  if [ -n "$1" ]; then
    read -n 1 -p "$1 (y / [ a ]): " AMSURE
  else
    read -n 1 AMSURE
  fi
  echo "" 1>&2

  case "$AMSURE" in
    y|Y|д|Д)
      echo "Сами попросили..."
      return 0
      ;;
    *)
      echo "Отмена установки..."
      return 255
      ;;
  esac
}

# Функция проверки статуса выполнения операции
# @since 0.2.0
check_success() {
  if [ $1 -eq 0 ]; then
    echo -n "${green}${toend}[ OK ]"
  else
    echo -n "${red}${toend}[fail]"
  fi
  echo -n "${reset}"
  echo
  
  [ $1 -eq 0 ] && return 0 || return 255
}

# Собираем пакет
# @since 0.2.0
build() {
  dpkg-buildpackage -rfakeroot

  check_success $?
  return $?
}

# Ставим пакет
# @since 0.2.0
install() {
  if [ -e $1 ]
  then
    sudo dpkg -i $1
    
    check_success $?
    return $?
  fi
}