{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "segoe-ui";
  name = "segoe-ui";

  src = pkgs.fetchzip {
    # https://aka.ms/segoeuifont
    url = "https://download.microsoft.com/download/d/f/9/df9f25d8-c6c2-47bf-9171-0b91fd3f20fc/Segoe%20UI.zip";
    sha256 = "sha256-xGx+FlOHON2+9M89BceTFEXhO/AWGQBCZfDF670lE+Y=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -m 444 ./*.ttf -Dt $out/share/fonts/truetype

    runHook postInstall
  '';
}