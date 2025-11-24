{ pkgs, lib, config, ... }:

{
  options = {
    system-modules.quietboot.enable = lib.mkEnableOption "enables quiet boot with plymouth";
  };

  config = lib.mkIf config.system-modules.quietboot.enable {
    console = {
        useXkbConfig = true;
        earlySetup = true;
      };
      boot = {
        initrd = {
          systemd.enable = true; # start earlier so plymouth asks for luks password
          verbose = false;
        };
        plymouth = {
          enable = true;
          theme = "bgrt";
        };
        loader.timeout = 0;
        consoleLogLevel = 0;
        kernelParams = [
          "plymouth.use-simpledrm"
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "loglevel=3"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
        ];
      };
  };
}
