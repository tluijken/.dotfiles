{ lib, pkgs, ... }:
let
  # calendar.notifications.times: comma-separated ISO-8601 durations relative to
  # event start (negative = before, PT0M = at start; "END:" prefix = relative to
  # end). Non-empty enables system notifications (nsIAlertsService -> swaync),
  # which fire independently of any per-event reminder and never open a window.
  # calendar.alarms.show / .showmissed gate the old focus-stealing reminder
  # dialog; both off leaves swaync as the only reminder surface.
  userJs = pkgs.writeText "thunderbird-user.js" ''
    // Managed by home-manager (modules/thunderbird.nix); edits here are overwritten.
    user_pref("calendar.notifications.times", "-PT15M");
    user_pref("calendar.alarms.show", false);
    user_pref("calendar.alarms.showmissed", false);
    user_pref("mail.shell.checkDefaultClient", false);
  '';
in
{
  home.activation.thunderbirdReminderPrefs =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      shopt -s nullglob
      for prof in "$HOME"/.thunderbird/*.default*/; do
        $DRY_RUN_CMD ln -sf ${userJs} "$prof/user.js"
      done
    '';
}
