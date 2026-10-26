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
  "customThemeFile": "/home/kraftmat/.config/DankMaterialShell/themes/amoledBlack/theme.json",
  "radiusStrength": 38,
  "clockFormat": "24h",
  "fontFamily": "Inter Nerd Font",
  "monoFontFamily": "JetBrainsMono NF",
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
          "id": "dock_launcher",
          "widgetId": "dockLauncher",
          "enabled": true
        },
        {
          "id": "dock_apps",
          "widgetId": "appsDock",
          "enabled": true
        },
        {
          "id": "dock_trash",
          "widgetId": "dockTrash",
          "enabled": true
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
      "id": "user",
      "enabled": true,
      "w": 5,
      "h": 1
    },
    {
      "id": "settings",
      "enabled": true,
      "w": 1,
      "h": 1,
      "small": true
    },
    {
      "id": "lock",
      "enabled": true,
      "w": 1,
      "h": 1,
      "small": true
    },
    {
      "id": "power",
      "enabled": true,
      "w": 1,
      "h": 1,
      "small": true
    },
    {
      "enabled": true,
      "id": "volumeSlider",
      "w": 4,
      "h": 1
    },
    {
      "deviceName": "backlight:intel_backlight",
      "enabled": true,
      "id": "brightnessSlider",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "wifi",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "bluetooth",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "audioOutput",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "audioInput",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "nightMode",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "darkMode",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "plugin_warpToggle",
      "w": 4,
      "h": 1
    },
    {
      "enabled": true,
      "id": "plugin_screenOff",
      "w": 4,
      "h": 1
    },
    {
      "id": "edit",
      "enabled": true,
      "w": 1,
      "h": 1,
      "small": true
    },
    {
      "id": "runningApps",
      "enabled": true,
      "w": 4,
      "h": 1,
      "small": true,
      "col": 0,
      "row": 7
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
          "enabled": true,
          "id": "music",
          "mediaSize": 3,
          "audioScrollMode": "nothing"
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
      "widgetOutlineColor": "primary",
      "widgetOutlineEnabled": false,
      "widgetOutlineOpacity": 1,
      "widgetOutlineThickness": 1,
      "widgetPadding": 8,
      "widgetTransparency": 1,
      "followInterfaceStyle": true,
      "widgetFollowInterfaceStyle": true
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
