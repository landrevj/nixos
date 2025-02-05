{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.desktop-environment.kde.enable = lib.mkEnableOption "enables kde";
    system-modules.desktop-environment.kde.displayManager.enable = lib.mkEnableOption "enables kde display manager";
  };

  config = lib.mkIf config.system-modules.desktop-environment.kde.enable {
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.enable = config.system-modules.desktop-environment.kde.displayManager.enable;
  };
}