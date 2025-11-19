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
    ./zen-browser.nix
  ];

  # Modules
  home-modules.applications = {
    darktable.enable = lib.mkDefault false;
    davinci-resolve.enable = lib.mkDefault false;
    firefox.enable = lib.mkDefault true;
    fish.enable = lib.mkDefault true;
    foot.enable = lib.mkDefault false;
    ghostty.enable = lib.mkDefault false;
    git.enable = lib.mkDefault true;
    helix.enable = lib.mkDefault true;
    mpv.enable = lib.mkDefault true;
    nautilus.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;
    nsxiv.enable = lib.mkDefault true;
    obs-studio.enable = lib.mkDefault false;
    xivlauncher.enable = lib.mkDefault false;
    yt-dlp.enable = lib.mkDefault true;
    zen-browser.enable = lib.mkDefault false;
  };

  # Packages
  home.packages = with pkgs; [
    # settings
    appeditor
    fastfetch

    # files
    vscode
    kdePackages.filelight
    sqlitebrowser

    # browsing
    chromium
    bitwarden-desktop

    # communication
    discord
    vesktop
    smile
    # gnome-frog
    signal-desktop
    thunderbird
    rustdesk-flutter

    # media
    audacity
    plexamp
    # f3d
    feh
    feishin
    foliate
    imagemagick
    switcheroo
    cuetools
    flacon
    qbittorrent

    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US-large

    # games
    aisleriot
    heroic
    prismlauncher
    steam-run
    # space-cadet-pinball
    mangohud
    protontricks

    steamtinkerlaunch # requires the below for nxm links
    unzip
    xdotool
    xorg.xwininfo

    # utilities
    bat
    (pkgs.bottles.override { removeWarningPopup = true; })
    eza
    fd
    mdf2iso
    mission-center
    mullvad-vpn
    nvtopPackages.amd
    resources
    sbctl
    shellcheck
    shfmt

    # resources
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
