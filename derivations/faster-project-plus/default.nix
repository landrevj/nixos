# reference:
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/emulators/dolphin-emu/default.nix
# https://github.com/jlambert360/FPM-AppImage/blob/master/setup_appimage
# https://github.com/djanatyn/ssbm-nix/blob/master/pplus/slippi.nix

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  fetchpatch,
  callPackage,
  makeDesktopItem,
  copyDesktopItems,

  alsa-lib,
  bluez,
  bzip2,
  cubeb,
  curl,
  ffmpeg,
  fmt_10,
  glib,
  gtk2,
  gtk3,
  gtest,
  hidapi,
  enet,
  libevdev,
  libGL,
  libiconv,
  libpulseaudio,
  libspng,
  libusb1,
  libXdmcp,
  libXext,
  libXi,
  libXrandr,
  lz4,
  lzo,
  mbedtls_2,
  miniupnpc,
  minizip-ng,
  mgba,
  openal,
  pugixml,
  qtbase,
  qtsvg,
  SDL2,
  sfml,
  udev,
  vulkan-loader,
  xorg,
  xxHash,
  xz,

  fpp-config,
  fpp-launcher,
  fpp-sdcard,
}:

stdenv.mkDerivation rec {
  pname = "faster-project-plus";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "jlambert360";
    repo = "Ishiiruka";
    rev = "49ac69f750e0f1c6422da114d630a2532f290db2";
    hash = "sha256-ookaP1I5uJJXzNQl1O+DoNFN7Fk+vMq/p/XacjrQ+ys=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dolphin-emu/dolphin/commit/3da2e15e6b95f02f66df461e87c8b896e450fdab.patch";
      hash = "sha256-+8yGF412wQUYbyEuYWd41pgOgEbhCaezexxcI5CNehc=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    stdenv.cc
    cmake
    pkg-config
    wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    bzip2
    cubeb
    curl
    ffmpeg
    fmt_10
    gtest
    hidapi
    enet
    
    libiconv
    libpulseaudio
    libspng
    libusb1
    libXdmcp
    libXi
    lz4
    lzo
    mbedtls_2
    miniupnpc
    minizip-ng
    openal
    pugixml
    qtbase
    qtsvg
    SDL2
    sfml
    xxHash
    xz # LibLZMA

    alsa-lib
    bluez
    libevdev
    libGL
    libXrandr
    libXext
    udev
    vulkan-loader

    glib
    gtk2
    gtk3
    xorg.libXinerama
    xorg.libXxf86vm
  ];

  cmakeFlags = [
    "-DLINUX_LOCAL_DEV=true"
    "-DGTK3_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-3.0/include"
    "-DGTK3_GDKCONFIG_INCLUDE_DIR=${gtk3.out}/lib/gtk-3.0/include"
    "-DGTK3_INCLUDE_DIRS=${gtk3.out}/lib/gtk-3.0"
    "-DENABLE_LTO=True"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_INCLUDE_DIRS=${gtk2}/lib/gtk-2.0"
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}"
    # https://bugs.dolphin-emu.org/issues/11807
    # The .desktop file should already set this, but Dolphin may be launched in other ways
    "--set QT_QPA_PLATFORM xcb"
  ];

  patchPhase = ''
    sed -i 's|\$\\{GIT_EXECUTABLE} rev-parse HEAD|echo ${src.rev}|g' CMakeLists.txt # --set scm_rev_str everywhere to actual commit hash when downloaded
    sed -i 's|\$\\{GIT_EXECUTABLE} describe --always --long --dirty|echo FM v${version}|g' CMakeLists.txt # ensures compatibility w/ netplay
    sed -i 's|\$\\{GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD|echo HEAD|g' CMakeLists.txt
    sed -i 's|#include <optional>|#include <optional>\n#include <string>|g' Source/Core/DiscIO/DiscExtractor.h
    cp Externals/wxWidgets3/include/wx Source/Core/ -r
    cp Externals/wxWidgets3/wx/* Source/Core/wx/
  '';

  installPhase = ''
    runHook preInstall

    cp -rf ${fpp-config}/Binaries/* Binaries/
    chmod -R 755 Binaries/
    rm Binaries/portable.txt

    cp -rf ${fpp-launcher}/Launcher/* Binaries/Launcher
    mkdir -p Binaries/User/Wii
    install -D -m 755 ${fpp-sdcard}/sd.raw Binaries/User/Wii
    mkdir -p $out
    cp Binaries/ $out/ -r

    sed -i 's|ISOPaths = 2|ISOPaths = 1|g' $out/Binaries/User/Config/Dolphin.ini
    sed -i 's|WiiSDCardPath = ./User/Wii/sd.raw|WiiSDCardPath = '$out'/User/Wii/sd.raw|g' $out/Binaries/User/Config/Dolphin.ini
    sed -i 's|ISOPath0 = ./Launcher|ISOPath0 = '$out'/Launcher|g' $out/Binaries/User/Config/Dolphin.ini
    sed -i '\|ISOPath1 = ./Games|d' $out/Binaries/User/Config/Dolphin.ini

    mkdir -p $out/bin
    ln -s $out/Binaries/ishiiruka $out/bin/faster-project-plus

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "faster-project-plus";
      exec = "faster-project-plus";
      icon = "ishiiruka";
      desktopName = "Faster Project+";
      comment = "Ishiiruka fork for SSBPM";
      type = "Application";
      categories = [ "Emulator" "Game" ];
      keywords = [ "ProjectM" "Project M" "ProjectPlus" "Project Plus" "Project+" ];
    })
  ];

  # meta = with lib; {
  #   homepage = "https://projectplusgame.com/";
  #   description = "A community driven patch for Project M, a game modification for Brawl";
  #   mainProgram = "ishiiruka";
  #   branch = "master";
  #   license = licenses.gpl2Plus;
  #   platforms = platforms.linux;
  #   maintainers = with maintainers; [
  #     landrevj
  #   ];
  # };
}