{
  description = "Thomas' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";  # match your current channel

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";  # must match nixpkgs
      follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.thomas = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        ./nixos/hardware-configuration.nix

        home-manager.nixosModules.homeManager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.thomas = import ./home-manager/home.nix;
          };
        }
      ];
    };
  };
}
