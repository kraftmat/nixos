{ config, pkgs, lib, ... }:

let
  profileId = "6so3nycd.default";
  floorpProfileDir = "${config.home.homeDirectory}/.floorp/${profileId}";
  chromeDir = "${floorpProfileDir}/chrome";
  userContentTemplate = builtins.readFile ../cfg/floorp-userContent.css;
in {
  home.file."${floorpProfileDir}/user.js" = {
    text = ''
      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    '';
    force = true;
  };

  xdg.configFile."matugen/templates/floorp-userChrome.css" = {
    source = ../cfg/floorp-userchrome.css;
  };

  xdg.configFile."matugen/templates/floorp-userContent.css" = {
    text = userContentTemplate;
  };

  xdg.configFile."matugen/config.toml" = {
    text = ''
      [config]

      [templates.floorp-chrome]
      input_path = '${config.home.homeDirectory}/.config/matugen/templates/floorp-userChrome.css'
      output_path = '${chromeDir}/userChrome.css'

      [templates.floorp-content]
      input_path = '${config.home.homeDirectory}/.config/matugen/templates/floorp-userContent.css'
      output_path = '${chromeDir}/userContent.css'
    '';
    force = true;
  };
}
