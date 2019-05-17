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
# date             :05-17-2019
# version          :0.1.4 Beta
# os               :Debian/Ubuntu
# usage            :bash kersync.sh
# notes            :If you have any problems feel free to email the maintainer: beard [AT] cryptoworld [DOT] is
#===============================================================================================================================================

# Force check for root
  if ! [ "$(id -u)" = 0 ]; then
    echo "You need to be logged in as root!"
    exit 1
  fi

  # Global Paths for Project Web Directory, and Projects RSYNC Path.
  P_WEB_DIR="/var/www/html/mirror/live"
  P_RSYNC_PATH="rsync://rsync.kernel.org/pub/"

# Setting up an update/upgrade global function
  function upkeep() {
    echo "Performing Upkeep.."
      apt-get update -y
      apt-get dist-upgrade -y
      apt-get clean -y
  }

  function cronjob_setup() {
      echo "Setting up the Cronjobs for this script.."
        crontab -e
  }

#START

# Checking for multiple "required" pieces of software.
    tools=( rsync dirmngr apt-transport-https ca-certificates )
     grab_eware=""
       for e in "${tools[@]}"; do
         if command -v "$e" >/dev/null 2>&1; then
           echo "Dependency $e is installed.."
         else
           echo "Dependency $e is not installed..?"
            upkeep
            grab_eware="$grab_eware $e"
         fi
       done
      apt-get install $grab_eware


# RSYNC Arg main
  read -r -p "Do you want to setup an RSYNC Mirror for the Linux kernel's? (Y/Yes | N/No) " REPLY
    case "${REPLY,,}" in
      [yY]|[yY][eE][sS])
            cronjob_setup
          echo "Setting up RSYNC paths, and getting RSYNC ready."
            mkdir -p "$P_WEB_DIR"
            rsync -av "$P_RSYNC_PATH" "$P_WEB_DIR"
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
