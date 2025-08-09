{
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation {
  name = "fpp-launcher";
  version = "3.1.2";

  src = fetchzip {
    url = "https://github.com/jlambert360/FPM-AppImage/releases/download/v3.1.2/Launcher.tar.gz";
    sha256 = "sha256-Q3F4V/ggePaZRsGFM54hkGBkLb52PaIn2lQ31gYANW0=";
  };

  installPhase = ''
    mkdir -p $out/Launcher
    cp -rf . $out/Launcher
  '';
}