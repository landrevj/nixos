# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  # Set kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  networking.hostName = "azeyma";
  users.users.${username} = {
    isNormalUser = true;
    description = "Joey Landreville";
    extraGroups = [
      "dialout" # needed for flashing mmu3 firmware
      "lp" # printing
      "networkmanager"
      "wheel" # sudo
    ];
  };

  # Secrets
  sops = {
    defaultSopsFile = ../../secrets/${username}/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets = {
      # "credentials/twitter/username" = {};
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3389 # remote desktop
    ];
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

  # programs.sleepy-launcher.enable = true;

  # Modules
  system-modules = {
    hardware = {
      amd.enable = true;
      vfio = {
        enable = true;
        pci-ids = [
          "10de:2206" # 3080 graphics
          "10de:1aef" # 3080 audio
          # "144d:a80c" # 990 nvme
          # "1b73:1100" # usb card
        ];
      };
    };
    # desktop-environment.cosmic.enable = true;
    applications = {
      distrobox.enable = true;
      openrgb.enable = true;
      steam.enable = true;
      waydroid.enable = true;
    };
  };
}
