{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pavucontrol  # per-app/device volume routing
    qpwgraph     # PipeWire graph patchbay (useful for debugging routing)
    libnotify    # provides notify-send
    alsa-utils   # amixer for setting hardware mic gain
  ];

  # The rt715 SoundWire mic codec starts with near-zero ADC gain on the XPS 17 9700.
  # PipeWire's software volume can't compensate — we must set the hardware control directly.
  systemd.user.services.rt715-mic-gain = {
    Unit = {
      Description = "Set rt715 microphone capture gain";
      After = [ "pipewire.service" "wireplumber.service" ];
    };
    Service = {
      Type = "oneshot";
      # rt715 Capture Volume is the control name when rt715 driver is present;
      # PGA5.0 5 Master Capture Volume is the fallback (matches UCM's hwctl condition).
      ExecStart = pkgs.writeShellScript "set-rt715-gain" ''
        AMIXER="${pkgs.alsa-utils}/bin/amixer"
        CARD="sofsoundwire"
        # rt715 codec ADC gain: 55/63 (~87%) — firmware default is near-zero on XPS 17 9700
        if $AMIXER -c $CARD cset name='rt715 Capture Volume' 55 2>/dev/null; then
          $AMIXER -c $CARD cset name='rt715 Capture Switch' 1
        fi
      '';
      RemainAfterExit = true;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
