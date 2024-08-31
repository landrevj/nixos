{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.hardware.amd.enable = lib.mkEnableOption "enables amd";
  };

  config = lib.mkIf config.system-modules.hardware.amd.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];
    environment.systemPackages = with pkgs; [
      lact
    ];

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        # include amdvlk even though we default to radv below
        # use amdvlk instead of radv by defining the following env var (e.g. in a game's steam launch params):
        # VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/amd_icd32.json:/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json"
        amdvlk
      
        rocmPackages.clr.icd # OpenCL
      ];
      enable32Bit = true;
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };
    
    # https://theholytachanka.com/posts/setting-up-resolve/
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    environment.variables = {
      AMD_VULKAN_ICD = "RADV"; # default to radv vulkan driver
    };
  };
}