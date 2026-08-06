{ config, pkgs, pkgs-unstable, ... }:
let
  # hyprlock 0.9.5 (and every release up to current main) hard-aborts via an
  # RASSERT in its Wayland/DBus poll thread the moment a polled fd reports
  # POLLHUP — which happens ~5s into every resume from suspend-then-hibernate
  # when the compositor briefly drops the lock client. std::abort() can't be
  # caught and upstream won't fix it (hyprwm/hyprlock#76, #638), so instead we
  # make the lock self-heal: relaunch a fresh instance whenever hyprlock exits
  # non-zero. Hyprland keeps the session locked between lock clients, so no
  # unlocked content is ever exposed during the swap. Only the first lock gets
  # a grace window; every crash-relaunch re-locks immediately (no grace) so a
  # crash can never open a passwordless entry point. hyprlock exits 0 only on a
  # genuine unlock, which is what ends the loop.
  resilientLock = pkgs.writeShellScript "hyprlock-resilient" ''
    ${pkgs-unstable.hyprlock}/bin/hyprlock --grace 5
    while [ $? -ne 0 ]; do
      sleep 1
      ${pkgs-unstable.hyprlock}/bin/hyprlock
    done
  '';
in
{
  wayland.windowManager.hyprland = {
    enable = true;
   
    # plugins = [
    #   pkgs.hyprlandPlugins.hyprscrolling
    # ];
  
    configType = "lua";

    extraConfig = ''
      dofile(os.getenv("HOME") .. "/.dotfiles/hypr/hyprland.lua")
    '';
  };
  
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # hyprctl talks to a lua-configured Hyprland, so `dispatch` parses its
        # argument as lua: the bare `dpms on` form errors out ("')' expected").
        # The dispatcher has to be named explicitly as hl.dsp.dpms("...").
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
        # Route every lock trigger through logind so only ONE code path
        # (lock_cmd) ever spawns hyprlock. Firing `hyprlock` directly from
        # multiple triggers races: pidof can return empty in two triggers at
        # once (idle-timeout + suspend) and launch two instances, the second
        # of which aborts failing to acquire the ext-session-lock.
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = false;
        # The single, pidof-guarded launcher; resilientLock re-locks if
        # hyprlock aborts on resume (see the let-binding above).
        lock_cmd = "pidof hyprlock || ${resilientLock}";
      };

      listener = [
        {
          timeout = 300;  # 5 min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;  # 10 min
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms(\"off\")'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
        }
        # No idle-triggered suspend/hibernate: inactivity only locks the
        # session and turns the screen off, so long-running jobs keep
        # running overnight. Sleep still happens on lid close (see
        # HandleLidSwitch in nixos/laptop.nix).
      ];
    };
  };
  
  # Polkit authentication agent — without one, actions that need auth
  # (fprintd-enroll, GUI mounts, etc.) are denied with no prompt shown.
  services.hyprpolkitagent.enable = true;

  programs.hyprlock = {
    enable = true;
    package = pkgs-unstable.hyprlock;
    settings = {
      general = {
        # hyprlock 0.9.5 rejects `disable_loading_bar`, `grace`, and
        # `no_fade_in` here (each logged a "config option does not exist"
        # error on every launch). `grace` moved to a CLI arg (see lock_cmd
        # above); the other two only set their own defaults, so dropping
        # them is behaviourally a no-op.
        hide_cursor = true;
      };

      # Talks to fprintd directly; no-op on machines without a reader
      auth = {
        "fingerprint:enabled" = true;
        "fingerprint:ready_message" = "(or scan fingerprint)";
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.6;  # darken slightly so text pops
        }
      ];
  
      input-field = [
        {
          size = "250, 55";
          position = "0, -100";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
  
          # Catppuccin Mocha
          font_color = "rgb(205, 214, 244)";   # text
          inner_color = "rgb(49, 50, 68)";     # surface0
          outer_color = "rgb(203, 166, 247)";  # mauve
          check_color = "rgb(166, 227, 161)";  # green
          fail_color = "rgb(243, 139, 168)";   # red
          fail_text = "wrong password";

          outline_thickness = 4;
          placeholder_text = "<span foreground=\"##a6adc8\">🔒 password</span>";
          shadow_passes = 3;
          shadow_color = "rgb(17, 17, 27)";    # crust
          shadow_boost = 1.2;
        }
      ];
  
      label = [
        # Clock
        {
          monitor = "";
          text = "$TIME";
          font_size = 96;
          font_family = "JetBrains Mono Bold";
          color = "rgba(205, 214, 244, 0.9)";  # text
          position = "0, 200";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_color = "rgb(17, 17, 27)";
          shadow_boost = 1.2;
        }

        # Date
        {
          monitor = "";
          text = ''cmd[update:60000] date +"%-A, %-d %B %Y"'';
          font_size = 24;
          font_family = "JetBrains Mono";
          color = "rgba(166, 173, 200, 0.9)";  # subtext0
          position = "0, 100";
          valign = "center";
          halign = "center";
          shadow_passes = 3;
          shadow_color = "rgb(17, 17, 27)";
          shadow_boost = 1.2;
        }

        # Username
        {
          monitor = "";
          text = "$USER";
          font_size = 18;
          font_family = "JetBrains Mono";
          color = "rgba(203, 166, 247, 0.9)";  # mauve
          position = "0, -50";
          valign = "center";
          halign = "center";
          shadow_passes = 2;
          shadow_color = "rgb(17, 17, 27)";
        }
      ];
    };
  };
}
