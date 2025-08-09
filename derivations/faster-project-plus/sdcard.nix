{
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation {
  name = "fpp-sdcard";
  version = "3.0.2";

  src = fetchzip {
    url = "https://github.com/jlambert360/FPM-AppImage/releases/download/v3.1.2/sd.tar.gz";
    sha256 = "sha256-PDLIg946mV45/t8uvux0x2TH67QKUi5EXbZicIFRPxI=";
  };

  installPhase = ''
    mkdir -p $out
    cp sd.raw $out
  '';
}