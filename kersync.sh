#!/usr/bin/env bash
#===============================================================================================================================================
# (C) Copyright 2019 KerSYNC a project under the Crypto World Foundation (https://cryptoworld.is).
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
# title            :KerSYNC
# description      :This script will make it super easy to rsync the kernel.org mirror.
# author           :The Crypto World Foundation.
# contributors     :Beardlyness
# date             :04-08-2019
# version          :0.1.2 Beta
# os               :Debian/Ubuntu
# usage            :bash kersync.sh
# notes            :If you have any problems feel free to email the maintainer: beard [AT] cryptoworld [DOT] is
#===============================================================================================================================================

# Force check for root
  if ! [ "$(id -u)" = 0 ]; then
    echo "You need to be logged in as root!"
    exit 1
  fi

# Setting up an update/upgrade global function
  function upkeep() {
    echo "Performing Upkeep.."
      apt-get update -y
      apt-get dist-upgrade -y
      apt-get clean -y
  }

#START

# Checking for multiple "required" pieces of software.
    if
      echo -e "\033[92mPerforming upkeep of system packages..\e[0m"
        upkeep

      echo -e "\033[92mChecking software list..\e[0m"
    [ ! -x  /usr/bin/lsb_release ] || [ ! -x  /usr/bin/rsync ] || [ ! -x  /usr/bin/apt-transport-https ] || [ ! -x  /usr/bin/dirmngr ] || [ ! -x  /usr/bin/ca-certificates ] ; then

      echo -e "\033[92mlsb_release: checking for software..\e[0m"
      echo -e "\033[34mInstalling lsb_release, Please Wait...\e[0m"
      apt-get install lsb-release

      echo -e "\033[92mwget: checking for software..\e[0m"
      echo -e "\033[34mInstalling wget, Please Wait...\e[0m"
      apt-get install wget

      echo -e "\033[92mrsync: checking for software..\e[0m"
      echo -e "\033[34mInstalling rsync, Please Wait...\e[0m"
      apt-get install rsync

      echo -e "\033[92mapt-transport-https: checking for software..\e[0m"
      echo -e "\033[34mInstalling apt-transport-https, Please Wait...\e[0m"
      apt-get install apt-transport-https

      echo -e "\033[92mdirmngr: checking for software..\e[0m"
      echo -e "\033[34mInstalling dirmngr, Please Wait...\e[0m"
      apt-get install dirmngr

      echo -e "\033[92mca-certificates: checking for software..\e[0m"
      echo -e "\033[34mInstalling ca-certificates, Please Wait...\e[0m"
      apt-get install ca-certificates
  fi

# RSYNC Arg main
  read -r -p "Do you want to setup RSYNC mirror for kernels? (Y/N) " REPLY
    case "${REPLY,,}" in
      [yY]|[yY][eE][sS])
          echo "Setting up RSYNC paths, and getting RSYNC ready."
            mkdir -p /var/www/html/mirror/live
            rsync -av rsync://rsync.kernel.org/pub/ /var/www/html/mirror/live/
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
