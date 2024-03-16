{ config, home-manager, pkgs, lib, username, ... }:

{
  # enable vfio and isolate the nvidia gpu
  boot = {
    kernelParams = [ "intel_iommu=on" ];
    blacklistedKernelModules = [ "nvidia" "nouveau" ];
    kernelModules = [
      "kvm-intel"
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];

    extraModprobeConfig = ("options vfio-pci ids=10de:2206,10de:1aef"); # (ids=nvidia_graphics,nvidia_audio)
  };

  # add user to group
  users.users.${username}.extraGroups = [ "libvirtd" ];

  # set up virtualization
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
     virt-manager
     virtio-win
  ];

  # set up qemu in virt-manager
  home-manager.users.${username} = {
    home.file = {
      # libvert uefi with ovmf
      ".config/libvirt/qemu.conf".text = ''
        nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
      '';
    };
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}