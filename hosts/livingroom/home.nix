{ config, pkgs, lib, username, ... }:

{
  imports = [ ../../modules/home ];

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
      rusty-psn-gui
      nsz
      xdelta

      # emulators
      cemu
      dolphin-emu
      faster-project-plus
      (lib.meta.lowPrio pcsx2) # binary collision with "resources"
      retroarchFull
      rpcs3
      ryujinx
      xemu
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
        nix-rebuild =
          "sudo nixos-rebuild switch --flake /etc/nixos#livingroom $argv";
        # nix-update = "sudo nix flake update --flake /etc/nixos#livingroom $argv";
      };
    };
  };

  xdg.configFile = {
    "retroarch/retroarch.cfg".text = ''
      ${builtins.readFile ./dotfiles/retroarch/retroarch.cfg}

      # /nix/store dirs
      assets_directory = "${pkgs.retroarch-assets}/share/retroarch/assets"
      joypad_autoconfig_dir = "${pkgs.retroarch-joypad-autoconfig}/share/libretro/autoconfig"
      libretro_directory = "${pkgs.retroarchFull}/lib/retroarch/cores"
      libretro_info_path = "${pkgs.libretro-core-info}/share/retroarch/cores"
    '';
  };

  # Modules
  home-modules = {
    # desktop-environment.gnome = {
    #   enable = true;
    #   wallpaper = ../../assets/wallpapers/aurora.jpg;
    # };
    desktop-environment.gnome.enable = false;
    desktop-environment.kde.enable = true;
    applications = {
      obs-studio.enable = true;
      xivlauncher.enable = true;
    };
  };
}
