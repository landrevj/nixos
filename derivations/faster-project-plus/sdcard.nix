{
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation {
  name = "fpp-sdcard";
  version = "3.0.2";

  src = fetchzip {
    url = "https://github.com/jlambert360/FPM-AppImage/releases/download/v3.0.2/sd.tar.gz";
    sha256 = "sha256-Eff4LW6WKBcSlnZYk3sVGebx72ZRPduO6ZVqCCXRsJQ=";
  };

  installPhase = ''
    mkdir -p $out
    cp sd.raw $out
  '';
}