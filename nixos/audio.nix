{ ... }:
{
  # Echo cancellation — creates a virtual mic source with AEC applied.
  # Switch to "Echo Cancelled Source" in pavucontrol during calls.
  services.pipewire.extraConfig.pipewire."80-echo-cancel" = {
    "context.modules" = [
      {
        name = "libpipewire-module-echo-cancel";
        args = {
          "capture.props" = {
            "node.name" = "echo-cancel-capture";
          };
          "source.props" = {
            "node.name"        = "echo-cancel-source";
            "node.description" = "Echo Cancelled Source";
          };
          "sink.props" = {
            "node.name"        = "echo-cancel-sink";
            "node.description" = "Echo Cancelled Sink";
          };
          "playback.props" = {
            "node.name" = "echo-cancel-playback";
          };
        };
      }
    ];
  };

  # Bluetooth audio — enable high-quality codecs and headset roles
  services.pipewire.wireplumber.extraConfig."51-bluetooth" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq"  = true;
      "bluez5.enable-msbc"    = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.headset-roles"  = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
      "bluez5.codecs"         = [ "sbc" "sbc_xq" "aac" "ldac" "aptx" "aptx_hd" ];
    };
  };
}
