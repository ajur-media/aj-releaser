#!/bin/bash

red=$(tput setf 4)
green=$(tput setf 2)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)

# Функция проверки статуса выполнения операции
check_success() {
  if [ $? -eq 0 ]; then
    echo -n "${green}${toend}[ OK ]"
  else
    echo -n "${red}${toend}[fail]"
  fi
  echo -n "${reset}"
  echo
}