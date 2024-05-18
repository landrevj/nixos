{ pkgs, ... }:

{
  # Make fonts available to programs
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })
  ];
}