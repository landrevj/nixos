{ pkgs, lib, config, ... }:

{
  options = {
    home-modules.applications.vscode.enable =
      lib.mkEnableOption "enables vscode";
  };

  config = lib.mkIf config.home-modules.applications.vscode.enable {
    home.packages = with pkgs; [ nixd nixfmt shellcheck shfmt ];
    programs.vscode = {
      enable = true;
      profiles."default" = {
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          bmalehorn.vscode-fish
          bradlc.vscode-tailwindcss
          christian-kohler.path-intellisense
          ecmel.vscode-html-css
          editorconfig.editorconfig
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          dotjoshjohnson.xml
          fill-labs.dependi
          formulahendry.auto-close-tag
          formulahendry.auto-rename-tag
          jnoortheen.nix-ide
          mkhl.shfmt
          ms-python.python
          ms-vscode.cpptools-extension-pack
          ndonfris.fish-lsp
          rust-lang.rust-analyzer
          signageos.signageos-vscode-sops
          streetsidesoftware.code-spell-checker
          timonwong.shellcheck
        ];
        userSettings = {
          "chat.disableAIFeatures" = true;
          "git.confirmSync" = false;
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          # nix
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            # check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
            "nixd" = {
              "formatting" = { "command" = [ "nixfmt" ]; };
              "options" = {
                # By default, this entry will be read from `import <nixpkgs> { }`.
                # You can write arbitrary Nix expressions here, to produce valid "options" declaration result.
                # Tip: for flake-based configuration, utilize `builtins.getFlake`
                "nixos" = {
                  "expr" = ''
                    (builtins.getFlake "/etc/nixos/flake.nix").nixosConfigurations.<name>.options'';
                };
                "home-manager" = {
                  "expr" = ''
                    (builtins.getFlake "/etc/nixos/flake.nix").homeConfigurations.<name>.options'';
                };
              };
            };
          };
        };
        keybindings = [
          {
            key = "ctrl+shift+down";
            command = "editor.action.copyLinesDownAction";
            when = "editorTextFocus && !editorReadonly";
          }
          {
            key = "ctrl+shift+alt+down";
            command = "-editor.action.copyLinesDownAction";
            when = "editorTextFocus && !editorReadonly";
          }
          {
            key = "ctrl+shift+up";
            command = "editor.action.copyLinesUpAction";
            when = "editorTextFocus && !editorReadonly";
          }
          {
            key = "ctrl+shift+alt+up";
            command = "-editor.action.copyLinesUpAction";
            when = "editorTextFocus && !editorReadonly";
          }
        ];
      };
    };
  };
}
