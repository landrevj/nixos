let
  pkgs = import <nixpkgs> { };
  TikTokApi = (pkgs.python3Packages.buildPythonPackage rec {
    name = "TikTok-Api";
    format = "setuptools";
    src = pkgs.fetchFromGitHub {
      owner = "davidteather";
      repo = name;
      rev = "e6310be5a2de0ab03440e70ce67b3f5086c97996";
      sha256 = "sha256-Y11jGbxKnzPSoQ/v4Neor8acePjA+e3GXLLeHYJsnZI=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      pytest
      playwright
      requests
      httpx
    ];
    pythonImportsCheck = [ "TikTokApi" ];
  });
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ playwright-driver.browsers ];
  buildInputs = [ pkgs.python3 TikTokApi ];
  shellHook = ''
    # Tells pip to put packages into $PIP_PREFIX instead of the usual locations.
    # See https://pip.pypa.io/en/stable/user_guide/#environment-variables.
    export PIP_PREFIX=$(pwd)/_build/pip_packages
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"
    unset SOURCE_DATE_EPOCH

    export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
    export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
  '';
}
