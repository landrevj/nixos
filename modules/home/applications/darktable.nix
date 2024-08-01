{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.darktable.enable = lib.mkEnableOption "enables darktable";
  };

  config = lib.mkIf config.home-modules.applications.darktable.enable {
    home.packages = with pkgs; [ darktable hugin hdrmerge ];
    xdg.configFile = {
      "darktable/lua".source = builtins.fetchGit {
        url = "https://github.com/darktable-org/lua-scripts";
        rev = "5b55a3116dcce07cf20c54e86f94892e375953c1";
      };
      "darktable/luarc".text = ''
        require "contrib/HDRMerge"
        require "contrib/hugin"
      '';
    };
  };
}