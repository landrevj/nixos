{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.firefox.enable =
      lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.home-modules.applications.firefox.enable {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        ff2mpv-rust
        kdePackages.plasma-browser-integration
      ];
    };
  };
}
