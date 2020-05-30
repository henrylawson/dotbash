#!/bin/bash
set -euo pipefail

UTILS_PATH=~/utils

install_go() {
  local version="go1.10"
  local success="${UTILS_PATH}/${version}-SUCCESS"
  if [ ! -f "${success}" ]
  then
    mkdir -p "${UTILS_PATH}/golang"
    cd "${UTILS_PATH}/golang"
    curl -L -o package.tar.gz "https://dl.google.com/go/${version}.darwin-amd64.tar.gz"
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch "${success}"
  fi
}

install_go
