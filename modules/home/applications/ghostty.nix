{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.ghostty.enable =
      lib.mkEnableOption "enables ghostty";
  };

  config = lib.mkIf config.home-modules.applications.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = config.home-modules.applications.fish.enable;
      installBatSyntax = true;
      systemd.enable = true;
      settings = {
        font-family = "MesloLGL Nerd Font Mono";
        font-size = 11;
        gtk-titlebar-style = "tabs";
        keybind = [ "global:super+enter=toggle_quick_terminal" ];
        # quick-terminal-autohide = true;
        quick-terminal-position = "top";
        quick-terminal-size = "50%,99%";
        quit-after-last-window-closed = false;
        theme = "my-theme";
        window-height = 27;
        window-width = 124;
        window-decoration = "client";
      };
      themes = {
        my-theme = {
          background = "1E1E1E";
          foreground = "FFFFFF";
          selection-background = "FFFFFF";
          selection-foreground = "000000";
          palette = [
            "0=#444444"
            "1=#FF0054"
            "2=#B1D630"
            "3=#F5C211"
            "4=#67BEE3"
            "5=#B576BC"
            "6=#569A9F"
            "7=#EDEDED"
            "8=#777777"
            "9=#D65E75"
            "10=#BAFFAA"
            "11=#F8E45C"
            "12=#9FD3E5"
            "13=#DEB3DF"
            "14=#B6E0E5"
            "15=#FFFFFF"
          ];
        };
      };
    };
  };
}
