{ pkgs, lib, config, ... }:

{
  options = {
    mpv.enable = lib.mkEnableOption "enables mpv";
  };

  config = lib.mkIf config.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.autoload];
      scriptOpts = {
        osc = {
          windowcontrols = false;
        };
        autoload = {
          images = false;
          additional_video_exts = "gif,apng";
        };
      };
      config = {
        no-border = true;
        osd-fractions = true;
        loop-file = true;
      };
    };
  };
}