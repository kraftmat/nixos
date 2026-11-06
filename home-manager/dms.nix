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
        cp ${./cfg/btplugin}/* $out/
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
  "lockScreenWidgetInstances": [
    {
      "id": "lock_clock",
      "widgetType": "desktopClock",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "style": "overlap",
        "transparency": 0,
        "weight": 0,
        "twoTone": true,
        "showDate": false,
        "showDigitalSeconds": false,
        "showAnalogNumbers": false,
        "showAnalogSeconds": true,
        "autoPosition": true,
        "colorMode": "default",
        "customColor": "#ffffff"
      }
    },
    {
      "id": "lock_date",
      "widgetType": "lockDate",
      "enabled": false,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "format": "short",
        "colorMode": "default",
        "customColor": "#ffffff"
      }
    },
    {
      "id": "lock_auth",
      "widgetType": "lockAuth",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "style": "expressive",
        "profileVisibility": "always",
        "passwordVisibility": "always"
      }
    },
    {
      "id": "lock_notifications",
      "widgetType": "lockNotifications",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "mode": 2
      }
    },
    {
      "id": "lock_status",
      "widgetType": "lockStatus",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "showMediaPlayer": true,
        "showWeather": true,
        "background": false
      }
    },
    {
      "id": "lock_power",
      "widgetType": "lockPower",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "shape": "round"
      }
    }
  ],
  "greeterWidgetInstances": [
    {
      "id": "lock_clock",
      "widgetType": "desktopClock",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "style": "overlap",
        "transparency": 0,
        "weight": 0,
        "twoTone": true,
        "showDate": false,
        "showDigitalSeconds": false,
        "showAnalogNumbers": false,
        "showAnalogSeconds": true,
        "autoPosition": true,
        "colorMode": "default",
        "customColor": "#ffffff"
      }
    },
    {
      "id": "lock_date",
      "widgetType": "lockDate",
      "enabled": false,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "format": "short",
        "colorMode": "default",
        "customColor": "#ffffff"
      }
    },
    {
      "id": "lock_auth",
      "widgetType": "lockAuth",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "style": "expressive",
        "profileVisibility": "always",
        "passwordVisibility": "always"
      }
    },
    {
      "id": "lock_status",
      "widgetType": "lockStatus",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "showMediaPlayer": true,
        "showWeather": true,
        "background": false
      }
    },
    {
      "id": "lock_power",
      "widgetType": "lockPower",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true,
        "shape": "round"
      }
    },
    {
      "id": "greeter_session",
      "widgetType": "greeterSession",
      "enabled": true,
      "config": {
        "displayPreferences": [
          "all"
        ],
        "syncPositionAcrossScreens": true
      }
    }
  ],
  "currentThemeName": "dynamic",
  "customThemeFile": "/home/kraftmat/.config/DankMaterialShell/themes/amoledBlack/theme.json",
  "radiusStrength": 38,
  "clockFormat": "24h",
  "fontFamily": "Inter Nerd Font",
  "monoFontFamily": "JetBrainsMono NF",
  "lockScreenShowPowerActions": true,
  "powerActionConfirm": false,
  "dockConfigs": [
    {
      "id": "dock",
      "name": "Dock",
      "enabled": false,
      "screenPreferences": [
        "all"
      ],
      "showOnLastDisplay": true,
      "position": 1,
      "mode": "compact",
      "taskbarAlign": "center",
      "widgetExpansion": "popout",
      "iconSize": 40,
      "spacing": 4,
      "itemSpacing": 4,
      "margin": 0,
      "bottomGap": 0,
      "transparency": 0.85,
      "followInterfaceStyle": false,
      "autoHide": false,
      "smartAutoHide": false,
      "useOverlayLayer": false,
      "editOnRightClick": false,
      "showOnFullscreen": false,
      "openOnOverview": false,
      "groupByApp": false,
      "separatePinnedAndRunningApps": false,
      "restoreSpecialWorkspaceOnClick": false,
      "isolateDisplays": false,
      "indicatorStyle": "circle",
      "borderEnabled": false,
      "borderColor": "surfaceText",
      "borderOpacity": 1,
      "borderThickness": 1,
      "launcherEnabled": false,
      "launcherLogoMode": "apps",
      "launcherLogoCustomPath": "",
      "launcherLogoColorOverride": "",
      "launcherLogoSizeOffset": 0,
      "launcherLogoBrightness": 0.5,
      "launcherLogoContrast": 1,
      "maxVisibleApps": 0,
      "maxVisibleRunningApps": 0,
      "showOverflowBadge": true,
      "showTrash": false,
      "trashFileManager": "default",
      "trashCustomCommand": "",
      "magnification": false,
      "magnificationScale": 130,
      "magnificationProfile": "parabolic",
      "magnificationExpand": false,
      "order": [],
      "widgets": [
        {
          "enabled": true,
          "id": "dock_launcher",
          "widgetId": "dockLauncher"
        },
        {
          "enabled": true,
          "id": "dock_apps",
          "widgetId": "appsDock"
        },
        {
          "enabled": true,
          "id": "dock_trash",
          "widgetId": "dockTrash"
        }
      ]
    }
  ],
  "currentThemeCategory": "dynamic",
  "dmsWindowsFloatingSeeded": [
    "niri"
  ],
  "barElevationEnabled": false,
  "blurWallpaperOnOverview": true,
  "controlCenterWidgets": [
    {
      "enabled": true,
      "h": 1,
      "id": "user",
      "w": 5
    },
    {
      "enabled": true,
      "h": 1,
      "id": "settings",
      "small": true,
      "w": 1
    },
    {
      "enabled": true,
      "h": 1,
      "id": "lock",
      "small": true,
      "w": 1
    },
    {
      "enabled": true,
      "h": 1,
      "id": "power",
      "small": true,
      "w": 1
    },
    {
      "enabled": true,
      "h": 1,
      "id": "volumeSlider",
      "w": 4
    },
    {
      "deviceName": "backlight:intel_backlight",
      "enabled": true,
      "h": 1,
      "id": "brightnessSlider",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "wifi",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "bluetooth",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "audioOutput",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "audioInput",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "nightMode",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "darkMode",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "plugin_warpToggle",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "plugin_screenOff",
      "w": 4
    },
    {
      "enabled": true,
      "h": 1,
      "id": "edit",
      "small": true,
      "w": 1
    },
    {
      "col": 0,
      "enabled": true,
      "h": 1,
      "id": "runningApps",
      "row": 7,
      "small": true,
      "w": 4
    }
  ],
  "audioVisualizerEnabled": false,
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
  "muxType": "zellij",
  "notificationOverlayEnabled": true,
  "lockPamExternallyManaged": true,
  "notificationCompactMode": true,
  "osdPowerProfileEnabled": true,
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
      "followInterfaceStyle": true,
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
          "id": "workspaceSwitcher",
          "showWorkspaceApps": true
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
          "audioScrollMode": "nothing",
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
      "rightWidgets": [
        {
          "enabled": true,
          "id": "privacyIndicator",
          "privacyShowMicIcon": true
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
          "id": "controlCenterButton",
          "showMicPercent": true
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
          "enabled": true,
          "id": "codec"
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
      "scrollXBehavior": "focusWindow",
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
      "widgetFollowInterfaceStyle": true,
      "widgetOutlineColor": "primary",
      "widgetOutlineEnabled": false,
      "widgetOutlineOpacity": 1,
      "widgetOutlineThickness": 1,
      "widgetPadding": 8,
      "widgetTransparency": 1
    }
  ],
  "builtInPluginSettings": {
    "dms_clipboard_search": {
      "trigger": "cb"
    },
    "dms_settings_search": {
      "trigger": "?"
    }
  },
  "configVersion": 42
}'';
  };
}
