{ config, pkgs, lib, username, ... }:

{
  imports = [
    ../../modules/home
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

      # emulators
      cemu
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
    desktop-environment.gnome = {
      enable = true;
      wallpaper = ../../assets/wallpapers/aurora.jpg;
    };
    applications = {
      obs-studio.enable = true;
      xivlauncher.enable = true;
    };
  };
}
