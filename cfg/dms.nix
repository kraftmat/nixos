{ config, pkgs, lib, hostName, ... } @ args:
    
    let
      dmsPluginRegistry = args."dms-plugin-registry" or null;
    
      patchedEasyEffects = pkgs.runCommandLocal "dms-plugin-easyeffects-patched" {
        src = dmsPluginRegistry.packages.${pkgs.stdenv.hostPlatform.system}.easyEffects;
      } ''
        cp -r "$src" "$out"
        chmod -R +w "$out"
        sed -i 's/"pgrep", "-x"/"pgrep", "-f"/' "$out/EasyEffectsWidget.qml"
      '';
    
      codec = pkgs.runCommandLocal "dms-plugin-codec" { } ''
        mkdir -p $out
        cp ${../modules/btplugin}/* $out/
        chmod u+w $out/headset.sh
        sed -i '2i export PATH=${lib.makeBinPath (with pkgs; [ pulseaudio bluez upower gawk gnused gnugrep coreutils ])}:$PATH' $out/headset.sh
        chmod +x $out/headset.sh
      '';
    
    in {
      programs.dank-material-shell = {
        enable = true;
    
        systemd = {
          enable           = true;
          restartIfChanged = true;
        };
    
        enableSystemMonitoring = true;
        enableVPN              = false;
        enableDynamicTheming   = true;
        enableAudioWavelength  = true;
        enableCalendarEvents   = false;
        enableClipboardPaste   = true;
    
        plugins = {
          bongoCat.enable = true;
          warpToggle.enable = true;
          easyEffects = {
            enable = true;
            src = lib.mkForce patchedEasyEffects;
          };
          nixMonitor = {
            enable = true;
            settings = {
              checkUpdates = false;
            };
          };
          screenkey.enable = false;
          screenOff.enable = true;
          hostnameWidget.enable = true;
          nixPackageRunner.enable = true;
          quickCapture.enable = true;
          dankKDEConnect.enable = true;
          codec = {
            enable = true;
            src = codec;
          };
        };
    settings = builtins.fromJSON ''
{
  "currentThemeName": "dynamic",
  "currentThemeCategory": "dynamic",
  "customThemeFile": "/home/kraftmat/.config/DankMaterialShell/themes/amoledBlack/theme.json",
  "dockTransparency": 0.85,
  "cornerRadius": 12,
  "clockFormat": "24h",
  "barElevationEnabled": false,
  "blurWallpaperOnOverview": true,
  "controlCenterShowMicPercent": true,
  "privacyShowMicIcon": true,
  "controlCenterWidgets": [
    {
      "enabled": true,
      "id": "volumeSlider",
      "width": 50
    },
    {
      "deviceName": "backlight:intel_backlight",
      "enabled": true,
      "id": "brightnessSlider",
      "width": 50
    },
    {
      "enabled": true,
      "id": "wifi",
      "width": 50
    },
    {
      "enabled": true,
      "id": "bluetooth",
      "width": 50
    },
    {
      "enabled": true,
      "id": "audioOutput",
      "width": 50
    },
    {
      "enabled": true,
      "id": "audioInput",
      "width": 50
    },
    {
      "enabled": true,
      "id": "nightMode",
      "width": 50
    },
    {
      "enabled": true,
      "id": "darkMode",
      "width": 50
    },
    {
      "enabled": true,
      "id": "plugin_warpToggle",
      "width": 50
    },
    {
      "enabled": true,
      "id": "plugin_screenOff",
      "width": 50
    }
  ],
  "showWorkspaceApps": true,
  "audioVisualizerEnabled": false,
  "audioScrollMode": "nothing",
  "appIdSubstitutions": [],
  "dankLauncherV2UnloadOnClose": true,
  "launcherStyle": "spotlight",
  "cursorSettings": {
    "dwl": {
      "cursorHideTimeout": 0
    },
    "hyprland": {
      "hideOnKeyPress": false,
      "hideOnTouch": false,
      "inactiveTimeout": 0
    },
    "niri": {
      "hideAfterInactiveMs": 0,
      "hideWhenTyping": false
    },
    "size": 24,
    "theme": "System Default"
  },
  "fontFamily": "Inter Nerd Font",
  "monoFontFamily": "JetBrainsMono NF",
  "muxType": "zellij",
  "notificationOverlayEnabled": true,
  "notificationCompactMode": true,
  "osdPowerProfileEnabled": true,
  "powerActionConfirm": false,
  "barConfigs": [
    {
      "autoHide": false,
      "autoHideDelay": 250,
      "borderColor": "surfaceText",
      "borderEnabled": false,
      "borderOpacity": 1,
      "borderThickness": 1,
      "bottomGap": 0,
      "centerWidgets": [
        "clock"
      ],
      "clickThrough": false,
      "enabled": true,
      "fontScale": 1,
      "gothCornerRadiusOverride": false,
      "gothCornerRadiusValue": 12,
      "gothCornersEnabled": false,
      "hoverPopouts": false,
      "iconScale": 1,
      "id": "default",
      "innerPadding": 4,
      "leftWidgets": [
        {
          "enabled": true,
          "id": "workspaceSwitcher"
        },
        {
          "enabled": true,
          "id": "hostnameWidget"
        },
        {
          "enabled": true,
          "id": "weather"
        },
        {
          "enabled": true,
          "id": "nixMonitor"
        },
        {
          "enabled": true,
          "id": "music",
          "mediaSize": 3
        }
      ],
      "maximizeDetection": true,
      "maximizeWidgetIcons": false,
      "maximizeWidgetText": false,
      "name": "Main Bar",
      "noBackground": false,
      "openOnOverview": true,
      "popupGapsAuto": true,
      "popupGapsManual": 4,
      "position": 0,
      "removeWidgetPadding": false,
      "rightWidgets": [
        {
          "enabled": true,
          "id": "privacyIndicator"
        },
        {
          "enabled": true,
          "id": "systemTray"
        },
        {
          "enabled": true,
          "id": "cpuUsage",
          "minimumWidth": false
        },
        {
          "enabled": true,
          "id": "memUsage"
        },
        {
          "enabled": true,
          "id": "notificationButton"
        },
        {
          "enabled": true,
          "id": "controlCenterButton"
        },
        {
          "enabled": true,
          "id": "keyboard_layout_name"
        },
        {
          "enabled": true,
          "id": "easyEffects"
        },
        {
          "enabled": true,
          "id": "dankKDEConnect"
        },
        {
          "id": "codec",
          "enabled": true
        },
        {
          "enabled": true,
          "id": "battery"
        }
      ],
      "screenPreferences": [
        "all"
      ],
      "scrollEnabled": true,
      "scrollXBehavior": "column",
      "scrollYBehavior": "workspace",
      "shadowColorMode": "text",
      "shadowCustomColor": "#000000",
      "shadowIntensity": 0,
      "shadowOpacity": 60,
      "showOnLastDisplay": true,
      "showOnWindowsOpen": false,
      "spacing": 0,
      "squareCorners": true,
      "transparency": 1,
      "useOverlayLayer": false,
      "visible": true,
      "widgetOutlineColor": "primary",
      "widgetOutlineEnabled": false,
      "widgetOutlineOpacity": 1,
      "widgetOutlineThickness": 1,
      "widgetPadding": 8,
      "widgetTransparency": 1
    }
  ],
  "desktopClockCustomColor": {
    "r": 1,
    "g": 1,
    "b": 1,
    "a": 1,
    "hsvHue": -1,
    "hsvSaturation": 0,
    "hsvValue": 1,
    "hslHue": -1,
    "hslSaturation": 0,
    "hslLightness": 1,
    "valid": true
  },
  "systemMonitorCustomColor": {
    "r": 1,
    "g": 1,
    "b": 1,
    "a": 1,
    "hsvHue": -1,
    "hsvSaturation": 0,
    "hsvValue": 1,
    "hslHue": -1,
    "hslSaturation": 0,
    "hslLightness": 1,
    "valid": true
  },
  "builtInPluginSettings": {
    "dms_clipboard_search": {
      "trigger": "cb"
    },
    "dms_settings_search": {
      "trigger": "?"
    }
  },
  "configVersion": 18
}'';
  };
}
