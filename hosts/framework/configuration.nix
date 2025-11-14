{ config, pkgs, inputs, lib, username, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./disko-config.nix ../../modules/nixos ];

  nixpkgs.config.permittedInsecurePackages = [ "libsoup-2.74.3" ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # Set kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # firmware
  services.fwupd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  networking.hostName = "nophica";
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
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # quietboot
  console = {
    useXkbConfig = true;
    earlySetup = true;
  };
  boot = {
    initrd = {
      systemd.enable = true; # start earlier so plymouth asks for luks password
      verbose = false;
    };
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    loader.timeout = 0;
    consoleLogLevel = 0;
    kernelParams = [
      "plymouth.use-simpledrm"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  # configure sleep
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20min
  '';

  # Secrets
  sops = {
    defaultSopsFile = ../../secrets/framework/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets = {
      "samba" = { };
      "tailscale/key" = { };
    };
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
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
      tailscale.enable = true;
    };
  };

  # fixes
  services.pipewire.wireplumber.extraConfig.no-ucm = {
    # https://github.com/NixOS/nixos-hardware/issues/1603
    "monitor.alsa.properties" = { "alsa.use-ucm" = false; };
  };
}
