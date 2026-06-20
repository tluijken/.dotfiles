{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pavucontrol  # per-app/device volume routing
    qpwgraph     # PipeWire graph patchbay (useful for debugging routing)
    libnotify    # provides notify-send
  ];

  # EasyEffects runs as a background service — no GUI needed for noise cancellation
  services.easyeffects = {
    enable = true;
    preset = "meeting";
  };

  # RNNoise noise cancellation preset for the mic
  home.file.".config/easyeffects/input/meeting.json".text = builtins.toJSON {
    input = {
      blocklist = [];
      plugins_order = [ "rnnoise#0" ];
      "rnnoise#0" = {
        bypass      = false;
        input-gain  = 0.0;
        output-gain = 0.0;
        release     = 20.0;
        vad-thres   = 50.0;
        wet         = 1.0;
      };
    };
  };
}
