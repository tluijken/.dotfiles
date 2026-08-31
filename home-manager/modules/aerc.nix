{ config, lib, dotfilesPath, ... }:
let
  # The encrypted secrets file is committed (sops keeps it safe); the age private
  # key that decrypts it lives only at ~/.config/sops/age/keys.txt and is never
  # in the repo. Until that file exists the account (and its sops secret) is
  # skipped so the whole config still evaluates and rebuilds.
  secretsFile = "${dotfilesPath}/home-manager/secrets/mail.yaml";
  mailConfigured = builtins.pathExists secretsFile;
  c = config.lib.stylix.colors.withHashtag;
in
{
  programs.aerc.enable = true;

  # Home Manager symlinks accounts.conf to the world-readable Nix store, which
  # aerc rejects as too permissive. The file holds no secret here (the password
  # comes from the sops *-cred-cmd, and the decrypted value lives 0600 under
  # ~/.config/sops-nix/secrets), so relaxing the check is safe.
  programs.aerc.extraConfig.general.unsafe-accounts-conf = true;

  # Home Manager writes a minimal aerc.conf with no [filters], so aerc has no
  # way to render message bodies and falls back to the "No filter configured"
  # prompt. These reference the filter scripts aerc bundles (colorize, html,
  # calendar); aerc prepends its own libexec/share filter dirs to $PATH, and the
  # html wrapper already carries w3m via Nix, so nothing extra is needed.
  programs.aerc.extraConfig.filters = {
    "text/plain" = "colorize";
    "text/calendar" = "calendar";
    "message/delivery-status" = "colorize";
    "message/rfc822" = "colorize";
    "text/html" = "! html";
  };

  # aerc uses the first binds.conf it finds and does not merge with the packaged
  # defaults, so this is the full default set plus the hjkl/Ctrl navigation.
  xdg.configFile."aerc/binds.conf".source = ./aerc-binds.conf;

  # Stylix has no aerc target, so without a styleset aerc uses its built-in
  # default colors, which clash with the active base16 scheme. This one is
  # generated from the stylix palette so it tracks whatever scheme is set.
  programs.aerc.extraConfig.ui.styleset-name = "stylix";
  xdg.configFile."aerc/stylesets/stylix".text = ''
    *.default = true

    *.fg = ${c.base05}
    *.bg = ${c.base00}

    title.fg = ${c.base00}
    title.bg = ${c.base0D}
    title.bold = true

    header.fg = ${c.base0D}
    header.bold = true

    signature.fg = ${c.base04}

    error.fg = ${c.base08}
    error.bold = true
    warning.fg = ${c.base09}
    success.fg = ${c.base0B}

    statusline_default.fg = ${c.base05}
    statusline_default.bg = ${c.base01}
    statusline_error.fg = ${c.base08}
    statusline_error.bg = ${c.base01}
    statusline_success.fg = ${c.base0B}
    statusline_success.bg = ${c.base01}

    msglist_default.fg = ${c.base05}
    msglist_unread.fg = ${c.base0D}
    msglist_unread.bold = true
    msglist_read.fg = ${c.base04}
    msglist_flagged.fg = ${c.base09}
    msglist_deleted.fg = ${c.base03}
    msglist_marked.fg = ${c.base00}
    msglist_marked.bg = ${c.base0A}
    msglist_result.fg = ${c.base0A}
    msglist_answered.fg = ${c.base0C}
    msglist_gutter.selected.bg = ${c.base02}
    msglist_default.selected.bg = ${c.base02}
    msglist_default.selected.bold = true

    dirlist_default.fg = ${c.base05}
    dirlist_unread.fg = ${c.base0D}
    dirlist_unread.bold = true
    dirlist_default.selected.fg = ${c.base00}
    dirlist_default.selected.bg = ${c.base0D}
    dirlist_default.selected.bold = true

    completion_default.fg = ${c.base05}
    completion_default.bg = ${c.base01}
    completion_gutter.bg = ${c.base01}
    completion_pill.bg = ${c.base0D}
    completion_pill.fg = ${c.base00}

    tab.fg = ${c.base04}
    tab.selected.fg = ${c.base05}
    tab.selected.bold = true
    border.fg = ${c.base02}

    selector_default.fg = ${c.base05}
    selector_focused.fg = ${c.base00}
    selector_focused.bg = ${c.base0D}
    selector_chooser.fg = ${c.base0D}
  '';

  sops = lib.mkIf mailConfigured {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ./../secrets/mail.yaml;
    secrets."baseflow-mail" = { };
  };

  accounts.email.accounts.baseflow = lib.mkIf mailConfigured {
    primary = true;
    flavor = "gmail.com";
    address = "thomas@baseflow.com";
    realName = "Thomas Luijken";
    passwordCommand = [ "cat" config.sops.secrets."baseflow-mail".path ];
    aerc.enable = true;
  };
}
