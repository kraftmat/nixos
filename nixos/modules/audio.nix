{ ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."51-bluez-ldac" = {
        "monitor.bluez.rules" = [
          {
            matches = [ { "device.name" = "~bluez_card.*"; } ];
            actions.update-props = {
              "bluez5.a2dp.ldac.quality" = "auto";
            };
          }
        ];
      };
    };
  };
  security.rtkit.enable = true;
}
