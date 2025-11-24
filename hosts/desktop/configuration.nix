{ config, pkgs, inputs, lib, username, ... }:

{
  imports = [ ./hardware-configuration.nix ./disko-config.nix ../../modules/nixos ];

  nixpkgs.config.permittedInsecurePackages = [ "libsoup-2.74.3" ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # Set kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_cachyos-rc;
  # boot.kernelPackages = pkgs.linuxPackages_cachyos;

  environment.sessionVariables = {
    KWIN_DRM_NO_DIRECT_SCANOUT =
      1; # https://gitlab.freedesktop.org/drm/amd/-/issues/2075
  };

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
  time.hardwareClockInLocalTime =
    true; # local time so it doesn't fight with windows dual boot
  
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
  
  # secureboot
  # boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };

  # Secrets
  sops = {
    defaultSopsFile = ../../secrets/landrevj/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets = { samba = { }; };
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

  #environment.systemPackages = [ ];
  # chaotic.mesa-git.enable = true;

  # Modules
  system-modules = {
    hardware = {
      amd.enable = true;
      vfio = {
        enable = true;
        pci-ids = [
          "1002:73bf" # 6800 graphics
          "1002:ab28" # 6800 audio
          # "144d:a80c" # 990 nvme
          # "1b73:1100" # usb card
        ];
      };
    };
    # desktop-environment.cosmic.enable = true;
    desktop-environment.gnome.enable = false;
    desktop-environment.kde.enable = true;
    applications = {
      distrobox.enable = true;
      openrgb.enable = true;
      steam.enable = true;
      waydroid.enable = true;
    };
  };
}
