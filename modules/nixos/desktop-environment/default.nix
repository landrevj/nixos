{ pkgs, lib, ... }:

{
  imports = [
    ./cosmic.nix
    ./gnome.nix
    ./kde.nix
  ];

  system-modules.desktop-environment = {
    cosmic.enable = lib.mkDefault false;
    gnome = {
      enable = lib.mkDefault true;
      displayManager.enable = lib.mkDefault true;
    };
    kde = {
      enable = lib.mkDefault false;
      displayManager.enable = lib.mkDefault true;
    };
  };
}
