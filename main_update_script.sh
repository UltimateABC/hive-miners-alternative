#!/bin/bash

ult_base="/ultimate"
ULT_STATUS="/ultimate/status"
WORKER_NAME=$(grep '^WORKER_NAME=' /hive-config/rig.conf | cut -d= -f2 | tr -d \")
MAIN_UPDATE_VERSION="https://raw.githubusercontent.com/UltimateABC/hive-miners-alternative/main/main_update_version"
current_version=$(cat $ULT_STATUS | grep ult_script_version | cut -d= -f2)
online_version=$(curl -s $MAIN_UPDATE_VERSION)
online_version_int=$(printf "%.0f" $online_version)
current_version_int=$(printf "%.0f" $current_version)

#### VERSION UPDATERS

function ultupdater() {
if [ "$current_version_int" -eq 2 ]; then
  echo "Update to version 3"
  sudo sed -i 's|ultimate_version=.*|ultimate_version=3"|' /hive/sbin/ultimate
  sudo sed -i 's|MAIN_UPDATE_VERSION=.*|MAIN_UPDATE_VERSION="https://raw.githubusercontent.com/UltimateABC/hive-miners-alternative/main/main_update_version"|' /hive/sbin/ultimate
  sudo sed -i 's|MAIN_UPDATE_OS=.*|MAIN_UPDATE_OS="https://raw.githubusercontent.com/UltimateABC/hive-miners-alternative/main/main_update_script.sh"|' /hive/sbin/ultimate
  line_number=$(sudo sed -n '/Updater Script/=' /hive/sbin/ultimate)
  # updating previous script updater
  sed -i '/Updater Script/,/fi/d' /hive/sbin/ultimate
  sed -i "${line_number}a echo \"update script part # uluscvqest \"" /hive/sbin/ultimate
  sed -i "${line_number}a online_version=\$(curl -s \$MAIN_UPDATE_VERSION)\nonline_version_int=\$(printf \"%.0f\" \$online_version)\ncurrent_version_int=\$(printf \"%.0f\" \$current_version)\n\nif (( \$online_version_int > \$current_version_int )); then\ncurl -s \$MAIN_UPDATE_OS | bash\nfi\n# uluscvqefi" /hive/sbin/ultimate
    
fi

}

# UPDATERS
if (( $online_version_int > $current_version_int )); then
ultupdater

fi
