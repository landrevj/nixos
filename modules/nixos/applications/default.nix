{ pkgs, lib, ... }:

{
  imports = [
    ./openrgb
    ./steam.nix
    ./waydroid.nix
  ];

  # Modules
  system-modules.applications = {
    openrgb.enable = lib.mkDefault false;
    steam.enable = lib.mkDefault true;
    waydroid.enable = lib.mkDefault false;
  };

  # Fix appimages
  programs.appimage ={
    enable = true;
    binfmt = true;
  };

  # Packages
  environment.systemPackages = with pkgs; [
    # gnome
    gnome-software
    dconf-editor
    gnome-tweaks
    gnome-themes-extra

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
    ncdu

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