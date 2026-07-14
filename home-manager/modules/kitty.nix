{ lib, ... }:
{
  # Colours + monospace font (JetBrainsMono Nerd Font @ terminal size) come
  # from stylix's kitty target, which is enabled by default — same as foot.
  programs.kitty = {
    enable = true;

    # Balanced size for the 4K panels. Unlike foot (dpi-aware=yes, true
    # physical sizing per monitor), kitty sizes by the compositor scale and
    # can't vary per monitor, so this one value splits the difference between
    # the laptop (eDP-1 @1.5) and the external LG (DP-3 @1.25). Overrides the
    # size stylix sets from stylix.fonts.sizes.terminal (10).
    font.size = lib.mkForce 16;

    settings = {
      # URLs: detection and plain left-click-to-open are kitty defaults; set
      # them explicitly so the click-to-open behaviour is obvious here.
      # `default` routes opens through xdg-open (-> zen-beta).
      detect_urls = "yes";
      url_style = "curly";
      open_url_with = "default";

      # Match the look foot had.
      window_padding_width = 20;
      # stylix also sets this (from stylix.opacity.terminal); force our value.
      background_opacity = lib.mkForce "0.95";

      # Don't nag on close.
      confirm_os_window_close = 0;
    };
  };
}
