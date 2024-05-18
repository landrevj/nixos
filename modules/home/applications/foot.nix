{ pkgs, lib, config, ... }:

{
  options = {
    foot.enable = lib.mkEnableOption "enables foot";
  };

  config = lib.mkMerge [
    (lib.mkIf config.foot.enable {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            font = "MesloLGLDZ Nerd Font Mono:size=11";
            initial-window-size-chars = "120x27";
          };
          colors = {
            background = "1e1e1e";
            regular0 = "444444";
            regular1 = "FF0054";
            regular2 = "B1D630";
            regular3 = "F5C211";
            regular4 = "67BEE3";
            regular5 = "B576BC";
            regular6 = "569A9F";
            regular7 = "EDEDED";
            bright0  = "777777";
            bright1  = "D65E75";
            bright2  = "BAFFAA";
            bright3  = "F8E45C";
            bright4  = "9FD3E5";
            bright5  = "DEB3DF";
            bright6  = "B6E0E5";
            bright7  = "FFFFFF";
          };
          csd = {
            color = "303030";
            button-color = "ffffff";
            button-minimize-color = "444444";
            button-maximize-color = "444444";
          };
          cursor = {
            blink = true;
          };
          tweak = {
            overflowing-glyphs=true;
          };
        };
      };
    })
    (lib.mkIf config.fish.enable {
      programs.fish.functions = {
        mark_prompt_start = {
          body = ''echo -en "\e]133;A\e\\"'';
          onEvent = "fish_prompt";
        };
        foot_cmd_start = {
          body = ''echo -en "\e]133;C\e\\"'';
          onEvent = "fish_preexec";
        };
        foot_cmd_end = {
          body = ''echo -en "\e]133;D\e\\'';
          onEvent = "fish_postexec";
        };
      };
    })
  ];
}