#!/bin/bash
set -euo pipefail

UTIL_PATH=~/utils

install_helm() {
  local SUCCESS="${UTILS_PATH}/helm-v2.8.0-SUCCESS"
  if [ ! -f $SUCCESS ]
  then
    mkdir -p "${UTILS_PATH}/helm"
    cd "${UTILS_PATH}/helm"
    wget -O package.tar.gz https://kubernetes-helm.storage.googleapis.com/helm-v2.8.0-darwin-amd64.tar.gz
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch $SUCCESS
  fi
}

install_helm
