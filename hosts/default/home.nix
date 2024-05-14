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
      # settings
      appeditor
      openrgb-with-all-plugins
      hyfetch

      # files
      vscode
      
      # browsing
      firefox
      chromium
      bitwarden

      # communication
      discord
      webcord
      vesktop
      signal-desktop
      element-desktop

      # media
      audacity
      darktable
      plexamp
      feh
      nsxiv
      foliate
      shotwell
      wireplumber # for obs-pipewire-audio-capture
      
      # games
      gnome.aisleriot
      heroic
      prismlauncher
      steamtinkerlaunch
      steam-run
      space-cadet-pinball
      mangohud

      # modeling
      prusa-slicer
      freecad

      # utilities
      bat
      bottles
      eza
      gcolor3
      gpu-screen-recorder
      gpu-screen-recorder-gtk
      grc
      fzf
      fd
      mullvad-vpn
      shellcheck
      shfmt
      starship
      waydroid
      playwright # make sure to `playwright install`
      unrpa

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
      (pkgs.writeScriptBin "nsxiv-rifle" (builtins.readFile ../../scripts/nsxiv-rifle.sh))
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
    desktopEntries = {
      nsxiv-rifle = {
        name = "nsxiv-rifle";
        genericName = "Image Viewer";
        exec = "nsxiv-rifle %U";
        terminal = false;
        categories = ["Graphics" "2DGraphics" "RasterGraphics" "Viewer"];
        mimeType = [
          "image/jpeg"
          "image/png"
          "image/gif"
          "image/webp"
          "image/tiff"
          "image/x-tga"
          "image/vnd-ms.dds"
          "image/x-dds"
          "image/bmp"
          "image/vnd.microsoft.icon"
          "image/vnd.radiance"
          "image/x-exr"
          "image/x-portable-bitmap"
          "image/x-portable-graymap"
          "image/x-portable-pixmap"
          "image/x-portable-anymap"
          "image/x-qoi"
          "image/svg+xml"
          "image/svg+xml-compressed"
          "image/avif"
          "image/heic"
          "image/jxl"
        ];
      };
    };
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

  # XResources
  xresources.extraConfig = ''
    Nsxiv.window.background: #1e1e1e
    Nsxiv.window.foreground: #bfbfbf
  '';

  # Programs
  programs = {
    foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "MesloLGLDZ Nerd Font Mono:size=11";
          initial-window-size-chars = "120x27";
        };
        colors = {
          background = "1e1e1e";
          regular0 = "444444";
          regular1 = "FF0054";
          regular2 = "B1D630";
          regular3 = "9D895E";
          regular4 = "67BEE3";
          regular5 = "B576BC";
          regular6 = "569A9F";
          regular7 = "EDEDED";
          bright0  = "777777";
          bright1  = "D65E75";
          bright2  = "BAFFAA";
          bright3  = "ECE1C8";
          bright4  = "9FD3E5";
          bright5  = "DEB3DF";
          bright6  = "B6E0E5";
          bright7  = "FFFFFF";
        };
        csd = {
          color = "303030";
          button-color = "ffffff";
          button-minimize-color = "444444";
          button-maximize-color = "444444";
        };
        cursor = {
          blink = true;
        };
        tweak = {
          overflowing-glyphs=true;
        };
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        starship init fish | source

        # environment variables
        set -gx ARCHIVE_DIR (cat ${config.sops.secrets."paths/archive_dir".path})
        set -gx TIKTOK_MS_TOKEN (cat ${config.sops.secrets."credentials/tiktok/ms_token".path})
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
        nix-rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#default $argv";
        # nix-update = "sudo nix flake update --flake /etc/nixos#default $argv";
        nix-update = "nix flake update /etc/nixos";
        nix-gc = "sudo nix-env --delete-generations 14d; and sudo nix-store --gc"; # sudo nix-collect-garbage --delete-older-than 14d
        vim = "nvim $argv";
        xcopy = "xclip -selection clipboard";
        xpaste = "xclip -selection clipboard -o";
        # foot events
        mark_prompt_start = {
          body = ''echo -en "\e]133;A\e\\"'';
          onEvent = "fish_prompt";
        };
        foot_cmd_start = {
          body = ''echo -en "\e]133;C\e\\"'';
          onEvent = "fish_preexec";
        };
        foot_cmd_end = {
          body = ''echo -en "\e]133;D\e\\'';
          onEvent = "fish_postexec";
        };
      };
    };

    git = {
      enable = true;
      userName = "Joseph Landreville";
      userEmail = "landrevillejoseph@gmail.com";
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      extraLuaConfig = ''
        vim.wo.number = true
        vim.wo.relativenumber = true
      '';
    };

    mpv = {
      enable = true;
      scripts = with pkgs; [ mpvScripts.autoload ];
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

    obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
  };
}
