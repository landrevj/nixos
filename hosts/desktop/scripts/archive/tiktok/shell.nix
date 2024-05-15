let
  pkgs = import <nixpkgs> {};
  TikTokApi = (pkgs.python3Packages.buildPythonPackage rec {
    name = "TikTok-Api";
    format = "setuptools";
    src = pkgs.fetchFromGitHub {
      owner = "davidteather";
      repo = name;
      rev = "7386b2b5f723fb1d376ef6e3ceca5aa30fc733a7";
      sha256 = "sha256-Rox/om8hgwUAptGgeI7oKWdvw9YCFiNypmmjfCKf3aM=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [ pytest playwright requests ];
    pythonImportsCheck = [ "TikTokApi" ];
  });
in pkgs.mkShell {
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
  '';
}