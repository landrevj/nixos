# a good resource https://github.com/bryansteiner/gpu-passthrough-tutorial https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/

{ config, home-manager, pkgs, lib, username, ... }:

let 
  # https://github.com/WJKPK/nixation/blob/main/nixos/perun/virt-manager.nix
  hugepage_handler = pkgs.writeShellScript "hp_handler.sh" ''
    xml_file="/var/lib/libvirt/qemu/$1.xml"
    
    function extract_number() {
        local xml_file=$1
        local number=$(grep -oPm1 "(?<=<memory unit='KiB'>)[^<]+" $xml_file)
        echo $((number/1024))
    }
    
    function prepare() { 
        # Calculate number of hugepages to allocate from memory (in MB)
        HUGEPAGES="$(($1/$(($(grep Hugepagesize /proc/meminfo | ${pkgs.gawk}/bin/gawk '{print $2}')/1024))))"
    
        echo "Allocating hugepages..."
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
    
        TRIES=0
        while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
        do
            echo 1 > /proc/sys/vm/compact_memory
            ## defrag ram
            echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
            ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
            echo "Successfully allocated $ALLOC_PAGES / $HUGEPAGES"
            let TRIES+=1
        done
    
        if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
        then
            echo "Not able to allocate all hugepages. Reverting..."
            echo 0 > /proc/sys/vm/nr_hugepages
            exit 1
        fi
    }
    
    function release() {
        echo 0 > /proc/sys/vm/nr_hugepages
    }
    
    case $2 in
        prepare)
            number=$(extract_number $xml_file)
            prepare $number
            ;;
        release)
            release
            ;;
    esac
  '';
  vfio_pci_devices = [
    "10de:2206" # 3080 graphics
    "10de:1aef" # 3080 audio
    # "144d:a80c" # 990 nvme
  ];
 in
{
  # enable vfio and isolate the nvidia gpu
  boot = {
    kernelParams = [ "intel_iommu=on" "video=efifb:off" "video=vesafb:off" "quiet" ];
    blacklistedKernelModules = [ "nvidia" "nouveau" ];
    kernelModules = [
      "kvm-intel"
      "vfio_virqfd"
      "vfio_pci"
      "vfio_iommu_type1"
      "vfio"
    ];

    extraModprobeConfig = ("options vfio-pci ids=" + lib.concatStringsSep "," vfio_pci_devices);
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
      hooks.qemu = {
        hugepage_handler = "${hugepage_handler}";
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
}