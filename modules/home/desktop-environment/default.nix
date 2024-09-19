{ pkgs, lib, ... }:

{
  imports = [
    ./gnome.nix
  ];

  # Modules
  home-modules.desktop-environment = {
    gnome.enable = lib.mkDefault true;
  };
}