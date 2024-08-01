{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.xivlauncher.enable = lib.mkEnableOption "enables xivlauncher";
  };

  config = lib.mkIf config.home-modules.applications.xivlauncher.enable {
    services.flatpak.packages = [
      "dev.goats.xivlauncher"
    ];
  };
}