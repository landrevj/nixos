# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, username, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/nixos/locale.nix
  ];

  # Secrets
  sops = {
    defaultSopsFile = ../../secrets/T470/secrets.yaml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets = {
      "hello" = {};
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Mounts (try to autogen these into hardware-configuration.nix)

  # Enable networking
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  networking.hostName = "nixos"; # Define your hostname.
  users.users.${username} = {
    isNormalUser = true;
    description = "Joey Landreville";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Services
  services.xserver.enable = true; # Enable the X11 windowing system.
  services.xserver.displayManager.gdm.enable = true; # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = { # Configure keymap in X11
    layout = "us";
    variant = "";
  };
  # services.xserver.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
  services.mullvad-vpn.enable = true;

  # Environment variables
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE="1";
  };

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

  # Make fonts available to programs
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })
    # google-fonts
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     gnome.gnome-software
     dconf-editor
     gnome-tweaks
     gnome-themes-extra
     wget
     python3
     ffmpeg
     htop
     killall
     libGL
     gamescope
     gamemode
     jdk17
     xclip
     man-pages
     tuptime
     pciutils
     usbutils
     cdrtools
     dmidecode
     hwloc
     smartmontools
     wineWowPackages.stable
     sops
     age
     jq
     p7zip
     file
     ntfs2btrfs
     gparted
     vulkan-tools
     findutils
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
  }; 
}
