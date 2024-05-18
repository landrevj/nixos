{ pkgs, lib, config, ... }:

{
  options = {
    xivlauncher.enable = lib.mkEnableOption "enables xivlauncher";
  };

  config = lib.mkIf config.xivlauncher.enable {
    services.flatpak.packages = [
      "dev.goats.xivlauncher"
    ];
  };
}