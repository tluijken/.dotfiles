{ config, lib, ... }:
let
  mailConfigured = builtins.pathExists "${config.home.homeDirectory}/.config/sops/age/keys.txt";
in
{
  # Proton's API is end-to-end versleuteld, dus geen mailclient praat er direct
  # mee; de bridge ontsleutelt lokaal en biedt IMAP op 127.0.0.1:1143 en SMTP op
  # 127.0.0.1:1025 aan.
  #
  # Hij draaide tijdelijk op cloudbox achter een SSH-tunnel, maar daar liep de
  # eerste synchronisatie vast: met 4 GB geheugen kiest Bridge een
  # downloadbuffer van 40 MB, en een bericht dat daar niet in past laat
  # chunkDivide crashen met "index out of range [-1]". Deze machine heeft genoeg
  # geheugen voor de grotere buffers.
  #
  # Credentials staan in gnome-keyring, dat nixos/configuration.nix al aanzet.
  # extraPackages blijft bewust leeg: de module maakt daar een absolute PATH=
  # van die de geerfde vervangt, en de bridge bereikt de keyring over
  # D-Bus in plaats van door een programma aan te roepen.
  #
  # De unit draait --noninteractive, wat pas werkt nadat er via
  # `protonmail-bridge --cli` -> `login` een account is toegevoegd.
  services.protonmail-bridge.enable = true;

  # age.keyFile en defaultSopsFile staan eenmalig in aerc.nix; dit voegt daar een
  # tweede secret aan mail.yaml toe.
  sops.secrets = lib.mkIf mailConfigured { "proton-bridge" = { }; };

  accounts.email.accounts.proton = lib.mkIf mailConfigured {
    address = "thomas@luijken.dev";
    realName = "Thomas Luijken";
    # Bridge geeft per adres een gebruikersnaam uit met hetzelfde wachtwoord;
    # dit is wat `info` toont. Het bridge-wachtwoord is niet het
    # Proton-wachtwoord.
    userName = "thomas@luijken.dev";
    passwordCommand = [ "cat" config.sops.secrets."proton-bridge".path ];

    # Alleen adressen die in het Proton-account bestaan kunnen als afzender
    # dienen, wat zowel SimpleLogin/Pass-aliassen als kale catch-all-ontvangers
    # op luijken.dev uitsluit. Antwoorden op mail aan zo'n adres werkt wel,
    # omdat Proton er een reverse alias voor in de plaats zet.
    aliases = [ "tluijken@protonmail.com" ];

    # Geen TLS naar de bridge. Zijn certificaat draagt basicConstraints CA:TRUE
    # en wordt rechtstreeks als servercertificaat aangeboden; Thunderbird weigert
    # dat met MOZILLA_PKIX_ERROR_CA_CERT_USED_AS_END_ENTITY, een foutklasse
    # waarvoor mozilla::pkix bewust geen uitzondering toestaat. Geen
    # vertrouwensvlag en geen cert_override komt daar omheen.
    #
    # Dat kan zonder bezwaar: alles blijft op de loopback van deze machine en
    # raakt geen netwerk.
    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls.enable = false;
      authentication = "plain";
    };
    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls.enable = false;
      authentication = "plain";
    };

    thunderbird.enable = true;
  };
}
