{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.desktop-environment.cosmic.enable = lib.mkEnableOption "enables cosmic";
  };

  config = lib.mkIf config.system-modules.desktop-environment.cosmic.enable {
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };

    services.desktopManager.cosmic.enable = true;
    # services.displayManager.cosmic-greeter.enable = true;
  };
}