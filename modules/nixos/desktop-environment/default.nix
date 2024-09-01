{ pkgs, lib, ... }:

{
  imports = [
    ./gnome.nix
    ./cosmic.nix
  ];

  system-modules.desktop-environment = {
    gnome = {
      enable = lib.mkDefault true;
      displayManager.enable = lib.mkDefault true;
    };
    cosmic.enable = lib.mkDefault false;
  };
}
