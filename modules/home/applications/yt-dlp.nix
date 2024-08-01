{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.yt-dlp.enable = lib.mkEnableOption "enables yt-dlp";
  };

  config = lib.mkIf config.home-modules.applications.yt-dlp.enable {
    programs.yt-dlp = {
      enable = true;
      settings = {
        downloader = "ffmpeg";
      };
    };
  };
}