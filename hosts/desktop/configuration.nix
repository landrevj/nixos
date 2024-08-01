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
  networking.hostName = "nixos";
  users.users.${username} = {
    isNormalUser = true;
    description = "Joey Landreville";
    extraGroups = [
      "networkmanager"
      "wheel" # give user sudo
      "dialout" # needed for flashing mmu3 firmware
      "lp"
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
    allowedTCPPorts = [ 3389 ];
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

  programs.sleepy-launcher.enable = true;

  # Modules
  system-modules = {
    hardware = {
      amd.enable = true;
      vfio.enable = true;
    };
    applications = {
      openrgb.enable = true;
      waydroid.enable = true;
    };
  };
}
