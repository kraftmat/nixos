{ ... }:

{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "dankcolors";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      window-padding-y = 15;
      window-padding-x = 15;
      notify-on-command-finish = "unfocused";
      right-click-action = "ignore";
      notify-on-command-finish-action = "notify";
      clipboard-read = "allow";
      clipboard-write = "allow";
      keybind = [
        "performable:ctrl+c=copy_to_clipboard"
        "alt+t=new_tab"
        "alt+c=close_surface"
        "alt+x=next_tab"
        "alt+z=previous_tab"
      ];
    };
  };
}
