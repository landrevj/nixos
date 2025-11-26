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
          "ff2mpv@yossarian.net" = "ff2mpv";
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
          "browser.download.useDownloadDir" = false;
          "browser.formfill.enable" = false;
          "browser.tabs.warnOnClose" = false;
          "browser.toolbars.bookmarks.visibility" = "always";
          "dom.battery.enabled" = false;
          "dom.forms.autocomplete.formautofill" = false;
          "general.autoScroll" = true;
          "gfx.webrender.all" = true;
          "network.cookie.cookieBehavior" = 5;
          "network.http.http3.enabled" = true;
          "network.socket.ip_addr_any.disabled" = true;
          "privacy.firstparty.isolate" = true;
          "privacy.resistFingerprinting" = true;

          # ai shit
          "browser.ml.enable" = false;
          "browser.tabs.groups.smart" = false;
          "browser.tabs.groups.smart.optin" = false;
          "extensions.ml.enabled" = false;
        };
      };
      profiles."landrevj.default" = {
        settings = {
          "zen.view.show-newtab-button-top" = false;
          "zen.welcome-screen.seen" = true;
        };
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
              definedAliases = [ "@maps" ];
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
            scryfall = {
              name = "Scryfall";
              definedAliases = [ "@scryfall" ];
              urls =
                [{ template = "https://scryfall.com/search?q={searchTerms}"; }];
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
        containersForce = true;
        containers = {
          Personal = {
            color = "blue";
            icon = "circle";
            id = 1;
          };
          Work = {
            color = "green";
            icon = "briefcase";
            id = 2;
          };
          Private = {
            color = "purple";
            icon = "fingerprint";
            id = 3;
          };
        };
        spacesForce = true;
        spaces = let
          containers =
            config.programs.zen-browser.profiles."landrevj.default".containers;
        in {
          Personal = {
            id = "7802c3a3-b986-47dc-b349-2b67b57047ef";
            position = 1000;
            theme = {
              type = "gradient";
              opacity = 0.5;
              texture = 0.3;
              colors = [
                {
                  red = 101;
                  green = 107;
                  blue = 205;
                  custom = false;
                  algorithm = "analogous";
                  primary = true;
                  lightness = 60;
                  position = {
                    x = 131;
                    y = 106;
                  };
                  type = "explicit-lightness";
                }
                {
                  red = 169;
                  green = 97;
                  blue = 209;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position = {
                    x = 193;
                    y = 99;
                  };
                  type = "explicit-lightness";
                }
                {
                  red = 100;
                  green = 179;
                  blue = 206;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position = {
                    x = 96;
                    y = 157;
                  };
                  type = "explicit-lightness";
                }
              ];
            };
          };
          Work = {
            id = "e2bf02ac-6716-409a-9118-0da58e680a67";
            container = containers."Work".id;
            position = 2000;
            theme = {
              type = "gradient";
              opacity = 0.5;
              texture = 0.3;
              colors = [
                {
                  red = 115;
                  green = 191;
                  blue = 149;
                  custom = false;
                  algorithm = "analogous";
                  primary = true;
                  lightness = 60;
                  position = {
                    x = 84;
                    y = 244;
                  };
                  type = "explicit-lightness";
                }
                {
                  red = 121;
                  green = 171;
                  blue = 185;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position = {
                    x = 57;
                    y = 152;
                  };
                  type = "explicit-lightness";
                }
                {
                  red = 145;
                  green = 199;
                  blue = 107;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position = {
                    x = 171;
                    y = 282;
                  };
                  type = "explicit-lightness";
                }
              ];
            };
          };
          Private = {
            id = "8c91d5a8-1983-4dac-b94a-809137daf41e";
            container = containers."Private".id;
            position = 3000;
            theme = {
              type = "gradient";
              opacity = 0.5;
              texture = 0.3;
              colors = [
                {
                  red = 160;
                  green = 106;
                  blue = 200;
                  custom = false;
                  algorithm = "analogous";
                  primary = true;
                  lightness = 60;
                  position = {
                    x = 189;
                    y = 82;
                  };
                  type = "explicit-lightness";
                }
                {
                  red = 207;
                  green = 99;
                  blue = 167;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position = {
                    x = 249;
                    y = 128;
                  };
                  type = "explicit-lightness";
                }
                {
                  red = 110;
                  green = 122;
                  blue = 196;
                  custom = false;
                  algorithm = "analogous";
                  primary = false;
                  lightness = 60;
                  position = {
                    x = 115;
                    y = 97;
                  };
                  type = "explicit-lightness";
                }
              ];
            };
          };
        };
      };
    };
  };
}
