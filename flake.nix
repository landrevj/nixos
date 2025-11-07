{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    flatpaks.url = "github:gmodena/nix-flatpak";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix"; # bad weeb games
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { username = "landrevj"; };
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          # nixos-cosmic.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { username = "landrevj"; };

            home-manager.users.landrevj = import ./hosts/desktop/home.nix;
            home-manager.sharedModules = [
              inputs.flatpaks.homeManagerModules.nix-flatpak
              inputs.sops-nix.homeManagerModules.sops
              inputs.zen-browser.homeModules.beta
            ];
          }
        ];
      };
      livingroom = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { username = "landrevj"; };
        system = "x86_64-linux";
        modules = [
          ./hosts/livingroom/configuration.nix
          inputs.jovian.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { username = "landrevj"; };

            home-manager.users.landrevj = import ./hosts/livingroom/home.nix;
            home-manager.sharedModules = [
              inputs.flatpaks.homeManagerModules.nix-flatpak
              inputs.sops-nix.homeManagerModules.sops
            ];
          }
        ];
      };
      framework = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { username = "landrevj"; };
        system = "x86_64-linux";
        modules = [
          ./hosts/framework/configuration.nix
          inputs.sops-nix.nixosModules.sops
          inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
          inputs.disko.nixosModules.disko
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { username = "landrevj"; };

            home-manager.users.landrevj = import ./hosts/framework/home.nix;
            home-manager.sharedModules = [
              inputs.flatpaks.homeManagerModules.nix-flatpak
              inputs.sops-nix.homeManagerModules.sops
              inputs.zen-browser.homeModules.beta
            ];
          }
        ];
      };
      T470 = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { username = "landrevj"; };
        system = "x86_64-linux";
        modules = [
          ./hosts/T470/configuration.nix
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { username = "landrevj"; };

            home-manager.users.landrevj = import ./hosts/T470/home.nix;
            home-manager.sharedModules = [
              inputs.flatpaks.homeManagerModules.nix-flatpak
              inputs.sops-nix.homeManagerModules.sops
            ];
          }
        ];
      };
    };
  };
}
