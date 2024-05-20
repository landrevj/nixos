{ pkgs, lib, config, ... }:

{
  options = {
    obs-studio.enable = lib.mkEnableOption "enables obs-studio";
  };

  config = lib.mkIf config.obs-studio.enable {
    home.packages = [ pkgs.wireplumber ];
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [
        obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
  };
}