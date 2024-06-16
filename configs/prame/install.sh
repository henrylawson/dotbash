#!/bin/bash
set -euo pipefail

UTILS_PATH=~/utils

install_rclone() {
    sudo -v ; curl https://rclone.org/install.sh | sudo bash
}

install_rclone
