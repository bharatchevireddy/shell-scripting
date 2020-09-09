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
    Print "Downloading Frontend App"
    curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/db389ddc-b576-4fd9-be14-b373d943d6ee/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    Status_Check
    cd /usr/share/nginx/html
    rm -rf *
    Print "Extracting Frontend Archive"
    unzip /tmp/frontend.zip
    Status_Check
    mv static/* .
    rm -rf static README.md
    mv localhost.conf /etc/nginx/nginx.conf
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