#!/bin/bash
set -euo pipefail

UTILS_PATH=~/utils

install_rclone() {
  if hash rclone 2>/dev/null
  then
    sudo -v ; curl https://rclone.org/install.sh | sudo bash
  fi
}

install_rclone
