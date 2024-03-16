{ config, pkgs, lib, ... }:

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

  # set up virtualization
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
    spiceUSBRedirection.enable = true;
  };
}