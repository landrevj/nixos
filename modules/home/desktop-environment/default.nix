{ pkgs, lib, ... }:

{
  imports = [ ./gnome.nix ./kde.nix ];

  # Modules
  home-modules.desktop-environment = {
    gnome.enable = lib.mkDefault true;
    kde.enable = lib.mkDefault false;
  };
}
