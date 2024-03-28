{ config, pkgs, lib, username, ... }:

{
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
      EDITOR = "vim";
      BROWSER = "firefox";
      TERMINAL = "blackboxasdf";
    };

    file = {
      # ".screenrc".source = dotfiles/screenrc;
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    packages = with pkgs; [
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
      heroic
      prismlauncher
      steamtinkerlaunch
      steam-run

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
      shfmt
      shellcheck
      grc
      fzf
      fd
      bat
      starship

      # downloaders
      gallery-dl
      youtube-dl
      yt-dlp

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
      (pkgs.writeScriptBin "archive" (builtins.readFile ./scripts/archive/archive.fish))
      (pkgs.writeScriptBin "iommu" (builtins.readFile ./scripts/iommu.sh))
      (pkgs.writeScriptBin "hotplug" (builtins.readFile ./scripts/hotplug/hotplug.sh))
    ];
  };

  services.flatpak.packages = [
    "it.mijorus.smile"
    "net.nokyan.Resources"
    "dev.goats.xivlauncher"
  ];

  # secrets
  sops = {
    defaultSopsFile = ../../secrets/${username}/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets = {
      "paths/archive_dir" = {};

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
      picture-uri = "file://" + ./wallpaper.jpg;
      picture-uri-dark = "file://" + ./wallpaper.jpg;
    };
    # set keybinds
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
      command = "blackbox";
      name = "open-terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>period";
      command = "flatpak run it.mijorus.smile";
      name = "open-emoji-picker";
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
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      starship init fish | source

      # environment variables
      set -gx ARCHIVE_DIR (cat $XDG_RUNTIME_DIR/secrets/paths/archive_dir)
    '';
    plugins = [
      { name = "colored_man_pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "fzf.fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
      # { name = "transient-fish"; src = pkgs.fishPlugins.transient-fish.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
      {
        name = "transient-fish";
        src = pkgs.fetchFromGitHub {
          owner = "zzhaolei";
          repo = "transient.fish";
          rev = "be0093f1799462a93953e69896496dee4d063fd6";
          sha256 = "sha256-rEkCimnkxcydKRI2y4DxEM7FD7F2/cGTZJN2Edq/Acc=";
        };
      }
    ];
    functions = {
      e = "eza -l $argv";
      ee = "eza -la $argv";
      replug = "hotplug d $argv[1]; and hotplug a $argv[1]";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#default $argv";
      xcopy = "xclip -selection clipboard";
      xpaste = "xclip -selection clipboard -o";
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
