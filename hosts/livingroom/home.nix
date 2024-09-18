{ config, pkgs, lib, username, ... }:

{
  imports = [
    ../../modules/home/applications
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home = {
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    username = username;
    homeDirectory = "/home/${username}";
    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "foot";
    };

    file = {
      # ".screenrc".source = dotfiles/screenrc;
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    packages = with pkgs; [
      protonup-qt

      # emulation
      steam-rom-manager
      dolphin-emu
      ryujinx
    ];
  };

  # secrets
  # sops = {
  #   defaultSopsFile = ../../secrets/livingroom/secrets.yaml;
  #   age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  #   secrets = {
  #     "hello" = {};
  #   };
  # };

  # sops-nix requirements
  # systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  # home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #   /run/current-system/sw/bin/systemctl start --user sops-nix
  # '';

  # Gnome
  dconf.settings = with lib.hm.gvariant; {
    # general settings
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      resize-with-right-button = true;
    };
    "org/gnome/desktop/search-providers" = {
      disabled = [ "org.gnome.Characters.desktop" ];
    };
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
    # set wallpaper
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ../../assets/wallpapers/aurora.jpg;
      picture-uri-dark = "file://" + ../../assets/wallpapers/aurora.jpg;
    };
    # set keybinds
    "org/gnome/shell/keybindings" = {
      screenshot = [ "Print" ];
      show-screenshot-ui = [ "<Shift><Super>s" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-left = [ "<Control><Alt><Super>Left" ];
      move-to-workspace-right = [ "<Control><Alt><Super>Right" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>E";
      command = "nautilus";
      name = "open-file-browser";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>T";
      command = "foot";
      name = "open-terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>period";
      command = "flatpak run it.mijorus.smile";
      name = "open-emoji-picker";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Shift><Control>Escape";
      command = "resources";
      name = "open-resources";
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

  # Programs
  programs = {
    fish = {
      enable = true;
      functions = {
        nix-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#livingroom $argv";
        # nix-update = "sudo nix flake update --flake /etc/nixos#livingroom $argv";
      };
    };
  };

  # Modules
  home-modules = {
    applications = {
      obs-studio.enable = true;
      xivlauncher.enable = true;
    };
  };
}