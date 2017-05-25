#!/bin/bash
set -euo pipefail

install_maven() {
  local SUCCESS="/opt/user/apache-maven-3.5.0-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    cd /opt/user
    wget -O package.tar.gz http://www-us.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch $SUCCESS
  fi
}

install_endpoints_frameworks_tools() {
  local SUCCESS="/opt/user/endpoints-framework-tools-2.0.0-beta.12-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    cd /opt/user
    wget -O package.zip http://search.maven.org/remotecontent?filepath=com/google/endpoints/endpoints-framework-tools/2.0.0-beta.12/endpoints-framework-tools-2.0.0-beta.12.zip
    unzip package.zip
    rm package.zip
    touch $SUCCESS
  fi
}

install_appcfg() {
  local SUCCESS="/opt/user/google_appengine_1.9.54-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    cd /opt/user
    wget -O package.zip https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.54.zip
    unzip package.zip
    rm package.zip
    touch $SUCCESS
  fi
}

install_fasd() {
  local SUCCESS="/opt/user/fasd-1.0.1-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    cd /opt/user
    wget -O package.tar.gz https://github.com/clvv/fasd/tarball/1.0.1
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch $SUCCESS
  fi
}

install_gradle() {
  local SUCCESS="/opt/user/gradle-3.5-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    cd /opt/user
    wget -O package.tar.gz https://services.gradle.org/distributions/gradle-3.5-bin.zip
    unzip package.zip
    rm package.zip
    touch $SUCCESS
  fi
}

main() {
  install_maven
  install_gradle
  install_endpoints_frameworks_tools
  install_appcfg
  install_fasd
}

main "$@"
