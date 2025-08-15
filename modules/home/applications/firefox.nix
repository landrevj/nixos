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
      profiles."landrevj.default" = {
        settings = {
          "browser.toolbars.bookmarks.visibility" = "never";
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "hide-sidebar";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = ''
          #sidebar-main,
          #sidebar-panel-header {
            display: none;
          }

          #sidebar-box {
            padding: 0 !important;
          }
        '';
      };
    };
  };
}
