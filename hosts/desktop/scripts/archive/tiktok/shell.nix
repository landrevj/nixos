let
  pkgs = import <nixpkgs> { };
  TikTokApi = (pkgs.python3Packages.buildPythonPackage rec {
    name = "TikTok-Api";
    format = "setuptools";
    src = pkgs.fetchFromGitHub {
      owner = "davidteather";
      repo = name;
      rev = "a4079f0a7ccac4f2a7482272f028849b45387a7d";
      sha256 = "sha256-aeY82HypYy+0H2kj7K5ihm4CVFKjYHgNszaZjDjEV4E=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [ pytest playwright requests httpx ];
    pythonImportsCheck = [ "TikTokApi" ];
  });
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    playwright-driver.browsers
  ];
  buildInputs = [
    pkgs.python3
    TikTokApi
  ];
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
