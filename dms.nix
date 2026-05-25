{ pkgs, ... }:

{
  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable           = false;
      restartIfChanged = true;
    };

    enableSystemMonitoring = true;
    enableVPN              = false;
    enableDynamicTheming   = true;
    enableAudioWavelength  = true;
    enableCalendarEvents   = false;
    enableClipboardPaste   = true;

    settings = {
      theme          = "dark";
      dynamicTheming = true;
    };

    session = {
      isLightMode = false;
    };

    clipboardSettings = {
      maxHistory     = 50;
      maxEntrySize   = 5242880;
      autoClearDays  = 3;
      clearAtStartup = false;
      disabled       = false;
      disableHistory = false;
      disablePersist = false;
    };

    plugins = {
      dankBatteryAlerts.enable = true;
    };
  };
}
