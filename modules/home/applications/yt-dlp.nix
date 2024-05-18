{ pkgs, lib, config, ... }:

{
  options = {
    yt-dlp.enable = lib.mkEnableOption "enables yt-dlp";
  };

  config = lib.mkIf config.yt-dlp.enable {
    programs.yt-dlp = {
      enable = true;
      settings = {
        downloader = "ffmepg";
      };
    };
  };
}