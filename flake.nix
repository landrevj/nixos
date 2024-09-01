{
  description = "NixOS configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager"; # unstable
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flatpaks.url = "github:gmodena/nix-flatpak";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix"; # bad weeb games
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, flatpaks, sops-nix, aagl, nixos-cosmic, jovian, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          username = "landrevj";
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          nixos-cosmic.nixosModules.default
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "landrevj";
            };

            home-manager.users.landrevj = import ./hosts/desktop/home.nix;
            home-manager.sharedModules = [
              flatpaks.homeManagerModules.nix-flatpak
              sops-nix.homeManagerModules.sops
            ];
          }
        ];
      };
      livingroom = nixpkgs.lib.nixosSystem {
        specialArgs = {
          username = "landrevj";
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/livingroom/configuration.nix
          nixos-cosmic.nixosModules.default
          jovian.nixosModules.default
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "landrevj";
            };

            home-manager.users.landrevj = import ./hosts/livingroom/home.nix;
            home-manager.sharedModules = [
              flatpaks.homeManagerModules.nix-flatpak
              sops-nix.homeManagerModules.sops
            ];
          }
        ];
      };
      T470 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          username = "landrevj";
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/T470/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "landrevj";
            };

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