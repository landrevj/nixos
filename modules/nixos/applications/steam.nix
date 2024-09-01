{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.applications.steam.enable = lib.mkEnableOption "enables steam";
  };

  config = lib.mkIf config.system-modules.applications.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [ "-f -m 1 -e" ];
      };
    };

    environment.systemPackages = with pkgs; [
      gamescope
      gamemode
    ];
  };
}