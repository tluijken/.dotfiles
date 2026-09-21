{ config, lib, ... }:
let
  mailConfigured = builtins.pathExists "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  # Thunderbird replaces file: image sources with inline (cid:) attachments
  # when sending, so the logos ride along with the mail instead of being
  # fetched from a remote host.
  signature = builtins.replaceStrings [ "@signatureDir@" ] [ "file://${./thunderbird}" ]
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
