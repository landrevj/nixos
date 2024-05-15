#! /usr/bin/env bash

# xmldir=${WIN11HOTPLUG_XMLDIR:-$(dirname $(readlink -f $0))}
xmldir="/etc/nixos/hosts/desktop/scripts/hotplug"
connection="qemu:///system"
dom="win11"

case $1 in
"attach" | "a")
  action="attach-device"
  ;;
"detach" | "d")
  action="detach-device"
  ;;
*)
  echo "Usage: [ a | d ] [ [ usb ] ... ]"
  exit 1
  ;;
esac
shift 1

for short in "$@"; do
  case $short in
  "dualsense")
    name="DualSense controller"
    files=("dualsense.xml")
    ;;
  "usb")
    name="USB devices"
    files=("dualsense.xml" "dac.xml" "scarlet.xml")
    ;;
  *)
    echo "=== Unknown device $d ==="
    continue
    ;;
  esac

  echo "=== $short - $name ==="

  for file in "${files[@]}"; do
    fullpath="$(readlink -f "$xmldir/$file")"
    echo "Using $fullpath"
    virsh -c "$connection" $action $dom --file "$fullpath" --persistent
  done
done
