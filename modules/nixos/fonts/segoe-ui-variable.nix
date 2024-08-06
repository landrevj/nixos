{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "segoe-ui-variable";
  name = "segoe-ui-variable";

  src = pkgs.fetchzip {
    # https://aka.ms/SegoeUIVariable
    url = "https://download.microsoft.com/download/f/5/9/f5908651-3551-4a00-b8a0-1b46b5feb723/SegoeUI-VF.zip";
    sha256 = "sha256-s82pbi3DQzcV9uP1bySzp9yKyPGkmJ9/m1Q6FRFfGxg=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -m 444 ./*.ttf -Dt $out/share/fonts/truetype

    runHook postInstall
  '';
}