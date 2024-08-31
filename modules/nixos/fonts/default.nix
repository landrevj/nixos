{ pkgs, ... }:

let
  segoe-ui = pkgs.callPackage ./segoe-ui.nix { inherit pkgs; };
  segoe-ui-variable = pkgs.callPackage ./segoe-ui-variable.nix { inherit pkgs; };
in 
{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Meslo" ]; })

    # google
    (google-fonts.override { fonts = [ "Roboto" "Open Sans" ]; })
    (noto-fonts.override { variants = [ "Noto Sans" ]; })
    noto-fonts-cjk-sans
    
    # microsoft
    corefonts
    vistafonts
    segoe-ui
    segoe-ui-variable
  ];
}