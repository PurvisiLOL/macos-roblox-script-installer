#!/bin/sh

targetFps=10000
robloxPath="/Applications/Roblox.app"
clientSettingsPath="$robloxPath/Contents/MacOS/ClientSettings"
clientSettingsFile="$clientSettingsPath/ClientAppSettings.json"

echo "🔄 Initializing setup, please wait..."
sleep 3

if [ ! -d "$robloxPath" ]; then
  robloxPath="~$robloxPath"

  if [ ! -d "$robloxPath" ]; then
    echo "🚫 Roblox installation folder not found."
    exit 1
  fi
fi

key_exists() {
  grep -q "$1" "$clientSettingsFile" 2>/dev/null
}

fpsUnlockerInstalled="no"
modernUIInstalled="no"

if [ -f "$clientSettingsFile" ]; then
  echo "📂 Existing settings detected."

  if key_exists '"DFIntTaskSchedulerTargetFps": 200000000,'; then
    fpsUnlockerInstalled="yes"
  fi

  if key_exists '"FFlagEnableInGameMenuChrome": "True"'; then
    modernUIInstalled="yes"
  fi

  echo "Do you want to uninstall the current settings? (yes/no, default is no): "
  read uninstallSettings
  uninstallSettings=${uninstallSettings:-no}

  if [ "$uninstallSettings" = "yes" ]; then
    if [ "$fpsUnlockerInstalled" = "yes" ]; then
      echo "Do you want to uninstall the FPS Unlocker? (yes/no, default is no): "
      read uninstallFpsUnlocker
      uninstallFpsUnlocker=${uninstallFpsUnlocker:-no}

      if [ "$uninstallFpsUnlocker" = "yes" ]; then
        tempFile="$clientSettingsFile.bak"
        cp "$clientSettingsFile" "$tempFile"
        
        echo '{"FFlagEnableInGameMenuChrome": "True"}' > "$clientSettingsFile"
        echo "✅ FPS Unlocker has been removed."
      fi
    fi

    if [ "$modernUIInstalled" = "yes" ]; then
      echo "Do you want to uninstall Modern UI? (yes/no, default is no): "
      read uninstallModernUI
      uninstallModernUI=${uninstallModernUI:-no}

      if [ "$uninstallModernUI" = "yes" ]; then
        tempFile="$clientSettingsFile.bak"
        cp "$clientSettingsFile" "$tempFile"
        
        grep -v '"FFlagEnableInGameMenuChrome": "True"' "$tempFile" | sed '/^\s*$/d' > "$clientSettingsFile"

        sed -i '' 's/,\s*}$/}/' "$clientSettingsFile"
        rm "$tempFile"

        if [ "$fpsUnlockerInstalled" = "no" ]; then
          rm "$clientSettingsFile"
        fi

        echo "✅ Modern UI has been removed."
      fi
    fi

    if [ "$fpsUnlockerInstalled" = "no" ] && [ "$modernUIInstalled" = "no" ]; then
      rm "$clientSettingsFile"
    fi

    if [ "$uninstallFpsUnlocker" = "yes" ] && [ "$uninstallModernUI" = "yes" ]; then
      rm "$clientSettingsFile"
      echo "✅ All settings have been removed."
    else
      echo "✅ Current settings have been uninstalled."
    fi

    exit 0
  fi
fi

clientSettings="{
"

if [ "$fpsUnlockerInstalled" = "no" ]; then
  echo "🎮 Want to add an FPS Unlocker? (yes/no, default is yes): "
  read addFpsUnlocker
  addFpsUnlocker=${addFpsUnlocker:-yes}

  if [ "$addFpsUnlocker" = "yes" ]; then
    settingsUrl="https://raw.githubusercontent.com/PurvisiLOL/macos-roblox-script-installer/main/fpsunlocker.txt"
    
    fpsSettings=$(curl -s "$settingsUrl")

    if [ -z "$fpsSettings" ]; then
      echo "⚠️ Failed to download FPS unlocker settings."
      exit 1
    fi

    clientSettings="$clientSettings$fpsSettings\n"
    echo "✅ FPS Unlocker settings have been applied."
  fi
fi

if [ "$modernUIInstalled" = "no" ]; then
  echo "✨ Enable modern UI? (yes/no, default is yes): "
  read enableModernUI
  enableModernUI=${enableModernUI:-yes}

  if [ "$enableModernUI" = "yes" ]; then
    if [ "$clientSettings" != "{" ]; then
      clientSettings="$clientSettings, "
    fi
    modernUiSettings="\"FFlagEnableInGameMenuChrome\": \"True\""
    clientSettings="$clientSettings$modernUiSettings\n"
    echo "✅ Modern UI settings have been applied."
  fi
fi

clientSettings="$clientSettings
}"

if [ "$fpsUnlockerInstalled" = "no" ] || [ "$modernUIInstalled" = "no" ]; then
  echo "$clientSettings" > "$clientSettingsFile"
  echo "✅ Configuration complete. Settings have been updated."
else
  echo "✅ Everything is installed! No need to update."
fi

echo "🚀 Script execution finished successfully!"
