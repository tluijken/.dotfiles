{ config, lib, pkgs, ... }:
let
  mailConfigured = builtins.pathExists "${config.home.homeDirectory}/.config/sops/age/keys.txt";
in
{
  # De bridge draait niet meer hier maar op cloudbox, waar hij altijd aan staat
  # en dus ook mail ophaalt als deze laptop uit is. Hij luistert daar alleen op
  # 127.0.0.1 -- dat is niet instelbaar -- dus een SSH-tunnel zet die poorten
  # hier neer. Daardoor blijft alles hieronder naar localhost wijzen en hoeft
  # Thunderbird niets te weten van de verhuizing.
  systemd.user.services.protonmail-bridge-tunnel = {
    Unit = {
      Description = "SSH-tunnel naar de Proton Mail Bridge op cloudbox";
      # Geen network-online.target: die bestaat niet in de user-manager. De
      # Restart-lus hieronder vangt een te vroege start op.
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.openssh}/bin/ssh -N"
        + " -o ExitOnForwardFailure=yes"
        + " -o ServerAliveInterval=30 -o ServerAliveCountMax=3"
        + " -o ConnectTimeout=15"
        + " -L 127.0.0.1:1143:127.0.0.1:1143"
        + " -L 127.0.0.1:1025:127.0.0.1:1025"
        + " cloudbox";
      Restart = "always";
      RestartSec = "15s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # De bridge serveert onder een zelfondertekende CA die hij bij de eerste login
  # aanmaakt en in zijn versleutelde vault bewaart. Thunderbirds uitzondering per
  # server dekt geen certificaat dat zelf de autoriteit is, dus de CA gaat het
  # profiel in. Dit is de CA van cloudbox; die van de oude lokale bridge is
  # daarmee vervallen.
  programs.thunderbird.policies.Certificates.Install = [
    (toString ./protonmail-bridge-ca.pem)
  ];

  # age.keyFile en defaultSopsFile staan eenmalig in aerc.nix; dit voegt daar een
  # tweede secret aan mail.yaml toe.
  sops.secrets = lib.mkIf mailConfigured { "proton-bridge" = { }; };

  accounts.email.accounts.proton = lib.mkIf mailConfigured {
    address = "thomas@luijken.dev";
    realName = "Thomas Luijken";
    # Bridge geeft per adres een eigen gebruikersnaam uit met hetzelfde
    # wachtwoord; dit is de naam die `info` op cloudbox toont. Het
    # bridge-wachtwoord is niet het Proton-wachtwoord.
    userName = "thomas@luijken.dev";
    passwordCommand = [ "cat" config.sops.secrets."proton-bridge".path ];

    # Alleen adressen die in het Proton-account bestaan kunnen als afzender
    # dienen, wat zowel SimpleLogin/Pass-aliassen als kale catch-all-ontvangers
    # op luijken.dev uitsluit. Antwoorden op mail aan zo'n adres werkt wel,
    # omdat Proton er een reverse alias voor in de plaats zet.
    aliases = [ "tluijken@protonmail.com" ];

    # Zonder expliciet mechanisme laat Home Manager Thunderbird op zijn
    # OAuth2-standaard staan, en die spreekt de bridge niet.
    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls = {
        enable = true;
        useStartTls = true;
      };
      authentication = "plain";
    };
    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls = {
        enable = true;
        useStartTls = true;
      };
      authentication = "plain";
    };

    thunderbird.enable = true;
  };
}
