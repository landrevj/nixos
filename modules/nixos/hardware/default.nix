{ pkgs, lib, ... }:

{
  imports = [
    ./amd.nix
    ./nvidia.nix
    ./vfio
  ];

  # Modules
  amd.enable = lib.mkDefault false;
  nvidia.enable = lib.mkDefault false;
  vfio.enable = lib.mkDefault false;
}