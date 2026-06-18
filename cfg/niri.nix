{ config, pkgs, hostConfig, ... }:

{
xdg.configFile."niri/config.kdl".text = ''
  output "${hostConfig.monitor}" {
      mode "${hostConfig.mode}"
      scale 1.0
  }
    config-notification {
        disable-failed
    }
    cursor {
        xcursor-theme "Bibata-Modern-Classic"
        xcursor-size 24
}
    gestures {
        hot-corners {
            off
        }
    }

    input {
        mouse {
            accel-speed -0.5
            accel-profile "flat"
            scroll-factor 1.0
        }
        keyboard {
            xkb {
                layout "us,ru"
                options "grp:caps_toggle"
            }
            numlock
        }
        touchpad {
                
                tap
                dwt
                disabled-on-external-mouse
                drag-lock
                natural-scroll
               
            }
    }

    layout {
        gaps 23
        background-color "transparent"
        center-focused-column "never"
        always-center-single-column

        border {
            off
            width 4
            active-color   "#707070"
            inactive-color "#d0d0d0"
            urgent-color   "#cc4444"
        }
        focus-ring {
            on
            width 3
            active-color "#4f6b5a"
        }
        shadow {
            softness 30
            spread 5
            offset x=0 y=5
            color "#0007"
        }
        struts {
        }
    }

    layer-rule {
        match namespace="^quickshell$"
        place-within-backdrop true
    }

    overview {
        workspace-shadow {
            off
        }
    }

    spawn-at-startup "bash" "-c" "wl-paste --watch cliphist store &"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "dms" "run"

    environment {
        XDG_CURRENT_DESKTOP "niri"
        QT_QPA_PLATFORMTHEME "qt6ct"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        TERMINAL "kitty --single-instance"
    }

    hotkey-overlay {
        skip-at-startup
    }

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    animations {
        on
        workspace-switch {
            spring damping-ratio=0.80 stiffness=523 epsilon=0.0001
        }
        window-open {
            duration-ms 150
            curve "ease-out-expo"
        }
        window-close {
            duration-ms 150
            curve "ease-out-quad"
        }
        horizontal-view-movement {
            spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=0.75 stiffness=323 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=0.85 stiffness=423 epsilon=0.0001
        }
        config-notification-open-close {
            spring damping-ratio=0.65 stiffness=923 epsilon=0.001
        }
        screenshot-ui-open {
            duration-ms 200
            curve "ease-out-quad"
        }
        overview-open-close {
            spring damping-ratio=0.85 stiffness=800 epsilon=0.0001
        }
    }

    window-rule {
        match app-id="KonataDancer"
        open-floating true
    }
    window-rule {
        open-maximized true
        geometry-corner-radius 4
        clip-to-geometry true
    }
    window-rule {
        match app-id=r#"^org\.gnome\."#
        open-maximized false
        default-column-width { proportion 0.5; }
        draw-border-with-background false
        geometry-corner-radius 12
        clip-to-geometry true
    }
   
    binds {
        Mod+Tab repeat=false { toggle-overview; }
        Mod+Shift+B { show-hotkey-overlay; }

        Mod+Return { spawn "kitty" "--single-instance"; }
        Mod+R hotkey-overlay-title="Application Launcher" {
            spawn "dms" "ipc" "call" "spotlight" "toggle";
        }
        Mod+Shift+R { switch-preset-column-width; }
        Mod+V hotkey-overlay-title="Clipboard Manager" {
            spawn "dms" "ipc" "call" "clipboard" "toggle";
        }
        Mod+N hotkey-overlay-title="Notification Center" {
            spawn "dms" "ipc" "call" "notifications" "toggle";
        }
        Mod+Alt+L hotkey-overlay-title="Lock Screen" {
            spawn "dms" "ipc" "call" "lock" "lock";
        }
        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete hotkey-overlay-title="Task Manager" {
            spawn "dms" "ipc" "call" "processlist" "toggle";
        }

        Ctrl+WheelScrollUp allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "increment" "3";
        }
        Ctrl+WheelScrollDown allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "decrement" "3";
        }
        Ctrl+TouchpadScrollDown allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "increment" "3";
        }
        Ctrl+TouchpadScrollUp allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "decrement" "3";
        }
        XF86AudioMute allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "mute";
        }
        XF86AudioMicMute allow-when-locked=true {
            spawn "dms" "ipc" "call" "audio" "micmute";
        }
        XF86MonBrightnessUp allow-when-locked=true {
            spawn "dms" "ipc" "call" "brightness" "increment" "5" "";
        }
        XF86MonBrightnessDown allow-when-locked=true {
            spawn "dms" "ipc" "call" "brightness" "decrement" "5" "";
        }

        Mod+Shift+C repeat=false { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Shift+Space { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Mod+Shift+J  { consume-or-expel-window-left; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        Mod+Ctrl+Home { move-column-to-first; }
        Mod+Ctrl+End  { move-column-to-last; }

        Mod+Ctrl+Left  { focus-monitor-left; }
        Mod+Ctrl+Right { focus-monitor-right; }
        Mod+Ctrl+H     { focus-monitor-left; }
        Mod+Ctrl+J     { focus-monitor-down; }
        Mod+Ctrl+K     { focus-monitor-up; }
        Mod+Ctrl+L     { focus-monitor-right; }

        Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
        Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+U         { focus-workspace-down; }
        Mod+I         { focus-workspace-up; }
        Mod+Ctrl+Down { move-column-to-workspace-down; }
        Mod+Ctrl+Up   { move-column-to-workspace-up; }
        Mod+Ctrl+U    { move-column-to-workspace-down; }
        Mod+Ctrl+I    { move-column-to-workspace-up; }

        Mod+Shift+Page_Down { move-workspace-down; }
        Mod+Shift+Page_Up   { move-workspace-up; }
        Mod+Shift+U         { move-workspace-down; }
        Mod+Shift+I         { move-workspace-up; }

        Mod+WheelScrollDown     cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp       cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }
        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
        
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        Mod+W { spawn "floorp"; }
        Mod+E { spawn "nautilus"; }
        Mod+Shift+D { spawn "vesktop"; }
        Pause { spawn "swayosd-client" "--playerctl" "play-pause"; }
        MouseBack { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && swayosd-client --input-volume mute-toggle"; }
        Shift+MouseBack { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && swayosd-client --input-volume mute-toggle"; }

        Mod+Ctrl+R { reset-window-height; }
        Mod+Ctrl+F { expand-column-to-available-width; }
        Mod+C { center-column; }
        Mod+Ctrl+C { center-visible-columns; }

        Mod+Minus       { set-column-width "-10%"; }
        Mod+Equal       { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Mod+Shift+S { screenshot; }
        Mod+Shift+W { screenshot-window; }
        Mod+Shift+A { screenshot-screen; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
        Mod+Shift+P { power-off-monitors; }
    }

    debug {
        honor-xdg-activation-with-invalid-serial
    }

    recent-windows {
        off
    }
  '';
}
