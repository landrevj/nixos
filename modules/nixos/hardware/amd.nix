{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.hardware.amd.enable = lib.mkEnableOption "enables amd";
  };

  config = lib.mkIf config.system-modules.hardware.amd.enable {
    # boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelParams = [
      "amdgpu.ppfeaturemask=0xfff7ffff"
    ]; # allow for changing clocks/volts https://wiki.archlinux.org/title/AMDGPU#Boot_parameter

    environment.systemPackages = with pkgs; [ lact ];
    systemd.services.lact = {
      description = "AMDGPU Control Daemon";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { ExecStart = "${pkgs.lact}/bin/lact daemon"; };
      enable = true;
    };
    # programs.corectrl = {
    #   enable = true;
    #   gpuOverclock.enable = true;
    # };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs;
        [
          # include amdvlk even though we default to radv below
          # use amdvlk instead of radv by defining the following env var (e.g. in a game's steam launch params):
          # VK_ICD_FILENAMES="/run/opengl-driver/share/vulkan/icd.d/amd_icd32.json:/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json"
          # amdvlk

          rocmPackages.clr.icd # OpenCL
        ];
      enable32Bit = true;
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };

    # https://theholytachanka.com/posts/setting-up-resolve/
    systemd.tmpfiles.rules =
      [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

    # environment.variables = {
    #   AMD_VULKAN_ICD = "RADV"; # default to radv vulkan driver
    # };
  };
}
