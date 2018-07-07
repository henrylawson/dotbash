#!/bin/bash
set -euo pipefail

TIMESTAMP="$(date +'%s')"

backup_file() {
  local file=$1

  echo "Backing up file [${file}]"
  sudo cp "${file}" "${file}.bk-${TIMESTAMP}"
}

log() {
  local message=$1

  echo ""
  echo ">>>> ${message}"
}

setup_raspberry_pi() {
  log "Enabling natural scrolling"
  backup_file /usr/share/X11/xorg.conf.d/40-libinput.conf
  sudo sh -c "cat <<EOF > /usr/share/X11/xorg.conf.d/40-libinput.conf
# Match on all types of devices but tablet devices and joysticks
Section "InputClass"
        Identifier "libinput pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "true"
EndSection

Section "InputClass"
        Identifier "libinput keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection

Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection

Section "InputClass"
        Identifier "libinput touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection

Section "InputClass"
        Identifier "libinput tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
EndSection
EOF"

  log "Setting keyboard to US layout"
  backup_file /etc/default/keyboard
  sudo sed -i "/XKBLAYOUT=/c\XKBLAYOUT=us" /etc/default/keyboard
  
  log "Change overscan for monitor"
  backup_file /boot/config.txt
  sudo sed -i "/disable_overscan=/c\disable_overscan=1" /boot/config.txt
  
  log "Create user hgl"
  sudo adduser --home /home/hgl --shell /bin/bash hgl || true
  
  log "Make hgl a sudoer"
  sudo adduser hgl sudo || true
  
  log "Setting hostname"
  backup_file /etc/hostname
  sudo sh -c "echo "Prasp" > /etc/hostname"
  backup_file /etc/hosts
  sudo sed -i "/127.0.1.1=/c\127.0.0.1\tPrasp" /etc/hosts
  
  log "Disable autologin"
  backup_file /etc/lightdm/lightdm.conf
  sudo sed -i "/autologin=pi/c\#autologin=pi" /etc/lightdm/lightdm.conf
  sudo mv /etc/systemd/system/autologin@.service /etc/systemd/system/autologin@.service-ignore || true

  log "Deleting pi user"
  if [ "${USER}" != "pi" ];then
    sudo deluser pi --remove-home || true
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

main() {
  setup_raspberry_pi
  install_fasd
}

main "${@}"
