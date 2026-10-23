{ config, lib, pkgs, ... }:
let
  # Zelfde guard als aerc.nix/protonmail.nix: zonder de age-key valt er niets te
  # ontsleutelen en moet de config toch kunnen evalueren.
  sopsConfigured = builtins.pathExists "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  nc-cal = pkgs.writeShellApplication {
    name = "nc-cal";
    runtimeInputs = with pkgs; [
      curl
      util-linux
      gawk
      gnused
      coreutils
    ];
    text = builtins.readFile ./nextcloud-caldav/nc-cal.sh;
  };
in
{
  # aerc.nix zet age.keyFile en defaultSopsFile; dit secret woont in een eigen
  # bestand omdat het niets met mail te maken heeft.
  sops.secrets = lib.mkIf sopsConfigured {
    "nextcloud-caldav" = { sopsFile = ./../secrets/nextcloud.yaml; };
  };

  home.packages = lib.mkIf sopsConfigured [ nc-cal ];
}
