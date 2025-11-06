{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.zen-browser.enable =
      lib.mkEnableOption "enables zen-browser";
  };

  config = lib.mkIf config.home-modules.applications.zen-browser.enable {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        ff2mpv-rust
        kdePackages.plasma-browser-integration
      ];
      policies = let
        mkLockedAttrs = builtins.mapAttrs (_: value: {
          Value = value;
          Status = "locked";
        });

        mkPluginUrl = id:
          "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";

        mkExtensionEntry = { id, pinned ? false, }:
          let
            base = {
              install_url = mkPluginUrl id;
              installation_mode = "force_installed";
            };
          in if pinned then base // { default_area = "navbar"; } else base;

        mkExtensionSettings = builtins.mapAttrs (_: entry:
          if builtins.isAttrs entry then
            entry
          else
            mkExtensionEntry { id = entry; });
      in {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings = mkExtensionSettings {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = mkExtensionEntry {
            id = "bitwarden-password-manager";
            pinned = true;
          };
          "uBlock0@raymondhill.net" = mkExtensionEntry {
            id = "ublock-origin";
            pinned = true;
          };
          "firefox@betterttv.net" = "betterttv";
          "{c3c10168-4186-445c-9c5b-63f12b8e2c87}" = "cookieeditor";
          "{868ea040-cb84-4afd-9ee5-b37e822430ff}" = "copy-tab-urls-webex";
          "{e90f5de4-8510-4515-9f67-3b6654e1e8c2}" = "dictionary-anyvhere";
          "{506e023c-7f2b-40a3-8066-bc5deb40aebe}" = "gesturefy";
          "{7e79d10d-9667-4d38-838d-471281c568c3}" = "history-autodelete";
          "{4a313247-8330-4a81-948e-b79936516f78}" = "image-search-options";
          "jordanlinkwarden@gmail.com" = "linkwarden";
          "multiple-paste-and-go-button@wantora.github.io" =
            "multiple-paste-and-go-button";
          "{6706d386-2d33-4e1e-bbf1-51b9e1ce47e1}" = "pixiv-toolkit";
          "plasma-browser-integration@kde.org" = "plasma-integration";
          "@react-devtools" = "react-devtools";
          "extension@redux.devtools" = "reduxdevtools";
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "jid0-bnmfwWw2w2w4e4edvcdDbnMhdVg@jetpack" = "tab-reloader";
          "izer@camelcamelcamel.com" = "the-camelizer-price-history-ch";
          "{08f0f80f-2b26-4809-9267-287a5bdda2da}" = "tubearchivist-companion";
          "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" =
            "user-agent-string-switcher";
        };
        Preferences = mkLockedAttrs {
          "browser.aboutConfig.showWarning" = false;
          "browser.tabs.warnOnClose" = false;
          "privacy.resistFingerprinting" = true;
          "privacy.firstparty.isolate" = true;
          "network.cookie.cookieBehavior" = 5;
          "dom.battery.enabled" = false;
          "gfx.webrender.all" = true;
          "network.http.http3.enabled" = true;
          "network.socket.ip_addr_any.disabled" = true;
        };
      };
      profiles."landrevj.default" = {
        search = {
          force = true;
          engines = {
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
                template =
                  "https://ffxiv.gamerescape.com/?search={searchTerms}";
              }];
            };
            google-maps = {
              name = "Google Maps";
              definedAliases = [ "@googlemaps" ];
              urls = [{
                template = "https://google.com/maps/search/{searchTerms}";
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
            nixpkgs-pr-tracker = {
              name = "Nixpkgs PR Tracker";
              definedAliases = [ "@nixpkgsprtracker" ];
              urls = [{
                template = "https://nixpk.gs/pr-tracker.html?pr={searchTerms}";
              }];
            };
            proton-db = {
              name = "ProtonDB";
              definedAliases = [ "@protondb" ];
              urls = [{
                template = "https://www.protondb.com/search?q={searchTerms}";
              }];
            };
            wanikani = {
              name = "WaniKani";
              definedAliases = [ "@wanikani" ];
              urls = [{
                template =
                  "https://www.wanikani.com/search?query={searchTerms}";
              }];
            };
            "amazondotcom-us".metaData.hidden = true;
            bing.metaData.hidden = true;
            ebay.metaData.hidden = true;
          };
        };
      };
    };
  };
}
