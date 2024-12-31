{ pkgs, lib, ... }:

{
  imports = [
    ./openrgb
    ./podman.nix
    ./steam.nix
    ./waydroid.nix
  ];

  # Modules
  system-modules.applications = {
    openrgb.enable = lib.mkDefault false;
    podman.enable = lib.mkDefault false;
    steam.enable = lib.mkDefault false;
    waydroid.enable = lib.mkDefault false;
  };

  # Fix appimages
  programs.appimage = {
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
    nixpkgs-fmt

    # hardware
    pciutils
    usbutils
    cdrtools
    hwloc
    dmidecode
    smartmontools

    # os
    scx.full

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
    unrar
    gparted
    vim

    # dev
    distrobox
    gcc
  ];
}
