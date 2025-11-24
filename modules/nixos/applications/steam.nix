{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.applications.steam.enable =
      lib.mkEnableOption "enables steam";
  };

  config = lib.mkIf config.system-modules.applications.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [ "--hdr-enabled --hdr-itm-enable --expose-wayland" ];
      };
    };

    environment.sessionVariables = {
      WAYLANDDRV_PRIMARY_MONITOR = "DP-1";
      PROTON_ENABLE_WAYLAND = 1;
      PROTON_ENABLE_HDR = 1;
    };

    programs.gamescope = {
      # package = pkgs.gamescope_git;
      enable = true;
      capSysNice = true;
    };

    environment.systemPackages = with pkgs; [ gamemode ];
  };
}
