{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grc
    fzf
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      starship init fish | source

      # environment variables
    '';
    plugins = [
      { name = "colored_man_pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "fzf.fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
      { name = "transient-fish"; src = pkgs.fishPlugins.transient-fish.src; }
      { name = "z"; src = pkgs.fishPlugins.z.src; }
    ];
    functions = {
      e = "eza -l $argv";
      ee = "eza -la $argv";
      nix-update = "nix flake update /etc/nixos";
      nix-gc = "sudo nix-env --delete-generations 14d; and sudo nix-store --gc";
      vim = "nvim $argv";
      xcopy = "xclip -selection clipboard";
      xpaste = "xclip -selection clipboard -o";
    };
  };
}