{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ cifs-utils ];

  fileSystems."/mnt/network/general" = {
    device = "//byregot.internal/general";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "credentials=${config.sops.secrets.samba.path}"
      "uid=1000"
      "gid=1000"
    ];
  };

  fileSystems."/mnt/network/media" = {
    device = "//byregot.internal/media";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "credentials=${config.sops.secrets.samba.path}"
      "uid=1000"
      "gid=1000"
    ];
  };
}
