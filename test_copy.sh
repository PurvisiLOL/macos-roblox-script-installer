#!/bin/sh

targetFps=10000
robloxPath="/Applications/Roblox.app"
clientSettingsPath="$robloxPath/Contents/MacOS/ClientSettings"
clientSettingsFile="$clientSettingsPath/ClientAppSettings.json"
backupFile="$clientSettingsPath/ClientAppSettings_backup.json"

center_text() {
  local text="$1"
  local width=$(tput cols)
  local text_length=${#text}
  local padding=$(( (width - text_length) / 2 ))
  printf "%*s%s\n" $padding "" "$text"
}

center_rainbow_part() {
  local non_rainbow_text="$1"
  local rainbow_part="$2"
  local width=$(tput cols)
  local colors=(31 33 32 36 34 35)
  local color_index=0
  local rainbow_output=""
  
  for ((i=0; i<${#rainbow_part}; i++)); do
    local char="${rainbow_part:$i:1}"
    rainbow_output+=$(printf "\e[${colors[$color_index]}m%s\e[0m" "$char")
    color_index=$(( (color_index + 1) % ${#colors[@]} ))
  done

  local full_text="${non_rainbow_text}${rainbow_output}"

  local stripped_text="${non_rainbow_text}${rainbow_part}"
  local text_length=${#stripped_text}
  local padding=$(( (width - text_length) / 2 ))
  
  printf "%*s%s\n" $padding "" "$full_text"
}
center_rainbow_text() {
  local text="$1"
  local width=$(tput cols)
  local colors=(31 33 32 36 34 35)
  local color_index=0
  local rainbow_output=""
  
  local stripped_text=""
  
  for ((i=0; i<${#text}; i++)); do
    local char="${text:$i:1}"
    rainbow_output+=$(printf "\e[${colors[$color_index]}m%s\e[0m" "$char")
    stripped_text+="$char"
    color_index=$(( (color_index + 1) % ${#colors[@]} ))
  done
  
  local text_length=${#stripped_text}
  local padding=$(( (width - text_length) / 2 ))
  
  printf "%*s%s\n" $padding "" "$rainbow_output"
}

print_header() {
  clear
  tput setaf 15
  
  center_rainbow_text "███████╗██████╗ ███████╗   ██╗   ██╗██╗"
  center_rainbow_text "██╔════╝██╔══██╗██╔════╝   ██║   ██║██║"
  center_rainbow_text "█████╗  ██████╔╝███████╗   ██║   ██║██║"
  center_rainbow_text "██╔══╝  ██╔═══╝ ╚════██║   ██║   ██║██║"
  center_rainbow_text "██║     ██║     ███████║██╗╚██████╔╝██║"
  center_rainbow_text "╚═╝     ╚═╝     ╚══════╝╚═╝ ╚═════╝ ╚═╝"
  
  center_text "======================================="
  center_rainbow_part "Made by " "Abyzal"
  center_text "© 2024 FPS.UI"
  echo
  tput sgr0
}

print_menu() {
  print_header
  tput setaf 7
  printf "%-25s %-25s %s\n" "Default" "Custom" "Exit"  
  printf "%-25s %-25s %s\n" "[1] Add FPS Unlocker" "[6] Custom FFLAGS" "[10] Exit"
  printf "%-25s %s\n" "[2] Enable Modern UI" "[7] Delete FFLAGS"
  printf "%-25s %s\n" "[3] Install Both" "[8] Backup FFLAGS"
  printf "%-25s %s\n" "[4] Uninstall Settings" "[9] Use Backup"
  tput sgr0
  echo ""
  printf "> "
}

print_uninstall_menu() {
  print_header
  tput setaf 7
  echo "[1] Uninstall FPS Unlocker"
  echo "[2] Uninstall Modern UI"
  echo "[3] Uninstall Both"
  echo "[4] Back to Main Menu"
  tput sgr0
  echo ""
  printf "> "
}

uninstall_fps_unlocker() {
  if [ -f "$clientSettingsFile" ]; then
    grep -v '"DFIntTaskSchedulerTargetFps": 200000000,' "$clientSettingsFile" > "$clientSettingsFile.tmp" && mv "$clientSettingsFile.tmp" "$clientSettingsFile"
    tput setaf 10; echo "✅ FPS Unlocker has been removed."
    tput sgr0
    fpsUnlockerInstalled="no"
  else
    tput setaf 9; echo "⚠️ No FPS Unlocker settings found."
    tput sgr0
  fi
  sleep 2
  clear
}

uninstall_modern_ui() {
  if [ -f "$clientSettingsFile" ]; then
    grep -v '"FFlagEnableInGameMenuChrome": "True"' "$clientSettingsFile" > "$clientSettingsFile.tmp" && mv "$clientSettingsFile.tmp" "$clientSettingsFile"
    tput setaf 10; echo "✅ Modern UI has been removed."
    tput sgr0
    modernUIInstalled="no"
  else
    tput setaf 9; echo "⚠️ No Modern UI settings found."
    tput sgr0
  fi
  sleep 2
  clear
}

uninstall_both() {
  if [ -f "$clientSettingsFile" ]; then
    rm "$clientSettingsFile"
    tput setaf 10; echo "✅ All settings have been removed."
    tput sgr0
    modernUIInstalled="no"
    fpsUnlockerInstalled="no"
  else
    tput setaf 9; echo "⚠️ No settings to uninstall."
    tput sgr0
  fi
  sleep 2
  clear
}

install_fps_unlocker() {
  tput setaf 2; echo "🎮 Adding FPS Unlocker..."
  tput sgr0
  settingsUrl="https://raw.githubusercontent.com/PurvisiLOL/macos-roblox-script-installer/main/fpsunlocker.txt"
  fpsSettings=$(curl -s -f "$settingsUrl")

  if [ $? -ne 0 ]; then
    tput setaf 9; echo "We couldn't download the FPS unlocker settings. Please try again later."
    tput sgr0
    sleep 2
    clear
    return
  fi

  if [ -z "$fpsSettings" ]; then
    tput setaf 9; echo "We couldn't download the FPS unlocker settings. Please try again later."
    tput sgr0
    sleep 2
    clear
    return
  fi

  clientSettings="{\n$fpsSettings\n}"
  echo "$clientSettings" > "$clientSettingsFile"
  tput setaf 10; echo "✅ FPS Unlocker settings have been applied."
  tput sgr0
  fpsUnlockerInstalled="yes"
  sleep 2
  clear
}

install_modern_ui() {
  tput setaf 3; echo "✨ Enabling Modern UI..."
  tput sgr0
  if [ "$fpsUnlockerInstalled" = "yes" ]; then
    clientSettings=$(sed 's/}$/,\n  "FFlagEnableInGameMenuChrome": "True"\n}/' "$clientSettingsFile")
  else
    clientSettings="{\n  \"FFlagEnableInGameMenuChrome\": \"True\"\n}"
  fi
  echo "$clientSettings" > "$clientSettingsFile"
  tput setaf 10; echo "✅ Modern UI settings have been applied."
  tput sgr0
  modernUIInstalled="yes"
  sleep 2
  clear
}

install_both() {
  if [ "$fpsUnlockerInstalled" = "no" ]; then
    install_fps_unlocker
  else
    tput setaf 9; echo "⚠️ FPS Unlocker is already installed."
    tput sgr0
    sleep 1
    clear
  fi

  if [ "$modernUIInstalled" = "no" ]; then
    install_modern_ui
  else
    tput setaf 9; echo "⚠️ Modern UI is already installed."
    tput sgr0
    sleep 2
    clear
  fi
}

edit_custom_fflags() {
  if [ ! -f "$clientSettingsFile" ]; then
    echo "{}" > "$clientSettingsFile"
  fi
  nano "$clientSettingsFile"
}

delete_fflags() {
  if [ -f "$clientSettingsFile" ]; then
    echo "{\n}" > "$clientSettingsFile"
    tput setaf 10; echo "✅ All FFLAGS have been deleted."
    tput sgr0
    fpsUnlockerInstalled="no"
    modernUIInstalled="no"
  else
    tput setaf 9; echo "⚠️ No FFLAGS file found to delete."
    tput sgr0
  fi
  sleep 2
  clear
}


backup_fflags() {
  if [ -f "$clientSettingsFile" ]; then
    cp "$clientSettingsFile" "$backupFile"
    tput setaf 10; echo "✅ FFLAGS have been backed up."
    tput sgr0
  else
    tput setaf 9; echo "⚠️ No FFLAGS file found to backup."
    tput sgr0
  fi
  sleep 2
  clear
}

use_backup() {
  if [ -f "$backupFile" ]; then
    cp "$backupFile" "$clientSettingsFile"
    tput setaf 10; echo "✅ Backup has been restored."
    tput sgr0
  else
    tput setaf 9; echo "⚠️ No backup file found."
    tput sgr0
  fi
  sleep 2
  clear
}

print_header
tput setaf 15
echo "🔄 Initializing setup, please wait..."
tput sgr0
if [ "$(id -u)" -ne 0 ]; then
  tput setaf 9; echo "⚠️  This script must be run with sudo or as root. Otherwise it cannot install or change the FFLAGS."
  exit 1
fi

url="https://raw.githubusercontent.com/PurvisiLOL/macos-roblox-script-installer/main/fpsunlocker.txt"
output_file="fpsunlocker.txt"

if curl -s -o "$output_file" "$url"; then
    if [ -s "$output_file" ]; then
        rm "$output_file"
        clear
    else
        tput setaf 9; echo "We couldn't download the settings. Please try again later."
        tput sgr0
        exit 1
    fi
else
    tput setaf 9; echo "You don't have network. Please try again later."
    tput sgr0
    exit 1
fi

if [ ! -d "$robloxPath" ]; then
  robloxPath="$HOME$robloxPath"

  if [ ! -d "$robloxPath" ]; then
    tput setaf 9; echo "🚫 Roblox installation folder not found."
    tput sgr0
    exit 1
  fi
fi

key_exists() {
  grep -q "$1" "$clientSettingsFile" 2>/dev/null
}

fpsUnlockerInstalled="no"
modernUIInstalled="no"

if [ -f "$clientSettingsFile" ]; then
  if key_exists '"DFIntTaskSchedulerTargetFps": 200000000,'; then
    fpsUnlockerInstalled="yes"
  fi

  if key_exists '"FFlagEnableInGameMenuChrome": "True"'; then
    modernUIInstalled="yes"
  fi
fi

while true; do
  print_menu
  read choice
  case $choice in
    1)
      if [ "$fpsUnlockerInstalled" = "no" ]; then
        install_fps_unlocker
      else
        tput setaf 9; echo "⚠️ FPS Unlocker is already installed."
        tput sgr0
        sleep 2
        clear
      fi
      ;;
    2)
      if [ "$modernUIInstalled" = "no" ]; then
        install_modern_ui
      else
        tput setaf 9; echo "⚠️ Modern UI is already installed."
        tput sgr0
        sleep 2
        clear
      fi
      ;;
    3)
      install_both
      ;;
    4)
      while true; do
        print_uninstall_menu
        read uninstall_choice
        case $uninstall_choice in
          1) uninstall_fps_unlocker ;;
          2) uninstall_modern_ui ;;
          3) uninstall_both ;;
          4) break ;;
          *) tput setaf 9; echo "Invalid option, please try again."; tput sgr0; sleep 2; clear ;;
        esac
      done
      ;;
    6)
      edit_custom_fflags
      ;;
    7)
      delete_fflags
      ;;
    8)
      backup_fflags
      ;;
    9)
      use_backup
      ;;
    10)
      tput setaf 15; echo "Exiting..."; tput sgr0; exit 0 ;;
    *)
      tput setaf 9; echo "Invalid option, please try again."; tput sgr0; sleep 2; clear ;;
  esac
done
