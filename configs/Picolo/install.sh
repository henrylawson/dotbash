#!/bin/bash
set -euo pipefail

UTILS_PATH=~/utils

install_helm() {
  local SUCCESS="${UTILS_PATH}/helm-v2.8.0-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    mkdir -p "${UTILS_PATH}/helm"
    cd "${UTILS_PATH}/helm"
    curl -L -o package.tar.gz https://kubernetes-helm.storage.googleapis.com/helm-v2.8.0-darwin-amd64.tar.gz
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch $SUCCESS
  fi
}

install_go() {
  local VERSION="go1.10"
  local SUCCESS="${UTILS_PATH}/%{VERSION}-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    mkdir -p "${UTILS_PATH}/go"
    cd "${UTILS_PATH}/go"
    curl -L -o package.tar.gz "https://dl.google.com/go/${VERSION}.darwin-amd64.tar.gz"
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch $SUCCESS
  fi
}

install_helm
install_go