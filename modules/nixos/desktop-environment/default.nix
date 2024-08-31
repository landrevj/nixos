{ pkgs, lib, ... }:

{
  imports = [
    ./cosmic.nix
  ];

  system-modules.desktop-environment = {
    cosmic.enable = lib.mkDefault false;
  };
}
