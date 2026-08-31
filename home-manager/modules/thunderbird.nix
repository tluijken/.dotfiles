{ ... }:

{
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
