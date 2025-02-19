{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.firefox.enable =
      lib.mkEnableOption "enables firefox";
  };

  config = lib.mkIf config.home-modules.applications.firefox.enable {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs;
        [
          ff2mpv-rust
          # kdePackages.plasma-browser-integration
        ];
      # preferences = {
      #   "widget.use-xdg-desktop-portal.file-picker" = 1;
      # };
    };
    home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
      "${pkgs.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };
}
