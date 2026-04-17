{
  description = "Thomas' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";  # match your current channel

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";  # must match nixpkgs
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        ./nixos/hardware-configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              dotfilesPath = ./.;
            };
            users.thomas = import ./home-manager/home.nix;
          };
        }
      ];
    };
  };
}
