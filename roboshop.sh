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

Status_Check() {
  case $? in
    0)
      echo SUCCESS
      ;;
    *)
      echo FAILURE
      exit 3
      ;;
  esac
}

### Main Program

case $1 in
  frontend)
    echo -e "\e[1;33m**************>>>>>>>>>>>>>>>>>>>>>  Installing Nginx   <<<<<<<<<<<<<<<<<<<<<<<<<<<****************\e[0m"
    yum install jenkins -y
    Status_Check
    echo -e "\e[1;33m**************>>>>>>>>>>>>>>>>>>>>>  Starting Nginx   <<<<<<<<<<<<<<<<<<<<<<<<<<<****************\e[0m"
    systemctl enable nginx
    systemctl start nginx
    case $? in
      0)
        echo SUCCESS
        ;;
      *)
        echo FAILURE
        exit 3
        ;;
    esac
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