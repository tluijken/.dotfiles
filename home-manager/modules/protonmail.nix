{ config, lib, ... }:
let
  mailConfigured = builtins.pathExists "${config.home.homeDirectory}/.config/sops/age/keys.txt";
in
{
  # Proton's API is end-to-end encrypted, so no mail client speaks to it
  # directly; the bridge decrypts locally and exposes IMAP on 127.0.0.1:1143 and
  # SMTP on 127.0.0.1:1025 for every client on this machine.
  #
  # Credentials live in gnome-keyring, which nixos/configuration.nix already
  # enables. extraPackages is deliberately left empty: the module turns it into
  # an absolute PATH= for the unit, replacing the inherited one, and the bridge
  # reaches the keyring over the Secret Service D-Bus interface rather than by
  # executing a binary.
  #
  # The unit runs --noninteractive, which only works once an account has been
  # added through `protonmail-bridge --cli` -> `login` from a terminal.
  services.protonmail-bridge.enable = true;

  # The bridge serves IMAP and SMTP under a self-signed CA it generates on first
  # login and keeps inside its encrypted vault. Thunderbird's per-server security
  # exception does not cover a certificate that is itself the authority, so the
  # CA is installed into the profile instead. Only the public certificate is
  # committed here; replacing the bridge vault invalidates it.
  programs.thunderbird.policies.Certificates.Install = [
    (toString ./protonmail-bridge-ca.pem)
  ];

  # age.keyFile and defaultSopsFile are set once in aerc.nix; this adds a second
  # secret to that same mail.yaml.
  sops.secrets = lib.mkIf mailConfigured { "proton-bridge" = { }; };

  accounts.email.accounts.proton = lib.mkIf mailConfigured {
    address = "thomas@luijken.dev";
    realName = "Thomas Luijken";
    # The bridge authenticates on the Proton login address regardless of which
    # of the account's addresses a message is sent from, and the generated
    # bridge password is not the Proton password.
    userName = "tluijken@protonmail.com";
    passwordCommand = [ "cat" config.sops.secrets."proton-bridge".path ];

    # Only addresses that exist in the Proton account can be sent from, which
    # rules out both SimpleLogin/Pass aliases and bare catch-all recipients on
    # luijken.dev. Replying to mail sent to those still works, because Proton
    # substitutes a reverse alias.
    aliases = [ "tluijken@protonmail.com" ];

    # Without an explicit mechanism Home Manager leaves Thunderbird on its
    # OAuth2 default, which the bridge does not speak.
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
