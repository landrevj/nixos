{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "landrevj";
  home.homeDirectory = "/home/landrevj";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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
    xivlauncher
    steamtinkerlaunch
    heroic

    # modeling
    prusa-slicer
    obs-studio
    freecad

    # utilities
    mullvad-vpn
    gpu-screen-recorder
    gpu-screen-recorder-gtk

    # downloaders
    gallery-dl

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/landrevj/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "blackbox";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  # Gnome
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ./wallpaper.jpg;
      picture-uri-dark = "file://" + ./wallpaper.jpg;
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      # Reversal
      # name = "Reversal-blue-dark";
      # package = (pkgs.reversal-icon-theme.override {
      #   colorVariants = ["-blue"];
      # });
      # WhiteSur
      name = "WhiteSur-dark";
      package = (pkgs.whitesur-icon-theme.override {
        alternativeIcons = true;
        boldPanelIcons = true;
      });
    };
  };


  ###
  # PROGRAMS
  ###
  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#default";
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
