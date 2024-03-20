{ config, pkgs, lib, flake-inputs, ... }:

{
  imports = [ flake-inputs.flatpaks.homeManagerModules.nix-flatpak ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "landrevj";
  home.homeDirectory = "/home/landrevj";
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "blackbox";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # settings
    appeditor
    openrgb-with-all-plugins
    neofetch

    # files
    blackbox-terminal
    vscode
    
    # browsing
    firefox
    chromium
    bitwarden

    # communication
    discord
    signal-desktop

    # media
    audacity
    plexamp
    feh
    foliate
    
    # games
    gnome.aisleriot
    xivlauncher
    steamtinkerlaunch
    heroic
    prismlauncher

    # modeling
    prusa-slicer
    obs-studio
    freecad

    # utilities
    bottles
    waydroid
    mullvad-vpn
    gpu-screen-recorder
    gpu-screen-recorder-gtk
    eza

    # downloaders
    gallery-dl
    youtube-dl
    yt-dlp

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  services.flatpak.packages = [
    "it.mijorus.smile"
    "net.nokyan.Resources"
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Gnome
  dconf.settings = with lib.hm.gvariant; {
    # set wallpaper
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ./wallpaper.jpg;
      picture-uri-dark = "file://" + ./wallpaper.jpg;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      # Reversal
      # name = "Reversal-blue-dark";
      # package = (pkgs.reversal-icon-theme.override {
      #   colorVariants = ["-blue"];
      # });
      # WhiteSur
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme.override {
        alternativeIcons = true;
        boldPanelIcons = true;
      };
    };
  };


  # Config files
  xdg = {
    enable = true;
    configFile."gallery-dl/config.json".source = ./configs/gallery-dl/config.json;
  };

  # Programs
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#default";
      xcopy = "xclip -selection clipboard";
      xpaste = "xclip -selection clipboard -o";
      e = "eza -l";
    };
    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

  programs.git = {
    enable = true;
    userName = "Joseph Landreville";
    userEmail = "landrevillejoseph@gmail.com";
  };

  programs.mpv = {
    enable = true;
    scripts = [pkgs.mpvScripts.autoload];
    scriptOpts = {
      osc = {
        windowcontrols = false;
      };
      autoload = {
        images = false;
        additional_video_exts = "gif,apng";
      };
    };
    config = {
      no-border = true;
      osd-fractions = true;
      loop-file = true;
    };
  };
}
