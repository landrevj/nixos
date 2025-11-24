{ pkgs, ... }: {
  imports = [
    ./applications
    ./desktop-environment
    ./hardware
    ./fonts

    ./locale.nix
    ./mounts.nix
    ./pipewire.nix
    ./quietboot.nix
  ];

  system-modules.quietboot.enable = lib.mkDefault true;

  nixpkgs.overlays = [
    (final: prev: {
      # faster-project-plus
      faster-project-plus =
        final.qt6Packages.callPackage ../../derivations/faster-project-plus { };
      fpp-config =
        final.callPackage ../../derivations/faster-project-plus/config.nix { };
      fpp-launcher =
        final.callPackage ../../derivations/faster-project-plus/launcher.nix
        { };
      fpp-sdcard =
        final.callPackage ../../derivations/faster-project-plus/sdcard.nix { };
    })
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  environment.variables = { NIXPKGS_ALLOW_UNFREE = "1"; };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable networking
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Services
  services.xserver.enable = true; # Enable the X11 windowing system.
  # services.xserver.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.flatpak.enable = true;
}
