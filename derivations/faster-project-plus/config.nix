{
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  name = "fpp-config";
  version = "3.1.2";

  archiveName = "fppconfig.tar.gz";
  src = fetchzip {
    url = "https://github.com/jlambert360/FPM-AppImage/raw/refs/heads/master/config/${archiveName}";
    sha256 = "sha256-1+dQkNuZi2LXqmUuYJHI6RYuFUmI2wzVb4D2SYdZt1Y=";
  };

  installPhase = ''
    mkdir -p $out/Binaries
    cp -rf . $out/Binaries
  '';

}