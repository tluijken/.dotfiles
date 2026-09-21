{ config, lib, pkgs, ... }:
let
  mailConfigured = builtins.pathExists "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  # Thunderbird turns file: <img> sources into inline (cid:) attachments when
  # sending, but leaves <source srcset> alone, so the dark-mode logo must be a
  # data: URI to travel with the mail. A <picture> is used instead of CSS
  # because Thunderbird strips conditional CSS (@media) from displayed mail.
  logoWhiteData = "data:image/png;base64,"
    + lib.fileContents (pkgs.runCommand "logo-white-b64" { } "base64 -w0 ${./thunderbird/logo-white.png} > $out");
  signature = builtins.replaceStrings
    [ "@signatureDir@" "@logoWhiteData@" ]
    [ "file://${./thunderbird}" logoWhiteData ]
    (builtins.readFile ./thunderbird/signature.html);
in
{
  accounts.email.accounts.baseflow = lib.mkIf mailConfigured {
    signature = {
      showSignature = "append";
      htmlFormat = true;
      text = signature;
    };
    thunderbird.perIdentitySettings = id: {
      "mail.identity.id_${id}.reply_on_top" = 1;
      "mail.identity.id_${id}.sig_bottom" = false;
      "mail.identity.id_${id}.suppress_signature_separator" = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    # The profile name matches the pre-existing imperative profile directory
    # under ~/.thunderbird, so declaring it here adopts that profile (OAuth
    # tokens, calendars, local folders) instead of starting an empty one.
    profiles."4ai4cf4s.default" = {
      isDefault = true;
      settings = {
        # calendar.notifications.times: comma-separated ISO-8601 durations
        # relative to event start (negative = before, PT0M = at start; "END:"
        # prefix = relative to end). Non-empty enables system notifications
        # (nsIAlertsService -> swaync), which fire independently of any
        # per-event reminder and never open a window.
        # calendar.alarms.show / .showmissed gate the old focus-stealing
        # reminder dialog; both off leaves swaync as the only reminder surface.
        "calendar.notifications.times" = "-PT15M";
        "calendar.alarms.show" = false;
        "calendar.alarms.showmissed" = false;
        "mail.shell.checkDefaultClient" = false;
      };
    };
  };
}
