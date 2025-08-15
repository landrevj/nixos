{ config, pkgs, inputs, lib, username, ... }:

{
  imports = [ ./hardware-configuration.nix ./disko-config.nix ../../modules/nixos ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # Set kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_cachyos-rc;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  networking.hostName = "azeyma";
  users.users.${username} = {
    isNormalUser = true;
    description = "Joey Landreville";
    extraGroups = [
      "lp" # printing
      "networkmanager"
      "wheel" # sudo
    ];
  };

  # secureboot
#   boot.loader.systemd-boot.enable = lib.mkForce false;
#   boot.lanzaboote = {
#     enable = true;
#     pkiBundle = "/var/lib/sbctl";
#   };

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

  #environment.systemPackages = [ ];

  # Modules
  system-modules = {
    # desktop-environment.cosmic.enable = true;
    desktop-environment.gnome.enable = false;
    desktop-environment.kde.enable = true;
    applications = {
      steam.enable = true;
    };
  };
}
