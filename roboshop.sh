#!/bin/bash

USER_ID=$(id -u)
DNS_DOMAIN_NAME="devopsb51.tk"

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

Create_AppUser() {
  id roboshop
  case $? in
    1)
      Print "Add Application User"
      useradd roboshop
      Status_Check
    ;;
  esac
}

Setup_NodeJS() {
  Print "Installing NodeJS"
  yum install nodejs make gcc-c++ -y
  Status_Check
  Create_AppUser
  Print "Downloading Application"
  curl -s -L -o /tmp/$1.zip "$2"
  Status_Check
  Print "Extracting Applciation Archive"
  mkdir -p /home/roboshop/$1
  cd /home/roboshop/$1
  unzip -o /tmp/$1.zip
  Status_Check
  Print "Install NodeJS App dependencies"
  npm --unsafe-perm install
  Status_Check
  chown roboshop:roboshop /home/roboshop -R
  Print "Setup $1 Service"
  mv /home/roboshop/$1/systemd.service /etc/systemd/system/$1.service
  sed -i -e "s/MONGO_ENDPOINT/mongodb.${DNS_DOMAIN_NAME}/" /etc/systemd/system/$1.service
  sed -i -e "s/REDIS_ENDPOINT/redis.${DNS_DOMAIN_NAME}/" /etc/systemd/system/$1.service
  sed -i -e "s/CATALOGUE_ENDPOINT/catalogue.${DNS_DOMAIN_NAME}/" /etc/systemd/system/$1.service
  Status_Check
  Print "Start $1 Service"
  systemctl daemon-reload
  systemctl enable $1
  systemctl start $1
  Status_Check
}

SHIPPING() {
    Print "Install Maven "
    yum install maven -y
    Status_Check
    Create_AppUser
    cd /home/roboshop
    Print "Downloading Application"
    curl -s -L -o /tmp/shipping.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/e13afea5-9e0d-4698-b2f9-ed853c78ccc7/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    Status_Check
    mkdir shipping
    cd shipping
    Print "Extracting Archive"
    unzip /tmp/shipping.zip
    Status_Check
    Print "Install Dependencies"
    mvn clean package
    Status_Check
    mv target/*dependencies.jar shipping.jar
    chown roboshop:roboshop /home/roboshop -R
    mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
    sed -i -e "s/CARTENDPOINT/cart.${DNS_DOMAIN_NAME}/" /etc/systemd/system/shipping.service
    sed -i -e "s/DBHOST/mysql.${DNS_DOMAIN_NAME}/" /etc/systemd/system/shipping.service
    systemctl daemon-reload
    systemctl enable shipping
    Print "Start Service"
    systemctl start shipping
    Status_Check
}

FRONTEND() {
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
    mv template.conf /etc/nginx/nginx.conf

#    for app in catalogue cart user shipping payment; do
#      export
#    done
    export CATALOGUE=catalogue.${DNS_DOMAIN_NAME}
    export CART=cart.${DNS_DOMAIN_NAME}
    export USER=user.${DNS_DOMAIN_NAME}
    export SHIPPING=shipping.${DNS_DOMAIN_NAME}
    export PAYMENT=payment.${DNS_DOMAIN_NAME}

    sed -i -e "s/CATALOGUE/${CATALOGUE}/" -e "s/CART/${CART}/" -e "s/USER/${USER}/" -e "s/SHIPPING/${SHIPPING}/" -e "s/PAYMENT/${PAYMENT}/" /etc/nginx/nginx.conf

    Print "Starting Nginx"
    systemctl enable nginx
    systemctl restart nginx
    Status_Check
}

REDIS() {
    echo Installing Redis
    Print "Install Yum Utils"
    yum install epel-release yum-utils http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
    Status_Check
    Print "Enable Remi repos"
    yum-config-manager --enable remi
    Status_Check
    Print "Install Redis"
    yum install redis -y
    Status_Check
    Print "Update Configuration"
    sed -i -e '/^bind 127.0.0.1/ c bind 0.0.0.0' /etc/redis.conf
    Status_Check
    Print "Start Service"
    systemctl enable redis
    systemctl start redis
    Status_Check
}

MONGO() {
    echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
    Print "Installing MongoDB"
    yum install -y mongodb-org
    Status_Check
    Print "Update MongoDB Configuration"
    sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
    Status_Check
    Print "Starting MongoDB Service"
    systemctl enable mongod
    systemctl start mongod
    Status_Check
    Print "Download Schema"
    curl -s -L -o /tmp/mongodb.zip "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/e9218aed-a297-4945-9ddc-94156bd81427/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    Status_Check
    cd /tmp
    Print "Extracting Archive"
    unzip -o /tmp/mongodb.zip
    Status_Check
    Print "Load Catalogue Schema"
    mongo <catalogue.js
    Status_Check
    Print "Load Users Schema"
    mongo <users.js
    Status_Check
}

MYSQL() {
  Print "Download MySQL"
  curl -L -o /tmp/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
  Status_Check
  cd /tmp
  Print "Extract Archive"
  tar -xf mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar
  Status_Check
  yum remove mariadb-libs -y
  Print "Install MySQL"
  yum install mysql-community-client-5.7.28-1.el7.x86_64.rpm \
              mysql-community-common-5.7.28-1.el7.x86_64.rpm \
              mysql-community-libs-5.7.28-1.el7.x86_64.rpm \
              mysql-community-server-5.7.28-1.el7.x86_64.rpm -y
  Status_Check
  systemctl enable mysqld
  Print "Start MySQL"
  systemctl start mysqld
  Status_Check
  echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Password@1';\nuninstall plugin validate_password;\nALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/reset-password.sql
  ROOT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  mysql -uroot -p"${ROOT_PASSWORD}" < /tmp/reset-password.sql
}

### Main Program

case $1 in
  frontend)
    FRONTEND
    ;;
  catalogue)
    echo Installing Catalogue
    Setup_NodeJS "catalogue" "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/558568c8-174a-4076-af6c-51bf129e93bb/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    ;;
  cart)
    echo Installing Cart
    Setup_NodeJS "cart" "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/ac4e5cc0-c297-4230-956c-ba8ebb00ce2d/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    ;;
  user)
    echo Installing User
    Setup_NodeJS "user" "https://dev.azure.com/DevOps-Batches/ce99914a-0f7d-4c46-9ccc-e4d025115ea9/_apis/git/repositories/e911c2cd-340f-4dc6-a688-5368e654397c/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    ;;
  redis)
    REDIS
    ;;
  mongodb)
    MONGO
    ;;
  shipping)
    SHIPPING
    ;;
  mysql)
    MYSQL
    ;;

  *)
    echo "Invalid Input, Following inputs are only accepted"
    echo "Usage: $0 frontend|catalogue|cart|mongodb|redis|shipping|mysql"
    exit 2
    ;;
esac