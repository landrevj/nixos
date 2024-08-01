{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.applications.waydroid.enable = lib.mkEnableOption "enables waydroid";
  };

  config = lib.mkIf config.system-modules.applications.waydroid.enable {
    virtualisation.waydroid.enable = true;
  };
}