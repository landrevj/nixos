{ pkgs, lib, ... }:

{
  imports = [
    ./openrgb
    ./steam.nix
  ];

  # Modules
  openrgb.enable = lib.mkDefault false;
  steam.enable = lib.mkDefault true;

  # Packages
  environment.systemPackages = with pkgs; [
    # gnome
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.gnome-software
    gnome.gnome-themes-extra

    # utils
    wget
    htop
    killall
    man-pages
    xclip
    tuptime
    vulkan-tools
    file
    jq
    findutils

    # hardware
    pciutils
    usbutils
    cdrtools
    hwloc
    dmidecode
    smartmontools

    # lib
    python3
    jdk
    libGL
    wineWowPackages.stable

    # software
    ffmpeg-full
    sops
    age
    p7zip
    gparted
    vim
  ];
}