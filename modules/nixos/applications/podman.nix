{ pkgs, lib, config, username, ... }:

{
  options = {
    system-modules.applications.podman.enable = lib.mkEnableOption "enables podman";
  };

  config = lib.mkIf config.system-modules.applications.podman.enable {
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

    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "podman" ];
    };
  };
}