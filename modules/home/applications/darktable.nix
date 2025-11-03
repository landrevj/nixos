{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.darktable.enable =
      lib.mkEnableOption "enables darktable";
  };

  config = lib.mkIf config.home-modules.applications.darktable.enable {
    home.packages = with pkgs; [ darktable hugin hdrmerge ];
    xdg.configFile = {
      "darktable/lua".source = builtins.fetchGit {
        url = "https://github.com/darktable-org/lua-scripts";
        rev = "447980ddc43bdc0f93be1f06ce05b7fd98812b7b";
      };
      "darktable/luarc".text = ''
        require "contrib/HDRMerge"
        require "contrib/hugin"
      '';
    };
  };
}
