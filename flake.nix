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
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=v0.3.0";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, flatpaks, sops-nix, ... }: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          username = "landrevj";
        };
        system = "x86_64-linux";
        modules = [
          ./hosts/default/configuration.nix
          sops-nix.nixosModules.sops

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              username = "landrevj";
            };

            home-manager.users.landrevj = import ./hosts/default/home.nix;
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