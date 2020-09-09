#!/bin/bash

USER_ID=$(id -u)

case $USER_ID in
  0)
    echo "Starting Installation"
  ;;
  *)
    echo -e "\e[1;31mYou should be a root user to perform this script\e[0m"
    exit 1
    ;;
esac

## Functions

Print() {
  echo -e "\e[1;33m**************>>>>>>>>>>>>>>>>>>>>>  $1   <<<<<<<<<<<<<<<<<<<<<<<<<<<****************\e[0m"
}

Status_Check() {
  case $? in
    0)
      echo -e "\e[1;32m**************>>>>>>>>>>>>>>>>>>>>>  SUCCESS   <<<<<<<<<<<<<<<<<<<<<<<<<<<****************\e[0m"
      ;;
    *)
      echo -e "\e[1;31m**************>>>>>>>>>>>>>>>>>>>>>  FAILURE   <<<<<<<<<<<<<<<<<<<<<<<<<<<****************\e[0m"
      exit 3
      ;;
  esac
}

### Main Program

case $1 in
  frontend)
    Print "Installing NGINX"
    yum install nginx -y
    Status_Check
    Print "Starting Nginx"
    systemctl enable nginx
    systemctl start nginx
    Status_Check
    ;;
  catalogue)
    echo Installing Catalogue
    echo Completed Installing  Catalogue
    ;;
  cart)
    echo Installing Cart
    echo Completed Installing Cart
    ;;
  *)
    echo "Invalid Input, Following inputs are only accepted"
    echo "Usage: $0 frontend|catalogue|cart"
    exit 2
    ;;
esac