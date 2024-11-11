# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, username, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Set kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  networking.hostName = "halone";
  users.users.${username} = {
    isNormalUser = true;
    description = "Joey Landreville";
    extraGroups = [
      "networkmanager"
      "wheel" # sudo
    ];
  };

  # Secrets
  # sops = {
  #   defaultSopsFile = ../../secrets/livingroom/secrets.yaml;
  #   age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

  #   secrets = {
  #     "hello" = {};
  #   };
  # };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [];
    # allowedUDPPorts = [ ... ];
  };

  # Services
  services.mullvad-vpn.enable = true; # enable mullvad service

  # Use fish shell
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # steam machine
  jovian = {
    hardware.has.amd.gpu = true;
    steamos.useSteamOSConfig = true;
    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "gnome";
      user = username;
      updater.splash = "vendor";
    };
    decky-loader = {
      enable = true;
      user = username;
      package = pkgs.decky-loader-prerelease;
    };
  };
  boot.kernelParams = [ "fbcon=rotate:0" ]; # stop jovian from rotating the tty
  environment.sessionVariables.XDG_DESKTOP_PORTAL_DIR = "/run/current-system/sw/share/xdg-desktop-portal/portals"; # recover xdg-desktop-portals from gamescope-session (?)
  xdg.portal.enable = true;


  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "51-gcadapter.rules";
      destination = "/etc/udev/rules.d/51-gcadapter.rules";
      text = ''
        #GameCube Controller Adapter
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"

        #Wiimotes or DolphinBar
        SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", TAG+="uaccess"
        SUBSYSTEM=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0330", TAG+="uaccess"
      '';
    })
  ];

  nixpkgs.overlays = [
    (final: prev: {
      faster-project-plus = final.qt6Packages.callPackage ../../derivations/faster-project-plus {};
      fpp-config = final.callPackage ../../derivations/faster-project-plus/config.nix {};
      fpp-launcher = final.callPackage ../../derivations/faster-project-plus/launcher.nix {};
      fpp-sdcard = final.callPackage ../../derivations/faster-project-plus/sdcard.nix {};
    })
  ];

  # Modules
  system-modules = {
    hardware.amd.enable = true;
    desktop-environment.gnome = {
      enable = true;
      displayManager.enable = false;
    };
    applications = {
      podman.enable = true;
    };
  };
}
