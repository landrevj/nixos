# latest udev rule at
# https://gitlab.com/CalcProgrammer1/OpenRGB/-/jobs/artifacts/master/raw/60-openrgb.rules?job=Linux+64+AppImage
# let openrgb-rules = builtins.fetchurl {
#   url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/jobs/artifacts/master/raw/60-openrgb.rules?job=Linux+64+AppImage";
#   sha256 = "sha256:09jskjgh543fszqc1c4sxjsp3rs0nspligy62xnngsvh6q13cdaj";
# };
# in
{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.applications.openrgb.enable = lib.mkEnableOption "enables openrgb";
  };

  config = lib.mkIf config.system-modules.applications.openrgb.enable {
    boot.kernelModules = [ "i2c-dev" "i2c-i801" ];
    services.udev.packages = [
      (pkgs.writeTextFile {
        name = "60-openrgb.rules";
        destination = "/etc/udev/rules.d/60-openrgb.rules";
        text = builtins.readFile ./60-openrgb.rules;
      })
    ];  # using a local version with references to chmod removed
  };
}