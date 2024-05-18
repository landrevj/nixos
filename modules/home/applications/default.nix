{ pkgs, lib, ... }:

{
  imports = [
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./mpv.nix
    ./neovim.nix
    ./nsxiv.nix
    ./obs-studio.nix
    ./yt-dlp.nix
  ];

  # Modules
  fish.enable = lib.mkDefault true;
  foot.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  mpv.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  nsxiv.enable = lib.mkDefault true;
  obs-studio.enable = lib.mkDefault false;
  yt-dlp.enable = lib.mkDefault true;

  # Packages
  home.packages = with pkgs; [
    # settings
    appeditor
    hyfetch

    # files
    vscode
    
    # browsing
    firefox
    chromium
    bitwarden

    # communication
    vesktop
    signal-desktop
    element-desktop

    # media
    audacity
    plexamp
    feh
    foliate
    
    # games
    gnome.aisleriot
    heroic
    prismlauncher
    steamtinkerlaunch
    steam-run
    space-cadet-pinball
    mangohud

    # utilities
    bat
    bottles
    eza
    gcolor3
    fd
    mullvad-vpn
    shellcheck
    shfmt
    starship
    mission-center
  ];

  # Flatpaks
  services.flatpak.packages = [
    "it.mijorus.smile"
  ];
}