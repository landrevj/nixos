{ pkgs, lib, ... }:

{
  imports = [
    ./darktable.nix
    ./davinci-resolve.nix
    ./firefox.nix
    ./fish.nix
    ./foot.nix
    ./ghostty.nix
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
    firefox.enable = lib.mkDefault true;
    fish.enable = lib.mkDefault true;
    foot.enable = lib.mkDefault false;
    ghostty.enable = lib.mkDefault true;
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
    fastfetch

    # files
    vscode

    # browsing
    chromium
    bitwarden

    # communication
    discord
    vesktop
    smile
    gnome-frog
    signal-desktop
    element-desktop

    # media
    audacity
    plexamp
    feh
    foliate
    imagemagick
    switcheroo
    cuetools
    flacon
    onlyoffice-bin
    qbittorrent

    # games
    aisleriot
    heroic
    prismlauncher
    steam-run
    space-cadet-pinball
    mangohud
    protontricks

    steamtinkerlaunch # requires the below for nxm links
    unzip
    xdotool
    xorg.xwininfo

    # utilities
    bat
    bottles
    eza
    fd
    mullvad-vpn
    shellcheck
    shfmt
    resources
    zenity

    # debug
    d-spy
  ];

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Flatpaks
  services.flatpak.packages =
    [ "it.mijorus.smile" "com.github.tchx84.Flatseal" ];
}
