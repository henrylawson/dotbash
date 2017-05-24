#!/bin/bash
set -euo pipefail

install_maven() {
  local SUCCESS="/opt/user/apache-maven-3.5.0-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    cd /opt/user
    wget http://www-us.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
    tar xzvf apache-maven-3.5.0-bin.tar.gz
    rm apache-maven-3.5.0-bin.tar.gz
    touch $SUCCESS
  fi
}

main() {
  install_maven
}

main "$@"
