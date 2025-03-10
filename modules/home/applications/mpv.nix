{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.mpv.enable = lib.mkEnableOption "enables mpv";
  };

  config = lib.mkIf config.home-modules.applications.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = [ pkgs.mpvScripts.autoload ];
      scriptOpts = {
        osc = { windowcontrols = false; };
        autoload = {
          images = false;
          additional_video_exts = "gif,apng";
        };
      };
      config = {
        border = "no";
        osd-fractions = true;
        loop-file = true;
      };
    };
  };
}
