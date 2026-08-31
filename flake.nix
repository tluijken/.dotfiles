{
  description = "Thomas' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Consumed via zen-browser's input.follows below (needs ffmpeg_9, absent
    # in 26.05), and instantiated as pkgs-unstable for hyprlock: 26.05 pins
    # 0.9.5, and 0.9.6 (unstable) moves the fprintd DBus connection off
    # hyprlock's shared poll fd (hyprwm/hyprlock#1029), trimming one of the
    # POLLHUP sources that abort it on resume.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
      # zen-browser's package tracks nixos-unstable (needs ffmpeg_9, absent in 26.05).
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      # Only its package output is consumed, so dedupe its home-manager input.
      inputs.home-manager.follows = "home-manager";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Code skills-framework plugin, consumed as a plain source tree.
    superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, stylix, zen-browser, nix-flatpak, sops-nix, superpowers, ... }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
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
            sharedModules = [ stylix.homeModules.stylix nix-flatpak.homeManagerModules.nix-flatpak sops-nix.homeManagerModules.sops ];
            extraSpecialArgs = {
              dotfilesPath = ./.;
              inherit zen-browser pkgs-unstable superpowers;
            };
            users.thomas = import ./home-manager/home.nix;
          };
        }
      ] ++ nixpkgs.lib.optional (builtins.pathExists /etc/nixos/local.nix) /etc/nixos/local.nix;
    };
  };
}
