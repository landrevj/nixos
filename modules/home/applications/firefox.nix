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
        search.engines = {
          ffxiv-consolegameswiki = {
            name = "FFXIV Wiki (consolegameswiki.com)";
            definedAliases = [ "@ffxivcgw" ];
            urls = [{
              template =
                "https://ffxiv.consolegameswiki.com/mediawiki/index.php?search={searchTerms}";
            }];
          };
          ffxiv-gamerescape = {
            name = "FFXIV Wiki (gamerescape.com)";
            definedAliases = [ "@ffxivge" ];
            urls = [{
              template = "https://ffxiv.gamerescape.com/?search={searchTerms}";
            }];
          };
          home-manager-options = {
            name = "Home Manager Options";
            definedAliases = [ "@homemanager" ];
            urls = [{
              template =
                "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
            }];
          };
          nix-options = {
            name = "Nix Options";
            definedAliases = [ "@nixoptions" ];
            urls = [{
              template =
                "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
            }];
          };
          nix-packages = {
            name = "Nix Packages";
            definedAliases = [ "@nixpackages" ];
            urls = [{
              template =
                "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
            }];
          };
          nixpkgs-issues = {
            name = "Nixpkgs Issues";
            definedAliases = [ "@nixpkgsissues" ];
            urls = [{
              template =
                "https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue%20state%3Aopen%20{searchTerms}";
            }];
          };
          nixpkgs-prs = {
            name = "Nixpkgs PRs";
            definedAliases = [ "@nixpkgsprs" ];
            urls = [{
              template =
                "https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+{searchTerms}";
            }];
          };
          "amazondotcom-us".metaData.hidden = true;
          bing.metaData.hidden = true;
          ebay.metaData.hidden = true;
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
