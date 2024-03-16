{pkgs, ...}:

{
  boot.initrd.kernelModules = [ "amdgpu" ];
  environment.systemPackages = with pkgs; [
    lact
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # services.xserver.videoDrivers = [ "modesetting" ]; # or "amdgpu"
}