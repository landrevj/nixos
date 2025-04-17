{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.obs-studio.enable =
      lib.mkEnableOption "enables obs-studio";
  };

  config = lib.mkIf config.home-modules.applications.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs; [ obs-studio-plugins.obs-pipewire-audio-capture ];
    };
  };
}
