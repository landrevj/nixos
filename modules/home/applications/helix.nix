{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.helix.enable = lib.mkEnableOption "enables helix";
  };

  config = lib.mkIf config.home-modules.applications.helix.enable {
    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "dark_plus";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          bufferline = "always";
          indent-guides = {
            render = true;
            character = "▏";
          };
        };
      };
      languages = {
        language-server.typescript-language-server = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
      };
    };
    xdg = {
      configFile = {
        "helix/themes/dark_plus.toml".source = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/helix-editor/helix/master/runtime/themes/dark_plus.toml";
          sha256 = "sha256:0xzgrbb2c5r92d7a13kbzqa0aa9k79m9v77csmhv0sda628x4fbq";
        };
      };
    };
  };
}
