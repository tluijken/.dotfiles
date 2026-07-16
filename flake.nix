{
  description = "Thomas' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, home-manager, stylix, zen-browser, nix-flatpak, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        # Machine-specific configuration lives outside the repo.
        # Requires building with --impure.
        /etc/nixos/hardware-configuration.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            # Back up (rather than fail on) any unmanaged file in the way of activation
            backupFileExtension = "hm-bak";
            sharedModules = [ stylix.homeModules.stylix nix-flatpak.homeManagerModules.nix-flatpak ];
            extraSpecialArgs = {
              dotfilesPath = ./.;
              inherit zen-browser;
            };
            users.thomas = import ./home-manager/home.nix;
          };
        }
      ] ++ nixpkgs.lib.optional (builtins.pathExists /etc/nixos/local.nix) /etc/nixos/local.nix;
    };
  };
}
