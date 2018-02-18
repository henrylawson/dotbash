#!/bin/bash
set -euo pipefail

UTILS_PATH=~/utils

install_helm() {
  local version="v2.8.0"
  local success="${UTILS_PATH}/helm-${version}-SUCCESS"
  if [ ! -f "${success}" ]
  then
    mkdir -p "${UTILS_PATH}/helm"
    cd "${UTILS_PATH}/helm"
    curl -L -o package.tar.gz https://kubernetes-helm.storage.googleapis.com/helm-${version}-darwin-amd64.tar.gz
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch "${success}"
  fi
}

install_go() {
  local version="go1.10"
  local success="${UTILS_PATH}/${version}-SUCCESS"
  if [ ! -f "${success}" ]
  then
    mkdir -p "${UTILS_PATH}/go"
    cd "${UTILS_PATH}/go"
    curl -L -o package.tar.gz "https://dl.google.com/go/${version}.darwin-amd64.tar.gz"
    tar xzvf package.tar.gz
    rm package.tar.gz
    touch "${success}"
  fi
}

install_helm
install_go