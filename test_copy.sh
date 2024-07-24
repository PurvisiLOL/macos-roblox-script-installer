#!/bin/sh

targetFps=10000
robloxPath="/Applications/Roblox.app"
clientSettingsPath="$robloxPath/Contents/MacOS/ClientSettings"
clientSettingsFile="$clientSettingsPath/ClientAppSettings.json"
backupFile="$clientSettingsPath/ClientAppSettings_backup.json"
cursorPath="$robloxPath/Contents/Resources/content/textures/Cursors/KeyboardMouse"
cursorBackupPath="$cursorPath/BackupCursors"
customCursorsPath="$robloxPath/Contents/Resources/content/textures/Cursors/KeyboardMouse/"
cursurPath="$robloxPath/Contents/Resources/content/textures/Cursors/KeyboardMouse/CustomCursors"
replacementCursorpath="$robloxPath/Contents/Resources/content/textures/Cursors/KeyboardMouse/"

center_text() {
  local text="$1"
  local width=$(tput cols)
  local text_length=${#text}
  local padding=$(( (width - text_length) / 2 ))
  printf "%*s%s\n" $padding "" "$text"
}

print_header() {
  clear
  tput setaf 15
  
  center_text "███████╗██████╗ ███████╗   ██╗   ██╗██╗"
  center_text "██╔════╝██╔══██╗██╔════╝   ██║   ██║██║"
  center_text "█████╗  ██████╔╝███████╗   ██║   ██║██║"
  center_text "██╔══╝  ██╔═══╝ ╚════██║   ██║   ██║██║"
  center_text "██║     ██║     ███████║██╗╚██████╔╝██║"
  center_text "╚═╝     ╚═╝     ╚══════╝╚═╝ ╚═════╝ ╚═╝"
  
  center_text "======================================="
  center_text "Made by Abyzal"
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
  printf "%-25s %s\n" "[5] Change Cursor" ""
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

print_cursor_menu() {
  print_header
  tput setaf 7
  echo "[1] Old Cursor"
  echo "[2] Circle"
  echo "[3] Cross"
  echo "[4] Cross Squared"
  echo "[5] Dot"
  echo "[6] Custom Cursor (Download)"
  echo "[7] Restore Original"
  echo "[8] Back to Main Menu"
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

restore_default_cursor() {
  if [ -d "$cursorBackupPath" ]; then
    cp "$cursurPath"/ArrowFarCursor.png "$cursorPath/ArrowFarCursor.png"
    tput setaf 10; echo "✅ Default cursors have been restored."
    tput sgr0
  else
    tput setaf 9; echo "⚠️ No backup found to restore cursors."
    tput sgr0
  fi
  sleep 2
  clear
}

change_cursor() {
  if [ ! -d "$cursorBackupPath" ]; then
    mkdir -p "$cursorBackupPath"
    cp "$cursorPath"/ArrowFarCursor.png "$cursorBackupPath"
  fi

  if [ -d "$cursurPath" ]; then
    cp "$customCursorsPath" "$cursorPath/ArrowFarCursor.png"
    tput setaf 10; echo "✅ Custom cursors have been applied."
    tput sgr0
  else
    tput setaf 9; echo "⚠️ Custom cursors path does not exist."
    tput sgr0
  fi
  customCursorsPath="$replacementCursorpath"
  sleep 2
  clear
}

download_custom_cursors() {
  clear
  print_header
  echo "Enter the URL for the custom cursor file (MUST BE ZIP. IMAGE SIZE MUST BE 64x64 AND NAME MUST BE WITH .PNG AS FILE TYPE: ArrowFarCursor.png ):"
  printf "> "
  read customCursorUrl
  
  tempCursorFile="custom_cursor.zip"
  tempUnzipDir="temp_unzip_dir"

  if curl -s -o "$tempCursorFile" "$customCursorUrl"; then
    if [ -s "$tempCursorFile" ]; then
      mkdir -p "$tempUnzipDir"
      
      unzip -o "$tempCursorFile" -d "$tempUnzipDir"
      
      if [ -f "$tempUnzipDir/ArrowFarCursor.png" ]; then
        cp "$tempUnzipDir/ArrowFarCursor.png" "$cursorPath/ArrowFarCursor.png"
        tput setaf 10; echo "✅ Custom cursor has been downloaded and applied."
        tput sgr0
      else
        tput setaf 9; echo "⚠️ Expected cursor file not found in the ZIP archive."; tput sgr0
      fi
      
      rm -r "$tempCursorFile" "$tempUnzipDir"
    else
      tput setaf 9; echo "⚠️ Downloaded file is empty. Please try again."
      tput sgr0
    fi
  else
    tput setaf 9; echo "⚠️ Failed to download custom cursor. Please check the URL and try again."
    tput sgr0
  fi
  sleep 2
  clear
}


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

if [ ! -d "$cursurPath" ]; then
  mkdir "$cursurPath"
fi

urls=(
  "https://raw.githubusercontent.com/PurvisiLOL/macos-roblox-script-installer/main/cursurs/cursor.zip"
  "https://raw.githubusercontent.com/PurvisiLOL/macos-roblox-script-installer/main/cursurs/ArrowFarCursor.png.zip"
  "https://raw.githubusercontent.com/PurvisiLOL/macos-roblox-script-installer/main/cursurs/og.png.zip"
)

for url in "${urls[@]}"; do
  fileName=$(basename "$url")

  curl -s -o "$cursurPath/$fileName" "$url"

  if [ $? -eq 0 ]; then
    
    unzip -o "$cursurPath/$fileName" -d "$cursurPath"

    if [ $? -eq 0 ]; then
    echo 
    else
      echo "⚠️ Error code: 56"
      exit 1
    fi

    rm "$cursurPath/$fileName"
  else
    echo "⚠️ Error code: 56"
    exit 1
  fi
  clear
done

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
    5)
      while true; do
        print_cursor_menu
        read cursor_choice
        case $cursor_choice in
          1) customCursorsPath="$replacementCursorpath/CustomCursors/Old/ArrowFarCursor.png"; change_cursor ;;
          2) customCursorsPath="$replacementCursorpath/CustomCursors/Circle/ArrowFarCursor.png"; change_cursor ;;
          3) customCursorsPath="$replacementCursorpath/CustomCursors/Cross/ArrowFarCursor.png"; change_cursor ;;
          4) customCursorsPath="$replacementCursorpath/CustomCursors/Cross Squared/ArrowFarCursor.png"; change_cursor ;;
          5) customCursorsPath="$replacementCursorpath/CustomCursors/Dot/ArrowFarCursor.png"; change_cursor ;;
          6) download_custom_cursors ;;
          7) restore_default_cursor ;;
          8) break ;;
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
