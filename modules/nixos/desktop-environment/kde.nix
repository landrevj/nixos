{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.desktop-environment.kde = {
      enable = lib.mkEnableOption "enables kde";
      displayManager.enable = lib.mkEnableOption "enables kde display manager";
      sddm.wallpaper = lib.mkOption {
        type = with lib.types; path;
        default = ../../../assets/wallpapers/woods.jpg;
        example = "./wallpaper.png";
        description = "Image to be used as the wallpaper during first login.";
      };
    };
  };

  config = lib.mkIf config.system-modules.desktop-environment.kde.enable {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable =
      config.system-modules.desktop-environment.kde.displayManager.enable;
    environment.sessionVariables.GTK_USE_PORTAL = 1;
    environment.systemPackages = with pkgs; [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${config.system-modules.desktop-environment.kde.sddm.wallpaper}
      '')
      ocs-url
    ];
  };
}
