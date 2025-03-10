{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.nsxiv.enable = lib.mkEnableOption "enables nsxiv";
  };

  config = lib.mkIf config.home-modules.applications.nsxiv.enable {
    home.packages = [
      pkgs.nsxiv
      (pkgs.writeScriptBin "nsxiv-rifle"
        (builtins.readFile ../../../scripts/nsxiv-rifle.sh))
    ];
    xdg = {
      enable = true;
      desktopEntries.nsxiv-rifle = {
        name = "nsxiv-rifle";
        genericName = "Image Viewer";
        exec = "nsxiv-rifle %U";
        terminal = false;
        categories = [ "Graphics" "2DGraphics" "RasterGraphics" "Viewer" ];
        mimeType = [
          "image/jpeg"
          "image/png"
          "image/gif"
          "image/webp"
          "image/tiff"
          "image/x-tga"
          "image/vnd-ms.dds"
          "image/x-dds"
          "image/bmp"
          "image/vnd.microsoft.icon"
          "image/vnd.radiance"
          "image/x-exr"
          "image/x-portable-bitmap"
          "image/x-portable-graymap"
          "image/x-portable-pixmap"
          "image/x-portable-anymap"
          "image/x-qoi"
          "image/svg+xml"
          "image/svg+xml-compressed"
          "image/avif"
          "image/heic"
          "image/jxl"
        ];
      };
    };
    xresources.extraConfig = ''
      Nsxiv.window.background: #1e1e1e
      Nsxiv.window.foreground: #bfbfbf
    '';
  };
}
