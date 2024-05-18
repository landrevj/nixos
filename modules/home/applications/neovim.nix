{ pkgs, lib, config, ... }:

{
  options = {
    neovim.enable = lib.mkEnableOption "enables neovim";
  };

  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraLuaConfig = ''
        vim.wo.number = true
        vim.wo.relativenumber = true
      '';
    };
  };
}