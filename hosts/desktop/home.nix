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
    stateVersion = "23.11"; # Please read the comment before changing.

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
      openrgb-with-all-plugins
      prusa-slicer
      freecad
      gpu-screen-recorder
      gpu-screen-recorder-gtk
      playwright # make sure to `playwright install`
      unrpa
      gallery-dl
      mkvtoolnix
      pinta
      puddletag
      protonup-qt

      # scripts
      (pkgs.writeScriptBin "archive" (builtins.readFile ./scripts/archive/archive.fish))
      (pkgs.writeScriptBin "iommu" (builtins.readFile ./scripts/iommu.sh))
      (pkgs.writeScriptBin "hotplug" (builtins.readFile ./scripts/hotplug/hotplug.sh))
      (pkgs.writers.writePython3Bin "__get_tiktok_user_video_urls" {
        libraries = [
          (pkgs.python3Packages.buildPythonPackage rec {
            name = "TikTok-Api";
            format = "setuptools";
            src = fetchFromGitHub {
              owner = "davidteather";
              repo = name;
              rev = "7386b2b5f723fb1d376ef6e3ceca5aa30fc733a7";
              sha256 = "sha256-Rox/om8hgwUAptGgeI7oKWdvw9YCFiNypmmjfCKf3aM=";
            };

            propagatedBuildInputs = with pkgs.python3Packages; [ pytest playwright requests ];
            pythonImportsCheck = [ "TikTokApi" ];
          })
        ];
        flakeIgnore = [ "E" "W" ];
      } (builtins.readFile ./scripts/archive/tiktok/tiktok.py))
    ];
  };

  # secrets
  sops = {
    defaultSopsFile = ../../secrets/${username}/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets = {
      "paths/archive_dir" = {};
      "credentials/tiktok/ms_token" = {};

      # secret config files
      gallery-dl = {
        sopsFile = ../../secrets/${username}/gallery-dl.yaml;
        path = "${config.home.homeDirectory}/.config/gallery-dl/config.json";
      };
    };
  };

  # sops-nix requirements
  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];
  home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    /run/current-system/sw/bin/systemctl start --user sops-nix
  '';

  # Config files
  xdg = {
    enable = true;
    # script completions
    configFile."fish/completions/archive.fish".source = ./scripts/archive/completions.fish;
  };

  # Gnome
  dconf.settings = with lib.hm.gvariant; {
    # set wallpaper
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ../../assets/wallpapers/clouds.jpg;
      picture-uri-dark = "file://" + ../../assets/wallpapers/clouds.jpg;
    };
    # set keybinds
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
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
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        starship init fish | source

        # environment variables
        set -gx ARCHIVE_DIR (cat ${config.sops.secrets."paths/archive_dir".path})
        set -gx TIKTOK_MS_TOKEN (cat ${config.sops.secrets."credentials/tiktok/ms_token".path})
      '';
      functions = {
        nix-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#desktop $argv";
        # nix-update = "sudo nix flake update --flake /etc/nixos#desktop $argv";
        replug = "hotplug d $argv[1]; and hotplug a $argv[1]";
      };
    };
  };

  # Modules
  home-modules = {
    applications = {
      darktable.enable = true;
      davinci-resolve.enable = true;
      obs-studio.enable = true;
      xivlauncher.enable = true;
    };
  };
}
