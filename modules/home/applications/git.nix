{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.git.enable = lib.mkEnableOption "enables git";
  };

  config = lib.mkIf config.home-modules.applications.git.enable {
    programs.git = {
      enable = true;
      userName = "Joseph Landreville";
      userEmail = "landrevillejoseph@gmail.com";
    };
  };
}