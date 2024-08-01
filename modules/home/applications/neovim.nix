{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.home-modules.applications.neovim.enable {
    programs.neovim = {
      enable = true;
      # defaultEditor = true;
      vimAlias = true;
      extraLuaConfig = ''
        vim.wo.number = true
        vim.wo.relativenumber = true
      '';
    };
  };
}