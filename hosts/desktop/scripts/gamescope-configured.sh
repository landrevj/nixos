#! /usr/bin/env bash

gamescope --fullscreen --borderless --force-grab-cursor --expose-wayland \
  --steam \
  -W 3840 -H 2160 --nested-refresh 240 \
  --hdr-enabled --hdr-itm-enabled \
  "${@:2}"
