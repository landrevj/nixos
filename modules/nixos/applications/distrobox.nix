{ pkgs, lib, config, username, ... }:

{
  options = {
    system-modules.applications.distrobox.enable = lib.mkEnableOption "enables distrobox";
  };

  config = lib.mkIf config.system-modules.applications.distrobox.enable {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = [ pkgs.distrobox ];

    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "podman" ];
    };
  };
}
