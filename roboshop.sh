#!/bin/bash

USER_ID=$(id -u)

case $USER_ID in
  0)
    echo "Starting Installation"
  ;;
  *)
    echo "You should be a root user to perform this script"
    exit 
    ;;
esac

case $1 in
  frontend)
    echo Installing Frontend
    yum install nginx -y
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
    ;;
esac