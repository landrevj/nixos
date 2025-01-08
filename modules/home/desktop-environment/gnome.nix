{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.desktop-environment.gnome = {
      enable = lib.mkEnableOption "configures gnome";
      wallpaper = lib.mkOption {
        type = with lib.types; path;
        default = ../../../assets/wallpapers/clouds.jpg;
        example = "./wallpaper.png";
        description = "Image to be used as the wallpaper.";
      };
    };
  };

  config = lib.mkIf config.home-modules.desktop-environment.gnome.enable {
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      iconTheme = {
        # Reversal
        # name = "Reversal-blue-dark";
        # package = (pkgs.reversal-icon-theme.override {
        #   colorVariants = ["-blue"];
        # });
        # WhiteSur
        name = "WhiteSur-dark";
        package = pkgs.whitesur-icon-theme.override {
          alternativeIcons = true;
          boldPanelIcons = true;
        };
      };
    };
    dconf.settings = with lib.hm.gvariant; {
      # general settings
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        resize-with-right-button = true;
      };
      "org/gnome/desktop/search-providers" = {
        disabled = [ "org.gnome.Characters.desktop" ];
      };
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
      # set wallpaper
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "file://" + config.home-modules.desktop-environment.gnome.wallpaper;
        picture-uri-dark = "file://" + config.home-modules.desktop-environment.gnome.wallpaper;
      };
      # set keybinds
      "org/gnome/shell/keybindings" = {
        screenshot = [ "Print" ];
        show-screenshot-ui = [ "<Shift><Super>s" ];
      };
      "org/gnome/desktop/wm/keybindings" = {
        move-to-workspace-left = [ "<Control><Alt><Super>Left" ];
        move-to-workspace-right = [ "<Control><Alt><Super>Right" ];
        switch-to-workspace-left = [ "<Control><Super>Left" ];
        switch-to-workspace-right = [ "<Control><Super>Right" ];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>E";
        command = "nautilus";
        name = "open-file-browser";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>T";
        command = "ghostty";
        name = "open-terminal";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
        binding = "<Super>period";
        command = "flatpak run it.mijorus.smile";
        name = "open-emoji-picker";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
        binding = "<Shift><Control>Escape";
        command = "resources";
        name = "open-resources";
      };
    };
  };
}
