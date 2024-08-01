# a good resource https://github.com/bryansteiner/gpu-passthrough-tutorial https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/

{ config, home-manager, pkgs, lib, username, ... }:

{
  options = {
    system-modules.hardware.vfio.enable = lib.mkEnableOption "enables vfio";
  };

  config = lib.mkIf config.system-modules.hardware.vfio.enable {
    # enable vfio and isolate the nvidia gpu
    boot = {
      kernelParams = [ "intel_iommu=on" ]; 
      # can also try this if vfio-pci doesn't want to grab the guest gpu
      # https://passthroughpo.st/explaining-csm-efifboff-setting-boot-gpu-manually/
      # https://www.reddit.com/r/VFIO/comments/ks7ve3/alternative_to_efifboff/
      # kernelParams = [ "intel_iommu=on" "video=efifb:off" "video=vesafb:off" "quiet" ]; 
      blacklistedKernelModules = [ "nvidia" "nouveau" ];
      kernelModules = [
        "kvm-intel"
        "vfio_virqfd"
        "vfio_pci"
        "vfio_iommu_type1"
        "vfio"
      ];

      extraModprobeConfig = ''
        options vfio-pci ids=${lib.concatStringsSep "," [
          "10de:2206" # 3080 graphics
          "10de:1aef" # 3080 audio
          # "144d:a80c" # 990 nvme
          # "1b73:1100" # usb card
        ]}
      '';
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
      virtio-win # mkisofs -o ./virtio-win.iso /nix/store/z0b6bjf9h6ph4wk50kz986k5p1v8qy9r-virtio-win-0.1.248-1
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
  };
}