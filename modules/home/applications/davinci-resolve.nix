{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.davinci-resolve.enable = lib.mkEnableOption "enables davinci-resolve";
  };

  config = lib.mkIf config.home-modules.applications.davinci-resolve.enable {
    home.packages = with pkgs; [
      davinci-resolve
    ];
    xdg = {
      enable = true;
      desktopEntries.davinci-resolve = {
        name = "DaVinci Resolve";
        genericName = "Video Editor";
        exec = "davinci-resolve %U";
        icon = "DV_Resolve";
        terminal = false;
        categories = [ "AudioVideo" "AudioVideoEditing" "Video" "Graphics" ];
        mimeType = [ "application/x-resolveproj" ];
      };
    };
  };
}