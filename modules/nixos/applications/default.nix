{ pkgs, lib, ... }:

{
  imports = [ ./distrobox.nix ./openrgb ./steam.nix ./tailscale.nix ./waydroid.nix ];

  # Modules
  system-modules.applications = {
    distrobox.enable = lib.mkDefault false;
    openrgb.enable = lib.mkDefault false;
    steam.enable = lib.mkDefault false;
    tailscale.enable = lib.mkDefault false;
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
    nixfmt-classic
    nixd
    helvum
    pavucontrol

    # hardware
    pciutils
    usbutils
    cdrtools
    hwloc
    dmidecode
    smartmontools
    linux-firmware

    # os
    # scx.full

    # lib
    python3
    jdk
    libGL
    wineWowPackages.stable
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi

    # software
    ffmpeg-full
    sops
    age
    p7zip
    unrar
    gparted
    vim

    # dev
    gcc
  ];
}
