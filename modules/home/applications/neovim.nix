{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = ''
      vim.wo.number = true
      vim.wo.relativenumber = true
    '';
  };
}