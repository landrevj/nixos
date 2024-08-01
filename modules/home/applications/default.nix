{ pkgs, lib, ... }:

{
  imports = [
    ./darktable.nix
    ./davinci-resolve.nix
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./helix.nix
    ./mpv.nix
    ./nautilus.nix
    ./neovim.nix
    ./nsxiv.nix
    ./obs-studio.nix
    ./xivlauncher.nix
    ./yt-dlp.nix
  ];

  # Modules
  home-modules.applications = {
    darktable.enable = lib.mkDefault false;
    davinci-resolve.enable = lib.mkDefault false;
    fish.enable = lib.mkDefault true;
    foot.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    helix.enable = lib.mkDefault true;
    mpv.enable = lib.mkDefault true;
    nautilus.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;
    nsxiv.enable = lib.mkDefault true;
    obs-studio.enable = lib.mkDefault false;
    xivlauncher.enable = lib.mkDefault false;
    yt-dlp.enable = lib.mkDefault true;
  };

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
    imagemagick
    switcheroo
    
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
    resources
  ];

  # Flatpaks
  services.flatpak.packages = [
    "it.mijorus.smile"
  ];
}