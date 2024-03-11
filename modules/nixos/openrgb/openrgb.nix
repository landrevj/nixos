# latest udev rule at
# https://gitlab.com/CalcProgrammer1/OpenRGB/-/jobs/artifacts/master/raw/60-openrgb.rules?job=Linux+64+AppImage
# let openrgb-rules = builtins.fetchurl {
#   url = "https://gitlab.com/CalcProgrammer1/OpenRGB/-/jobs/artifacts/master/raw/60-openrgb.rules?job=Linux+64+AppImage";
#   sha256 = "sha256:09jskjgh543fszqc1c4sxjsp3rs0nspligy62xnngsvh6q13cdaj";
# };
# in
{
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  services.udev.extraRules =  builtins.readFile ./60-openrgb.rules;
}