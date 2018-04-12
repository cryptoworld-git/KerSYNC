#!/usr/bin/env bash
#===============================================================================================================================================
# (C) Copyright 2018 Kersync a project under the CryptoWorld Foundation (https://cryptoworld.is).
#
# Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#===============================================================================================================================================
# title            :Kersync
# description      :This script will make it super easy to rsync the kernel.org mirror.
# author           :The Crypto World Foundation.
# contributors     :Beardlyness
# date             :04-11-2018
# version          :0.1.0 Beta
# os               :Debian/Ubuntu
# usage            :bash kersync.sh
# notes            :If you have any problems feel free to email the maintainer: beard [AT] cryptoworld [DOT] is
#===============================================================================================================================================

# Force check for root
  if ! [ $(id -u) = 0 ]; then
    echo "You need to be logged in as root!"
    exit 1
  fi

# Setting up an update/upgrade global function
  function upkeep() {
    apt-get update -y
    apt-get dist-upgrade -y
    apt-get clean -y
  }

# Grabbing info on active machine.
    flavor=`lsb_release -cs`
    system=`lsb_release -i | grep "Distributor ID:" | sed 's/Distributor ID://g' | sed 's/["]//g' | awk '{print tolower($1)}'`

#START

# Checking for multiple "required" pieces of software.
    if
      echo -e "\033[92mPerforming upkeep of system packages..\e[0m"
        upkeep

      echo -e "\033[92mChecking software list..\e[0m"

    [ ! -x  /usr/bin/lsb_release ] || [ ! -x  /usr/bin/rsync ] || [ ! -x  /usr/bin/dialog ] ; then

      echo -e "\033[92mLsb_release: checking for software..\e[0m"
      echo -e "\033[34mInstalling lsb_release, Please Wait...\e[0m"
      apt-get install lsb-release

      echo -e "\033[92mRsync: checking for software..\e[0m"
      echo -e "\033[34mInstalling rsync, Please Wait...\e[0m"
      apt-get install rsync

      echo -e "\033[92mDialog: checking for software..\e[0m"
      echo -e "\033[34mInstalling dialog, Please Wait...\e[0m"
      apt-get install dialog
  fi

# RSYNC Arg main
  read -r -p "Do you want to setup RSYNC mirror for kernels? (Y/N) " REPLY
    case "${REPLY,,}" in
      [yY]|[yY][eE][sS])
        echo "Setting up RSYNC paths, and getting RSYNC ready."
          cd /home
            mkdir mirror && mkdir mirror/live
            rsync -av rsync://rsync.kernel.org/pub/ /home/mirror/live/
          ;;
        [nN]|[nN][oO])
          echo "You have said no? We cannot work without your permission!"
          ;;
        *)
          echo "Invalid response. You okay?"
          ;;
    esac

# Web Server Arg second
      read -r -p "Would you like to setup a Web server to serve the mirror content? (Y/N) " REPLY
        case "${REPLY,,}" in
          [yY]|[yY][eE][sS])
            HEIGHT=20
            WIDTH=120
            CHOICE_HEIGHT=3
            BACKTITLE="Kersync | Installer"
            TITLE="~~~ Kersync ~~~"
            MENU="Choose one of the following Web Servers:"

            OPTIONS=(1 "Apache"
                     2 "NGINX"
                     3  "Hiawatha")

            CHOICE=$(dialog --clear \
                            --backtitle "$BACKTITLE" \
                            --title "$TITLE" \
                            --menu "$MENU" \
                            $HEIGHT $WIDTH $CHOICE_HEIGHT \
                            "${OPTIONS[@]}" \
                            2>&1 >/dev/tty)

            clear

# Attached Arg for dialogs $CHOICE output
        case $CHOICE in
          1)
          echo "Performing upkeep.."
            upkeep
          echo "Installing Apache.."
            apt-get install apache2 apache2-doc apache2-utils
            service apache2 status
            ;;
          2)
          echo deb http://nginx.org/packages/$system/ $flavor nginx > /etc/apt/sources.list.d/engine.list
          echo deb-src http://nginx.org/packages/$system/ $flavor nginx >> /etc/apt/sources.list.d/engine.list
            wget -4 https://nginx.org/keys/nginx_signing.key
            apt-key add nginx_signing.key
          echo "Performing upkeep.."
            upkeep
          echo "Installing NGINX.."
            apt-get install nginx
            service nginx status
            ;;
          3)
          echo deb http://mirror.tuxhelp.org/debian/ squeeze main > /etc/apt/sources.list.d/engine.list
            apt-key adv --recv-keys --keyserver keys.gnupg.net 79AF54A9
          echo "Performing upkeep.."
            upkeep
          echo "Installing Hiawatha.."
            apt-get install hiawatha
            service hiawatha status
            ;;
        esac
    clear
      ;;
    [nN]|[nN][oO])
      echo "You have said no? We cannot work without your permission!"
      ;;
    *)
      echo "Invalid response. You okay?"
      ;;
esac

# End statement
   echo -e "\e[5m" "\033[92mThat's all folks..\e[0m"