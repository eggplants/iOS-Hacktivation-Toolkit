#!/usr/bin/env bash

set -euo pipefail

# This program is free software:
#     you can redistribute it and/or modify it under the terms of
#     the GNU General Public License as published by the Free
#     Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

# License:
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program. If not, see <https://www.gnu.org/licenses/>.

###########################
# COLOURS                 #
###########################

RED="\033[1;31m"
GREEN="\033[1;32m"
# YELLOW="\033[1;33m"
# CYAN="\033[0;36m"
NC="\033[0m"

###########################
# ROOT PRIVILEGES         #
###########################

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED} You don't have root privileges, execute the script as root.${NC}"
  exit 1
fi

###########################
# ROOT PRIVILEGES         #
###########################

if ! command -v ideviceinfo &>/dev/null; then
  echo -e "${RED} Please Install 'ideviceinfo' ${NC}" >&2
  exit 1
elif ! command -v git &>/dev/null; then
  echo -e "${RED} Please Install 'git' ${NC}" >&2
  exit 1
fi

###########################
# Functions               #
###########################

function continueOrExit() {
  # Continue or Exit
  echo
  read -r -p "Complete! Back To Menu? [ Y / n ] : " check
  if [[ "$check" =~ ^(Y|y|Yes|yes|YES)$ ]]; then
    :
  else
    echo -e "${RED} Program Exit ...${NC}"
    exit 0
  fi
}

###########################
# MENU                    #
###########################

while true; do
  clear
  echo -n -e "${GREEN}
 **********************************************************************
 ********************** iOS Hacktivation Toolkit **********************
 **********************************************************************${NC}
 [+]${GREEN}        This software is maintained by SRS appsec@tuta.io${NC}       [+]
 [+]${GREEN}    Thanks to${NC} :${GREEN} @exploit3dguy + @appletech752 + @iRogerosx ${NC}     [+]
 [+]${GREEN}    @SoNick_14 + OC34N Team + Thelittlechicken + iGerman00 ${NC}     [+]
"

  ActivationState="$(ideviceinfo | grep ActivationState: | awk '{print $NF}')"
  # DeviceName="$(ideviceinfo | grep DeviceName | awk '{print $NF}')"
  # UniqueDeviceID="$(ideviceinfo | grep UniqueDeviceID | awk '{print $NF}')"
  SerialNumber="$(ideviceinfo | grep -w SerialNumber | awk '{print $NF}')"
  ProductType="$(ideviceinfo | grep ProductType | awk '{print $NF}')"
  ProductVersion="$(ideviceinfo | grep ProductVersion | awk '{print $NF}')"

  if test -z "$ActivationState"; then
    echo ' ----------------------------------------------------------------------'
    echo -e "${RED}			CANNOT CONNECT TO DEVICE${NC}           "
    echo ' ----------------------------------------------------------------------'
  else
    echo ' ----------------------------------------------------------------------'
    echo -n -e "${GREEN} Serial Number : ${SerialNumber} ${NC}"
    echo -n -e "${GREEN} Device : ${ProductType} ${NC}"
    echo -n -e "${GREEN} Firmware : ${ProductVersion} ${NC}"
    echo ' ----------------------------------------------------------------------'
  fi

  echo -e "${YELLOW} Select an option from the menu : ${NC}"
  echo ' ----------------------------------------------------------------------'
  echo -e "${CYAN} 1 : Complete Installation${NC}"
  echo -e "${CYAN} 2 : Factory Reset (Restore iDevice)${NC}"
  echo -e "${CYAN} 3 : Jailbreak (checkra1n)${NC}"
  echo -e "${CYAN} 4 : PAID Untethered Bypass iOS 13.0 > [OC34N ACTIVATION SERVER]${NC}"
  echo -e "${CYAN} 5 : FREE Tethered Bypass iOS 13.0 > [PATCHED MOBILEACTIVATIOND]${NC}"
  echo -e "${CYAN} 6 : FREE Tethered Bypass iOS 12.4.7 > [PATCHED MOBILEACTIVATIOND]${NC}"
  echo -e "${CYAN} 7 : SSH Shell${NC}"
  echo -e "${CYAN} 0 : Exit${NC}"
  echo ' ----------------------------------------------------------------------'
  read -r -p " Choose >  " ch

  case "$ch" in

  "0")
    echo -e "$RED Program Exit ...$NC"
    break
    ;;

    ###########################
    # INSTALL
    ###########################

  "1") # Install

    if command -v apt &>/dev/null; then # Ubuntu, Debian

      echo "deb https://assets.checkra.in/debian /" | sudo tee -a /etc/apt/sources.list
      apt-key adv --fetch-keys https://assets.checkra.in/debian/archive.key
      apt update
      apt install -y \
        python libtool-bin libcurl4-openssl-dev libplist-dev libzip-dev openssl libssl-dev
      libcurl4-openssl-dev libimobiledevice-dev libusb-1.0-0-dev libreadline-dev build-essential
      git make autoconf automake libxml2-dev libtool pkg-config checkra1n sshpass checkinstall
      git clone --depth 1 'https://github.com/libimobiledevice/libirecovery'
      git clone --depth 1 'https://github.com/libimobiledevice/libideviceactivation'
      git clone --depth 1 'https://github.com/libimobiledevice/idevicerestore'
      git clone --depth 1 'https://github.com/libimobiledevice/usbmuxd'
      git clone --depth 1 'https://github.com/libimobiledevice/libimobiledevice'
      git clone --depth 1 'https://github.com/libimobiledevice/libusbmuxd'
      git clone --depth 1 'https://github.com/libimobiledevice/libplist'
      git clone --depth 1 'https://github.com/rcg4u/iphonessh'
      cd ./libplist && ./autogen.sh --without-cython && sudo make install && cd ..
      cd ./libusbmuxd && ./autogen.sh && sudo make install && cd ..
      cd ./libimobiledevice && ./autogen.sh --without-cython && sudo make install && cd ..
      cd ./usbmuxd && ./autogen.sh && sudo make install && cd ..
      cd ./libirecovery && ./autogen.sh && sudo make install && cd ..
      cd ./idevicerestore && ./autogen.sh && sudo make install && cd ..
      cd ./libideviceactivation/ && ./autogen.sh && sudo make && sudo make install && cd ..
      sudo ldconfig
    elif command -v brew &>/dev/null; then
      brew tap stek29/homebrew-idevice
      brew install \
        checkra1n libirecovery libideviceactivation idevicerestore usbmuxd \
        libimobiledevice libusbmuxd libplist --HEAD
      git clone --depth 1 'https://github.com/rcg4u/iphonessh.git'
    else
      echo -e "${RED} Unknown platform.${NC}"
    fi
    continueOrExit
    ;;

    ###########################
    # RESTORE                 #
    ###########################

  "2") # RESTORE

    idevicerestore -e -l
    continueOrExit
    ;;

    ###########################
    # CHECKRA1N               #
    ###########################

  "3") # CHECKRA1N

    checkra1n
    continueOrExit
    ;;

    ###########################
    # OC34N PAID              #
    ###########################

  "4") # OC34N PAID

    bypass_scripts/oc34n_activation_server_13_x/./run.sh
    continueOrExit
    ;;

    ##############################
    # IOS 13 > MOBILEACTIVATIOND #
    ##############################

  "5") # IOS 13 > MOBILEACTIVATIOND

    bypass_scripts/mobileactivationd_13_x/./run.sh
    continueOrExit
    ;;

    ##################################
    # IOS 12.4.7 > MOBILEACTIVATIOND #
    ##################################

  "6") # IOS 12.4.7 > MOBILEACTIVATIOND

    bypass_scripts/mobileactivationd_12_4_7/./run.sh
    continueOrExit
    ;;

    ###########################
    # SSH SHELL               #
    ###########################

  "7") # SSH SHELL

    echo ""
    rm ~/.ssh/known_hosts >/dev/null 2>&1
    pgrep -f 'tcprelay.py' | xargs kill >/dev/null 2>&1
    python iphonessh/python-client/tcprelay.py -t 44:2222 >/dev/null 2>&1 &
    sleep 2
    sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost -p 2222 mount -o rw,union,update /
    sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost -p 2222
    pgrep -f 'tcprelay.py' | xargs kill >/dev/null 2>&1
    continueOrExit
    ;;

  *) # UNKNOWN SELECTIOM

    echo "Option not found."
    ;;

  esac
done
