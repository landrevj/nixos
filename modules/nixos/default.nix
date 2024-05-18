{
  imports = [
    ./locale.nix
    ./pipewire.nix
    ./fonts.nix
    ./applications
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  environment.variables = {
    NIXPKGS_ALLOW_UNFREE="1";
  };

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
  services.xserver.displayManager.gdm.enable = true; # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
  services.printing.enable = true; # Enable CUPS to print documents.
  services.flatpak.enable = true; # List services that you want to enable:
}