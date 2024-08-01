{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.nautilus.enable = lib.mkEnableOption "enables nautilus";
  };

  config = lib.mkIf config.home-modules.applications.nautilus.enable {
    # home.packages = with pkgs; [ gnome.nautilus-python ];
    # xdg = {
    #   enable = true;
    #   dataFile = {
    #     "nautilus-python/extensions/nautilus-fileconverter.py".source = pkgs.fetchFromGitHub {
    #       owner = "Lich-Corals";
    #       repo = "linux-file-converter-addon";
    #       rev = "1.2.10";
    #       sha256 = "sha256-2628HEIUnQcgPATeax28ZjwR2q1GvAXZj1D4VYUs0A4=";
    #     } + "/nautilus-fileconverter.py";
    #   };
    # };
  };
}