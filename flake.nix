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

  outputs = inputs@{ nixpkgs, nixos-hardware, disko, home-manager, chaotic
    , flatpaks, sops-nix, aagl, jovian, lanzaboote, zen-browser, ... }: {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { username = "landrevj"; };
          system = "x86_64-linux";
          modules = [
            ./hosts/desktop/configuration.nix
            # nixos-cosmic.nixosModules.default
            chaotic.nixosModules.default
            sops-nix.nixosModules.sops
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { username = "landrevj"; };

              home-manager.users.landrevj = import ./hosts/desktop/home.nix;
              home-manager.sharedModules = [
                flatpaks.homeManagerModules.nix-flatpak
                sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };
        livingroom = nixpkgs.lib.nixosSystem {
          specialArgs = { username = "landrevj"; };
          system = "x86_64-linux";
          modules = [
            ./hosts/livingroom/configuration.nix
            jovian.nixosModules.default
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { username = "landrevj"; };

              home-manager.users.landrevj = import ./hosts/livingroom/home.nix;
              home-manager.sharedModules = [
                flatpaks.homeManagerModules.nix-flatpak
                sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };
        framework = nixpkgs.lib.nixosSystem {
          specialArgs = { username = "landrevj"; };
          system = "x86_64-linux";
          modules = [
            ./hosts/framework/configuration.nix
            sops-nix.nixosModules.sops
            nixos-hardware.nixosModules.framework-amd-ai-300-series
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { username = "landrevj"; };

              home-manager.users.landrevj = import ./hosts/framework/home.nix;
              home-manager.sharedModules = [
                flatpaks.homeManagerModules.nix-flatpak
                sops-nix.homeManagerModules.sops
                zen-browser.homeModules.beta
              ];
            }
          ];
        };
        T470 = nixpkgs.lib.nixosSystem {
          specialArgs = { username = "landrevj"; };
          system = "x86_64-linux";
          modules = [
            ./hosts/T470/configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { username = "landrevj"; };

              home-manager.users.landrevj = import ./hosts/T470/home.nix;
              home-manager.sharedModules = [
                flatpaks.homeManagerModules.nix-flatpak
                sops-nix.homeManagerModules.sops
              ];
            }
          ];
        };
      };
    };
}
