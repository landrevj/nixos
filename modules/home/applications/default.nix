{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./mpv.nix
    ./neovim.nix
    ./fish.nix
    ./nsxiv.nix
    ./foot.nix
  ];  

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

  services.flatpak.packages = [
    "it.mijorus.smile"
  ];
}