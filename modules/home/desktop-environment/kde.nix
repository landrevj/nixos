{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.desktop-environment.kde.enable =
      lib.mkEnableOption "configures kde";
  };

  config = lib.mkIf config.home-modules.desktop-environment.kde.enable {
    gtk = {
      enable = true;
      theme = {
        # name = "Material-You-dark";
        # package = pkgs.libsForQt5.breeze-gtk;
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
    };
    home.packages = with pkgs; [
      python313Packages.kde-material-you-colors
      plasma-panel-colorizer

      kdePackages.kcalc
      kdePackages.kcolorchooser
      # kdePackages.sierra-breeze-enhanced
    ];
  };
}
