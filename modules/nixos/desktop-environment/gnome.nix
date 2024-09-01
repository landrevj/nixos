{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.desktop-environment.gnome.enable = lib.mkEnableOption "enables gnome";
    system-modules.desktop-environment.gnome.displayManager.enable = lib.mkEnableOption "enables gnome display manager";
  };

  config = lib.mkIf config.system-modules.desktop-environment.gnome.enable {
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = config.system-modules.desktop-environment.gnome.displayManager.enable;
  };
}